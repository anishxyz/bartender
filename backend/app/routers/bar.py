from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id

router = APIRouter()

class Bar(BaseModel):
    bar_id: int
    created_at: datetime
    updated_at: datetime
    uid: uuid.UUID
    name: str
    description: str | None


@router.get("", response_model=List[Bar])
async def get_bars(user_id: str = Depends(get_user_id)):
    print(user_id)
    query = supabase.table("bars").select("*").eq("uid", user_id)
    data = query.execute()

    print(data.data)

    # Check if the response has the expected data
    if not data.data:
        # Handle the case where data is not found or an error occurred
        raise HTTPException(status_code=404, detail="Bars not found")

    return data.data

class BarCreate(BaseModel):
    name: Optional[str] = 'New Bar'
    description: Optional[str] = None

@router.post("/create", response_model=Bar)
async def create_bar(bar_data: BarCreate, user_id: str = Depends(get_user_id)):
    curr_time = datetime.now().isoformat()
    new_bar_data = bar_data.model_dump()
    new_bar_data['uid'] = user_id
    new_bar_data['created_at'] = curr_time
    new_bar_data['updated_at'] = curr_time

    insert_query = supabase.table("bars").insert(new_bar_data).execute()

    if not insert_query.data:
        raise HTTPException(status_code=500, detail="Failed to add the bar")

    # Return the inserted bar
    print(insert_query.data)
    return insert_query.data[0]

from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id

router = APIRouter()


class Cellar(BaseModel):
    id: Optional[int]
    created_at: Optional[datetime]
    last_updated: Optional[datetime]
    uid: uuid.UUID
    name: str
    type: str
    qty: int
    current: bool
    price: float
    description: str
    bar_id: int

    class Config:
        orm_mode = True


@router.get("/", response_model=List[Cellar])
async def get_cellar(user_id: str = Depends(get_user_id)):
    print(user_id)
    query = supabase.table("cellar").select("*").eq("uid", user_id)
    data = query.execute()

    print(data)

    # Check if the response has the expected data
    if not data.data:
        # Handle the case where data is not found or an error occurred
        raise HTTPException(status_code=404, detail="Cellar not found")

    return data.data


class BottleData(BaseModel):
    name: str
    type: str
    qty: int = 1
    current: bool = True
    price: Optional[float] = None
    description: str = ""
    bar_id: Optional[int] = None


@router.post("/add_bottle", response_model=Cellar)
async def add_bottle(bottle_data: BottleData, user_id: str = Depends(get_user_id)):
    new_bottle = bottle_data.model_dump()
    new_bottle["uid"] = user_id
    new_bottle["created_at"] = datetime.now()
    new_bottle["last_updated"] = datetime.now()

    response = supabase.table("cellar").insert(new_bottle).execute()

    if not response.data:
        raise HTTPException(status_code=500, detail="Failed to add bottle to cellar")

    return response.data[0]


class UpdateBottleData(BaseModel):
    name: Optional[str]
    type: Optional[str]
    qty: Optional[int]
    current: Optional[bool]
    price: Optional[float]
    description: Optional[str]
    bar_id: Optional[int]


@router.put("/update_bottle/{bottle_id}", response_model=Cellar)
async def update_bottle(bottle_id: int, bottle_data: UpdateBottleData, user_id: str = Depends(get_user_id)):
    update_data = bottle_data.model_dump(exclude_unset=True)
    update_data["last_updated"] = datetime.now()

    response = supabase.table("cellar").update(update_data).eq("id", bottle_id).eq("uid", user_id).execute()

    if not response.data:
        raise HTTPException(status_code=404, detail="Bottle not found or update failed")

    return response.data[0]


@router.delete("/delete_bottle/{bottle_id}", response_model=dict)
async def delete_bottle(bottle_id: int, user_id: str = Depends(get_user_id)):
    response = supabase.table("cellar").delete().eq("id", bottle_id).eq("uid", user_id).execute()

    if not response.data:
        raise HTTPException(status_code=500, detail="Failed to delete bottle")

    return {"msg": "Bottle deleted successfully"}

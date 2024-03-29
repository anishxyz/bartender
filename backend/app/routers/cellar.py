from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException, File, Form, UploadFile
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id
from ..llm_pipelines.cellar_from_image import bottle_extraction
from ..llm_pipelines.helpers import process_image_data

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
    price: Optional[float] = None
    description: str
    bar_id: Optional[int] = None

    class Config:
        orm_mode = True


@router.get("", response_model=List[Cellar])
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
    print(bottle_data)
    new_bottle = bottle_data.model_dump()
    new_bottle["uid"] = user_id
    new_bottle["created_at"] = datetime.now().isoformat()
    new_bottle["last_updated"] = datetime.now().isoformat()

    response = supabase.table("cellar").insert(new_bottle).execute()

    if not response.data:
        raise HTTPException(status_code=500, detail="Failed to add bottle to cellar")

    print(response.data[0])
    return response.data[0]


@router.post("/ai/bottle")
async def add_bottle(
    file: Optional[UploadFile] = File(None),
    base64_image: Optional[str] = Form(None),
    bar_id: Optional[int] = Form(None),
    user_id: str = Depends(get_user_id)
):
    image_data = await process_image_data(base64_image=base64_image, file=file)
    cellar_parse = await bottle_extraction(image_data)

    for bottle in cellar_parse:
        bottle["uid"] = user_id
        bottle["created_at"] = datetime.now().isoformat()
        bottle["last_updated"] = datetime.now().isoformat()
        bottle["uid"] = user_id
        bottle["qty"] = 1
        bottle["current"] = True
        if bar_id:
            bottle["bar_id"] = bar_id

    response = supabase.table("cellar").insert(cellar_parse).execute()

    if not response.data:
        raise HTTPException(status_code=500, detail="Failed to add bottles to cellar")

    print(response.data)
    return response.data


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


## TODO: fix delete via RLS
@router.delete("/delete_bottle/{bottle_id}", response_model=dict)
async def delete_bottle(bottle_id: int, user_id: str = Depends(get_user_id)):
    print('BOTTLE ID', bottle_id, 'USER', user_id)
    response = supabase.table("cellar").delete().eq('id', bottle_id).eq("uid", user_id).execute()
    print('RESPONSE IS', response)
    if not response.data:
        print('failed')
        raise HTTPException(status_code=500, detail="Failed to delete bottle")

    return {"msg": "Bottle deleted successfully"}

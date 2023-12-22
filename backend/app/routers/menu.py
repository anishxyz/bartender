from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id
from ..schemas.cocktail_schemas import Menu, Cocktail, Ingredient, Section, Step


router = APIRouter()

@router.get("/{menu_id}", response_model=Menu)
async def get_menu(menu_id: int, user_id: str = Depends(get_user_id)):
    # Query the 'menus' table to get the specific menu
    menu_query = supabase.table("menus").select("*").eq("menu_id", menu_id).eq("uid", user_id)
    menu_data = menu_query.execute()

    # Check if the menu exists
    if not menu_data.data:
        raise HTTPException(status_code=404, detail="Menu not found")

    # Return the found menu
    return menu_data.data[0]


@router.get("/{menu_id}/cocktails", response_model=List[Cocktail])
async def get_cocktails_for_menu(menu_id: int, user_id: str = Depends(get_user_id)):
    # Query the 'menus' table to check if the menu exists
    menu_query = supabase.table("menus").select("*").eq("menu_id", menu_id).eq("uid", user_id)
    menu_data = menu_query.execute()

    # Check if the menu exists
    if not menu_data.data:
        raise HTTPException(status_code=404, detail="Menu not found")

    # Query the 'cocktails' table for cocktails associated with the menu
    cocktail_query = supabase.table("cocktails").select("*").eq("menu_id", menu_id)
    cocktail_data = cocktail_query.execute()

    # Check if the response has the expected data
    if not cocktail_data.data:
        # Handle the case where data is not found or an error occurred
        raise HTTPException(status_code=404, detail="Cocktails not found for the given menu")

    return cocktail_data.data

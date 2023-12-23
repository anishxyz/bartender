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


@router.get("/{menu_id}/details", response_model=dict)
async def get_menu_full_details(menu_id: int, user_id: str = Depends(get_user_id)):
    # Fetch the menu
    menu_query = supabase.table("menus").select("*").eq("menu_id", menu_id).eq("uid", user_id)
    menu_data = menu_query.execute()
    if not menu_data.data:
        raise HTTPException(status_code=404, detail="Menu not found")

    # Initialize an empty list for cocktails in the menu
    cocktails_full_details = []

    # Fetch cocktails for the menu
    cocktail_query = supabase.table("cocktails").select("*").eq("menu_id", menu_id)
    cocktail_data = cocktail_query.execute()

    for cocktail in cocktail_data.data:
        # Fetch ingredients for each cocktail
        ingredients_query = supabase.table("ingredients").select("*").eq("cocktail_id", cocktail['cocktail_id'])
        ingredients_data = ingredients_query.execute()

        # Fetch sections for each cocktail
        sections_query = supabase.table("sections").select("*").eq("cocktail_id", cocktail['cocktail_id']).order("index")
        sections_data = sections_query.execute()

        cocktail_sections = []
        for section in sections_data.data:
            # Fetch steps for each section
            steps_query = supabase.table("steps").select("*").eq("section_id", section['section_id']).order("index")
            steps_data = steps_query.execute()

            # Append steps to section
            section_with_steps = section
            section_with_steps["steps"] = steps_data.data

            cocktail_sections.append(section_with_steps)

        # Append cocktail with its ingredients and sections
        cocktails_full_details.append({
            "cocktail_id": cocktail['cocktail_id'],
            "created_at": cocktail['created_at'],
            "updated_at": cocktail['updated_at'],
            "menu_id": cocktail['menu_id'],
            "name": cocktail['name'],
            "ingredients": ingredients_data.data,
            "sections": cocktail_sections
        })

    # Return the complete menu data with cocktails
    return {
        "menu_id": menu_data.data[0]['menu_id'],
        "created_at": menu_data.data[0]['created_at'],
        "updated_at": menu_data.data[0]['updated_at'],
        "uid": menu_data.data[0]['uid'],
        "name": menu_data.data[0].get('name'),
        "cocktails": cocktails_full_details
    }


from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id
from ..schemas.cocktail_schemas import Menu, Cocktail, Ingredient, Section, Step


router = APIRouter()


@router.get("/{cocktail_id}", response_model=Cocktail)
async def get_cocktail(cocktail_id: int, user_id: str = Depends(get_user_id)):
    # Query the 'cocktails' table to get the specific cocktail
    cocktail_query = supabase.table("cocktails").select("*").eq("cocktail_id", cocktail_id).eq("uid", user_id)
    cocktail_data = cocktail_query.execute()

    # Check if the cocktail exists
    if not cocktail_data.data:
        raise HTTPException(status_code=404, detail="Cocktail not found")

    # Return the found cocktail
    return cocktail_data.data[0]


@router.get("/{cocktail_id}/details", response_model=dict)
async def get_cocktail_full_details(cocktail_id: int, user_id: str = Depends(get_user_id)):
    # Query the 'cocktails' table to get the specific cocktail
    cocktail_query = supabase.table("cocktails").select("*").eq("cocktail_id", cocktail_id).eq("uid", user_id)
    cocktail_data = cocktail_query.execute()

    # Check if the cocktail exists
    if not cocktail_data.data:
        raise HTTPException(status_code=404, detail="Cocktail not found")

    # Query the 'ingredients' table to get ingredients for the cocktail
    ingredients_query = supabase.table("ingredients").select("*").eq("cocktail_id", cocktail_id)
    ingredients_data = ingredients_query.execute()

    # Query the 'sections' table to get sections for the cocktail
    sections_query = supabase.table("sections").select("*").eq("cocktail_id", cocktail_id).order("index")
    sections_data = sections_query.execute()

    # Query the 'steps' table to get steps for the cocktail
    steps_query = supabase.table("steps").select("*").eq("cocktail_id", cocktail_id).order("index")
    steps_data = steps_query.execute()

    # Format sections with their corresponding steps
    sections_with_steps = []
    for section in sections_data.data:
        section_steps = [step for step in steps_data.data if step['section_id'] == section['section_id']]
        sections_with_steps.append({
            "section": section,
            "steps": section_steps
        })

    # Return the found cocktail, its ingredients, and its sections with steps
    return {
        "cocktail": cocktail_data.data[0],
        "ingredients": ingredients_data.data,
        "sections_with_steps": sections_with_steps
    }


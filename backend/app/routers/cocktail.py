import asyncio
import base64
from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from openai import OpenAI
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id
from ..llm_pipelines.cocktail_from_image import cocktail_extraction, generate_cocktail_instructions, get_cocktails_from_image
from ..llm_pipelines.helpers import process_image_data
from ..schemas.cocktail_schemas import Menu, Cocktail, Ingredient, Section, Step


router = APIRouter()

client = OpenAI()

def add_cocktail_from_image_db(user_id, menu_id, sorted_response):
    # Current timestamp
    current_time = datetime.now().isoformat()

    # response stores
    cocktails_db = []
    ingredients_db = []
    sections_db = []
    steps_db = []

    # loading batches
    cocktails_batch = []
    ingredients_batch = []
    sections_batch = []
    steps_batch = []

    # Stage 1: Insert Cocktails
    for cocktail in sorted_response:
        cocktails_batch.append(
            {
                "created_at": current_time,
                "updated_at": current_time,
                "menu_id": menu_id,
                "name": cocktail["name"],
                "uid": user_id,
            }
        )

    inserted_cocktails = supabase.table("cocktails").insert(cocktails_batch).execute()
    cocktails_db = inserted_cocktails.data

    # Stage 2: Prepare Ingredients and Sections
    temp_sect_id = 0
    for cocktail_info, cocktail_data in zip(cocktails_db, sorted_response):

        cocktail_id = cocktail_info['cocktail_id']

        for ingredient in cocktail_data["ingredients"]:
            ingredients_batch.append({
                "cocktail_id": cocktail_id,
                "created_at": current_time,
                "updated_at": current_time,
                "name": ingredient["name"],
                "type": ingredient.get("type"),
                "quantity": float(ingredient["quantity"]) if ingredient.get("quantity") is not None else None,
                "units": ingredient.get("units")
            })

        for section in cocktail_data["sections"]:
            sections_batch.append({
                "cocktail_id": cocktail_id,
                "created_at": current_time,
                "updated_at": current_time,
                "name": section.get("name"),
                "index": int(section["index"])
            })

            for step in section["steps"]:
                steps_batch.append({
                    "section_id": temp_sect_id,  # Placeholder, will update later
                    "created_at": current_time,
                    "updated_at": current_time,
                    "index": int(step["index"]),
                    "instruction": step["instruction"]
                })

            temp_sect_id += 1

    # Stage 3: Insert Ingredients and Sections, Retrieve Section IDs
    if ingredients_batch:
        data = supabase.table("ingredients").insert(ingredients_batch).execute()
        ingredients_db = data.data

    if sections_batch:
        data = supabase.table("sections").insert(sections_batch).execute()
        sections_db = data.data

        # Update section_id for steps
        for step in steps_batch:
            step['section_id'] = sections_db[step['section_id']]['section_id']

        # Stage 4: Insert Steps
        if steps_batch:
            data = supabase.table("steps").insert(steps_batch).execute()
            steps_db = data.data

    return cocktails_db, ingredients_db, sections_db, steps_db


def post_process_db_res(sorted_response, tails_db, ingrs_db, sects_db, steps_db):

    ingr_ct = 0
    sect_ct = 0
    step_ct = 0

    for cocktail, tail_db in zip(sorted_response, tails_db):
        cocktail.update(
            {
                "created_at": tail_db['created_at'],
                "updated_at": tail_db['updated_at'],
                "menu_id": tail_db['menu_id'],
                "cocktail_id": tail_db['cocktail_id']
            }
        )

        if ingrs_db and cocktail["ingredients"]:
            for ingr in cocktail["ingredients"]:
                ingr.update(
                    {
                        "created_at": ingrs_db[ingr_ct]['created_at'],
                        "updated_at": ingrs_db[ingr_ct]['updated_at'],
                        "ingredient_id": ingrs_db[ingr_ct]['ingredient_id'],
                        "cocktail_id": ingrs_db[ingr_ct]['cocktail_id']
                    }
                )
                ingr_ct += 1

        if sects_db and cocktail["sections"]:
            for sect in cocktail["sections"]:
                sect.update(
                    {
                        "section_id": sects_db[sect_ct]['section_id'],
                        "created_at": sects_db[sect_ct]['created_at'],
                        "updated_at": sects_db[sect_ct]['updated_at'],
                        "cocktail_id": sects_db[sect_ct]['cocktail_id']
                    }
                )
                sect_ct += 1

                if steps_db and sect["steps"]:
                    for step in sect["steps"]:
                        step.update(
                            {
                                "step_id": steps_db[step_ct]['step_id'],
                                "created_at": steps_db[step_ct]['created_at'],
                                "updated_at": steps_db[step_ct]['updated_at'],
                                "section_id": steps_db[step_ct]['section_id']
                            }
                        )
                        step_ct += 1

    return sorted_response

@router.post("/{menu_id:int}/ai")
async def upload_cocktail(
    menu_id: int,
    file: Optional[UploadFile] = File(None),
    base64_image: Optional[str] = Form(None),
    user_id: str = Depends(get_user_id)
):
    image_data = await process_image_data(base64_image=base64_image, file=file)
    response = await get_cocktails_from_image(image_data)
    sorted_response = sorted(response, key=lambda x: x['name'])

    tails_db, ingrs_db, sects_db, steps_db = add_cocktail_from_image_db(user_id, menu_id, sorted_response)
    sorted_response = post_process_db_res(sorted_response, tails_db, ingrs_db, sects_db, steps_db)

    return sorted_response

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


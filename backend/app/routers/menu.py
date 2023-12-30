from typing import Optional, List
from datetime import datetime
import uuid
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from pydantic import BaseModel
from ..database import supabase
from ..dependencies import get_user_id
from ..llm_pipelines.cocktail_from_image import get_cocktails_from_image, cocktail_extraction
from ..llm_pipelines.cocktails_db_helper import add_cocktail_from_image_db, post_process_db_res
from ..llm_pipelines.helpers import process_image_data, format_cocktail_list
from ..llm_pipelines.menu_generation_helper import generate_menu_name
from ..schemas.cocktail_schemas import Menu, Cocktail, Ingredient, Section, Step


router = APIRouter()


@router.get("", response_model=List[Menu])
async def get_menu_summary(user_id: str = Depends(get_user_id)):
    # Query the 'menus' table for all menus associated with the user
    menus_query = supabase.table("menus").select("*").eq("uid", user_id)
    menus_data = menus_query.execute()

    # Check if there are any menus found
    if not menus_data.data:
        raise HTTPException(status_code=404, detail="No menus found for the user")

    # Return the list of menus
    return menus_data.data


class MenuCreate(BaseModel):
    name: Optional[str] = 'New Menu'

@router.post("/create", response_model=Menu)
async def add_menu(menu_data: MenuCreate, user_id: str = Depends(get_user_id)):
    new_menu_data = menu_data.model_dump()
    new_menu_data['uid'] = user_id
    new_menu_data['created_at'] = datetime.now().isoformat()
    new_menu_data['updated_at'] = datetime.now().isoformat()

    insert_query = supabase.table("menus").insert(new_menu_data).execute()

    # Check if the insert was successful
    if not insert_query.data:
        raise HTTPException(status_code=500, detail="Failed to add the menu")

    # Return the inserted menu
    print(insert_query.data)
    return insert_query.data[0]


@router.post("/create/ai")
async def upload_menu_image(
    file: Optional[UploadFile] = File(None),
    base64_image: Optional[str] = Form(None),
    user_id: str = Depends(get_user_id)
):
    image_data = await process_image_data(base64_image=base64_image, file=file)
    cocktails = await cocktail_extraction(image_data)

    # menu creation / insertion
    cocktails_str = format_cocktail_list(cocktails)
    menu_name = await generate_menu_name(cocktails_str)
    temp_menu = {
        'name': menu_name,
        'uid': user_id,
        'created_at': datetime.now().isoformat(),
        'updated_at': datetime.now().isoformat(),
    }
    insert_query = supabase.table("menus").insert(temp_menu).execute()

    res_menu = insert_query.data[0]
    menu_id = res_menu['menu_id']

    # generate cocktails
    response = await get_cocktails_from_image(image_data, cocktails=cocktails)
    sorted_response = sorted(response, key=lambda x: x['name'])
    tails_db, ingrs_db, sects_db, steps_db = add_cocktail_from_image_db(user_id, menu_id, sorted_response)
    final_cocktails_list = post_process_db_res(sorted_response, tails_db, ingrs_db, sects_db, steps_db)

    res_menu['cocktails'] = final_cocktails_list

    return res_menu

@router.get("/id/{menu_id:int}", response_model=Menu)
async def get_menu(menu_id: int, user_id: str = Depends(get_user_id)):
    # Query the 'menus' table to get the specific menu
    menu_query = supabase.table("menus").select("*").eq("menu_id", menu_id).eq("uid", user_id)
    menu_data = menu_query.execute()

    # Check if the menu exists
    if not menu_data.data:
        raise HTTPException(status_code=404, detail="Menu not found")

    # Return the found menu
    return menu_data.data[0]


@router.get("/all", response_model=List[dict])
async def get_all_menu_details(user_id: str = Depends(get_user_id)):
    # Fetch all menus for the user
    menus_query = supabase.table("menus").select("*").eq("uid", user_id)
    menus_data = menus_query.execute()
    if not menus_data.data:
        raise HTTPException(status_code=404, detail="No menus found for the user")

    menu_ids = [menu['menu_id'] for menu in menus_data.data]

    # Fetch all cocktails in a single query
    cocktail_query = supabase.table("cocktails").select("*").in_("menu_id", menu_ids)
    cocktail_data = cocktail_query.execute()
    cocktails_by_menu_id = {menu_id: [] for menu_id in menu_ids}
    for cocktail in cocktail_data.data:
        cocktails_by_menu_id[cocktail['menu_id']].append(cocktail)

    # Fetch all ingredients, sections, and steps in batch
    cocktail_ids = [cocktail['cocktail_id'] for cocktail in cocktail_data.data]

    ingredients_query = supabase.table("ingredients").select("*").in_("cocktail_id", cocktail_ids)
    ingredients_data = ingredients_query.execute()
    ingredients_by_cocktail_id = {cocktail_id: [] for cocktail_id in cocktail_ids}
    for ingredient in ingredients_data.data:
        ingredients_by_cocktail_id[ingredient['cocktail_id']].append(ingredient)

    sections_query = supabase.table("sections").select("*").in_("cocktail_id", cocktail_ids).order("index")
    sections_data = sections_query.execute()
    sections_by_cocktail_id = {cocktail_id: [] for cocktail_id in cocktail_ids}
    for section in sections_data.data:
        sections_by_cocktail_id[section['cocktail_id']].append(section)

    steps_query = supabase.table("steps").select("*").in_("section_id", [section['section_id'] for section in sections_data.data]).order("index")
    steps_data = steps_query.execute()
    steps_by_section_id = {section['section_id']: [] for section in sections_data.data}
    for step in steps_data.data:
        steps_by_section_id[step['section_id']].append(step)

    # Construct the full details
    all_menus_full_details = []
    for menu in menus_data.data:
        cocktails_full_details = []
        for cocktail in cocktails_by_menu_id[menu['menu_id']]:
            cocktail_sections = []
            for section in sections_by_cocktail_id[cocktail['cocktail_id']]:
                section_with_steps = section
                section_with_steps["steps"] = steps_by_section_id[section['section_id']]
                cocktail_sections.append(section_with_steps)

            cocktails_full_details.append({
                "cocktail_id": cocktail['cocktail_id'],
                "created_at": cocktail['created_at'],
                "updated_at": cocktail['updated_at'],
                "menu_id": cocktail['menu_id'],
                "name": cocktail['name'],
                "ingredients": ingredients_by_cocktail_id[cocktail['cocktail_id']],
                "sections": cocktail_sections
            })

        all_menus_full_details.append({
            "menu_id": menu['menu_id'],
            "created_at": menu['created_at'],
            "updated_at": menu['updated_at'],
            "uid": menu['uid'],
            "name": menu.get('name'),
            "cocktails": cocktails_full_details
        })

    return all_menus_full_details


## NOT USED -------- ##

@router.get("/id/{menu_id:int}/cocktails", response_model=List[Cocktail])
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


@router.get("/id/{menu_id:int}/details", response_model=dict)
async def get_menu_full_details(menu_id: int, user_id: str = Depends(get_user_id)):
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

@router.delete("/id/{menu_id:int}", response_model=dict)
async def delete_menu(menu_id: int, user_id: str = Depends(get_user_id)):
    # Check if the menu exists
    menu_query = supabase.table("menus").select("menu_id").eq("menu_id", menu_id).eq("uid", user_id)
    menu_data = menu_query.execute()
    if not menu_data.data:
        raise HTTPException(status_code=404, detail="Menu not found")

    # Get all cocktail IDs for the menu
    cocktail_ids_query = supabase.table("cocktails").select("cocktail_id").eq("menu_id", menu_id)
    cocktail_ids_data = cocktail_ids_query.execute()
    cocktail_ids = [cocktail['cocktail_id'] for cocktail in cocktail_ids_data.data]

    if cocktail_ids:
        # Get all section IDs for these cocktails
        section_ids_query = supabase.table("sections").select("section_id").in_("cocktail_id", cocktail_ids)
        section_ids_data = section_ids_query.execute()
        section_ids = [section['section_id'] for section in section_ids_data.data]

        # Delete steps for these sections
        if section_ids:
            supabase.table("steps").delete().in_("section_id", section_ids).execute()

        # Delete sections for these cocktails
        supabase.table("sections").delete().in_("cocktail_id", cocktail_ids).execute()

        # Delete ingredients for these cocktails
        supabase.table("ingredients").delete().in_("cocktail_id", cocktail_ids).execute()

    # Delete cocktails for the menu
    supabase.table("cocktails").delete().eq("menu_id", menu_id).execute()

    # Delete the menu
    delete_menu_result = supabase.table("menus").delete().eq("menu_id", menu_id).execute()

    if not delete_menu_result.data:
        raise HTTPException(status_code=500, detail="Failed to delete the menu")

    return {"detail": "Menu deleted successfully"}
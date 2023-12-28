from ..database import supabase
from datetime import datetime


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
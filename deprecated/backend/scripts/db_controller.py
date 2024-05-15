import os
import requests
from pydantic import BaseModel
from datetime import datetime
from random import choice, randint
from typing import Optional
from supabase import create_client, Client

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase: Client = create_client(url, key)
USER_ID = "8e2fc51e-58a6-469d-b932-d483dd9e10b5"

class BottleData(BaseModel):
    name: str
    type: str
    qty: int = 1
    current: bool = True
    price: Optional[float] = None
    description: str = ""
    bar_id: Optional[int] = None


def add_bottle(user_id: str, bottle_data: BottleData):
    # Assuming your API is hosted and accessible at a given URL
    api_url = "http://127.0.0.1:8000/api/cellar/add_bottle"

    headers = {"Authorization": f"Bearer {user_id}"}

    response = requests.post(api_url, headers=headers, json=bottle_data.model_dump())

    if response.status_code != 200:
        print(f"Failed to add bottle: {response.text}")
    else:
        print(f"Bottle added successfully: {response.json()}")


def generate_synthetic_bottle_data():
    types = ["Wine", "Whiskey", "Vodka", "Rum", "Tequila"]
    names = ["Brand A", "Brand B", "Brand C", "Brand D", "Brand E"]

    return BottleData(
        name=choice(names),
        type=choice(types),
        qty=randint(1, 10),
        current=choice([True, False]),
        price=randint(10, 100),
        description="A synthetic bottle description.",
        bar_id=None
    )


class MenuData(BaseModel):
    name: Optional[str]

def generate_synthetic_menu_data():
    adjectives = ["Summer", "Winter", "Spring", "Autumn", "Holiday", "Exclusive", "Classic", "Tropical", "Cozy"]
    themes = ["Delights", "Collection", "Fiesta", "Specials", "Favorites", "Selection", "Gala", "Jubilee", "Extravaganza"]
    types = ["Menu", "Assortment", "Series", "Range", "Variety", "Array", "Set", "Lineup", "Spread"]

    name = f"{choice(adjectives)} {choice(themes)} {choice(types)}"
    return MenuData(name=name)


def add_menu(user_id: str, menu_data: MenuData):
    # Assuming your API is hosted and accessible at a given URL
    api_url = "http://127.0.0.1:8000/api/menu/create"

    headers = {"Authorization": f"Bearer {user_id}"}

    response = requests.post(api_url, headers=headers, json=menu_data.model_dump())

    if response.status_code != 200:
        print(f"Failed to add menu: {response.text}")
    else:
        print(f"Menu added successfully: {response.json()}")

def main_bottle():
    bottles_to_add = 5
    for _ in range(bottles_to_add):
        synthetic_bottle = generate_synthetic_bottle_data()
        add_bottle(USER_ID, synthetic_bottle)


def main_menu():
    menus_to_add = 2
    for _ in range(menus_to_add):
        synthetic_menu = generate_synthetic_menu_data()
        add_menu(USER_ID, synthetic_menu)

if __name__ == "__main__":
    main_menu()

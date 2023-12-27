from enum import Enum
from typing import List

from pydantic import BaseModel

class BottleType(str, Enum):
    wine = "Wine"
    whiskey = "Whiskey"
    vodka = "Vodka"
    tequila = "Tequila"
    rum = "Rum"
    gin = "Gin"
    brandy = "Brandy"
    liqueur = "Liqueur"
    champagne = "Champagne"
    beer = "Beer"
    cider = "Cider"
    sake = "Sake"
    absinthe = "Absinthe"
    mezcal = "Mezcal"
    bitters = "Bitters"
    mixer = "Mixer"
    garnish = "Garnish" # added
    other = "Other"

    @classmethod
    def list(cls) -> List[str]:
        return [item.value for item in cls]

class YourModel(BaseModel):
    bottle_type: BottleType

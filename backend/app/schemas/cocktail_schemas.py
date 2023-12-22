from typing import Optional, List
from datetime import datetime
import uuid
from pydantic import BaseModel

class Menu(BaseModel):
    menu_id: int
    created_at: datetime
    updated_at: datetime
    uid: uuid.UUID
    name: Optional[str]

class Cocktail(BaseModel):
    cocktail_id: int
    created_at: datetime
    updated_at: datetime
    menu_id: int
    name: str

class Ingredient(BaseModel):
    ingredient_id: int
    cocktail_id: int
    created_at: datetime
    updated_at: datetime
    name: str
    type: Optional[str]
    quantity: Optional[float]
    units: Optional[str]

class Section(BaseModel):
    section_id: int
    cocktail_id: int
    created_at: datetime
    updated_at: datetime
    name: Optional[str]
    index: int

class Step(BaseModel):
    step_id: int
    section_id: int
    created_at: datetime
    updated_at: datetime
    index: int
    instruction: str
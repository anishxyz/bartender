from fastapi import FastAPI

from app.routers import cellar, cocktail, menu

app = FastAPI()
# uvicorn app.main:app --reload

app.include_router(cellar.router, prefix="/api/cellar", tags=["cellar"])
app.include_router(menu.router, prefix="/api/menu", tags=["menu"])
app.include_router(cocktail.router, prefix="/api/cocktail", tags=["cocktail"])


@app.get("/")
async def read_root():
    return {"Hello": "World"}


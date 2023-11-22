from fastapi import FastAPI

from app.routers import cellar

app = FastAPI()
# uvicorn app.main:app --reload

app.include_router(cellar.router, prefix="/api/cellar", tags=["cellar"])


@app.get("/")
async def read_root():
    return {"Hello": "World"}


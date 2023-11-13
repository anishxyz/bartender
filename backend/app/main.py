from fastapi import FastAPI

app = FastAPI()
# uvicorn app.main:app --reload


@app.get("/")
async def read_root():
    return {"Hello": "World"}

from fastapi import FastAPI
from app.api.v1.endpoints.telegram import router as telegram_router

app = FastAPI(title="FastAPI Clean Architecture", version="1.0.0")

app.include_router(telegram_router, prefix="/api/v1/telegram", tags=["telegram"])

@app.get("/")
def read_root():
    return {"message": "Welcome to FastAPI with Clean Architecture"}
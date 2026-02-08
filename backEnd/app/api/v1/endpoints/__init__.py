from fastapi import APIRouter

from .telegram import router as telegram_router

router = APIRouter()

# Include the telegram router
router.include_router(telegram_router, prefix="/tg", tags=["Telegram"])
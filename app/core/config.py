from pydantic_settings import BaseSettings
import os

class Settings(BaseSettings):
    app_name: str = "FastAPI Clean Architecture"
    database_url: str = "postgresql://neondb_owner:npg_ztKJ3YdEoGC2@ep-soft-boat-adabqlr6-pooler.c-2.us-east-1.aws.neon.tech/Hustler_db?sslmode=require&channel_binding=require"

    # Telegram API settings
    telegram_api_id: int = 0  # Replace with your API ID
    telegram_api_hash: str = ""  # Replace with your API Hash

    # Gemini API settings
    gemini_api_key: str = ""
    gemini_api_keys: str = ""  # Comma-separated list of keys

    class Config:
        env_file = os.path.join(os.path.dirname(__file__), "../../.env")

settings = Settings()

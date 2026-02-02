from pydantic import BaseSettings

class Settings(BaseSettings):
    app_name: str = "FastAPI Clean Architecture"
    database_url: str = "sqlite:///./test.db"

    # Telegram API settings
    telegram_api_id: int = 0  # Replace with your API ID
    telegram_api_hash: str = ""  # Replace with your API Hash

    class Config:
        env_file = ".env"

settings = Settings()
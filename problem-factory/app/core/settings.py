from pydantic import BaseModel
import os


class Settings(BaseModel):
    app_env: str = os.getenv("APP_ENV", "local")
    port: int = int(os.getenv("PORT", "8090"))
    redis_url: str = os.getenv("REDIS_URL", "redis://localhost:6379/0")
    database_url: str = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/project1")


settings = Settings()

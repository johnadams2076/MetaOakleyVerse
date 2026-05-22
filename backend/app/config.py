from __future__ import annotations

import os
from dataclasses import dataclass


def _to_bool(value: str | None, default: bool) -> bool:
    if value is None:
        return default
    return value.strip().lower() in {"1", "true", "yes", "on"}


@dataclass(frozen=True)
class Settings:
    app_env: str = os.getenv("APP_ENV", "development")
    mock_ai: bool = _to_bool(os.getenv("MOCK_AI"), True)
    openai_api_key: str = os.getenv("OPENAI_API_KEY", "")
    openai_vision_model: str = os.getenv("OPENAI_VISION_MODEL", "gpt-4.1-mini")
    max_image_upload_mb: int = int(os.getenv("MAX_IMAGE_UPLOAD_MB", "12"))
    max_video_upload_mb: int = int(os.getenv("MAX_VIDEO_UPLOAD_MB", "100"))
    enable_gemini_video: bool = _to_bool(os.getenv("ENABLE_GEMINI_VIDEO"), False)
    enable_gemini_image_edit: bool = _to_bool(os.getenv("ENABLE_GEMINI_IMAGE_EDIT"), False)


settings = Settings()

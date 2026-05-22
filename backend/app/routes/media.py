from __future__ import annotations

from fastapi import APIRouter, File, Form, UploadFile

from app.providers.mock_ai import background_not_configured
from app.schemas import BackgroundEditResponse

router = APIRouter(prefix="/v1/media", tags=["media"])


@router.post("/background", response_model=BackgroundEditResponse)
async def background_edit(
    media: UploadFile = File(...),
    media_type: str = Form(...),
    prompt: str | None = Form(default=None),
    preserve_subject: bool = Form(default=True),
) -> BackgroundEditResponse:
    del media, media_type, prompt, preserve_subject
    return background_not_configured()

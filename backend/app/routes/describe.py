from __future__ import annotations

from fastapi import APIRouter, File, Form, HTTPException, UploadFile

from app.config import settings
from app.media_utils import ensure_image_type, ensure_size_limit
from app.providers.mock_ai import mock_photo_response, mock_video_response
from app.providers.openai_vision import describe_photo_with_openai
from app.schemas import DescribePhotoResponse, DescribeVideoResponse

router = APIRouter(prefix="/v1/describe", tags=["describe"])


@router.post("/photo", response_model=DescribePhotoResponse)
async def describe_photo(
    image: UploadFile = File(...),
    question: str | None = Form(default=None),
    mode: str = Form(default="scene_description"),
) -> DescribePhotoResponse:
    del mode
    ensure_image_type(image)
    content = await image.read()
    ensure_size_limit(content, settings.max_image_upload_mb, "Image")

    if settings.mock_ai:
        return mock_photo_response()

    if not settings.openai_api_key:
        raise HTTPException(status_code=503, detail="OpenAI provider is not configured")

    return describe_photo_with_openai(
        api_key=settings.openai_api_key,
        model=settings.openai_vision_model,
        image_bytes=content,
        question=question,
    )


@router.post("/video", response_model=DescribeVideoResponse)
async def describe_video(
    frames: list[UploadFile] | None = File(default=None),
    video: UploadFile | None = File(default=None),
    question: str | None = Form(default=None),
    strategy: str = Form(default="openai_keyframes"),
) -> DescribeVideoResponse:
    del question, strategy
    if not frames and not video:
        raise HTTPException(status_code=400, detail="Provide frames[] or video")

    if frames:
        for frame in frames:
            ensure_image_type(frame)
            content = await frame.read()
            ensure_size_limit(content, settings.max_image_upload_mb, "Frame")

    if video:
        content = await video.read()
        ensure_size_limit(content, settings.max_video_upload_mb, "Video")

    return mock_video_response()

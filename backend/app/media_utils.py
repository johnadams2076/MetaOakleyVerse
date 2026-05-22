from __future__ import annotations

from fastapi import HTTPException, UploadFile

_ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/png", "image/webp"}


def ensure_image_type(upload: UploadFile) -> None:
    if upload.content_type not in _ALLOWED_IMAGE_TYPES:
        raise HTTPException(status_code=400, detail="Unsupported image content type")


def ensure_size_limit(content: bytes, max_mb: int, kind: str) -> None:
    max_bytes = max_mb * 1024 * 1024
    if len(content) > max_bytes:
        raise HTTPException(status_code=413, detail=f"{kind} exceeds {max_mb}MB limit")

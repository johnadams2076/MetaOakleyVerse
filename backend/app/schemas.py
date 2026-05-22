from __future__ import annotations

from pydantic import BaseModel


class HealthResponse(BaseModel):
    status: str
    version: str


class DescribePhotoResponse(BaseModel):
    request_id: str
    short_description: str
    detailed_description: str
    spoken_response: str
    safety_notes: list[str]
    model: str
    provider: str


class VideoObservation(BaseModel):
    timestamp_seconds: int
    description: str


class DescribeVideoResponse(BaseModel):
    request_id: str
    summary: str
    spoken_response: str
    observations: list[VideoObservation]
    model: str
    provider: str
    strategy: str


class BackgroundEditResponse(BaseModel):
    request_id: str
    status: str
    media_type: str | None = None
    prompt_used: str | None = None
    result_base64: str | None = None
    result_url: str | None = None
    provider: str | None = None
    message: str | None = None

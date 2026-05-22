from __future__ import annotations

from app.schemas import BackgroundEditResponse, DescribePhotoResponse, DescribeVideoResponse, VideoObservation


def mock_photo_response() -> DescribePhotoResponse:
    return DescribePhotoResponse(
        request_id="mock-request-id",
        short_description="A mock scene description is ready.",
        detailed_description=(
            "This is a mock response for a captured glasses-style photo. It confirms that "
            "capture, upload, AI response parsing, display, and speech playback are wired correctly."
        ),
        spoken_response="A mock scene description is ready.",
        safety_notes=[],
        model="mock-model",
        provider="mock",
    )


def mock_video_response() -> DescribeVideoResponse:
    return DescribeVideoResponse(
        request_id="mock-video-request-id",
        summary="This mock video appears to show a short glasses-style view with changing frames.",
        spoken_response="This mock video flow is working.",
        observations=[VideoObservation(timestamp_seconds=0, description="Mock frame zero is visible.")],
        model="mock-model",
        provider="mock",
        strategy="mock",
    )


def background_not_configured() -> BackgroundEditResponse:
    return BackgroundEditResponse(
        request_id="mock-background-request-id",
        status="not_configured",
        message="Background editing provider is not configured yet.",
    )

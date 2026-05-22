from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_describe_video_not_implemented_or_mock() -> None:
    files = [("frames", ("f1.jpg", b"bytes", "image/jpeg"))]
    response = client.post("/v1/describe/video", files=files)
    assert response.status_code == 200
    body = response.json()
    assert body["provider"] == "mock"
    assert body["strategy"] == "mock"

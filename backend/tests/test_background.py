from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_background_not_configured_returns_clear_message() -> None:
    files = {"media": ("scene.jpg", b"bytes", "image/jpeg")}
    data = {"media_type": "image", "preserve_subject": "true"}
    response = client.post("/v1/media/background", files=files, data=data)
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "not_configured"
    assert "not configured" in body["message"].lower()

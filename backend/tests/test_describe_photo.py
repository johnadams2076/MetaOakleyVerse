from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_describe_photo_mock_success() -> None:
    files = {"image": ("scene.jpg", b"fake-jpg-bytes", "image/jpeg")}
    response = client.post("/v1/describe/photo", files=files)
    assert response.status_code == 200
    body = response.json()
    assert body["provider"] == "mock"
    assert "mock scene" in body["short_description"].lower()
    assert body["spoken_response"]
    assert body["short_description"]


def test_describe_photo_rejects_large_file() -> None:
    large = b"x" * (13 * 1024 * 1024)
    files = {"image": ("big.jpg", large, "image/jpeg")}
    response = client.post("/v1/describe/photo", files=files)
    assert response.status_code == 413


def test_describe_photo_rejects_invalid_type() -> None:
    files = {"image": ("bad.txt", b"not-image", "text/plain")}
    response = client.post("/v1/describe/photo", files=files)
    assert response.status_code == 400

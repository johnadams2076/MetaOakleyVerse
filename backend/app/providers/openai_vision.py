from __future__ import annotations

import base64

from openai import OpenAI

from app.schemas import DescribePhotoResponse

PHOTO_PROMPT = """You are an accessibility-focused visual assistant for a user wearing Meta/Oakley AI glasses.
The user intentionally captured this image and wants a helpful description.
Instructions:
- Start with the most important answer in one sentence.
- Then describe relevant objects, people, signs, text, obstacles, and spatial layout.
- If the user asked a question, answer that question first.
- Do not identify private people by name.
- Do not infer sensitive attributes.
- Do not pretend certainty when visual evidence is unclear.
- Keep the spoken response natural and concise."""


def describe_photo_with_openai(
    api_key: str,
    model: str,
    image_bytes: bytes,
    question: str | None,
) -> DescribePhotoResponse:
    client = OpenAI(api_key=api_key)
    payload = base64.b64encode(image_bytes).decode("utf-8")
    user_text = question or "Describe what is most important in this image."
    completion = client.responses.create(
        model=model,
        input=[
            {
                "role": "system",
                "content": [{"type": "input_text", "text": PHOTO_PROMPT}],
            },
            {
                "role": "user",
                "content": [
                    {"type": "input_text", "text": user_text},
                    {"type": "input_image", "image_url": f"data:image/jpeg;base64,{payload}"},
                ],
            },
        ],
    )
    text = completion.output_text or "Description unavailable."
    return DescribePhotoResponse(
        request_id=completion.id,
        short_description=text.split(".")[0].strip() + ".",
        detailed_description=text,
        spoken_response=text,
        safety_notes=[],
        model=model,
        provider="openai",
    )

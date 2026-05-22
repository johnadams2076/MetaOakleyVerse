from __future__ import annotations

from fastapi import FastAPI

from app.routes.describe import router as describe_router
from app.routes.health import router as health_router
from app.routes.media import router as media_router

app = FastAPI(title="Meta Oakley Vision Backend", version="0.1.0")
app.include_router(health_router)
app.include_router(describe_router)
app.include_router(media_router)

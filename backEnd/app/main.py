from fastapi import FastAPI, Depends, HTTPException, Request
from collections import defaultdict, deque
from datetime import datetime, timedelta
import asyncio
from sqlalchemy.orm import Session
from app.crud.db_poster import sync_job_posts, get_all_jobs, get_db
from app.api.v1.endpoints import telegram, map, resume, github

app = FastAPI()

# Simple in-memory rate limiter (per IP)
RATE_LIMIT_MAX_REQUESTS = 60
RATE_LIMIT_WINDOW_SECONDS = 60
_rate_limit_store = defaultdict(deque)
_rate_limit_lock = asyncio.Lock()


def _get_client_ip(request: Request) -> str:
    forwarded = request.headers.get("x-forwarded-for")
    if forwarded:
        return forwarded.split(",")[0].strip()
    return request.client.host if request.client else "unknown"


@app.middleware("http")
async def rate_limit_middleware(request: Request, call_next):
    ip = _get_client_ip(request)
    now = datetime.utcnow()
    window_start = now - timedelta(seconds=RATE_LIMIT_WINDOW_SECONDS)

    async with _rate_limit_lock:
        q = _rate_limit_store[ip]
        while q and q[0] < window_start:
            q.popleft()
        if len(q) >= RATE_LIMIT_MAX_REQUESTS:
            raise HTTPException(status_code=429, detail="Rate limit exceeded")
        q.append(now)

    response = await call_next(request)
    return response

app.include_router(telegram.router, prefix="/api/v1/telegram", tags=["telegram"])
app.include_router(map.router, prefix="/api/v1/map", tags=["map"])
app.include_router(resume.router, prefix="/api/v1/resume", tags=["resume"])
app.include_router(github.router, prefix="/api/v1/github", tags=["github"])

@app.get("/")
def read_root():
    return {"message": "Hustlers API is running"}

# List all jobs endpoint
@app.get("/api/jobs")
def list_jobs(db: Session = Depends(get_db)):
    try:
        jobs = get_all_jobs(db)
        return {"status": "success", "jobs": jobs}
    except Exception as e:
        return {"status": "error", "message": str(e)}

# Cron job endpoint
@app.post("/api/sync-jobs")
async def run_sync_jobs():
    try:
        await sync_job_posts()
        return {"status": "success", "message": "Job posts synced successfully"}
    except Exception as e:
        return {"status": "error", "message": str(e)}
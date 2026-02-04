from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from app.crud.db_poster import sync_job_posts, get_all_jobs, get_db

app = FastAPI()

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
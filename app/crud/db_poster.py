from __future__ import annotations

from datetime import datetime, timedelta
from typing import Any, Dict, Iterable, List, Optional

from sqlalchemy.orm import Session
from sqlalchemy import text

from app.db.session import SessionLocal
from app.models.post import JobPost


def get_db() -> Iterable[Session]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def _parse_datetime(value: Optional[Any]) -> Optional[datetime]:
    if value is None or value == "":
        return None
    if isinstance(value, datetime):
        return value
    if isinstance(value, str):
        try:
            return datetime.fromisoformat(value)
        except ValueError:
            return None
    return None


def _calculate_ttl(expiry_date: Optional[str]) -> Optional[int]:
    """Calculate time to live in hours from expiry date to now"""
    if not expiry_date:
        return None
    
    expiry_dt = _parse_datetime(expiry_date)
    if not expiry_dt:
        return None
    
    now = datetime.now(expiry_dt.tzinfo) if expiry_dt.tzinfo else datetime.now()
    if expiry_dt <= now:
        return 0  # Already expired
    
    ttl_seconds = (expiry_dt - now).total_seconds()
    ttl_hours = int(ttl_seconds / 3600)
    return max(0, ttl_hours)


def _build_job_post(data: Dict[str, Any]) -> JobPost:
    """Build JobPost from AI service data with TTL calculation"""
    posted_at = _parse_datetime(data.get("date") or data.get("posted_at"))
    ttl_hours = _calculate_ttl(data.get("expierdate"))
    
    # Calculate expires_at based on posted_at and TTL
    expires_at = None
    if posted_at and ttl_hours is not None:
        from datetime import timedelta
        expires_at = posted_at + timedelta(hours=ttl_hours)
    
    return JobPost(
        jobname=data.get("jobname", ""),
        jobtype=data.get("jobtype", ""),
        price=data.get("price", ""),
        expierdate=data.get("expierdate", ""),
        jobdescrbiton=data.get("jobdescrbiton", ""),
        deep_link=data.get("deep_link"),
        posted_at=posted_at,
        ttl_hours=ttl_hours,
        expires_at=expires_at,
    )


def cleanup_expired_jobs(db: Session) -> int:
    """Delete expired jobs using PostgreSQL function"""
    try:
        result = db.execute(text("SELECT cleanup_expired_jobs()"))
        deleted_count = result.scalar()
        db.commit()
        print(f"Cleaned up {deleted_count} expired jobs")
        return deleted_count
    except Exception as e:
        db.rollback()
        print(f"Error cleaning up expired jobs: {e}")
        return 0


async def sync_job_posts():
    """Main task to fetch from Telegram, process with AI, and save to DB."""
    print("Fetching and processing job posts from AI service...")
    
    # Import here to avoid circular import
    from app.services.ai_service import res as fetch_and_process_jobs
    
    # Get processed job data from AI service
    try:
        all_jobs_data = await fetch_and_process_jobs()
        print(f"Retrieved {len(all_jobs_data)} job posts from AI service")
    except Exception as e:
        print(f"Error fetching job data from AI service: {e}")
        return
    
    if not all_jobs_data:
        print("No job posts to sync")
        return
    
    db = SessionLocal()
    try:
        # Filter out error responses and build job posts
        valid_jobs = []
        for job_data in all_jobs_data:
            if "error" not in job_data and job_data.get("jobname"):
                job_post = _build_job_post(job_data)
                
                # Calculate and print TTL for each job
                ttl_hours = job_post.ttl_hours
                if ttl_hours is not None:
                    print(f"Job '{job_post.jobname}' - TTL: {ttl_hours} hours, Expires: {job_post.expires_at}")
                else:
                    print(f"Job '{job_post.jobname}' - TTL: Unknown")
                
                valid_jobs.append(job_post)
            else:
                print(f"Skipping invalid job data: {job_data}")
        
        if valid_jobs:
            db.add_all(valid_jobs)
            db.commit()
            print(f"Successfully synced {len(valid_jobs)} job posts to database")
            
            # Clean up expired jobs after sync
            cleanup_expired_jobs(db)
        else:
            print("No valid job posts to save")
            
    except Exception as e:
        db.rollback()
        print(f"Error syncing job posts: {e}")
    finally:
        db.close()


def create_job_post(db: Session, job_data: Dict[str, Any]) -> JobPost:
    """Create a single job post from AI service data"""
    job_post = _build_job_post(job_data)
    
    # Calculate TTL
    ttl_hours = _calculate_ttl(job_data.get("expierdate"))
    print(f"Creating job '{job_post.jobname}' with TTL: {ttl_hours} hours")
    
    try:
        db.add(job_post)
        db.commit()
        db.refresh(job_post)
    except Exception:
        db.rollback()
        raise
    return job_post


def create_job_posts(db: Session, posts: Iterable[Dict[str, Any]]) -> List[JobPost]:
    """Create multiple job posts from AI service data"""
    job_posts = []
    
    for post_data in posts:
        if "error" not in post_data and post_data.get("jobname"):
            job_post = _build_job_post(post_data)
            
            # Calculate TTL
            ttl_hours = _calculate_ttl(post_data.get("expierdate"))
            print(f"Adding job '{job_post.jobname}' with TTL: {ttl_hours} hours")
            
            job_posts.append(job_post)
        else:
            print(f"Skipping invalid post: {post_data}")
    
    try:
        db.add_all(job_posts)
        db.commit()
        for job_post in job_posts:
            db.refresh(job_post)
        print(f"Successfully created {len(job_posts)} job posts")
    except Exception:
        db.rollback()
        raise
    return job_posts


def get_active_jobs(db: Session, ttl_hours: int = 24) -> List[JobPost]:
    """Get jobs that are still active within specified TTL hours"""
    from sqlalchemy import and_
    
    cutoff_time = datetime.now() - timedelta(hours=ttl_hours)
    
    return db.query(JobPost).filter(
        and_(
            JobPost.posted_at >= cutoff_time,
            JobPost.expierdate.isnot(None),
            JobPost.expierdate != ""
        )
    ).all()


def get_expired_jobs(db: Session) -> List[JobPost]:
    """Get jobs that have expired"""
    from sqlalchemy import and_
    
    now = datetime.now()
    
    return db.query(JobPost).filter(
        and_(
            JobPost.expierdate.isnot(None),
            JobPost.expierdate != "",
            # This would need proper date parsing in a real implementation
            # For now, we'll use posted_at as a rough estimate
            JobPost.posted_at < now - timedelta(days=30)  # Assume 30 days expiry
        )
    ).all()


def get_all_jobs(db: Session) -> List[JobPost]:
    """Get all job posts from the database"""
    return db.query(JobPost).order_by(JobPost.posted_at.desc()).all()

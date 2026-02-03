from contextlib import contextmanager
from typing import Dict, Iterable, List
from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.post import JobPost


@contextmanager
def get_db() -> Session:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def create_job_post(db: Session, data: Dict) -> JobPost:
    post = JobPost(**data)
    db.add(post)
    db.commit()
    db.refresh(post)
    return post


def create_job_posts(db: Session, items: Iterable[Dict]) -> List[JobPost]:
    posts = [JobPost(**item) for item in items]
    db.add_all(posts)
    db.commit()
    for post in posts:
        db.refresh(post)
    return posts

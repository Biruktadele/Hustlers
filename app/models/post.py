from datetime import datetime
from sqlalchemy import DateTime, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from app.db.base import Base


class JobPost(Base):
    __tablename__ = "job_posts"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    job_name: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    job_type: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    job_location: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    salary: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    application_deadline: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    job_description: Mapped[str] = mapped_column(Text, nullable=False, default="")
    post_text: Mapped[str] = mapped_column(Text, nullable=False, default="")
    deep_link: Mapped[str] = mapped_column(String(512), nullable=True)
    posted_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=True)

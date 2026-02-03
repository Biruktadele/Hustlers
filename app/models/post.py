from datetime import datetime
from sqlalchemy import DateTime, String, Text, Integer, func
from sqlalchemy.orm import Mapped, mapped_column
from app.db.base import Base


class JobPost(Base):
    __tablename__ = "job_posts"

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    jobname: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    jobtype: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    price: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    expierdate: Mapped[str] = mapped_column(String(255), nullable=False, default="")
    jobdescrbiton: Mapped[str] = mapped_column(Text, nullable=False, default="")
    deep_link: Mapped[str] = mapped_column(String(512), nullable=True)
    posted_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=True)
    ttl_hours: Mapped[int] = mapped_column(Integer, nullable=True)  # TTL in hours
    expires_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=True)  # Auto-calc expiry

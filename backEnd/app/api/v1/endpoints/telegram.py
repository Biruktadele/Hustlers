from fastapi import APIRouter, HTTPException
from typing import List, Dict
from app.services.telegram_service import telegram_service
from app.services.singel_group_services.fetch_afriworkamharic import main as fetch_jobs

router = APIRouter()

@router.get("/group/{group_username}/posts", response_model=List[Dict])
async def get_group_posts(group_username: str, limit: int = 10):
    """
    Get recent posts from a Telegram group/channel.

    - **group_username**: The username of the group/channel (without @)
    - **limit**: Number of posts to retrieve (default: 10)
    """
    try:
        posts = await telegram_service.get_group_posts(group_username, limit)
        return posts
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching posts: {str(e)}")

@router.get("/group/{group_username}/info")
async def get_group_info(group_username: str):
    """
    Get information about a Telegram group/channel.

    - **group_username**: The username of the group/channel (without @)
    """
    try:
        info = await telegram_service.get_group_info(group_username)
        return info
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching group info: {str(e)}")

@router.get("/jobs")
async def get_jobs():
    """
    Fetch jobs from the Afriwork Amharic group.
    """
    try:
        jobs = await fetch_jobs()

        return {
            "status_code": 200,
            "status": "success",
            "data": jobs
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching jobs: {str(e)}")
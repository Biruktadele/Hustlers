from fastapi import APIRouter, HTTPException
from app.services.github_service import github_service

router = APIRouter()


@router.get("/repos/score")
async def score_repos(username: str, role: str, limit: int = 5):
    try:
        results = await github_service.score_repos_for_role(username=username, role=role, limit=limit)
        return {"status": "success", "data": results}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to score repos: {str(e)}")

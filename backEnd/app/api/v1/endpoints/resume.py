from fastapi import APIRouter, HTTPException, UploadFile, File, Form
from pydantic import BaseModel
from typing import Dict, List, Optional
from app.services.resume_parser_service import resume_parser_service
from app.services.resume_suggestion_service import resume_suggestion_service

router = APIRouter()


class ResumeSuggestionRequest(BaseModel):
    resume_text: str
    github_username: str
    role: str
    limit: int = 5


class ParsedResumeModel(BaseModel):
    name: Optional[str]
    email: Optional[str]
    phone: Optional[str]
    skills: List[str]
    experience: List[str]
    education: List[str]
    projects: List[str]


class GitHubRepoScoreModel(BaseModel):
    name: str
    url: str
    description: str
    scores: Dict[str, int]
    total: int
    evidence: Dict[str, str]


class GitHubScoresModel(BaseModel):
    username: str
    role: str
    repos: List[GitHubRepoScoreModel]


class ResumeSuggestionsModel(BaseModel):
    resume_summary: str
    strengths: List[str]
    gaps: List[str]
    skills_to_add: List[str]
    project_improvements: List[str]
    bullet_rewrites: List[str]
    github_highlights: List[str]
    next_steps: List[str]


class ResumeSuggestionDataModel(BaseModel):
    resume: ParsedResumeModel
    github: GitHubScoresModel
    suggestions: ResumeSuggestionsModel


class ResumeSuggestionResponseModel(BaseModel):
    status: str
    data: ResumeSuggestionDataModel


@router.post("/parse")
async def parse_resume(file: UploadFile = File(...)):
    if file.content_type not in {"application/pdf", "application/octet-stream"}:
        raise HTTPException(status_code=400, detail="Only PDF files are supported")

    try:
        file_bytes = await file.read()
        parsed = resume_parser_service.parse_pdf(file_bytes)
        return {"status": "success", "data": parsed}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to parse resume: {str(e)}")


@router.post("/suggestions", response_model=ResumeSuggestionResponseModel)
async def resume_suggestions(payload: ResumeSuggestionRequest):
    try:
        result = await resume_suggestion_service.generate_suggestions(
            resume_text=payload.resume_text,
            github_username=payload.github_username,
            role=payload.role,
            limit=payload.limit,
        )
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate suggestions: {str(e)}")


@router.post("/suggestions/pdf", response_model=ResumeSuggestionResponseModel)
async def resume_suggestions_from_pdf(
    file: UploadFile = File(...),
    github_username: str = Form(...),
    role: str = Form(...),
    limit: int = Form(5),
):
    if file.content_type not in {"application/pdf", "application/octet-stream"}:
        raise HTTPException(status_code=400, detail="Only PDF files are supported")

    try:
        file_bytes = await file.read()
        resume_text = resume_parser_service.extract_text(file_bytes)
        result = await resume_suggestion_service.generate_suggestions(
            resume_text=resume_text,
            github_username=github_username,
            role=role,
            limit=limit,
        )
        return {"status": "success", "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to generate suggestions: {str(e)}")

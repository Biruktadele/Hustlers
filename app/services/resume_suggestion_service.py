from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, Tuple

from app.services.ai_service import AIService
from app.services.github_service import GitHubService
from app.services.resume_parser_service import ResumeParserService


@dataclass
class SuggestionResult:
    resume: Dict
    github: Dict
    suggestions: Dict

    def to_dict(self) -> Dict:
        return {
            "resume": self.resume,
            "github": self.github,
            "suggestions": self.suggestions,
        }


class ResumeSuggestionService:
    def __init__(self):
        self.parser = ResumeParserService()
        self.github = GitHubService()
        self.ai = AIService()

    async def generate_suggestions(
        self,
        resume_text: str,
        github_username: str,
        role: str,
        limit: int = 5,
    ) -> Dict:
        parsed = self.parser.parse_text(resume_text)
        github_scores = await self.github.score_repos_for_role(
            username=github_username, role=role, limit=limit
        )

        suggestions = self._ai_suggestions(parsed, github_scores, role)
        if not suggestions:
            suggestions = self._fallback_suggestions(parsed, github_scores, role)

        result = SuggestionResult(
            resume=parsed,
            github={
                "username": github_username,
                "role": role,
                "repos": github_scores,
            },
            suggestions=suggestions,
        )
        return result.to_dict()

    def _ai_suggestions(self, parsed: Dict, github_scores: List[Dict], role: str) -> Dict:
        prompt = (
            "You must return STRICT JSON ONLY. No extra text. "
            "If you cannot follow the schema exactly, return an empty string.\n\n"
            "SCHEMA (all keys required):\n"
            "{\n"
            "  \"resume_summary\": string,\n"
            "  \"strengths\": [string],\n"
            "  \"gaps\": [string],\n"
            "  \"skills_to_add\": [string],\n"
            "  \"project_improvements\": [string],\n"
            "  \"bullet_rewrites\": [string],\n"
            "  \"github_highlights\": [string],\n"
            "  \"next_steps\": [string]\n"
            "}\n\n"
            "Write concise, actionable resume suggestions tailored to the role. "
            "Use the parsed resume and GitHub repo scores below. "
            "If a section is missing, recommend how to add it. "
            "Prefer strong verbs and measurable impact."
        )

        payload = {
            "role": role,
            "resume": parsed,
            "github_scores": github_scores,
        }

        response = self.ai.respond_to_input(
            user_input=str(payload),
            prompt_template=prompt,
        )

        if not response or "error" in response:
            return {}

        try:
            import json

            parsed_json = json.loads(response)
            if not isinstance(parsed_json, dict):
                return {}
            required_keys = [
                "resume_summary",
                "strengths",
                "gaps",
                "skills_to_add",
                "project_improvements",
                "bullet_rewrites",
                "github_highlights",
                "next_steps",
            ]
            if any(key not in parsed_json for key in required_keys):
                return {}
            return parsed_json
        except Exception:
            return {}

    def _fallback_suggestions(self, parsed: Dict, github_scores: List[Dict], role: str) -> Dict:
        strengths: List[str] = []
        gaps: List[str] = []
        skills_to_add: List[str] = []
        project_improvements: List[str] = []
        bullet_rewrites: List[str] = []
        github_highlights: List[str] = []
        next_steps: List[str] = []

        if parsed.get("skills"):
            strengths.append("Clear skills list present")
        else:
            gaps.append("Missing skills section")
            skills_to_add.append("Add a concise skills section with tools, frameworks, and languages")

        if parsed.get("experience"):
            strengths.append("Experience section present")
        else:
            gaps.append("Missing experience section")
            next_steps.append("Add 2–4 experience bullets with impact metrics")

        if parsed.get("projects"):
            strengths.append("Projects section present")
        else:
            gaps.append("Missing projects section")
            next_steps.append("Add 2–3 projects aligned to the role with measurable outcomes")

        if not github_scores:
            gaps.append("No GitHub repo scores available")
            next_steps.append("Add at least one public repo that matches the target role")
        else:
            top_repo = max(github_scores, key=lambda r: r.get("total", 0))
            github_highlights.append(
                f"Highlight repo '{top_repo.get('name')}' with total score {top_repo.get('total')}"
            )

            for repo in github_scores:
                scores = repo.get("scores", {})
                if scores.get("quality_docs_tests", 0) < 3:
                    project_improvements.append(
                        f"Improve README/tests for {repo.get('name')} (docs/tests score low)"
                    )
                if scores.get("results_metrics", 0) < 3:
                    project_improvements.append(
                        f"Add measurable impact metrics to {repo.get('name')}"
                    )
                if scores.get("relevance", 0) < 3:
                    skills_to_add.append(
                        f"Align {repo.get('name')} with {role} keywords and tech stack"
                    )

        if not bullet_rewrites:
            bullet_rewrites.append("Led X to achieve Y, resulting in Z% improvement")
            bullet_rewrites.append("Built feature A using B, reducing C by D%")

        return {
            "resume_summary": "Add a concise summary tailored to the target role.",
            "strengths": strengths or ["Clean resume structure"],
            "gaps": gaps or ["Add more measurable outcomes"],
            "skills_to_add": skills_to_add or ["Add role-specific tools and frameworks"],
            "project_improvements": project_improvements or ["Add tests and CI to top projects"],
            "bullet_rewrites": bullet_rewrites,
            "github_highlights": github_highlights or ["Surface best GitHub repo with impact metrics"],
            "next_steps": next_steps or ["Update resume with quantified outcomes"],
        }


resume_suggestion_service = ResumeSuggestionService()

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
import re
from typing import Dict, List, Optional, Tuple

import httpx
from app.core.config import settings


ROLE_KEYWORDS: Dict[str, List[str]] = {
    "backend": ["backend", "api", "rest", "graphql", "database", "db", "postgres", "mysql", "redis", "auth", "queue", "celery", "fastapi", "django", "flask", "node", "express"],
    "frontend": ["frontend", "react", "vue", "angular", "ui", "ux", "next", "vite", "css", "tailwind"],
    "data": ["data", "ml", "machine learning", "pandas", "numpy", "etl", "pipeline", "spark"],
    "devops": ["devops", "docker", "kubernetes", "k8s", "ci", "cd", "terraform", "ansible"],
    "mobile": ["android", "ios", "flutter", "react native", "swift", "kotlin"],
}


@dataclass
class RepoScore:
    name: str
    url: str
    description: str
    scores: Dict[str, int]
    total: int
    evidence: Dict[str, str]

    def to_dict(self) -> Dict:
        return {
            "name": self.name,
            "url": self.url,
            "description": self.description,
            "scores": self.scores,
            "total": self.total,
            "evidence": self.evidence,
        }


class GitHubService:
    def __init__(self):
        self.base_url = "https://api.github.com"
        self.token = settings.github_token

    async def score_repos_for_role(self, username: str, role: str, limit: int = 5) -> List[Dict]:
        repos = await self._fetch_repos(username)
        if not repos:
            return []

        scored: List[RepoScore] = []
        for repo in repos:
            languages = await self._fetch_languages(username, repo["name"])
            readme = await self._fetch_readme(username, repo["name"])
            scored.append(self._score_repo(repo, languages, readme, role))

        scored.sort(key=lambda r: r.total, reverse=True)
        return [item.to_dict() for item in scored[:limit]]

    async def _fetch_repos(self, username: str) -> List[Dict]:
        url = f"{self.base_url}/users/{username}/repos"
        headers = self._headers()
        params = {"per_page": 100, "type": "owner", "sort": "updated"}
        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=headers, params=params, timeout=30)
            response.raise_for_status()
            return response.json()

    async def _fetch_languages(self, username: str, repo: str) -> Dict[str, int]:
        url = f"{self.base_url}/repos/{username}/{repo}/languages"
        headers = self._headers()
        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=headers, timeout=30)
            if response.status_code != 200:
                return {}
            return response.json()

    async def _fetch_readme(self, username: str, repo: str) -> str:
        url = f"{self.base_url}/repos/{username}/{repo}/readme"
        headers = self._headers()
        headers["Accept"] = "application/vnd.github.raw+json"
        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=headers, timeout=30)
            if response.status_code != 200:
                return ""
            return response.text

    def _headers(self) -> Dict[str, str]:
        headers = {"Accept": "application/vnd.github+json"}
        if self.token:
            headers["Authorization"] = f"Bearer {self.token}"
        return headers

    def _score_repo(self, repo: Dict, languages: Dict[str, int], readme: str, role: str) -> RepoScore:
        name = repo.get("name", "")
        url = repo.get("html_url", "")
        description = repo.get("description") or ""
        topics = repo.get("topics") or []
        updated_at = repo.get("updated_at")
        stargazers = repo.get("stargazers_count", 0)
        forks = repo.get("forks_count", 0)
        size = repo.get("size", 0)
        is_fork = repo.get("fork", False)

        relevance, relevance_evidence = self._score_relevance(role, name, description, readme, topics, languages)
        impact, impact_evidence = self._score_impact(stargazers, forks)
        complexity, complexity_evidence = self._score_complexity(size, languages)
        quality, quality_evidence = self._score_quality(readme)
        recency, recency_evidence = self._score_recency(updated_at)
        ownership, ownership_evidence = self._score_ownership(is_fork)
        results, results_evidence = self._score_results(readme)

        scores = {
            "relevance": relevance,
            "impact": impact,
            "complexity": complexity,
            "quality_docs_tests": quality,
            "recency": recency,
            "ownership": ownership,
            "results_metrics": results,
        }
        total = sum(scores.values())
        evidence = {
            "relevance": relevance_evidence,
            "impact": impact_evidence,
            "complexity": complexity_evidence,
            "quality_docs_tests": quality_evidence,
            "recency": recency_evidence,
            "ownership": ownership_evidence,
            "results_metrics": results_evidence,
        }

        return RepoScore(
            name=name,
            url=url,
            description=description,
            scores=scores,
            total=total,
            evidence=evidence,
        )

    def _score_relevance(
        self,
        role: str,
        name: str,
        description: str,
        readme: str,
        topics: List[str],
        languages: Dict[str, int],
    ) -> Tuple[int, str]:
        role_key = role.strip().lower()
        keywords = ROLE_KEYWORDS.get(role_key, [role_key])
        haystack = " ".join([name, description, readme, " ".join(topics), " ".join(languages.keys())]).lower()
        matches = [kw for kw in keywords if kw in haystack]
        count = len(matches)

        if count >= 6:
            score = 5
        elif count >= 4:
            score = 4
        elif count >= 2:
            score = 3
        elif count == 1:
            score = 2
        else:
            score = 1

        evidence = f"matched: {', '.join(matches[:6])}" if matches else "no role keywords found"
        return score, evidence

    def _score_impact(self, stargazers: int, forks: int) -> Tuple[int, str]:
        score = 1
        impact = stargazers + (forks * 2)
        if impact >= 200:
            score = 5
        elif impact >= 50:
            score = 4
        elif impact >= 10:
            score = 3
        elif impact >= 1:
            score = 2
        evidence = f"stars: {stargazers}, forks: {forks}"
        return score, evidence

    def _score_complexity(self, size: int, languages: Dict[str, int]) -> Tuple[int, str]:
        lang_count = len(languages)
        score = 1
        if size >= 20000 or lang_count >= 5:
            score = 5
        elif size >= 5000 or lang_count >= 3:
            score = 4
        elif size >= 1000 or lang_count >= 2:
            score = 3
        elif size >= 100 or lang_count >= 1:
            score = 2
        evidence = f"size_kb: {size}, languages: {', '.join(languages.keys()) or 'none'}"
        return score, evidence

    def _score_quality(self, readme: str) -> Tuple[int, str]:
        if not readme:
            return 1, "no README"

        text = readme.lower()
        has_install = "install" in text or "setup" in text
        has_usage = "usage" in text or "how to" in text
        has_tests = "test" in text or "pytest" in text or "unittest" in text
        has_ci = "github actions" in text or "ci" in text

        score = 2
        if has_install and has_usage and has_tests and has_ci:
            score = 5
        elif has_install and has_usage and has_tests:
            score = 4
        elif has_install and has_usage:
            score = 3

        evidence = f"install:{has_install}, usage:{has_usage}, tests:{has_tests}, ci:{has_ci}"
        return score, evidence

    def _score_recency(self, updated_at: Optional[str]) -> Tuple[int, str]:
        if not updated_at:
            return 1, "no updated_at"

        updated = datetime.fromisoformat(updated_at.replace("Z", "+00:00"))
        now = datetime.now(timezone.utc)
        months = (now.year - updated.year) * 12 + (now.month - updated.month)

        if months <= 3:
            score = 5
        elif months <= 6:
            score = 4
        elif months <= 12:
            score = 3
        elif months <= 24:
            score = 2
        else:
            score = 1

        evidence = f"updated {months} months ago"
        return score, evidence

    def _score_ownership(self, is_fork: bool) -> Tuple[int, str]:
        if is_fork:
            return 2, "forked repo"
        return 5, "original repo"

    def _score_results(self, readme: str) -> Tuple[int, str]:
        if not readme:
            return 1, "no README"

        text = readme.lower()
        # match percentages (e.g. 50%) or numeric metrics with units
        has_metrics = bool(re.search(r"(\d+%|\d+\s*(users|downloads|requests|ms|seconds|secs|ops))", text))
        has_outcomes = any(kw in text for kw in ["performance", "latency", "throughput", "scale", "uptime"])

        if has_metrics and has_outcomes:
            score = 5
        elif has_metrics:
            score = 4
        elif has_outcomes:
            score = 3
        else:
            score = 1

        evidence = f"metrics:{has_metrics}, outcomes:{has_outcomes}"
        return score, evidence


github_service = GitHubService()

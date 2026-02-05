import pytest
from unittest.mock import AsyncMock
from datetime import datetime, timezone

from app.services.github_service import GitHubService


@pytest.fixture
def github_service():
    svc = GitHubService()
    # Mock network-bound coroutine helpers
    svc._fetch_repos = AsyncMock()
    svc._fetch_languages = AsyncMock()
    svc._fetch_readme = AsyncMock()
    return svc


def test_headers_with_and_without_token():
    svc = GitHubService()
    svc.token = "my-secret"
    headers = svc._headers()
    assert headers.get("Authorization") == "Bearer my-secret"

    svc.token = ""
    headers = svc._headers()
    assert "Authorization" not in headers


def test_score_relevance_matches_role_keywords():
    svc = GitHubService()
    name = "awesome-backend-api"
    description = "A backend REST API using FastAPI and postgres"
    readme = "Some usage docs and setup guide"
    topics = ["api"]
    languages = {"python": 100, "sql": 50}

    score, evidence = svc._score_relevance("backend", name, description, readme, topics, languages)

    # We expect multiple keyword matches (backend, api, rest, postgres, fastapi)
    assert score >= 4
    assert "backend" in evidence or "api" in evidence


def test_score_impact_thresholds():
    svc = GitHubService()

    s, _ = svc._score_impact(0, 0)
    assert s == 1

    s, _ = svc._score_impact(1, 0)
    assert s == 2

    s, _ = svc._score_impact(10, 0)
    assert s == 3

    s, _ = svc._score_impact(50, 0)
    assert s == 4

    s, _ = svc._score_impact(200, 0)
    assert s == 5


def test_score_complexity_by_size_and_lang_count():
    svc = GitHubService()

    s, _ = svc._score_complexity(10, {})
    assert s == 1

    s, _ = svc._score_complexity(150, {"python": 1})
    assert s == 2

    s, _ = svc._score_complexity(1500, {"python": 1, "js": 1})
    assert s == 3

    s, _ = svc._score_complexity(6000, {"python": 1, "js": 1, "go": 1})
    assert s == 4

    s, _ = svc._score_complexity(25000, {"a": 1, "b": 1, "c": 1, "d": 1, "e": 1})
    assert s == 5


def test_score_quality_readme_variations():
    svc = GitHubService()

    s, e = svc._score_quality("")
    assert s == 1

    readme = "Install: run pip install. Usage: see examples. Test: run pytest. CI: GitHub Actions"
    s, _ = svc._score_quality(readme)
    assert s == 5

    readme = "Install instructions and usage examples"
    s, _ = svc._score_quality(readme)
    assert s == 3


def test_score_recency_and_ownership():
    svc = GitHubService()

    now = datetime.now(timezone.utc)
    recent = now.isoformat()
    s, _ = svc._score_recency(recent)
    assert s == 5

    s, _ = svc._score_recency(None)
    assert s == 1

    s, _ = svc._score_ownership(True)
    assert s == 2

    s, _ = svc._score_ownership(False)
    assert s == 5


def test_score_results_metrics_and_outcomes():
    svc = GitHubService()

    readme = "This project improved throughput by 50% and reduced latency"
    s, e = svc._score_results(readme)
    assert s == 5

    readme = "Has good performance characteristics"
    s, _ = svc._score_results(readme)
    assert s >= 3

    s, _ = svc._score_results("")
    assert s == 1


@pytest.mark.asyncio
async def test_score_repos_for_role_end_to_end(github_service):
    # Prepare a fake repo with rich metadata so scoring buckets are exercised
    now = datetime.now(timezone.utc).isoformat()
    fake_repos = [
        {
            "name": "repo1",
            "html_url": "https://github.com/user/repo1",
            "description": "An awesome backend service using FastAPI and Postgres",
            "topics": ["api", "backend"],
            "updated_at": now,
            "stargazers_count": 42,
            "forks_count": 3,
            "size": 2000,
            "fork": False,
        }
    ]

    github_service._fetch_repos.return_value = fake_repos
    github_service._fetch_languages.return_value = {"python": 100, "sql": 50}
    github_service._fetch_readme.return_value = (
        "Install: pip install. Usage: see examples. Test: run pytest. CI: GitHub Actions. "
        "Performance: 100% throughput"
    )

    results = await github_service.score_repos_for_role("someuser", "backend", limit=5)

    assert isinstance(results, list)
    assert len(results) == 1
    repo = results[0]
    assert repo["name"] == "repo1"
    assert "total" in repo and isinstance(repo["total"], int)
    assert repo["scores"]["relevance"] >= 3
    assert repo["scores"]["quality_docs_tests"] >= 4

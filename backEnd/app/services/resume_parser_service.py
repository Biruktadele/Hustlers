from __future__ import annotations

from dataclasses import dataclass
from io import BytesIO
import re
from typing import Dict, List, Optional


EMAIL_REGEX = re.compile(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b")
PHONE_REGEX = re.compile(r"(\+?\d{1,3}[-.\s]?)?(\(?\d{2,4}\)?[-.\s]?)?\d{3}[-.\s]?\d{3,4}")


SECTION_ALIASES = {
    "skills": {"skills", "technical skills", "core competencies", "competencies"},
    "experience": {"experience", "work experience", "professional experience", "employment"},
    "education": {"education", "academic background", "academics"},
    "projects": {"projects", "project", "selected projects"},
}


@dataclass
class ParsedResume:
    name: Optional[str]
    email: Optional[str]
    phone: Optional[str]
    skills: List[str]
    experience: List[str]
    education: List[str]
    projects: List[str]

    def to_dict(self) -> Dict:
        return {
            "name": self.name,
            "email": self.email,
            "phone": self.phone,
            "skills": self.skills,
            "experience": self.experience,
            "education": self.education,
            "projects": self.projects,
        }


class ResumeParserService:
    def extract_text(self, file_bytes: bytes) -> str:
        return self._extract_text(file_bytes)

    def parse_pdf(self, file_bytes: bytes) -> Dict:
        text = self._extract_text(file_bytes)
        lines = self._normalize_lines(text)

        email = self._extract_email(text)
        phone = self._extract_phone(text)
        name = self._extract_name(lines, email, phone)

        sections = self._extract_sections(lines)
        skills = self._extract_skills(sections.get("skills", []))

        experience = self._clean_section_lines(sections.get("experience", []))
        education = self._clean_section_lines(sections.get("education", []))
        projects = self._clean_section_lines(sections.get("projects", []))

        parsed = ParsedResume(
            name=name,
            email=email,
            phone=phone,
            skills=skills,
            experience=experience,
            education=education,
            projects=projects,
        )
        return parsed.to_dict()

    def parse_text(self, text: str) -> Dict:
        lines = self._normalize_lines(text)

        email = self._extract_email(text)
        phone = self._extract_phone(text)
        name = self._extract_name(lines, email, phone)

        sections = self._extract_sections(lines)
        skills = self._extract_skills(sections.get("skills", []))

        experience = self._clean_section_lines(sections.get("experience", []))
        education = self._clean_section_lines(sections.get("education", []))
        projects = self._clean_section_lines(sections.get("projects", []))

        parsed = ParsedResume(
            name=name,
            email=email,
            phone=phone,
            skills=skills,
            experience=experience,
            education=education,
            projects=projects,
        )
        return parsed.to_dict()

    def _extract_text(self, file_bytes: bytes) -> str:
        import pdfplumber
        with pdfplumber.open(BytesIO(file_bytes)) as pdf:
            pages_text = [page.extract_text() or "" for page in pdf.pages]
        return "\n".join(pages_text)

    def _normalize_lines(self, text: str) -> List[str]:
        raw_lines = text.splitlines()
        return [line.strip() for line in raw_lines if line.strip()]

    def _extract_email(self, text: str) -> Optional[str]:
        match = EMAIL_REGEX.search(text)
        return match.group(0) if match else None

    def _extract_phone(self, text: str) -> Optional[str]:
        match = PHONE_REGEX.search(text)
        if not match:
            return None
        phone = match.group(0)
        return phone.strip()

    def _extract_name(self, lines: List[str], email: Optional[str], phone: Optional[str]) -> Optional[str]:
        for line in lines[:5]:
            normalized = line.lower()
            if email and email.lower() in normalized:
                continue
            if phone and phone in line:
                continue
            if len(line.split()) >= 2 and re.match(r"^[A-Za-z .'-]+$", line):
                return line.strip()
        return lines[0].strip() if lines else None

    def _extract_sections(self, lines: List[str]) -> Dict[str, List[str]]:
        sections: Dict[str, List[str]] = {"skills": [], "experience": [], "education": [], "projects": []}
        current_section = None

        for line in lines:
            section_key = self._match_heading(line)
            if section_key:
                current_section = section_key
                continue
            if current_section:
                sections[current_section].append(line)

        return sections

    def _match_heading(self, line: str) -> Optional[str]:
        normalized = re.sub(r"[^a-zA-Z ]", "", line).strip().lower()
        for key, aliases in SECTION_ALIASES.items():
            if normalized in aliases:
                return key
        return None

    def _extract_skills(self, skills_lines: List[str]) -> List[str]:
        if not skills_lines:
            return []

        combined = " ".join(skills_lines)
        parts = re.split(r"[\n,;|•\u2022\-]+", combined)
        skills = []
        seen = set()
        for part in parts:
            skill = part.strip()
            if not skill:
                continue
            key = skill.lower()
            if key in seen:
                continue
            seen.add(key)
            skills.append(skill)
        return skills

    def _clean_section_lines(self, section_lines: List[str]) -> List[str]:
        cleaned = []
        for line in section_lines:
            if line.strip():
                cleaned.append(line.strip())
        return cleaned


resume_parser_service = ResumeParserService()

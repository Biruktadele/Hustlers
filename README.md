# Hustlers — AI-Powered Job Discovery & Client Outreach Platform

Hustlers is a full-stack platform that helps job seekers and freelancers discover opportunities, evaluate companies, and generate AI-powered insights and outreach. It includes a FastAPI backend for data aggregation, AI services, and integrations, plus a Flutter mobile app with a clean-architecture UI for discovery, analysis, and resume tooling.

---

## 📸 Product Screenshots

![Screenshot 1](https://drive.google.com/uc?export=view&id=1XJFHWR3IB541AzkpllncCA8hMdIIHya6)
![Screenshot 2](https://drive.google.com/uc?export=view&id=15XX7W6vTL_p_X0v6wIEVnpKELu-LvTzp)
![Screenshot 3](https://drive.google.com/uc?export=view&id=199c145OENj8s1AbhTTJdflUKflw8_Dxa)
![Screenshot 4](https://drive.google.com/uc?export=view&id=1DWBQzZ_9eEusXdUAlUvRaUbfdDlxGhLU)
![Screenshot 5](https://drive.google.com/uc?export=view&id=1Hq2qFd8PuJ-2byOp_ssukkuamaIzOwNX)

---

## 🌍 What the Platform Does

### For Job Seekers
- Aggregates jobs from Telegram channels and groups.
- Helps evaluate companies using map-based discovery and AI-generated insights.
- Parses resumes and provides role-specific improvement suggestions.
- Scores GitHub portfolios against target roles.

### For Freelancers / Consultants
- Deep company analysis to surface pain points.
- AI-generated outreach pitch with CTA to close leads faster.

---

## 🧭 System Overview

**Hustlers** is split into two major parts:

- **Backend**: FastAPI services for Telegram scraping, AI analysis, resume parsing, GitHub scoring, maps, and persistence.
- **Mobile App**: Flutter app using Clean Architecture, Riverpod, and rich UI for search, insights, and resume tooling.

For component-specific documentation:
- Backend details are in [backEnd/README.md](backEnd/README.md)
- Mobile details are in [hustlers_mobile/README.md](hustlers_mobile/README.md)

---

## 🧱 High-Level Architecture

```
┌───────────────────────┐        ┌────────────────────────────┐
│  Flutter Mobile App   │──────▶│  FastAPI Backend (REST)     │
│  - Job Finder         │        │  - Telegram Services        │
│  - Company Insights   │        │  - AI/Gemini Insights        │
│  - Resume Tools       │        │  - Resume Parsing            │
│  - Saved Items        │        │  - GitHub Scoring            │
└───────────────────────┘        └────────────────────────────┘
                     ▲                        │
                     │                        ▼
             Local Cache               PostgreSQL / APIs
```

---

## ✅ Core Features

### 🔎 Job Discovery
- Telegram group/channel aggregation with configurable group sources.
- Job post normalization and structured extraction.

### 🗺️ Company Discovery & AI Insights
- Nearby company search via map services.
- Gemini-powered insights on digital presence, pain points, and opportunities.

### 📄 Resume Intelligence
- PDF extraction for skills, experience, education, and contact.
- AI suggestions based on GitHub portfolio + target role.

### 🐙 GitHub Portfolio Scoring
- Public repo analysis for role fit.
- Evidence-based scoring and highlights.

### 📱 Mobile App Experience
- Feature-first clean architecture.
- Smooth UI with charts and deep analytics.
- Saved companies and curated insights.

---

## 📁 Monorepo Structure

```
Hustlers/
├── backEnd/                 # FastAPI backend services
│   ├── app/                 # API, services, models, db
│   └── README.md
├── hustlers_mobile/         # Flutter mobile client
│   ├── lib/
│   └── README.md
└── README.md                # This file
```

---

## 🛠️ Tech Stack

### Backend
- FastAPI
- PostgreSQL + SQLAlchemy
- Google Gemini (LLM)
- Telethon
- pdfplumber
- Railway deployment

### Mobile
- Flutter + Dart
- Riverpod (Hooks + Codegen)
- sqflite + shared_preferences
- http client
- fl_chart + percent_indicator

---

## ⚙️ Local Setup

### 1) Clone Repository
```
git clone https://github.com/your-username/Hustlers.git
cd Hustlers
```

### 2) Backend Setup
Follow [backEnd/README.md](backEnd/README.md) for Python environment, DB, and secrets.

### 3) Mobile Setup
Follow [hustlers_mobile/README.md](hustlers_mobile/README.md) for Flutter dependencies and run steps.

---

## 🔐 Environment Variables (Backend)

Create a .env file in backEnd or configure environment variables in deployment.

```
DATABASE_URL=postgresql://user:pass@localhost/hustlers_db
TELEGRAM_API_ID=your_id
TELEGRAM_API_HASH=your_hash
TELEGRAM_SESSION=your_base64_session_string
GEMINI_API_KEY=your_gemini_key
GITHUB_TOKEN=your_github_token
```

---

## 🧪 Tests

### Backend
```
cd backEnd
pytest
```

### Mobile
```
cd hustlers_mobile
flutter test
```

---

## 🚀 Deployment

- Backend: Railway or similar PaaS with Postgres
- Mobile: Flutter build for Android, iOS, Web, and Desktop

See [backEnd/README.md](backEnd/README.md) for deployment specifics.

---

## 🧭 Roadmap

- Centralized admin dashboard for analytics
- Company lead scoring system
- Multilingual content generation
- Push notifications for new matches
- Saved outreach templates

---

## 🤝 Contributing

Contributions are welcome. Please open a PR with clear context and tests where applicable.

---

## 📄 License

MIT — see LICENSE file if present.

---

Built with ❤️ by the Hustlers team.

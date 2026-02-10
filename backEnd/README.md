# Hustlers Backend 🚀

**Hustlers** is a mobile-first platform designed to empower skilled professionals by streamlining their job search process. It aggregates opportunities from Telegram and other sources, provides AI-driven company insights, parses resumes for tailored suggestions, and tracks application progress—all in one place.

The backend is built with **FastAPI** to ensure high performance, easy scalability, and automatic interactive documentation.

## 🌐 Live Deployment
The API is currently deployed on Railway:
**[https://hustlers-production.up.railway.app/docs](https://hustlers-production.up.railway.app/docs)**

---

## ✨ Key Features

### 1. 🤖 Intelligent Job Discovery (Telegram Integration)
Leveraging `Telethon`, the backend connects directly to Telegram to source job postings from popular channels and groups.
- **Fetch Group Posts**: Retrieve recent messages from any public Telegram group.
- **Group Info**: Get metadata about specific job communities.
- **Afriwork Integration**: Specialized specialized fetcher for the "Afriwork Amharic" job channel.

### 2. 🗺️ Company Discovery & Insights (Map Services)
Helps users find and evaluate potential employers nearby.
- **Nearby Search**: Locate companies, hotels, and other establishments based on coordinates.
- **AI Insights**: Generates deep insights about a company or hotel using **Google Gemini AI**. It analyzes location data to tell you what it's like to work there or visit.

### 3. 📄 Resume Intelligence
A powerful suite of tools to help users polish their profiles.
- **PDF Parser**: Extracts contact info, skills, education, and experience from PDF resumes using `pdfplumber`.
- **AI Suggestions**: unique feature that takes a **Resume**, a **GitHub Profile**, and a **Target Role** to generate actionable advice. It tells candidates:
    - Strengths & Weaknesses
    - Missing Skills
    - Project Improvements
    - GitHub Highlights to showcase

### 4. 🐙 GitHub Portfolio Scoring
- **Repo Analysis**: Analyze a user's public repositories and score them based on relevance to a specific job role (e.g., "Frontend Developer", "Data Scientist"). It provides evidence-based scoring logic.

---

## 🛠️ Tech Stack

- **Framework**: [FastAPI](https://fastapi.tiangolo.com/) (Python 3.10+)
- **Database**: PostgreSQL (via [SQLAlchemy](https://www.sqlalchemy.org/))
- **AI/LLM**: Google Gemini (via `google-genai`)
- **Telegram Client**: [Telethon](https://docs.telethon.dev/)
- **Resume Parsing**: `pdfplumber`
- **Deployment**: [Railway](https://railway.app/)
- **Package Management**: `pip` / `pipenv`

---

## 📂 Project Structure

```bash
/app
├── api/
│   └── v1/
│       └── endpoints/   # Route handlers (GitHub, Map, Resume, Telegram)
├── core/                # Configuration (Env vars, constants)
├── crud/                # Database interactions
├── db/                  # Database connection & session management
├── models/              # SQLAlchemy models
├── schemas/             # Pydantic models (Request/Response validation)
├── services/            # Business logic (AI pipelines, 3rd party integrations)
└── main.py              # Application entry point
```

---

## 🚀 Getting Started

Follow these instructions to set up the project locally.

### Prerequisites
- Python 3.9+
- PostgreSQL database
- Telegram API Credentials (API ID & Hash)
- Google Gemini API Key
- GitHub Token

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/Hustlers-Backend.git
cd Hustlers/backEnd
```

### 2. Create Virtual Environment
```bash
# Using Python venv
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Or using Pipenv
pipenv shell
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables
Create a `.env` file in the root directory (or update `app/core/config.py` directly, though `.env` is recommended).

```ini
# Database
DATABASE_URL=postgresql://user:password@localhost/hustlers_db

# Telegram API (get from my.telegram.org)
TELEGRAM_API_ID=your_id
TELEGRAM_API_HASH=your_hash
TELEGRAM_SESSION=your_base64_session_string

# AI / LLM
GEMINI_API_KEY=your_gemini_key

# GitHub
GITHUB_TOKEN=your_github_personal_access_token
```

### 5. Run the Application
```bash
uvicorn app.main:app --reload
```
The server will start at `http://127.0.0.1:8000`.

---

## 📖 API Documentation

FastAPI automatically generates interactive documentation. Once the server is running, visit:

- **Swagger UI**: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)
- **ReDoc**: [http://127.0.0.1:8000/redoc](http://127.0.0.1:8000/redoc)

---

## ☁️ Deployment (Railway)

This project is configured for easy deployment on [Railway](https://railway.app/).

1. **Push to GitHub**: Ensure your code is in a GitHub repository.
2. **New Project on Railway**: Select "Deploy from GitHub repo".
3. **Environment Variables**: Add the variables listed in the "Configure Environment Variables" section to your Railway project settings.
    - *Note*: For `DATABASE_URL`, Railway can provision a Postgres database for you. Simply link it.
4. **Start Command**: Railway will automatically detect the `Procfile` if present, or you can set the start command:
   ```bash
   uvicorn app.main:app --host 0.0.0.0 --port $PORT
   ```
5. **Watch it fly!** 🚀

---

## 🧪 Testing

Run the test suite to ensure everything is working correctly:

```bash
pytest
```

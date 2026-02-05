# Hustlers
Hustlers is a mobile-first app that helps skilled professionals find local jobs that match their abilities quickly. It offers smart job discovery from Telegram and other job boards, company insights to understand potential employers, and application tracking to monitor your job search progres all in one place.

## FastAPI Backend

This project includes a FastAPI backend with clean architecture.

### Folder Structure

- `app/`: Main application code
  - `api/`: API routes
    - `v1/`: Version 1 API
      - `endpoints/`: API endpoints
  - `core/`: Core configuration and settings
  - `models/`: Database models
  - `schemas/`: Pydantic schemas
  - `services/`: Business logic services
  - `db/`: Database setup and connections
- `tests/`: Unit and integration tests
- `requirements.txt`: Python dependencies

### Setup

1. Install dependencies:
   ```bash
   pipenv install
   ```

2. Set up Telegram API credentials:
   - Go to https://my.telegram.org/auth and create an app
   - Copy your API ID and API Hash
   - Update the `.env` file with your credentials:
     ```
     TELEGRAM_API_ID=your_api_id
     TELEGRAM_API_HASH=your_api_hash
     ```

3. Run the application:
   ```bash
   pipenv run uvicorn app.main:app --reload
   ```

4. Open http://127.0.0.1:8000/docs for API documentation.

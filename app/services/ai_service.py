from typing import List, Optional
import json
import google.generativeai as genai
from app.core.config import settings
from app.services import fetch_afriworkamharic
import asyncio
class AIService:
    def __init__(self, model_name: str = "gemini-2.5-flash"):
        self.model_name = model_name
        self._model: Optional[genai.GenerativeModel] = None
        self._api_keys: List[str] = self._load_api_keys()
        self._api_key_index = 0

        if self._api_keys:
            self._configure_current_key()

    def _load_api_keys(self) -> List[str]:
        keys = []
        if settings.gemini_api_keys:
            keys.extend([k.strip() for k in settings.gemini_api_keys.split(",") if k.strip()])
        if settings.gemini_api_key:
            keys.append(settings.gemini_api_key.strip())
        # De-duplicate while preserving order
        seen = set()
        unique_keys = []
        for key in keys:
            if key and key not in seen:
                seen.add(key)
                unique_keys.append(key)
        return unique_keys

    def _configure_current_key(self) -> Optional[str]:
        if not self._api_keys:
            self._model = None
            return None
        key = self._api_keys[self._api_key_index]
        genai.configure(api_key=key)
        self._model = genai.GenerativeModel(self.model_name)
        return key

    def _rotate_key(self) -> Optional[str]:
        if not self._api_keys:
            return None
        self._api_key_index = (self._api_key_index + 1) % len(self._api_keys)
        return self._configure_current_key()

    def respond_to_input(self, user_input: str) -> str:
        """
        Takes a user input and returns a Gemini-generated response.

        Args:
            user_input (str): The input provided by the user.

        Returns:
            str: The AI's response.
        """
        if not self._model:
            return "Gemini API key is missing. Set GEMINI_API_KEY or GEMINI_API_KEYS in your .env file."

        prompt = (
            "Extract job data from the user input and return STRICT JSON only. "
            "No markdown, no extra text. Use these keys: "
            "job_name, job_type, job_location, salary, application_deadline, job_description : explain the job deescrbition very weel by ur self. "
            "If a field is missing, use an empty string.\n\n"
            f"Input:\n{user_input}"
        )

        response = self._model.generate_content(prompt)
        self._rotate_key()

        text = (response.text or "").strip()
        try:
            parsed = json.loads(text)
        except json.JSONDecodeError:
            return "{\"error\": \"Invalid JSON response from model\"}"

        return json.dumps(parsed, ensure_ascii=False)

    def list_available_models(self) -> List[str]:
        """
        List all available models for the Gemini API.

        Returns:
            List[str]: A list of model names.
        """
        if not self._api_keys:
            return ["Gemini API key is missing. Set GEMINI_API_KEY or GEMINI_API_KEYS in your .env file."]

        try:
            models = genai.list_models()
            return [model.name for model in models]
        except Exception as e:
            return [f"Error listing models: {str(e)}"]

    def debug_key_state(self) -> dict:
        """Return non-sensitive info about loaded API keys for debugging."""
        masked_keys = []
        for key in self._api_keys:
            if len(key) <= 8:
                masked_keys.append("****")
            else:
                masked_keys.append(f"{key[:4]}...{key[-4:]}")
        return {
            "keys_loaded": len(self._api_keys),
            "active_index": self._api_key_index if self._api_keys else None,
            "masked_keys": masked_keys,
            "model_name": self.model_name,
        }


if __name__ == "__main__":
    # Simple smoke test
    service = AIService()

    sample_input = (
        "We are hiring a Backend Developer (Full-time) in Addis Ababa. "
        "Salary: 2000 USD. Apply by 2024-12-31. "
        "Role: Build APIs and maintain services."
    )
    ls = asyncio.run(fetch_afriworkamharic.main())[:1]
    # print(ls)
    for post in ls:
        # print(post)
        response = json.loads(service.respond_to_input(post['text']))
        response["deep_link"] = post.get("deep_link")
        response["date"] = post.get("date")
        print( response)
    # print(service.respond_to_input(sample_input))
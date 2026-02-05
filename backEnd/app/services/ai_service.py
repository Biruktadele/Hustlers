from typing import List, Optional
import json
import asyncio
from google import genai
from app.core.config import settings

class AIService:
    def __init__(self, model_name: str = "models/gemini-2.5-flash"):
        self.model_name = model_name
        self._client: Optional[genai.Client] = None
        self._api_keys: List[str] = self._load_api_keys()
        self._api_key_index = 0

        # Available models for rotation
        self._models = [
            "models/gemini-2.5-flash",
            "models/gemini-2.5-flash-lite", 
            "models/gemini-2.5-flash-preview-tts",
            "models/gemini-3-flash-preview"
        ]
        self._model_index = 0

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
            self._client = None
            return None
        key = self._api_keys[self._api_key_index]
        try:
            self._client = genai.Client(api_key=key)
            return key
        except Exception:
            self._client = None
            return None
    def _rotate_model(self) -> str:
        """Rotate to the next available model"""
        self._model_index = (self._model_index + 1) % len(self._models)
        self.model_name = self._models[self._model_index]
        return self.model_name
    def _rotate_key(self) -> Optional[str]:
        if not self._api_keys:
            return None     
        self._api_key_index = (self._api_key_index + 1) % len(self._api_keys)
        return self._configure_current_key()

    def respond_to_input(self, user_input: str, prompt_template: Optional[str] = None) -> str:
        """
        Takes a user input and returns a Gemini-generated response.

        Args:
            user_input (str): The input provided by the user.
            prompt_template (Optional[str]): Custom prompt template. If provided, user_input will be appended.

        Returns:
            str: The AI's response.
        """
        if not self._client:
            return "Gemini API key is missing. Set GEMINI_API_KEY or GEMINI_API_KEYS in your .env file."

        if prompt_template:
            prompt = f"{prompt_template}\n\nInput:\n{user_input}"
        else:
            prompt = (
                "Extract job data from the user input and return STRICT JSON only. "
                "No markdown, no extra text. Use these keys: "
                "jobname, jobtype, price, expierdate, jobdescrbiton. jobdescrbiton should explain the job description very well. "
                "use english for all the fields. even if its in amharic or any other language, translate it to english."
                "If a field is missing, use an empty string.\n\n"
                f"Input:\n{user_input}"
            )

        # Try with current key, and retry with other keys if quota exceeded
        max_retries = min(len(self._api_keys) * len(self._models), 10)  # Don't try more than available keys
        
        for attempt in range(max_retries):
            try:
                response = self._client.models.generate_content(
                    model=self.model_name,
                    contents=prompt
                )
                # Only rotate on success after getting a response
                if attempt == 0:  # Only rotate if this was the first attempt
                    self._rotate_key()
                    self._rotate_model()
                    # Reconfigure client with new key
                    self._configure_current_key()

                text = (response.text or "").strip()
                # Remove markdown code blocks if present
                if text.startswith("```json"):
                    text = text[7:]
                if text.endswith("```"):
                    text = text[:-3]
                text = text.strip()

                parsed = json.loads(text)
                return json.dumps(parsed, ensure_ascii=False)
                
            except Exception as e:
                error_str = str(e)
                if "429" in error_str or "RESOURCE_EXHAUSTED" in error_str:
                    # Rotate to next key and retry
                    if attempt < max_retries - 1:  # Don't rotate on last attempt
                        self._rotate_key()
                        self._rotate_model()
                        # Reconfigure client with new key
                        self._configure_current_key()
                        continue
                    else:
                        # Last attempt failed, return error
                        return json.dumps({"error": f"All API keys and models exhausted. Last error: {error_str}"}, ensure_ascii=False)
                else:
                    # Non-quota error, return immediately
                    return json.dumps({"error": error_str}, ensure_ascii=False)
        
        return json.dumps({"error": "Max retries exceeded"}, ensure_ascii=False)

    def list_available_models(self) -> List[str]:
        """
        List all available models for the Gemini API.

        Returns:
            List[str]: A list of model names.
        """
        if not self._client:
            return ["Gemini API key is missing. Set GEMINI_API_KEY or GEMINI_API_KEYS in your .env file."]

        try:
            models = self._client.models.list()
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

async def res():
    from app.services import fetch_afriworkamharic
    service = AIService()
    try:
        ls = await fetch_afriworkamharic.main()
    except Exception as e:
        print(f"Error fetching posts: {e}")
        return []
        
    posts = []
    for post in ls:
        response_text = service.respond_to_input(post['text'])
        try:
            if "error" in response_text:
                continue
            response = json.loads(response_text)
            response["deep_link"] = post.get("deep_link")
            response["date"] = post.get("date")
            posts.append(response)
            print(response)
        except json.JSONDecodeError:
            print(f"Failed to parse AI response: {response_text}")
    return posts

if __name__ == "__main__":
    asyncio.run(res())

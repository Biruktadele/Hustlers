from typing import List, Dict, Optional
import httpx
import json
from app.core.config import settings
from app.services.ai_service import AIService

class MapService:
    def __init__(self):
        self.overpass_url = "https://overpass-api.de/api/interpreter"
        self.ai_service = AIService()

    async def get_hotels_in_addis_ababa(self) -> List[Dict]:
        """
        Fetch hotels in Addis Ababa using OpenStreetMap Overpass API.
        Uses a bounding box for better reliability.
        """
        # Default center of Addis Ababa: 9.0192, 38.7525
        return await self.get_nearby_hotels(9.0192, 38.7525, radius=5000)

    async def get_nearby_hotels(self, lat: float, lon: float, radius: int = 5000) -> List[Dict]:
        """
        Search for hotels around a specific coordinate.
        """
        query = f"""
        [out:json][timeout:25];
        (
          node["tourism"="hotel"](around:{radius},{lat},{lon});
          way["tourism"="hotel"](around:{radius},{lat},{lon});
          relation["tourism"="hotel"](around:{radius},{lat},{lon});
        );
        out body;
        """
        
        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(self.overpass_url, data={"data": query})
                response.raise_for_status()
                data = response.json()
                
                hotels = []
                for element in data.get("elements", []):
                    if "tags" in element:
                        tags = element["tags"]
                        hotels.append({
                            "id": element.get("id"),
                            "name": tags.get("name", "Unnamed Hotel"),
                            "description": tags.get("description") or tags.get("addr:description", ""),
                            "website": tags.get("website", ""),
                            "phone": tags.get("phone") or tags.get("contact:phone", ""),
                            "email": tags.get("email") or tags.get("contact:email", ""),
                            "address": tags.get("addr:street") or tags.get("addr:full", ""),
                            "stars": tags.get("stars", ""),
                            "latitude": element.get("lat") or element.get("center", {}).get("lat"),
                            "longitude": element.get("lon") or element.get("center", {}).get("lon")
                        })
                return hotels
            except Exception as e:
                print(f"Error fetching hotels from Overpass: {e}")
                return []

    async def search_nearby_companies(self, lat: float, lon: float, radius: int = 1000) -> List[Dict]:
        """
        Search for companies near a specific location using OpenStreetMap.
        """
        query = f"""
        [out:json];
        (
          node["office"](around:{radius},{lat},{lon});
          way["office"](around:{radius},{lat},{lon});
          relation["office"](around:{radius},{lat},{lon});
          node["amenity"="bank"](around:{radius},{lat},{lon});
        );
        out body;
        """
        async with httpx.AsyncClient() as client:
            try:
                response = await client.post(self.overpass_url, data={"data": query})
                response.raise_for_status()
                data = response.json()
                
                companies = []
                for element in data.get("elements", []):
                    if "tags" in element:
                        tags = element["tags"]
                        companies.append({
                            "id": element.get("id"),
                            "name": tags.get("name", tags.get("office", "Unknown Office")),
                            "description": tags.get("description") or tags.get("addr:description", ""),
                            "type": tags.get("office", tags.get("amenity", "office")),
                            "website": tags.get("website", ""),
                            "phone": tags.get("phone") or tags.get("contact:phone", ""),
                            "latitude": element.get("lat") or element.get("center", {}).get("lat"),
                            "longitude": element.get("lon") or element.get("center", {}).get("lon")
                        })
                return companies
            except Exception as e:
                print(f"Error fetching companies from Overpass: {e}")
                return []

    async def get_hotel_insights(self, hotel_data: Dict) -> Dict | str:
        """
        Use AI to generate deep insights for a hotel based on its available data.
        Helps software engineers identify specific value propositions.
        """
        # Convert the dictionary to a formatted string for the AI
        hotel_info_str = json.dumps(hotel_data, indent=2)
        
        allowed_scale = ["extremely low", "low", "medium", "high", "extremely high"]

        prompt_template = (
            "You must return STRICT JSON ONLY. No extra text. "
            "If you cannot follow the schema exactly, return an empty string.\n\n"
            "SCHEMA (all keys required, keep exact key names and types):\n"
            "{\n"
            "  \"hotel\": {\n"
            "    \"id\": number | null,\n"
            "    \"name\": string,\n"
            "    \"location\": { \"latitude\": number | null, \"longitude\": number | null }\n"
            "  },\n"
            "  \"current_state\": {\n"
            "    \"digital_presence\": string,\n"
            "    \"contact_information\": {\n"
            "      \"website\": string | null,\n"
            "      \"phone\": string | null,\n"
            "      \"email\": string | null,\n"
            "      \"address\": string | null\n"
            "    },\n"
            "    \"online_visibility\": one of [\"extremely low\",\"low\",\"medium\",\"high\",\"extremely high\"],\n"
            "    \"booking_method\": string\n"
            "  },\n"
            "  \"key_problems\": [string],\n"
            "  \"missing_components\": [string],\n"
            "  \"business_impact\": {\n"
            "    \"lost_bookings\": one of [\"extremely low\",\"low\",\"medium\",\"high\",\"extremely high\"],\n"
            "    \"revenue_leakage\": string,\n"
            "    \"growth_potential\": one of [\"extremely low\",\"low\",\"medium\",\"high\",\"extremely high\"]\n"
            "  },\n"
            "  \"recommended_solutions\": {\n"
            "    \"website\": string,\n"
            "    \"booking\": string,\n"
            "    \"payments\": string,\n"
            "    \"local_seo\": string,\n"
            "    \"operations\": string,\n"
            "    \"marketing\": string\n"
            "  },\n"
            "  \"value_for_hotel\": [string],\n"
            "  \"outreach_summary\": {\n"
            "    \"goal\": string,\n"
            "    \"primary_pitch\": string,\n"
            "    \"call_to_action\": string\n"
            "  }\n"
            "}\n\n"
            "Use the provided hotel data to fill fields. If a field is missing, "
            "use null (for website/phone/email/address) or a reasonable string. "
            "Never add extra keys."
        )

        response_text = self.ai_service.respond_to_input(hotel_info_str, prompt_template=prompt_template)

        def is_valid(payload: Dict) -> bool:
            try:
                if not isinstance(payload, dict):
                    return False
                required_keys = [
                    "hotel", "current_state", "key_problems", "missing_components",
                    "business_impact", "recommended_solutions", "value_for_hotel", "outreach_summary"
                ]
                if any(k not in payload for k in required_keys):
                    return False

                if payload["current_state"]["online_visibility"] not in allowed_scale:
                    return False
                if payload["business_impact"]["lost_bookings"] not in allowed_scale:
                    return False
                if payload["business_impact"]["growth_potential"] not in allowed_scale:
                    return False

                contact = payload["current_state"]["contact_information"]
                for k in ["website", "phone", "email", "address"]:
                    if k not in contact:
                        return False

                rec = payload["recommended_solutions"]
                for k in ["website", "booking", "payments", "local_seo", "operations", "marketing"]:
                    if k not in rec:
                        return False

                loc = payload["hotel"]["location"]
                for k in ["latitude", "longitude"]:
                    if k not in loc:
                        return False

                return True
            except Exception:
                return False

        try:
            parsed = json.loads(response_text)
            return parsed if is_valid(parsed) else ""
        except Exception as e:
            print(f"Failed to parse AI response: {response_text}, error: {e}")
            return ""

# Global instance
map_service = MapService()

from typing import List, Dict, Optional
import httpx
import json
import random
from app.core.config import settings
from app.services.ai_service import AIService

class MapService:
    def __init__(self):
        self.overpass_urls = [
            "https://overpass-api.de/api/interpreter",
            "https://lz4.overpass-api.de/api/interpreter",
            "https://z.overpass-api.de/api/interpreter",
            "https://overpass.kumi.systems/api/interpreter",
            "https://overpass.osm.ch/api/interpreter",
        ]
        self.ai_service = AIService()
        self.category_tags = {
            # 🏥 Health
            "hospital": ("amenity", "hospital"),
            "clinic": ("amenity", "clinic"),
            "doctors": ("amenity", "doctors"),
            "pharmacy": ("amenity", "pharmacy"),
            "dentist": ("amenity", "dentist"),

            # 🍽️ Food & Drink
            "restaurant": ("amenity", "restaurant"),
            "cafe": ("amenity", "cafe"),
            "fast_food": ("amenity", "fast_food"),
            "bar": ("amenity", "bar"),
            "pub": ("amenity", "pub"),

            # 🏨 Accommodation (Tourism)
            "hotel": ("tourism", "hotel"),
            "hostel": ("tourism", "hostel"),
            "motel": ("tourism", "motel"),
            "guest_house": ("tourism", "guest_house"),
            "apartment": ("tourism", "apartment"),

            # 🛒 Shopping
            "supermarket": ("shop", "supermarket"),
            "convenience": ("shop", "convenience"),
            "mall": ("shop", "mall"),
            "bakery": ("shop", "bakery"),
            "clothes": ("shop", "clothes"),
            "electronics": ("shop", "electronics"),

            # 🏦 Services
            "bank": ("amenity", "bank"),
            "atm": ("amenity", "atm"),
            "post_office": ("amenity", "post_office"),
            "police": ("amenity", "police"),
            "fire_station": ("amenity", "fire_station"),

            # 🏢 Offices & Workplaces
            "company": ("office", "company"),
            "government": ("office", "government"),
            "lawyer": ("office", "lawyer"),
            "insurance": ("office", "insurance"),
            "ngo": ("office", "ngo"),

            # 🏫 Education
            "school": ("amenity", "school"),
            "college": ("amenity", "college"),
            "university": ("amenity", "university"),
            "kindergarten": ("amenity", "kindergarten"),

            # ⛽ Transport & Travel
            "fuel": ("amenity", "fuel"),
            "parking": ("amenity", "parking"),
            "bus_station": ("amenity", "bus_station"),
            "station": ("railway", "station"),
            "airport": ("aeroway", "airport"),

            # 🎭 Entertainment & Public Places
            "cinema": ("amenity", "cinema"),
            "theatre": ("amenity", "theatre"),
            "library": ("amenity", "library"),
            "park": ("leisure", "park"),
            "stadium": ("leisure", "stadium"),
        }

    async def get_hotels_in_addis_ababa(self) -> List[Dict]:
        """
        Fetch hotels in Addis Ababa using OpenStreetMap Overpass API.
        Uses a bounding box for better reliability.
        """
        # Default center of Addis Ababa: 9.0192, 38.7525
        return await self.get_nearby_places(9.0192, 38.7525, category="hotel", radius=5000)

    async def get_companies_type_companies(self, lat: float, lon: float) -> List[Dict]:
        """
        Fetch companies of type 'company' near a specific location.
        """
        return await self.get_nearby_places(lat, lon, category="office", radius=1000)

    async def get_nearby_hotels(self, lat: float, lon: float, radius: int = 5000) -> List[Dict]:
        """
        Search for hotels around a specific coordinate.
        """
        return await self.get_nearby_places(lat, lon, category="hotel", radius=radius)

    async def search_nearby_companies(self, lat: float, lon: float, radius: int = 1000) -> List[Dict]:
        """
        Search for companies near a specific location using OpenStreetMap.
        """
        return await self.get_nearby_places(lat, lon, category="office", radius=radius)

    async def get_nearby_places(self, lat: float, lon: float, category: str, radius: int = 1000) -> List[Dict]:
        """
        Generic search for places near a specific location using OpenStreetMap.
        """
        tag_key_value = self.category_tags.get(category.lower())
        if not tag_key_value:
            return []
        tag_key, tag_value = tag_key_value
        tag_queries = f"nwr[\"{tag_key}\"=\"{tag_value}\"](around:{radius},{lat},{lon});"
        # Increased timeout in Overpass QL for more complex/larger radius searches
        query = f"""
        [out:json][timeout:30];
        (
          {tag_queries}
        );
        out center;
        """
        headers = {
            "User-Agent": "HustlersMapService/1.0 (contact: dev@hustlers.local)",
            "Accept": "application/json",
        }
        # Increased httpx timeout to accommodate Overpass QL timeout
        timeout = httpx.Timeout(40.0, connect=10.0)

        # Shuffle URLs to distribute load across mirrors
        shuffled_urls = list(self.overpass_urls)
        random.shuffle(shuffled_urls)

        async with httpx.AsyncClient(headers=headers, timeout=timeout, follow_redirects=True) as client:
            last_error: Optional[Exception] = None
            for url in shuffled_urls:
                try:
                    response = await client.post(url, data={"data": query})
                    if response.status_code == 429:
                        print(f"Rate limited by Overpass mirror: {url}")
                        continue
                        
                    response.raise_for_status()
                    data = response.json()

                    places = []
                    for element in data.get("elements", []):
                        if "tags" in element:
                            tags = element["tags"]
                            places.append({
                                "id": element.get("id"),
                                "name": tags.get("name", f"Unnamed {category.title()}"),
                                "description": tags.get("description") or tags.get("addr:description", ""),
                                "type": tags.get("tourism") or tags.get("amenity") or tags.get("office", category),
                                "website": tags.get("website", ""),
                                "phone": tags.get("phone") or tags.get("contact:phone", ""),
                                "email": tags.get("email") or tags.get("contact:email", ""),
                                "address": tags.get("addr:street") or tags.get("addr:full", ""),
                                "latitude": element.get("lat") or element.get("center", {}).get("lat"),
                                "longitude": element.get("lon") or element.get("center", {}).get("lon")
                            })
                    return places
                except httpx.HTTPStatusError as e:
                    last_error = e
                    status = e.response.status_code
                    body_preview = e.response.text[:300].strip()
                    print(f"Overpass HTTP error {status} from {url}: {body_preview}")
                    if status in {429, 504, 502, 503}:
                        continue
                except httpx.RequestError as e:
                    last_error = e
                    print(f"Overpass request error from {url}: {type(e).__name__} - {e}")
                    continue
                except Exception as e:
                    last_error = e
                    print(f"Error fetching places from Overpass ({url}): {type(e).__name__} - {e}")
                    continue

            print(f"Error fetching places from Overpass: {last_error}")
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

    async def get_company_insights(self, company_data: Dict, company_type: Optional[str] = None) -> Dict | str:
        """
        Use AI to generate deep insights for any company type based on its available data.
        """
        company_info_str = json.dumps(company_data, indent=2)
        allowed_scale = ["extremely low", "low", "medium", "high", "extremely high"]
        
        # Use provided type or fallback to the 'type' field in data, then 'company'
        raw_type = company_type or company_data.get("type", "company")
        company_label = raw_type.strip().lower()

        prompt_template = (
            "You must return STRICT JSON ONLY. No extra text. "
            "If you cannot follow the schema exactly, return an empty string.\n\n"
            f"COMPANY TYPE: {company_label}\n"
            "SCHEMA (all keys required, keep exact key names and types):\n"
            "{\n"
            "  \"company\": {\n"
            "    \"id\": number | null,\n"
            "    \"name\": string,\n"
            "    \"type\": string,\n"
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
            "    \"customer_acquisition\": string\n"
            "  },\n"
            "  \"key_problems\": [string],\n"
            "  \"missing_components\": [string],\n"
            "  \"business_impact\": {\n"
            "    \"lost_leads\": one of [\"extremely low\",\"low\",\"medium\",\"high\",\"extremely high\"],\n"
            "    \"revenue_leakage\": string,\n"
            "    \"growth_potential\": one of [\"extremely low\",\"low\",\"medium\",\"high\",\"extremely high\"]\n"
            "  },\n"
            "  \"recommended_solutions\": {\n"
            "    \"website\": string,\n"
            "    \"seo\": string,\n"
            "    \"payments\": string,\n"
            "    \"operations\": string,\n"
            "    \"marketing\": string\n"
            "  },\n"
            "  \"value_for_company\": [string],\n"
            "  \"outreach_summary\": {\n"
            "    \"goal\": string,\n"
            "    \"primary_pitch\": string,\n"
            "    \"call_to_action\": string\n"
            "  }\n"
            "}\n\n"
            "Use the provided company data to fill fields. If a field is missing, "
            "use null (for website/phone/email/address) or a reasonable string. "
            "Never add extra keys."
        )

        response_text = self.ai_service.respond_to_input(company_info_str, prompt_template=prompt_template)

        def is_valid(payload: Dict) -> bool:
            try:
                if not isinstance(payload, dict):
                    return False
                required_keys = [
                    "company", "current_state", "key_problems", "missing_components",
                    "business_impact", "recommended_solutions", "value_for_company", "outreach_summary"
                ]
                if any(k not in payload for k in required_keys):
                    return False

                if payload["current_state"]["online_visibility"] not in allowed_scale:
                    return False
                if payload["business_impact"]["lost_leads"] not in allowed_scale:
                    return False
                if payload["business_impact"]["growth_potential"] not in allowed_scale:
                    return False

                contact = payload["current_state"]["contact_information"]
                for k in ["website", "phone", "email", "address"]:
                    if k not in contact:
                        return False

                rec = payload["recommended_solutions"]
                for k in ["website", "seo", "payments", "operations", "marketing"]:
                    if k not in rec:
                        return False

                loc = payload["company"]["location"]
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

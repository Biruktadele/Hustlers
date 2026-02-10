from fastapi import APIRouter, HTTPException
from typing import Any, Dict, List
from app.services.map_service import map_service

router = APIRouter()

@router.get("/companies", response_model=List[Dict])
async def get_addis_companies(lat: float = 9.0192, lon: float = 38.7525, radius: int = 10000):
    """
    Get a list of companies in Addis Ababa, centered around specific coordinates.
    Default center is 9.0192° N, 38.7525° E.
    """
    try:
        companies = await map_service.search_nearby_companies(lat, lon, radius)
        return companies
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/search/nearby", response_model=Dict[str, Any])
async def search_nearby(
    lat: float = 9.0192,
    lon: float = 38.7525,
    category: str = "hotel",
    radius: int = 1000,
):
    """
    Search for any supported category near a specific coordinate.
    Defaults to hotels around Addis Ababa (9.0192, 38.7525).
    Example categories: hotel, restaurant, hospital, school, mall, airport.
    """
    try:
        results = await map_service.get_nearby_places(lat, lon, category=category, radius=radius)
        return {
            "status_code": 200,
            "status": "success",
            "data": results 
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/company/insights")
async def get_company_insights(company_data: Dict):
    """
    Get deep AI-generated insights for a specific company or place by passing its data.
    Works for any category (hotel, restaurant, office, etc.)
    """
    try:
        insights = await map_service.get_company_insights(company_data)
        return {
            "status_code": 200,
            "status": "success",
            "data": insights
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/hotel/insights")
async def get_hotel_insights(hotel_data: Dict):
    """
    Get deep AI-generated insights specifically for a hotel.
    """
    try:
        insights = await map_service.get_hotel_insights(hotel_data)
        return {
            "status_code": 200,
            "status": "success",
            "data": insights
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

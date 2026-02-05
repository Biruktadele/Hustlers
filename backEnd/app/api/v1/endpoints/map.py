from fastapi import APIRouter, HTTPException
from typing import List, Dict
from app.services.map_service import map_service

router = APIRouter()

@router.get("/hotels/addis-ababa", response_model=List[Dict])
async def get_addis_hotels(lat: float = 9.0192, lon: float = 38.7525, radius: int = 10000):
    """
    Get a list of hotels in Addis Ababa, centered around specific coordinates.
    Default center is 9.0192° N, 38.7525° E.
    """
    try:
        hotels = await map_service.get_nearby_hotels(lat, lon, radius)
        return hotels
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/search/nearby")
async def search_nearby(lat: float, lon: float, radius: int = 1000):
    """
    Search for companies/offices near a specific coordinate.
    """
    try:
        results = await map_service.search_nearby_companies(lat, lon, radius)
        return results
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/hotel/insights")
async def get_hotel_insights(hotel_data: Dict):
    """
    Get deep AI-generated insights for a specific hotel by passing its data.
    """
    try:
        insights = await map_service.get_hotel_insights(hotel_data)
        return insights
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

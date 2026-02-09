import asyncio
import json
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
from app.services.map_service import map_service

# ...existing code...

async def manual_call():
    results = await map_service.get_nearby_places(
        lat=9.0192,
        lon=38.7525,
        category="hospital",
        radius=1000,
    )
    print(results[:3])

if __name__ == "__main__":
    asyncio.run(manual_call())
import json
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_map_endpoints():
    print("--- Testing GET /api/v1/map/search/nearby ---")
    # Using a small radius for faster testing
    response = client.get("/api/v1/map/search/nearby?lat=9.0192&lon=38.7525&category=hotel&radius=1000")
    
    if response.status_code != 200:
        print(f"Error: {response.status_code}")
        print(response.text)
        return

    hotels = response.json()
    print(f"Found {len(hotels)} hotels.")
    
    if not hotels:
        print("No hotels found in this radius. Cannot test insights.")
        return

    # Pick the first hotel to test insights
    sample_hotel = hotels[0]
    print(f"\nTesting insights for: {sample_hotel.get('name')}")
    # print(f"Hotel Data: {json.dumps(sample_hotel, indent=2)}")

    print("\n--- Testing POST /api/v1/map/company/insights ---")
    # The endpoint is /company/insights but it takes general place data
    insight_response = client.post("/api/v1/map/company/insights", json=sample_hotel)
    
    if insight_response.status_code == 200:
        insights = insight_response.json()
        print("Deep Insights Received:")
        print(json.dumps(insights, indent=2))
    else:
        print(f"Error calling insights: {insight_response.status_code}")
        print(insight_response.text)

if __name__ == "__main__":
    test_map_endpoints()

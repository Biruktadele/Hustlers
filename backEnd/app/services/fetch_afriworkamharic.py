import asyncio
from datetime import datetime, timedelta, timezone
from app.services.telegram_service import telegram_service

async def main():
    channel_username = "afriworkamharic"
    try:
        # print(f"Fetching data from channel: {channel_username}")

        # Calculate yesterday's date range with timezone-aware UTC datetimes
        today = datetime.now(timezone.utc)
        yesterday_start = (today - timedelta(days=1)).replace(hour=0, minute=0, second=0, microsecond=0)
        yesterday_end = yesterday_start.replace(hour=23, minute=59, second=59)

        # Fetch posts from the channel within the date range
        posts = await telegram_service.get_group_posts(channel_username, date_range=(yesterday_start, yesterday_end))

        # Define keywords for filtering
        keywords = [
            "software engineer", "mobile developer", "android", "ios", "flutter", "react native",
            "backend developer", "backend engineer", "django", "flask", "node.js" , "express"
        ]

        # Filter posts related to keywords
        filtered_posts = []
        for post in posts:
            # print(post)
            text = post.get('text', '').lower()  
            # print(text)  # Safely get the text and convert to lowercase
            if any(keyword in text for keyword in keywords):
                filtered_posts.append(post)
                post["text"] = text[:-200]
                print(post)

        # print("Filtered posts from yesterday (00:00 - 23:59) related to Software Engineering, Mobile Development, and Backend Development:")
        return filtered_posts
    except Exception as e:
        print(f"Error fetching data: {e}")

if __name__ == "__main__":
    asyncio.run(main())
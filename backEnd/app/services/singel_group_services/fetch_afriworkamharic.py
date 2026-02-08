import os , sys
import asyncio
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '../../..'))

from datetime import datetime, timedelta, timezone
from app.services.telegram_service import telegram_service

def formater(s , words):

    s = s.replace("\n", "")

    
    wordsen= ["job_title", "job_type", "location","sex","salary","deadline","description" , "more_info"]

    final = {word: "" for word in words}

    last_index = 0
    ll = -1
    for i, word in enumerate(words):
        start = s.find(word)
        
        if start != -1:
        
            if last_index > 0:
                final[words[ll]] = s[last_index:start].strip()


            ll = i
            last_index = start + len(word)
    i = 0
    for key in words:
        final[wordsen[i]] = final.pop(key)
        i += 1
    return final

async def main():

    filtered_posts1 = []
    filtered_posts2 = []
    channel_usernames = [
        "freelance_ethio","afriworkamharic"
]
    # for channel_username in channel_usernames:
    try:
        
        posts1 = await telegram_service.get_group_posts(channel_usernames[0], limit = 1000)
        posts2 = await telegram_service.get_group_posts(channel_usernames[1], limit = 1000)

        s1 = set(post["deep_link"] for post in posts1)
        posts2 = [post for post in posts2 if post["deep_link"] not in s1]




        
        # posts = list(set(posts))
        # Define keywords for filtering
        keywords = [
            
            "software", "mobile", "backend",
            "software development", "mobile development", "backend development",
            "artificial intelligence", "machine learning", "data science", "data analyst",
            "software engineer", "mobile developer", "android", "flutter", "react native",
            "backend developer", "backend engineer", "django", "flask", "fastapi","django"
        ]
        keywords_not = ["accountant", "sales and marketing", "sales representative" , "አካውንታንት" , "ሽያጭ እና ማርኬቲንግ",
                        "architect" ,"Video editor" 
                        ]

        # Filter posts related to keywords
        
        for post in posts1:
            # print(post)
            text = post["message"].lower()
            # print(text)  # Safely get the text and convert to lowercase
            if any(keyword in text for keyword in keywords) and not any(keyword in text for keyword in keywords_not): 
                filtered_posts1.append(post)
        for post in posts2:
            # print(post)
            text = post["message"].lower()
            # print(text)  # Safely get the text and convert to lowercase
            if any(keyword in text for keyword in keywords) and not any(keyword in text for keyword in keywords_not):
                filtered_posts2.append(post)
    except Exception as e:
        print(f"Error fetching data: {e}")
    final_posts = []

    for data in filtered_posts1:
        dict1 = formater(data["message"] , ["Job Title:", "Job Type:", "Work Location:","Sex", "Salary/Compensation:", "Deadline:", "Description:", "..."])
        dict1["deeplink"] = data["deep_link"]
        final_posts.append(dict1)
    for data in filtered_posts2:
        dic = formater(data["message"] , ["የስራው መጠሪያ:", "የስራው አይነት:", "የስራው ቦታ:", "የአመልካቾች ጾታ:", "ደሞዝ/ክፍያ:", "የማመልከቻ ማብቂያ ቀን:", "የስራው ዝርዝር:" , "..."])
        dic["deeplink"] = data["deep_link"]
        final_posts.append(dic)
   
    return final_posts

if __name__ == "__main__":
    asyncio.run(main())
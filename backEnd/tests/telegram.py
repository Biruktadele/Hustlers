import asyncio
import json
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from app.services.telegram_service import TelegramService

telegram_service = TelegramService()

# telegram_service = TelegramService()

async def main():
    # afriworkamharic

    # data = await telegram_service.get_group_posts("freelance_ethio", limit=10)
    s = "Job Title: Architect\n\n\n\nWork Location: Addis Ababa, Ethiopia\n\nSalary/Compensation: Monthly\n\nDeadline: February 28th, 2026\n\nDescription:\nWe are seeking a highly skilled and creative Architect with strong expertise in 3ds Max and Blender to join our team. The ideal candidate will be responsible for architectural design, detailed 3D mode ..."
    s = s.replace("\n", "")

    words =  ["Job Title:", "Job Type:", "Work Location:","sex", "Salary/Compensation:", "Deadline:", "Description:", "..."]
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
    print(final)

    
    



    # print(data)
    
asyncio.run(main())

# s = desc.split("\n\n")
#     final = {}
#     final["Job Title"] = s[0].split(":")[1].strip() if len(s) > 0 and ":" in s[0] else ""
#     final["Job Type"] = s[1].split(":")[1].strip() if len(s) > 1 and ":" in s[1] else ""
#     final["Work Location"] = s[2].split(":")[1].strip() if len(s) > 2 and ":" in s[2] else ""
#     final["Salary/Compensation"] = s[3].split(":")[1].strip() if len(s) > 3 and ":" in s[3] else ""
#     final["Deadline"] = s[4].split(":")[1].strip() if len(s) > 4 and ":" in s[4] else ""
#     final["Description"] = s[5].split(":")[1].strip().split('\n')[0] if len(s) > 5 and ":" in s[5] else ""
  
#     final["deeplink"] = data[0]["deep_link"]
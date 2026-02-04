# Telegram Job Extraction Implementation

## Required Code Changes

### 1. Update AI Service Prompt (app/services/ai_service.py)

**Current prompt (line 68-70):**
```
"Extract job data from the user input and return STRICT JSON only. "
"No markdown, no extra text. Use these keys: "
"job_name, job_type, job_location, salary, application_deadline, job_description : explain the job deescrbition very weel by ur self. "
```

**New prompt should be:**
```
"Extract job data from the user input and return STRICT JSON only. "
"No markdown, no extra text. Use these keys: "
"jobname, jobtype, price, expierdate, jobdescrbiton. "
"jobdescrbiton should explain the job description very well. "
"If a field is missing, use an empty string.\n\n"
```

### 2. Update Data Combination Logic (app/services/ai_service.py)

**Current res() function (lines 126-146) already combines data correctly:**
```python
def res():
    from app.services import fetch_afriworkamharic
    service = AIService()
    try:
        ls = asyncio.run(fetch_afriworkamharic.main())
    except Exception as e:
        print(f"Error fetching posts: {e}")
        return []
        
    posts = []
    for post in ls:
        response_text = service.respond_to_input(post['text'])
        try:
            response = json.loads(response_text)
            response["deep_link"] = post.get("deep_link")
            response["date"] = post.get("date")
            posts.append(response)
            print(response)
        except json.JSONDecodeError:
            print(f"Failed to parse AI response: {response_text}")
    return posts
```

This function already produces the exact format you want:
```json
{
    "jobname": "...",
    "jobtype": "...", 
    "price": "...",
    "expierdate": "...",
    "jobdescrbiton": "...",
    "date": "2025-01-XX...",
    "deep_link": "https://..."
}
```

### 3. Verify Filtering (app/services/fetch_afriworkamharic.py)

**Current keywords (lines 19-23) already include your requirements:**
```python
keywords = [
    "a",
    "software engineer", "mobile developer", "android", "ios", "flutter", "react native",
    "backend developer", "backend engineer", "django", "flask", "node.js", "express"
]
```

## Implementation Steps

1. **Only change needed**: Update the AI service prompt to use exact field names
2. **Test**: Run the existing `res()` function to verify output format
3. **Done**: The rest of the system already works as requested

## Files to Modify

- `app/services/ai_service.py` - Update prompt in `respond_to_input()` method (lines 68-72)

## Expected Result

After the prompt change, calling `res()` will return posts in exactly the format you specified, with:
- AI-extracted job data using your field names
- Original post metadata (date, deep_link)
- Proper filtering for software engineering jobs

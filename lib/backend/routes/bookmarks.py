import os
from fastapi import APIRouter, HTTPException
import httpx
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

JSEARCH_API_KEY = os.getenv("JSEARCH_API_KEY")

@router.get("/remotive")
async def get_remotive_jobs():
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get("https://remotive.com/api/remote-jobs?category=software-dev&limit=10")
            response.raise_for_status()
            data = response.json()
            jobs = [
                {
                    "title": job["title"],
                    "company": job["company_name"],
                    "url": job["url"],
                    "logo": job.get("company_logo_url"),
                    "location": job.get("candidate_required_location", "Remote"),
                    "description": job.get("description", ""),
                    "source": "Remotive"
                }
                for job in data.get("jobs", [])
            ]
            return {"jobs": jobs}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/jsearch")
async def get_jsearch_jobs():
    if not JSEARCH_API_KEY:
        return {"jobs": []}
    
    url = "https://jsearch.p.rapidapi.com/search"
    querystring = {"query": "software developer", "num_pages": "1"}

    headers = {
        "X-RapidAPI-Key": JSEARCH_API_KEY,
        "X-RapidAPI-Host": "jsearch.p.rapidapi.com"
    }

    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, headers=headers, params=querystring)
            response.raise_for_status()
            data = response.json()
            jobs = [
                {
                    "title": job.get("job_title"),
                    "company": job.get("employer_name"),
                    "url": job.get("job_apply_link"),
                    "logo": job.get("employer_logo"),
                    "location": job.get("job_country", "Unknown"),
                    "description": job.get("job_description", ""),
                    "source": "JSearch"
                }
                for job in data.get("data", [])
            ]
            return {"jobs": jobs}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


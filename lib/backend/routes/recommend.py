import json
import os
import httpx
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")

class RecommendationRequest(BaseModel):
    interests: str
    skills: str
    goals: str

@router.post("/recommend")
async def recommend_career(data: RecommendationRequest):
    prompt = f"""
    Given the following user profile:

Interests: {data.interests}  
Skills: {data.skills}  
Goals: {data.goals}  

Based on this information, recommend the most suitable career path.

Respond **only** with a JSON object in the following format and nothing else. Remove mark-down formatting and escape characters:


  "job_title": "string",
  "skills_required": ["string", ...],
  "job_description": "string"

    """

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json"
    }

    body = {
        "model": "deepseek/deepseek-chat-v3-0324:free",  # or another free model
        "messages": [
            {"role": "user", "content": prompt}
        ]
    }

    async with httpx.AsyncClient() as client:
        response = await client.post("https://openrouter.ai/api/v1/chat/completions", json=body, headers=headers)
    print(" " + response.text)

    if response.status_code != 200:
        raise HTTPException(status_code=response.status_code, detail=response.text)

    result = response.json()
    reply = result["choices"][0]["message"]["content"].replace("`", "" ).replace("json","")
    return {"recommendation": json.loads(reply)}

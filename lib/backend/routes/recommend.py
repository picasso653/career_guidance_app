import os
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv
from openai import OpenAI

# Load API key from .env
load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

router = APIRouter()

class UserInput(BaseModel):
    interests: str
    skills: str
    goals: str

@router.post("/recommend")
async def recommend_career(data: UserInput):
    try:
        prompt = f"Suggest a career path based on these details:\nInterests: {data.interests}\nSkills: {data.skills}\nGoals: {data.goals}"
        
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a career guidance assistant."},
                {"role": "user", "content": prompt}
            ]
        )

        result = response.choices[0].message.content.strip()
        return {"recommendation": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

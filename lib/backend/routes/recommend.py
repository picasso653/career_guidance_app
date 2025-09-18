# lib/backend/routes/recommend.py
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
    education_level: str

@router.post("/recommend")
async def recommend_career(data: RecommendationRequest):
    # Different prompts based on education level
    if data.education_level == "Basic school":
        prompt = f"""
        You are WiseChoiceAI, an expert career counselor with 20 years of career guidance experience.
        Given the following user profile from a basic school student:

        Interests: {data.interests}

        Recommend the most suitable career path and the best high school course they should pursue.
        High school courses should be one of: Science, Business, Visual Arts, General Arts, Home Economics, Technical skills.

        Respond ONLY with a JSON object in this exact format:
        {{
          "recommended_career_path": "string",
          "recommended_high_school_course": "string",
          "explanation": "string"
        }}
        Do not include any additional text, markdown, or explanations.
        """
    elif data.education_level == "High school grad":
        prompt = f"""
        You are WiseChoiceAI, an expert career counselor with 20 years of career guidance experience.
        Given the following user profile from a high school graduate:

        Interests: {data.interests}
        Goals: {data.goals}

        Recommend the most suitable career path, the best university program, and essential skills to learn.

        Respond ONLY with a JSON object in this exact format:
        {{
          "recommended_career_path": "string",
          "recommended_university_program": "string",
          "essential_skills": ["string", "string"],
          "explanation": "string"
        }}
        Do not include any additional text, markdown, or explanations.
        """
    else:  # Undergraduate
        prompt = f"""
        You are WiseChoiceAI, an expert career counselor with 20 years of career guidance experience.
        Given the following user profile:

        Interests: {data.interests}
        Skills: {data.skills}
        Goals: {data.goals}

        Based on this information, recommend the most suitable career path.

        Respond ONLY with a JSON object in this exact format:
        {{
          "job_title": "string",
          "skills_required": ["string", "string"],
          "job_description": "string"
        }}
        Do not include any additional text, markdown, or explanations.
        """

    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "HTTP-Referer": "https://yourdomain.com",
        "X-Title": "Career Guidance App",
        "Content-Type": "application/json"
    }

    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://openrouter.ai/api/v1/chat/completions",
                json={
                    "model": "deepseek/deepseek-chat-v3.1:free",
                    "messages": [{"role": "user", "content": prompt}],
                    "temperature": 0.7
                },
                headers=headers,
                timeout=30.0
            )
        
        response.raise_for_status()
        content = response.json()
        ai_response = content["choices"][0]["message"]["content"]
        
        # Clean and parse the JSON response
        json_str = ai_response.strip()
        if json_str.startswith('```json'):
            json_str = json_str[7:]  # Remove ```json
        if json_str.endswith('```'):
            json_str = json_str[:-3]  # Remove ```
        json_str = json_str.strip()
        
        recommendation = json.loads(json_str)
        
        # Add education level to response for frontend handling
        recommendation["education_level"] = data.education_level
        
        return {"recommendation": recommendation}
        
    except httpx.HTTPStatusError as e:
        error_msg = f"OpenRouter API error: {e.response.status_code} - {e.response.text}"
        print(error_msg)
        raise HTTPException(status_code=502, detail=error_msg)
    except json.JSONDecodeError as e:
        error_msg = f"Failed to parse AI response: {str(e)}\nRaw response: {ai_response}"
        print(error_msg)
        raise HTTPException(status_code=500, detail="Invalid response format from AI")
    except Exception as e:
        error_msg = f"Unexpected error: {str(e)}"
        print(error_msg)
        raise HTTPException(status_code=500, detail=error_msg)
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from lib.backend.database import get_db
from lib.backend.auth import models
import json

router = APIRouter()

@router.post("/test-results")
def save_test_result(
    interests: str,
    skills: str,
    goals: str,
    recommendation: str,
    db: Session = Depends(get_db)
):
    # In real app, get user from token
    user = db.query(models.User).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Save test result
    user.test_result = recommendation
    
    # Update user's skills/interests
    user.skills = skills
    user.interests = interests
    user.goals = goals
    
    db.commit()
    return {"message": "Test result saved"}


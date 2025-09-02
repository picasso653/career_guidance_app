from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from lib.backend.database import get_db
from lib.backend.auth import models
import os
import shutil
import json

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/profile")
def get_profile(db: Session = Depends(get_db)):
    user = db.query(models.User).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "full_name": user.full_name,
        "profile_picture": user.profile_picture,
        "test_result": json.loads(user.test_result) if user.test_result else None,
        "bookmarked_jobs": json.loads(user.bookmarked_jobs) if user.bookmarked_jobs else [],
        "bookmarked_courses": json.loads(user.bookmarked_courses) if user.bookmarked_courses else [],
    }

@router.put("/profile")
async def update_profile(
    username: str,
    email: str,
    full_name: str,
    profile_image: UploadFile = File(None),
    db: Session = Depends(get_db)
):
    user = db.query(models.User).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    user.username = username
    user.email = email
    user.full_name = full_name
    
    if profile_image:
        file_path = os.path.join(UPLOAD_DIR, profile_image.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(profile_image.file, buffer)
        user.profile_picture = f"/uploads/{profile_image.filename}"
    
    db.commit()
    return {"message": "Profile updated successfully"}


from fastapi import APIRouter, Depends, HTTPException, UploadFile, File
from sqlalchemy.orm import Session
from lib.backend.database import get_db
from lib.backend.auth import models
from lib.backend.routes.auth import get_current_user
import os
import shutil
import json

router = APIRouter()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.get("/profile")
def get_profile(
    current_user: models.User = Depends(get_current_user),  # ✅ use token
    db: Session = Depends(get_db)
):
    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
        "full_name": current_user.full_name,
        "profile_picture": current_user.profile_picture,
        "test_result": json.loads(current_user.test_result) if current_user.test_result else None,
        "bookmarked_jobs": json.loads(current_user.bookmarked_jobs) if current_user.bookmarked_jobs else [],
        "bookmarked_courses": json.loads(current_user.bookmarked_courses) if current_user.bookmarked_courses else [],
    }

@router.put("/profile")
async def update_profile(
    username: str,
    email: str,
    full_name: str,
    profile_image: UploadFile = File(None),
    current_user: models.User = Depends(get_current_user),  # ✅ secure
    db: Session = Depends(get_db)
):
    current_user.username = username
    current_user.email = email
    current_user.full_name = full_name
    
    if profile_image:
        file_path = os.path.join(UPLOAD_DIR, profile_image.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(profile_image.file, buffer)
        current_user.profile_picture = f"/uploads/{profile_image.filename}"

    db.commit()
    return {"message": "Profile updated successfully"}


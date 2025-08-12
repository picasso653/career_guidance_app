from fastapi import APIRouter
import json
import os

router = APIRouter()

@router.get("/courses")
def get_courses():
    with open("backend/data/courses.json") as f:
        data = json.load(f)
    return data

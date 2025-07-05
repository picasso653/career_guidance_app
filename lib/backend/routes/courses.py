from fastapi import APIRouter
import json
from pathlib import Path

router = APIRouter()

@router.get("/courses")
async def get_courses():
    file_path = Path(__file__).parent.parent / "data" / "courses.json"
    with open(file_path, "r") as f:
        courses = json.load(f)
    return {"courses": courses}



@router.get("/courses/{id}")
def get_course_by_id(id: str):
    # Use course dataset to fetch course by ID
    ...

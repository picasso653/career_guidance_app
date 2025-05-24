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

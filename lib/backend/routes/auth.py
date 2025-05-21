from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

# Temporary in-memory "users"
users_db = {
    "student1": {"password": "password123"},
    "admin": {"password": "adminpass"},
}

class AuthRequest(BaseModel):
    username: str
    password: str

@router.post("/login")
def login(data: AuthRequest):
    user = users_db.get(data.username)
    if not user or user["password"] != data.password:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    return {"message": "Login successful", "username": data.username}

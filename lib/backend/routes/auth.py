import logging
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from pydantic import BaseModel
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt

from database import SessionLocal
from models import user as models
from auth import utils
from backend.auth.auth_utils import SECRET_KEY, ALGORITHM

# Initialize logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

class UserSignup(BaseModel):
    username: str
    email: str
    password: str

class UserLogin(BaseModel):
    username: str
    password: str

@router.post("/signup")
def signup(user: UserSignup, db: Session = Depends(get_db)):
    logger.info(f"Received signup request for username: {user.username}, email: {user.email}")
    try:
        db_user = db.query(models.User).filter(models.User.username == user.username).first()
        if db_user:
            logger.warning("Signup failed: Username already taken")
            raise HTTPException(status_code=400, detail="Username already taken")

        hashed_pw = utils.hash_password(user.password)
        new_user = models.User(username=user.username, email=user.email, hashed_password=hashed_pw)
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        logger.info(f"User {user.username} created successfully")
        return {"message": "User created successfully"}

    except Exception as e:
        logger.error(f"Error during signup: {e}")
        raise HTTPException(status_code=500, detail="Internal server error during signup")

@router.post("/login")
def login(user: UserLogin, db: Session = Depends(get_db)):
    logger.info(f"Login attempt for user: {user.username}")
    try:
        db_user = db.query(models.User).filter(models.User.username == user.username).first()
        if not db_user or not utils.verify_password(user.password, db_user.hashed_password):
            logger.warning("Login failed: Invalid credentials")
            raise HTTPException(status_code=401, detail="Invalid credentials")

        token = utils.create_access_token({"sub": db_user.username})
        logger.info(f"Token issued for user: {user.username}")
        return {"access_token": token, "token_type": "bearer"}

    except Exception as e:
        logger.error(f"Error during login: {e}")
        raise HTTPException(status_code=500, detail="Internal server error during login")

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            logger.warning("Token decode failed: Missing username")
            raise credentials_exception
    except JWTError as e:
        logger.warning(f"Token verification failed: {e}")
        raise credentials_exception

    user = db.query(models.User).filter(models.User.username == username).first()
    if user is None:
        logger.warning("User not found in DB after token verification")
        raise credentials_exception
    return user

@router.post("/profile")
def get_profile(current_user: models.User = Depends(get_current_user)):
    logger.info(f"Profile accessed by user: {current_user.username}")
    return {
        "id": current_user.id,
        "username": current_user.username,
        "email": current_user.email,
    }

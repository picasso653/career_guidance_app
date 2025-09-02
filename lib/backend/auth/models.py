from sqlalchemy import Column, Integer, String, Text, ForeignKey
from sqlalchemy.orm import relationship
from lib.backend.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String, nullable=True)
    profile_picture = Column(String, nullable=True)
    bio = Column(Text, nullable=True)
    hashed_password = Column(String)
    
    # For career test - these should be columns, not relationships
    skills = Column(Text, nullable=True)
    interests = Column(Text, nullable=True)
    goals = Column(Text, nullable=True)
    test_result = Column(Text, nullable=True)
    
    # For bookmarks - these should be columns, not relationships
    bookmarked_jobs = Column(Text, nullable=True)
    bookmarked_courses = Column(Text, nullable=True)


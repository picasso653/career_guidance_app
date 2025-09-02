from sqlalchemy import Column, Integer, String, ForeignKey, Table
from sqlalchemy.orm import relationship
from lib.backend.database import Base

# User model
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String, nullable=True)
    profile_picture = Column(String, nullable=True)
    hashed_password = Column(String)

    bookmarked_jobs = relationship("BookmarkedJob", back_populates="user")
    bookmarked_courses = relationship("BookmarkedCourse", back_populates="user")

# Bookmark models
class BookmarkedJob(Base):
    __tablename__ = "bookmarked_jobs"

    id = Column(Integer, primary_key=True, index=True)
    job_id = Column(String, index=True)
    job_data = Column(String)  # Store serialized job data
    user_id = Column(Integer, ForeignKey("users.id"))

    user = relationship("User", back_populates="bookmarked_jobs")

class BookmarkedCourse(Base):
    __tablename__ = "bookmarked_courses"

    id = Column(Integer, primary_key=True, index=True)
    course_id = Column(String, index=True)
    course_data = Column(String)  # Store serialized course data
    user_id = Column(Integer, ForeignKey("users.id"))

    user = relationship("User", back_populates="bookmarked_courses")

# Test results model
class TestResult(Base):
    __tablename__ = "test_results"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    interests = Column(String)
    skills = Column(String)
    goals = Column(String)
    recommendation = Column(String)  # Store serialized recommendation

    user = relationship("User")

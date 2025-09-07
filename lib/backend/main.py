from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from database import Base, engine
from routes import courses, jobs, recommend
from auth.routes import router as auth_router
from routes import profile, test_results, bookmarks  # Remove duplicate courses, jobs imports

app = FastAPI()
Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(recommend.router)
app.include_router(jobs.router)
app.include_router(courses.router)
app.include_router(auth_router, prefix="/auth")
app.include_router(profile.router, prefix="/profile")
app.include_router(test_results.router, prefix="/test")
app.include_router(bookmarks.router, prefix="/bookmarks")

@app.get('/')
def read_root():
    return {'message': 'Backend running'}


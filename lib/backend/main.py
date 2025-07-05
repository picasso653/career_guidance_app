from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from lib.backend.routes import courses
from lib.backend.routes import recommend
from lib.backend.routes import jobs
from lib.backend.auth.routes import router as auth_router
from lib.backend.database import Base, engine



app = FastAPI()
Base.metadata.create_all(bind=engine)



app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Replace "*" with your Flutter host in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



app.include_router(recommend.router)
app.include_router(jobs.router)
app.include_router(courses.router)
app.include_router(auth_router)

@app.get('/')
def read_root():
    return {'message': 'Backend running'}

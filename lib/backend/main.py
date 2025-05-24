from fastapi import FastAPI
from routes import courses
from routes import recommend
from routes import jobs




app = FastAPI()

app.include_router(recommend.router)
app.include_router(jobs.router)
app.include_router(courses.router)

@app.get('/')
def read_root():
    return {'message': 'Backend running'}

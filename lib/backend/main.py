from fastapi import FastAPI
from routes import recommend




app = FastAPI()

app.include_router(recommend.router)

@app.get('/')
def read_root():
    return {'message': 'Backend running'}

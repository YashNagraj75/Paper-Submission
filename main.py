from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/submit_paper")
def read_authors():
    return {"authors": ["author1", "author2"]}

@app.post("/review")
def read_review():
    return {"review": "review"}

@app.post("/conference")
def read_conference():
    return {"conference": "conference"}

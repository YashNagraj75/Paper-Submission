from pydantic import BaseModel

class Paper_Submit(BaseModel):
    title: str
    abstract: str
    keywords: str
    submission_date: str
    track: str

class Review(BaseModel):
    paper_id: int
    reviewer_id: int 
    score: int
    feedback: str
    date: str

class Author(BaseModel):
    name: str
    password: str
    email: str
    affiliation: str
    age: int

class Schedule_Preview(BaseModel):
    paper_id: int
    presentation_time: str
    room: str
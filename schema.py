from pydantic import BaseModel

class Paper_Submit(BaseModel):
    title: str
    abstract: str
    keywords: str
    submission_date: str
    tack: str

class Review(BaseModel):
    paper_id: int
    reviewer_id: int 
    score: int
    feedback: str
    date: str


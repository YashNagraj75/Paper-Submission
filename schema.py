from pydantic import BaseModel

class Paper_Submit(BaseModel):
    title: str
    abstract: str
    keywords: str
    submission_date: str
    tack: str
import datetime
import mysql.connector
from mysql.connector import Error
from narwhals import col
from schema import Author, Paper_Submit,Review
import pandas as pd

def get_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            port="3306",
            user="a",
            password="abc",
            database="Paper"
        )
        cursor = conn.cursor()
        return conn, cursor
    
    except Error as e:
        print(e)
        return None, None


conn, cur  = get_connection()

def submit_new_paper(submission:Paper_Submit):
    try:
        track_id = get_track_id(submission.track)
        query = "INSERT INTO Paper (Title, Abstract, Keywords, SubmissionDate, TrackID) VALUES (%s, %s, %s, %s, %s)"
        values = (submission.title, submission.abstract, submission.keywords, submission.submission_date, track_id)
        cur.execute(query, values)
        conn.commit()
        return True
    except Error as e:
        print(e)
        return False


def get_track_id(track_name):
    try:
        query = "SELECT TrackID FROM Track WHERE TrackName = %s"
        values = (track_name,)
        cur.execute(query, values)
        result = cur.fetchone()
        return result
    except Error as e:
        print(e)
        return None
    
def review_paper(review:Review):
    try:
        query = "INSERT INTO Review (PaperId, ReviewerId, Score, Feedback, ReviewDate) VALUES (%s, %s, %s, %s, %s)"
        values = (review.paper_id, review.reviewer_id, review.score, review.feedback, review.date)
        result = cur.execute(query, values) # type: ignore
        conn.commit() # type: ignore
        return result
    except Error as e:
        print(e)
        return None
    

def final_review(paper_id):
    try:
        all_reviews = "SELECT * FROM Review where PaperId = %s"
        cur.execute(all_reviews,(paper_id,))
        result = cur.fetchall()
        conn.commit()
        print(result)
    except Exception as e:
        print(e)
        return None
    


def author_signup(author: Author):
    try:
        query = "INSERT INTO Author (Name,Email, Affiliation,ProfileCreationDate, Age, Password) VALUES (%s, %s, %s, %s, %s, %s)"
        creation_date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        values = (author.name, author.email, author.affiliation, creation_date, author.age, author.password)
        cur.execute(query, values)
        conn.commit()
        return True
    except Error as e:
        print(e)
        return False

def author_login(name, password):
    try:
        query = "SELECT * FROM Author WHERE Name = %s AND Password = %s"
        values = (name, password)
        cur.execute(query, values)
        author = cur.fetchone()
        if author:
            return "Author"
        
        reviewer = "SELECT * FROM Reviewer WHERE Name = %s"
        r_values = (name,)
        cur.execute(reviewer,r_values)
        reviewer = cur.fetchone()
        if reviewer:
            return "Reviewer"

    except Error as e:
        print(e)
        return False
    
def get_presentation_details(paper_name:str):
    paper= "Select PaperId from Paper where Title = %s"
    cur.execute(paper,(paper_name,))
    paper_id = cur.fetchone()
    print(paper_id)

    presentation_details = "select * from Schedule where PaperId = %s"
    try:
        cur.execute(presentation_details,(int(paper_id[0]),))
        details = cur.fetchone()
    except Exception as e:
        return f"No Presentation Details {e}"
    print(details)

    details = [details]
    try:
        df = pd.DataFrame(details,columns=["ScheduleId","PaperID","PresentationDate","TimeSlot","Room"])
    except ValueError as e:
        return "No Presentation Details"
    return df


def update_paper_details(paper_id: int, new_title: str, new_keywords: str):
    update_query = """
    UPDATE Paper
    SET Title = %s, Keywords = %s
    WHERE PaperId = %s
    """
    cur.execute(update_query, (new_title, new_keywords, paper_id))
    conn.commit()


def get_user_id(username: str):
    query = "SELECT AuthorID FROM Author WHERE Name = %s"
    cur.execute(query, (username,))
    result = cur.fetchone()
    return result[0] if result else None

# Function to get all papers submitted by a user given their user ID
def get_papers_by_user(user_id: int):
    query = """
    SELECT Paper.PaperID, Paper.Title, Paper.Keywords, Paper.SubmissionDate, Paper.Status
    FROM Paper
    INNER JOIN PaperAuthor ON Paper.PaperID = PaperAuthor.PaperID
    WHERE PaperAuthor.AuthorID = %s
    """
    cur.execute(query, (user_id,))
    papers = cur.fetchall()
    return papers


def update_paper_details(paper_id: int, new_title: str, new_keywords: str):
    try:
        update_query = """
        UPDATE Paper
        SET Title = %s, Keywords = %s
        WHERE PaperId = %s
        """
        cur.execute(update_query, (new_title, new_keywords, paper_id))
        conn.commit()
        return True
    except Exception as e:
        return f"Error while updating entry: {e}"
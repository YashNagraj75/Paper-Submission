import mysql.connector
from mysql.connector import Error
from schema import Paper_Submit,Review

def get_connection():
    try:
        conn = mysql.connector.connect(
            host="localhost",
            port="3306",
            user="root",
            password="12345678",
            database="Paper"
        )
        cursor = conn.cursor()
        return conn, cursor
    
    except Error as e:
        print(e)
        return None, None


conn, cur  = get_connection()

def submit_paper(submission:Paper_Submit):
    try:
        track_id = get_track_id(submission.tack)
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
        return result[0]
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
    



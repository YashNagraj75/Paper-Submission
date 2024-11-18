import mysql.connector
from mysql.connector import Error
from schema import Paper_Submit

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
    

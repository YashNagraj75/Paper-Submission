-- Server Part
CREATE DATABASE Paper;
USE Paper;

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Affiliation VARCHAR(255),
    ProfileCreationDate DATE,
    Age INT,
    Password VARCHAR(255)
);

CREATE TABLE Track (
    TrackID INT PRIMARY KEY,
    TrackName VARCHAR(255),
    Description TEXT
);

CREATE TABLE Paper (
    PaperID INT PRIMARY KEY,
    Title VARCHAR(255),
    Keywords VARCHAR(255),
    SubmissionDate DATE,
    TrackID INT,
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID)
);

CREATE TABLE PaperAuthor (
    PaperID INT,
    AuthorID INT,
    PRIMARY KEY (PaperID, AuthorID),
    FOREIGN KEY (PaperID) REFERENCES Paper(PaperID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Reviewer (
    ReviewerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    ExpertiseArea VARCHAR(255),
    maxPapers INT
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY,
    PaperID INT,
    ReviewerID INT,
    Score INT,
    Feedback TEXT,
    ReviewDate DATE,
    FOREIGN KEY (PaperID) REFERENCES Paper(PaperID),
    FOREIGN KEY (ReviewerID) REFERENCES Reviewer(ReviewerID)
);

CREATE TABLE Schedule (
    ScheduleID INT PRIMARY KEY,
    PaperID INT,
    PresentationDate DATE,
    TimeSlot TIME,
    Room VARCHAR(255),
    FOREIGN KEY (PaperID) REFERENCES Paper(PaperID)
);

INSERT INTO Author (AuthorID, Name, Email, Affiliation, ProfileCreationDate, Age, Password) VALUES
(1, 'Alice Smith', 'alice@example.com', 'University A', '2023-01-01', 35, 'password123'),
(2, 'Bob Johnson', 'bob@example.com', 'University B', '2023-02-01', 40, 'password456'),
(3, 'Carol White', 'carol@example.com', 'University C', '2023-03-01', 30, 'password789'),
(4, 'David Brown', 'david@example.com', 'University D', '2023-04-01', 45, 'password101'),
(5, 'Eve Black', 'eve@example.com', 'University E', '2023-05-01', 50, 'password202');

INSERT INTO Track (TrackID, TrackName, Description) VALUES
(1, 'Machine Learning', 'Research on machine learning algorithms and applications'),
(2, 'Data Science', 'Research on data science techniques and tools'),
(3, 'Artificial Intelligence', 'Research on AI and its applications'),
(4, 'Computer Vision', 'Research on image and video analysis'),
(5, 'Natural Language Processing', 'Research on language understanding and generation');

INSERT INTO Paper (PaperID, Title, Keywords, SubmissionDate, TrackID) VALUES
(1, 'Deep Learning Techniques', 'deep learning, neural networks', '2023-03-01', 1),
(2, 'Data Analysis Methods', 'data analysis, statistics', '2023-03-02', 2),
(3, 'AI in Healthcare', 'AI, healthcare', '2023-03-03', 3),
(4, 'Image Recognition', 'computer vision, image recognition', '2023-03-04', 4),
(5, 'Text Generation', 'NLP, text generation', '2023-03-05', 5);

INSERT INTO PaperAuthor (PaperID, AuthorID) VALUES
(1, 1),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Reviewer (ReviewerID, Name, Email, ExpertiseArea, maxPapers) VALUES
(1, 'Charlie Brown', 'charlie@example.com', 'Machine Learning', 5),
(2, 'Diana Prince', 'diana@example.com', 'Data Science', 3),
(3, 'Edward Green', 'edward@example.com', 'Artificial Intelligence', 4),
(4, 'Fiona Blue', 'fiona@example.com', 'Computer Vision', 2),
(5, 'George Red', 'george@example.com', 'Natural Language Processing', 6);

INSERT INTO Review (ReviewID, PaperID, ReviewerID, Score, Feedback, ReviewDate) VALUES
(1, 1, 1, 85, 'Good work on deep learning techniques.', '2023-03-10'),
(2, 2, 2, 90, 'Excellent analysis methods.', '2023-03-11'),
(3, 3, 3, 88, 'Innovative use of AI in healthcare.', '2023-03-12'),
(4, 4, 4, 92, 'Great work on image recognition.', '2023-03-13'),
(5, 5, 5, 87, 'Impressive text generation techniques.', '2023-03-14');

INSERT INTO Schedule (ScheduleID, PaperID, PresentationDate, TimeSlot, Room) VALUES
(1, 1, '2023-04-01', '10:00:00', 'Room 101'),
(2, 2, '2023-04-02', '11:00:00', 'Room 102'),
(3, 3, '2023-04-03', '12:00:00', 'Room 103'),
(4, 4, '2023-04-04', '13:00:00', 'Room 104'),
(5, 5, '2023-04-05', '14:00:00', 'Room 105');

CREATE USER 'federated_user'@'%' IDENTIFIED BY 'federated_password';
GRANT SELECT ON Paper.Review TO 'federated_user'@'%';
FLUSH PRIVILEGES;

INSERT INTO Review (ReviewID, PaperID, ReviewerID, Score, Feedback, ReviewDate) VALUES
(6, 1, 2, 95, 'Excellent work on deep learning techniques.', '2023-03-15');

SELECT * FROM ReviewFederated WHERE ReviewID = 6;

WITH RECURSIVE ReviewHistory AS (
    SELECT 
        ReviewID,
        ReviewerID,
        PaperID,
        Score,
        Feedback,
        ReviewDate
    FROM 
        Review
    WHERE 
        ReviewerID = 1 AND PaperID = 1
    UNION ALL
    SELECT 
        r.ReviewID,
        r.ReviewerID,
        r.PaperID,
        r.Score,
        r.Feedback,
        r.ReviewDate
    FROM 
        Review r
    INNER JOIN 
        ReviewHistory rh ON r.ReviewerID = rh.ReviewerID AND r.PaperID = rh.PaperID
    WHERE 
        r.ReviewDate > rh.ReviewDate
)
SELECT 
    ReviewID,
    ReviewerID,
    PaperID,
    Score,
    Feedback,
    ReviewDate
FROM 
    ReviewHistory
ORDER BY 
    ReviewDate;


DELIMITER //

CREATE PROCEDURE AssignExpeditedReview(IN paper_id INT)
BEGIN
    DECLARE avg_score FLOAT;
    DECLARE senior_reviewer_id INT;
    DECLARE review_count INT;

    SELECT AVG(Score) INTO avg_score
    FROM Review
    WHERE PaperID = paper_id;

    IF avg_score < 7.0 THEN
        SELECT ReviewerID INTO senior_reviewer_id
        FROM Reviewer
        WHERE ExpertiseArea = 'Data Science' or ExpertiseArea = 'Machine Learning'
        AND ReviewerID NOT IN (SELECT ReviewerID FROM Review WHERE PaperID = paper_id)
        AND (SELECT COUNT(*) FROM Review WHERE ReviewerID = Reviewer.ReviewerID) < maxPapers
        LIMIT 1;

        IF senior_reviewer_id IS NOT NULL THEN
            INSERT INTO Review (PaperID, ReviewerID, Score, Feedback, ReviewDate)
            VALUES (paper_id, senior_reviewer_id, 0.0, 'Expedited review', CURDATE());
        END IF;
    END IF;
END //

DELIMITER ;

CALL AssignExpeditedReview(1);


-- TrackResubmission Trigger
DELIMITER //

CREATE TRIGGER TrackResubmission
BEFORE UPDATE ON Paper
FOR EACH ROW
BEGIN
    IF NEW.title != OLD.title OR NEW.abstract != OLD.abstract OR NEW.keywords != OLD.keywords THEN
        SET NEW.submission_date = CURDATE();
        IF OLD.status IN ('Submitted', 'Under Review') THEN
            SET NEW.status = 'Resubmitted';
        END IF;
    END IF;
END;
//

DELIMITER ;
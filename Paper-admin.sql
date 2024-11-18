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
    Status ENUM('Submitted', 'Under Review', 'Accepted', 'Rejected', 'Resubmitted') DEFAULT 'Submitted',
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
    Expertise VARCHAR(255),
    maxPapers INT CHECK (maxPapers<5)
);

CREATE TABLE Review (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
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

INSERT INTO Reviewer (ReviewerID, Name, Email, Expertise, maxPapers) VALUES
(1, 'Charlie Brown', 'charlie@example.com', 'Senior', 5),
(2, 'Diana Prince', 'diana@example.com', 'Junior', 3),
(3, 'Edward Green', 'edward@example.com', 'Senior', 4),
(4, 'Fiona Blue', 'fiona@example.com', 'Senior', 2),
(5, 'George Red', 'george@example.com', 'Junior', 6);

INSERT INTO Review (ReviewID, PaperID, ReviewerID, Score, Feedback, ReviewDate) VALUES
(1, 1, 1, 4.5, 'Good work on deep learning techniques.', '2023-03-10'),
(2, 2, 2, 9.0, 'Excellent analysis methods.', '2023-03-11'),
(3, 3, 3, 8.8, 'Innovative use of AI in healthcare.', '2023-03-12'),
(4, 4, 4, 9.2, 'Great work on image recognition.', '2023-03-13'),
(5, 5, 5, 8.7, 'Impressive text generation techniques.', '2023-03-14'),
(6, 1, 2, 3.5, 'Excellent work on deep learning techniques.', '2023-03-15'),
(7, 1, 1, 1.8, 'Revised review: Improved work on deep learning techniques.', '2023-03-20'),
(8, 1, 1, 8.0, 'Final review: Excellent work on deep learning techniques.', '2023-03-25'),
(9, 2, 2, 2.3, 'Revised review: Good analysis methods.', '2023-03-21'),
(10, 2, 2, 8.7, 'Final review: Very good analysis methods.', '2023-03-26'),
(11, 1, 1, 6.0, 'Needs improvement.', '2023-03-16'),
(12, 1, 2, 5.5, 'Poor quality.', '2023-03-17'),
(14, 2, 4, 3.5, 'Needs significant improvement.', '2023-03-19'),
(15, 3, 5, 2.0, 'Very poor quality.', '2023-03-20'),
(16, 4, 1, 1.0, 'Unacceptable work.', '2023-03-21'),
(17, 5, 2, 0.5, 'Extremely poor quality.', '2023-03-22'),
(19, 2, 4, 8.5, 'Good work.', '2023-03-24'),
(20, 3, 5, 9.0, 'Very good work.', '2023-03-25');

INSERT INTO Schedule (ScheduleID, PaperID, PresentationDate, TimeSlot, Room) VALUES
(1, 1, '2023-04-01', '10:00:00', 'Room 101'),
(2, 2, '2023-04-02', '11:00:00', 'Room 102'),
(3, 3, '2023-04-03', '12:00:00', 'Room 103'),
(4, 4, '2023-04-04', '13:00:00', 'Room 104'),
(5, 5, '2023-04-05', '14:00:00', 'Room 105');

CREATE USER 'federated_user'@'%' IDENTIFIED BY 'federated_password';
GRANT SELECT ON Paper.Review TO 'federated_user'@'%';
FLUSH PRIVILEGES;


-- WITH RECURSIVE ReviewHistory AS (
--     SELECT 
--         ReviewID,
--         ReviewerID,
--         PaperID,
--         Score,
--         Feedback,
--         ReviewDate
--     FROM 
--         Review
--     WHERE 
--         ReviewerID = 1 AND PaperID = 1
--     UNION ALL
--     SELECT 
--         r.ReviewID,
--         r.ReviewerID,
--         r.PaperID,
--         r.Score,
--         r.Feedback,
--         r.ReviewDate
--     FROM 
--         Review r
--     INNER JOIN 
--         ReviewHistory rh ON r.ReviewerID = rh.ReviewerID AND r.PaperID = rh.PaperID
--     WHERE 
--         r.ReviewDate > rh.ReviewDate
-- )
-- SELECT 
--     ReviewID,
--     ReviewerID,
--     PaperID,
--     Score,
--     Feedback,
--     ReviewDate
-- FROM 
--     ReviewHistory
-- ORDER BY 
--     ReviewDate;


DELIMITER //

CREATE PROCEDURE AssignExpeditedReview(IN paper_id INT)
BEGIN
    DECLARE avg_score FLOAT;
    DECLARE senior_reviewer_id INT;

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
            PaperID = paper_id
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
    SELECT AVG(Score) INTO avg_score
    FROM ReviewHistory;
    IF avg_score < 7.0 THEN
        SELECT ReviewerID INTO senior_reviewer_id
        FROM Reviewer
        WHERE (Expertise = 'Senior')
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
    IF NEW.Title != OLD.Title OR NEW.Keywords != OLD.Keywords THEN
        SET NEW.SubmissionDate = CURDATE();
        IF OLD.status IN ('Submitted', 'Under Review') THEN
            SET NEW.status = 'Resubmitted';
        END IF;
    END IF;
END;
//
DELIMITER ;


-- Aggregate Scores Function 
DELIMITER $$

CREATE FUNCTION CalculateAggregateScore(paper_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE aggregate_score DECIMAL(10, 2);
    SELECT 
        SUM(r.score * CASE WHEN r.Expertise = 'Senior' THEN 2 ELSE 1 END) /
        SUM(CASE WHEN r.Expertise = 'Senior' THEN 2 ELSE 1 END)
    INTO aggregate_score
    FROM Reviews r
    WHERE r.PaperID = paper_id;
    RETURN IFNULL(aggregate_score, 0);
END;
$$
DELIMITER ;
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

-- CREATE TABLE ReviewFederated (
--     ReviewID INT PRIMARY KEY,
--     PaperID INT,
--     ReviewerID INT,
--     Score INT,
--     Feedback TEXT,
--     ReviewDate DATE
-- ) ENGINE=FEDERATED
-- CONNECTION='mysql://federated_user:federated_password@10.20.206.87:3306/Paper/Review';

SELECT * FROM ReviewFederated WHERE ReviewID = 6;
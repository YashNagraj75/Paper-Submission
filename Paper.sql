PROMPT 155_161_197_922 > 
use Paper;

CREATE TABLE Author (
    AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Affiliation VARCHAR(255),
    ProfileCreationDate DATE,
    Age INT,
    Password VARCHAR(255)
);

CREATE TABLE Track (
    TrackID INT PRIMARY KEY AUTO_INCREMENT,
    TrackName VARCHAR(255),
    Description TEXT
);

CREATE TABLE Paper (
    PaperID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Abstract TEXT,
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
    ReviewerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    Email VARCHAR(255),
    ExpertiseArea VARCHAR(255),
    maxPapers INT
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
    ScheduleID INT PRIMARY KEY AUTO_INCREMENT,
    PaperID INT,
    PresentationDate DATE,
    TimeSlot TIME,
    Room VARCHAR(255),
    FOREIGN KEY (PaperID) REFERENCES Paper(PaperID)
);

-- Insert data into Author table
INSERT INTO Author (Name, Email, Affiliation, ProfileCreationDate, Age, Password) VALUES
('Alice Smith', 'alice@example.com', 'University A', '2023-01-01', 35, 'password123'),
('Bob Johnson', 'bob@example.com', 'University B', '2023-02-01', 40, 'password456');

-- Insert data into Track table
INSERT INTO Track (TrackName, Description) VALUES
('Machine Learning', 'Research on machine learning algorithms and applications'),
('Data Science', 'Research on data science techniques and tools');

-- Insert data into Paper table
INSERT INTO Paper (Title, Keywords, SubmissionDate, TrackID) VALUES
('Deep Learning Techniques', 'deep learning, neural networks', '2023-03-01', 1),
('Data Analysis Methods', 'data analysis, statistics', '2023-03-02', 2);

-- Insert data into PaperAuthor table
INSERT INTO PaperAuthor (PaperID, AuthorID) VALUES
(1, 1),
(1, 2),
(2, 1);

-- Insert data into Reviewer table
INSERT INTO Reviewer (Name, Email, ExpertiseArea, maxPapers) VALUES
('Charlie Brown', 'charlie@example.com', 'Machine Learning', 5),
('Diana Prince', 'diana@example.com', 'Data Science', 3);

-- Insert data into Review table
INSERT INTO Review (PaperID, ReviewerID, Score, Feedback, ReviewDate) VALUES
(1, 1, 85, 'Good work on deep learning techniques.', '2023-03-10'),
(2, 2, 90, 'Excellent analysis methods.', '2023-03-11');

-- Insert data into Schedule table
INSERT INTO Schedule (PaperID, PresentationDate, TimeSlot, Room) VALUES
(1, '2023-04-01', '10:00:00', 'Room 101'),
(2, '2023-04-02', '11:00:00', 'Room 102');
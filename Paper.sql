PROMPT 155_161_197_922 > 
CREATE DATABASE Paper;
use Paper;

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
    ExpertiseArea VARCHAR(255)
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
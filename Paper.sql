CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Affiliation VARCHAR(255),
    ProfileCreationDate DATE
);

CREATE TABLE Track (
    TrackID INT PRIMARY KEY,
    TrackName VARCHAR(255)
);

CREATE TABLE Paper (
    PaperID INT PRIMARY KEY,
    Title VARCHAR(255),
    Abstract TEXT,
    Keywords VARCHAR(255),
    SubmissionDate DATE,
    TrackID INT,
    AuthorID INT,
    FOREIGN KEY (TrackID) REFERENCES Track(TrackID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Reviewer (
    ReviewerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    ExpertiseArea VARCHAR(255)
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
    FOREIGN KEY (PaperID) REFERENCES Paper(PaperID)
);

CREATE TABLE Conference (
    Cid INT PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255),
    StartDate DATE,
    EndDate DATE
);
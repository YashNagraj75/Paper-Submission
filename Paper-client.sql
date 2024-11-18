CREATE DATABASE Paper;
USE Paper;

CREATE TABLE ReviewFederated (
    ReviewID INT PRIMARY KEY,
    PaperID INT,
    ReviewerID INT,
    Score INT,
    Feedback TEXT,
    ReviewDate DATE
) ENGINE=FEDERATED
CONNECTION='mysql://federated_user:federated_password@192.168.208.46:3306/Paper/Review';

SELECT * FROM ReviewFederated;
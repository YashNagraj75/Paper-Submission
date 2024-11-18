CREATE TABLE ReviewFederated (
    ReviewID INT PRIMARY KEY,
    PaperID INT,
    ReviewerID INT,
    Score INT,
    Feedback TEXT,
    ReviewDate DATE
) ENGINE=FEDERATED
CONNECTION='mysql://federated_user:federated_password@10.20.206.87:3306/Paper/Review';
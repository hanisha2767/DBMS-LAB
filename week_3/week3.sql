CREATE DATABASE bankDatabase222;
USE bankDatabase222;
 
CREATE TABLE branch (
    branch_name VARCHAR(50),
    branch_city VARCHAR(50),
    assets REAL,
    PRIMARY KEY (branch_name)
);

INSERT INTO branch (branch_name, branch_city, assets) VALUES
('SBI_Chamrajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParlimentRoad', 'Delhi', 10000),
('SBI_Jantarmantar', 'Delhi', 20000);

CREATE TABLE bankAccount (
    accno INT,
    branch_name VARCHAR(50),
    balance REAL,
    PRIMARY KEY (accno),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO bankAccount (accno, branch_name, balance) VALUES
(1,'SBI_Chamrajpet',2000),
(2,'SBI_ResidencyRoad',5000),
(3,'SBI_ShivajiRoad',6000),
(4,'SBI_ParlimentRoad',9000),
(5,'SBI_Jantarmantar',8000),
(6,'SBI_ShivajiRoad',4000),
(8,'SBI_ResidencyRoad',4000),
(9,'SBI_ParlimentRoad',3000),
(10,'SBI_ResidencyRoad',5000),
(11,'SBI_Jantarmantar',2000);

 CREATE TABLE bankCustomer (
    customer_name VARCHAR(50),
    customer_street VARCHAR(50),
    customer_city VARCHAR(50),
    PRIMARY KEY (customer_name)
);
 
 INSERT INTO bankCustomer (customer_name,customer_street,customer_city) VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannergatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithiviraj_Road', 'Delhi');

CREATE TABLE Depositer (
	customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (accno),
    FOREIGN KEY (customer_name) REFERENCES bankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES bankAccount(accno)
);

 INSERT INTO Depositer (customer_name,accno) VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikil', 4),
('Ravi', 5),
('Avinash', 8),
('Nikil', 9),
('Dinesh', 10),
('Nikil', 11);

CREATE TABLE Loan (
    loan_number INT,
	branch_name VARCHAR(50),
    amount REAL,
    PRIMARY KEY (loan_number),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

INSERT INTO Loan (loan_number,branch_name, amount) VALUES
(1,'SBI_Chamrajpet',1000),
(2,'SBI_ResidencyRoad',2000),
(3,'SBI_ShivajiRoad',3000),
(4,'SBI_ParlimentRoad',4000),
(5,'SBI_Jantarmantar', 5000);

SELECT branch_name,assets FROM branch;

ALTER TABLE branch CHANGE assets assets_in_lakhs REAL;

SELECT 
    d.customer_name,
    a.branch_name,
    COUNT(*) AS deposit_count
FROM 
    Depositer d
JOIN 
    bankAccount a ON d.accno = a.accno
GROUP BY 
    d.customer_name, a.branch_name
HAVING 
    COUNT(*) >= 2;
    
CREATE VIEW branch_loan_sums AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;

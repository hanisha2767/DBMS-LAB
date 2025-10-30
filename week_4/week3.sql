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


SELECT customer_name
FROM Depositer d
JOIN bankAccount a ON d.accno = a.accno
WHERE a.branch_name IN (
    SELECT branch_name
    FROM branch
    WHERE branch_city = 'Delhi'
)
GROUP BY customer_name
HAVING COUNT(DISTINCT a.branch_name) = (
    SELECT COUNT(*)
    FROM branch
    WHERE branch_city = 'Delhi'
);

SELECT DISTINCT customer_name
FROM bankCustomer c
WHERE customer_name IN (
    SELECT d.customer_name
    FROM Depositer d
    JOIN bankAccount a ON d.accno = a.accno
    JOIN Loan l ON a.branch_name = l.branch_name
)
AND customer_name NOT IN (
    SELECT d.customer_name FROM Depositer d
);

SELECT DISTINCT c.customer_name
FROM bankCustomer c
WHERE c.customer_name NOT IN (
    SELECT customer_name FROM Depositer
)
AND EXISTS (
    SELECT 1 FROM Loan
);

SELECT DISTINCT d.customer_name
FROM Depositer d
JOIN bankAccount a ON d.accno = a.accno
JOIN Loan l ON a.branch_name = l.branch_name
WHERE a.branch_name IN (
    SELECT branch_name FROM branch WHERE branch_city = 'Bangalore'
);

SELECT branch_name
FROM branch
WHERE assets_in_lakhs > ALL (
    SELECT assets_in_lakhs FROM branch WHERE branch_city = 'Bangalore'
);

DELETE FROM bankAccount
WHERE branch_name IN (
    SELECT branch_name FROM branch WHERE branch_city = 'Bombay'
);
set sql_safe_updates =0;
UPDATE bankAccount
SET balance = balance * 1.05;
set sql_safe_updates =1;
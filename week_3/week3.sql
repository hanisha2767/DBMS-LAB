drop database bank;
CREATE DATABASE IF NOT EXISTS Bank;
USE Bank;

CREATE TABLE Branch(
    branch_name VARCHAR(20),
    branch_city VARCHAR(20),
    assets REAL,
    PRIMARY KEY(branch_name)
);

CREATE TABLE BankAccount(
    accno INT,
    branch_name VARCHAR(20),
    balance REAL,
    PRIMARY KEY(accno),
    FOREIGN KEY(branch_name) REFERENCES Branch(branch_name)
);

CREATE TABLE BankCustomer(
    customer_name VARCHAR(20),
    customer_street VARCHAR(20),
    customer_city VARCHAR(20),
    PRIMARY KEY (customer_name)
);

CREATE TABLE Depositer(
    customer_name VARCHAR(20),
    accno INT,
    PRIMARY KEY(customer_name, accno),
    FOREIGN KEY(accno) REFERENCES BankAccount(accno),
    FOREIGN KEY(customer_name) REFERENCES BankCustomer(customer_name)
);

CREATE TABLE Loan(
    loan_number INT,
    branch_name VARCHAR(20),
    amount REAL,
    PRIMARY KEY(loan_number),
    FOREIGN KEY(branch_name) REFERENCES Branch(branch_name)
);


INSERT INTO Branch VALUES("SBI_Chamrajpet","Bangalore",50000);
INSERT INTO Branch VALUES("SBI_ResidencyRoad","Bangalore",10000);
INSERT INTO Branch VALUES("SBI_ShivajiRoad","Bombay",20000);
INSERT INTO Branch VALUES("SBI_ParlimentRoad","Delhi",10000);
INSERT INTO Branch VALUES("SBI_Jantarmantar","Delhi",20000);


INSERT INTO BankAccount VALUES(1,"SBI_Chamrajpet",2000);
INSERT INTO BankAccount VALUES(2,"SBI_ResidencyRoad",5000);
INSERT INTO BankAccount VALUES(3,"SBI_ShivajiRoad",6000);
INSERT INTO BankAccount VALUES(4,"SBI_ParlimentRoad",9000);
INSERT INTO BankAccount VALUES(5,"SBI_Jantarmantar",8000);
INSERT INTO BankAccount VALUES(6,"SBI_ShivajiRoad",4000);
INSERT INTO BankAccount VALUES(7,"SBI_ResidencyRoad",4000);
INSERT INTO BankAccount VALUES(8,"SBI_ParlimentRoad",3000);
INSERT INTO BankAccount VALUES(9,"SBI_ResidencyRoad",5000);
INSERT INTO BankAccount VALUES(10,"SBI_Jantarmantar",2000);


INSERT INTO BankCustomer VALUES("Avinash","Bull_Temple_Road","Bangalore");
INSERT INTO BankCustomer VALUES("Dinesh","Bannergatta_Road","Bangalore");
INSERT INTO BankCustomer VALUES("Mohan","NationalCollege_Road","Bangalore");
INSERT INTO BankCustomer VALUES("Nikil","Akbar_Road","Delhi");
INSERT INTO BankCustomer VALUES("Ravi","Prithviraj_Road","Delhi");


INSERT INTO Depositer VALUES("Avinash", 1);
INSERT INTO Depositer VALUES("Dinesh", 2);
INSERT INTO Depositer VALUES("Nikil", 4);
INSERT INTO Depositer VALUES("Ravi", 5);
INSERT INTO Depositer VALUES("Avinash", 7);
INSERT INTO Depositer VALUES("Nikil", 8);
INSERT INTO Depositer VALUES("Dinesh", 9);
INSERT INTO Depositer VALUES("Nikil", 10);



INSERT INTO Loan VALUES(1,"SBI_Chamrajpet",1000);
INSERT INTO Loan VALUES(2,"SBI_ResidencyRoad",2000);
INSERT INTO Loan VALUES(3,"SBI_ShivajiRoad",3000);
INSERT INTO Loan VALUES(4,"SBI_ParlimentRoad",3000);
INSERT INTO Loan VALUES(5,"SBI_Jantarmantar",3000);

select branch_name,(assets/100000) as 'assets in lakhs' from branch;
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

UPDATE bankAccount
SET balance = balance * 1.05;


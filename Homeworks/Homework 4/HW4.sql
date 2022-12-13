-- DROP TABLE Works;
-- DROP TABLE Dept;
-- DROP TABLE Emp;


CREATE TABLE Emp(
    eid INTEGER,
    ename CHAR,
    age INTEGER,
    salary INTEGER,
    PRIMARY KEY (eid)
);


CREATE TABLE Dept(
    did INTEGER,
    budget INTEGER,
    managerid INTEGER,
    dname CHAR,
    PRIMARY KEY (did),
    FOREIGN KEY (managerid) REFERENCES Emp(eid)
);

CREATE TABLE Works(
    eid INTEGER,
    did INTEGER,
    FOREIGN KEY (did) REFERENCES Dept(did),
    FOREIGN KEY (eid) REFERENCES Emp(eid),
    PRIMARY KEY (eid, did)
);

INSERT INTO Emp (eid, ename, age, salary)
VALUES (1, 'John', 30, 100000),
         (2, 'Mary', 35, 110000),
         (3, 'Bob', 40, 120000),
         (4, 'Alice', 45, 130000),
         (5, 'Joe', 50, 140000),
         (6, 'Sue', 55, 150000),
         (7, 'Tom', 60, 160000),
         (8, 'Jane', 65, 170000),
         (9, 'Bill', 20, 180000),
         (10, 'Kate', 75, 190000);

INSERT INTO Dept (did, budget, managerid, dname)
VALUES (1, 1000000, 1, 'Sales'),
         (2, 2000000, 2, 'Marketing'),
         (3, 3000000, 3, 'Hardware'),
         (4, 6000000, 4, 'Software'),
         (5, 5000000, 1, 'Finance');

INSERT INTO Works (eid, did)
VALUES (1, 1),
       (1, 5),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       (6, 1),
       (7, 2),
       (8, 3),
       (9, 4),
       (10, 5),
       (10, 4),
       (10, 3);



-- Find the name of the employees who are older than 40 and 
-- are working in Software department 

SELECT E.ename
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
WHERE E.age > 40
AND D.dname = 'Software';


-- Find the name of the employee(s) in Hardware department 
-- that has the highest salary

SELECT E.ename
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
GROUP BY E.ename
HAVING D.dname = 'Hardware'
AND E.salary = MAX(E.salary);


-- Find the salary of the oldest employee in Hardware department
SELECT E.salary
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
WHERE D.dname = 'Hardware'
AND E.age = MAX(E.age);


-- Find the name of all employees who work in both
-- Hardware and Software departments
SELECT E.ename
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D1 NATURAL JOIN Dept D2
WHERE D1.dname = 'Hardware' AND D2.dname = 'Software';  


-- Find the name of the employees who work in more than 3 departments
SELECT E.ename
FROM Emp E NATURAL JOIN Works W
GROUP BY E.ename
HAVING COUNT(DISTINCT W.did) > 3;


-- Find the name of the employees (mangers) who manages 
-- more than one department
SELECT E.ename
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
GROUP BY E.ename
HAVING COUNT(DISTINCT D.did) > 1;

-- Find the ID of managers who control the largest 
-- total amounts of budget

SELECT E.eid
FROM Emp E NATURAL JOIN Works NATURAL JOIN Dept D
GROUP BY E.eid
HAVING D.budget = MAX(SUM(D.budget));

-- Find the ID of the managers who manages at least
-- one department of budget over 1 million dollars

SELECT E.eid
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
GROUP BY E.eid
HAVING SUM(D.budget) > 1000000;

-- Find the ID of the managers who only manages department(s)
-- of budget over 1 million dollars

SELECT E.eid
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
GROUP BY E.eid
HAVING SUM(D.budget) > 1000000
AND COUNT(DISTINCT D.did) = COUNT(DISTINCT W.did);

-- For each department, return the average salary of all its employees
SELECT AVG(E.salary), D.dname -- or D.did
FROM Emp E NATURAL JOIN Works W NATURAL JOIN Dept D
GROUP BY D.did;



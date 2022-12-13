CREATE TABLE Student(
    snum INTEGER,
    sname CHAR(20),
    major CHAR(20),
    level CHAR(20),
    age INTEGER,
    PRIMARY KEY (snum)
);

CREATE TABLE Class(
    cnum INTEGER,
    cname CHAR(20),
    meets_date DATE,
    room CHAR(20),
    fid INTEGER,
    PRIMARY KEY (cnum),
    FOREIGN KEY (fid) REFERENCES Faculty(fid)
);

CREATE TABLE Enrolled(
    snum INTEGER,
    cnum INTEGER,
    FOREIGN KEY (snum) REFERENCES Student,
    FOREIGN KEY (cnum) REFERENCES Class,
    PRIMARY KEY (snum, cnum)
);

CREATE TABLE Faculty(
    fid INTEGER,
    fname CHAR(20),
    deptid INTEGER,
    PRIMARY KEY (fid)
);


-- Find the age of the oldest student who is
--  enrolled in a course taught by faculty member Adam Smith.
SELECT MAX(S.age)
FROM Student S NATURAL JOIN Enrolled E NATURAL JOIN Class C NATURAL JOIN Faculty F
WHERE F.fname = 'Adam Smith';

-- Find the same thing but use nested queries
SELECT MAX(age)
FROM Student
WHERE snum IN (
    SELECT snum
    FROM Enrolled
    WHERE cnum IN (
        SELECT cnum
        FROM Class
        WHERE fid IN (
            SELECT fid
            FROM Faculty
            WHERE fname = 'Adam Smith'
)));


-- Find the name of all classes that either meet in room GS122 or
-- have 40 or more students enrolled

SELECT cname
FROM Class
WHERE room = 'GS122'
UNION
SELECT C.cname
FROM Class C NATURAL JOIN Enrolled E
GROUP BY C.cnum, C.cname
HAVING COUNT(E.snum) >= 40;


-- Find the same thing but use nested queries
SELECT cname
FROM Class 
WHERE room = 'GS122'
OR cnum IN (
    SELECT cnum
    FROM Enrolled
    GROUP BY cnum
    HAVING COUNT(*) >= 40
    );

-- Find the name of the students that are not enrolled in any class
SELECT sname
FROM Student
WHERE snum NOT IN (
    SELECT snum
    FROM Enrolled
    );

-- Find the name of the students who have the largest number of enrolled classes
SELECT S.sname
FROM Student S NATURAL JOIN Enrolled E
GROUP BY S.sname
HAVING COUNT(E.cnum) = MAX(COUNT(E.cnum));


-- Find the same thing but use nested queries
SELECT sname
FROM Student
WHERE snum IN (
    SELECT snum
    FROM Enrolled
    GROUP BY snum
    HAVING COUNT(*) = (
        SELECT MAX(count)
        FROM (
            SELECT COUNT(*) AS count
            FROM Enrolled
            GROUP BY snum
        )
    )
);

-- Find the name of the students who have the largest number of enrolled classes using EXCEPT
CREATE TABLE temp(
    SELECT snum, sname
    FROM Student
    EXCEPT
    SELECT snum, sname
    FROM Student NATURAL JOIN Enrolled
);
SELECT sname
FROM temp



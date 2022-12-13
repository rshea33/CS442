-- FIND THE NAME OF THE DRIVERS WHO GOT THE LICENSE FROM NYC BRANCH

SELECT *
FROM driver NATURAL JOIN license NATURAL JOIN branch
WHERE branch_name = 'NYC';

    
    
-- FIND THE NAME OF THE DRIVERS WHOS DRIVER LICENSE EXPIRES BY 2022-12-31
SELECT *
FROM driver NATURAL JOIN license
where license_expiry < '2022-12-31';


-- Find the name of the drivers who took at least 2 exams for the same driver license type
-- at the same branch

SELECT *
FROM driver NATURAL JOIN exam
;

SELECT driver_name, exam_type
FROM driver NATURAL JOIN exam
GROUP BY driver_ssn, branch_id, exam_type
HAVING COUNT(*) >= 2 and avg(exam_score) < 65;

SELECT * 
FROM driver natural join exam
group by driver_ssn
having count(*) > 2 and avg(exam_score) < 65;

-- Find the name of the drivers who took more than two exams with average score lower
-- than 65. All the exams that the driver took cannot be of the same type.  
    

SELECT driver_name, COUNT(*), AVG(exam_score)
FROM driver NATURAL JOIN exam
GROUP BY driver_ssn
HAVING COUNT(*) > 2 AND AVG(exam_score) < 65
AND driver_ssn IN (SELECT e1.driver_ssn
				   FROM exam e1 INNER JOIN exam e2 ON e1.driver_ssn = e2.driver_ssn
				   WHERE e1.exam_type <> e2.exam_type
                   GROUP BY e1.driver_ssn
                   HAVING count(*) > 2);

    
select * from exam;
-- Check if exam type per person came before 


-- The database administrator made some mistakes when he entered the data. These mistakes
-- allow some drivers to take the Driver test (type=“D”) before they passed the learner test 
-- (type=”L”) . Find the name of these by-mistake drivers, assuming the passing score of learner 
-- tests is 70.
    
SELECT *
FROM driver NATURAL JOIN exam;

-- Get the date 
SELECT driver_ssn, driver_name, exam_date, exam_type, exam_score
FROM driver NATURAL JOIN exam;



SELECT driver_name
FROM exam NATURAL JOIN driver
WHERE exam_type = 'D'
AND driver_ssn NOT IN (SELECT driver_ssn
						FROM exam
						WHERE exam_type = 'L'
						AND exam_score >= 70);
UNION;
SELECT *
FROM exam e NATURAL JOIN driver
WHERE e.exam_type = 'D'
AND driver_ssn not in (SELECT driver_ssn
				   FROM exam e1
				   WHERE e1.exam_type = 'L'
				   AND e1.exam_score >= 70
                   and e.exam_date > e1.exam_date);





SELECT driver_ssn, exam_date
FROM exam e2
WHERE exam_type = 'D' and
EXISTS
(SELECT e.driver_ssn, e.exam_date
FROM exam e
WHERE e.exam_type = 'L'
AND e.exam_score >= 70
AND e2.driver_ssn = e.driver_ssn
AND e2.exam_date < e.exam_date); -- Valid tests, dates







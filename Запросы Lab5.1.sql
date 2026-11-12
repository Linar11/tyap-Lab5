SELECT 
    robot_id AS "Уникальный ID", 
    full_name AS "ФИО", 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, start_date)) AS "Стаж (лет)"
FROM robots_employees;


SELECT 
    robot_id AS "Уникальный ID", 
    full_name AS "ФИО", 
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, start_date)) AS "Стаж (лет)"
FROM robots_employees
LIMIT 3;


SELECT 
    robot_id, model, serial_number, commissioning_date, status, power_type, max_load, max_speed, battery_level
FROM robots_employees;


SELECT robot_id AS "ID Сотрудника" 
FROM quarterly_evaluations
WHERE q1 IN ('D', 'E') OR q2 IN ('D', 'E') OR q3 IN ('D', 'E') OR q4 IN ('D', 'E');


SELECT ROUND(AVG(salary), 2) AS "Средняя зарплата" 
FROM robots_employees;


SELECT department_name AS "Самый маленький отдел" 
FROM departments
ORDER BY expert_count ASC
LIMIT 1;


SELECT robot_id, full_name, start_date 
FROM robots_employees
ORDER BY start_date DESC;

ALTER TABLE robots_employees ADD COLUMN bonus_coefficient NUMERIC(5,2) DEFAULT 1.0;


UPDATE robots_employees re
SET bonus_coefficient = 1.0 + 
    CASE e.q1 WHEN 'A' THEN 0.2 WHEN 'B' THEN 0.1 WHEN 'D' THEN -0.1 WHEN 'E' THEN -0.2 ELSE 0 END +
    CASE e.q2 WHEN 'A' THEN 0.2 WHEN 'B' THEN 0.1 WHEN 'D' THEN -0.1 WHEN 'E' THEN -0.2 ELSE 0 END +
    CASE e.q3 WHEN 'A' THEN 0.2 WHEN 'B' THEN 0.1 WHEN 'D' THEN -0.1 WHEN 'E' THEN -0.2 ELSE 0 END +
    CASE e.q4 WHEN 'A' THEN 0.2 WHEN 'B' THEN 0.1 WHEN 'D' THEN -0.1 WHEN 'E' THEN -0.2 ELSE 0 END
FROM quarterly_evaluations e
WHERE re.robot_id = e.robot_id;


SELECT robot_id, full_name, bonus_coefficient FROM robots_employees;
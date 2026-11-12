SELECT full_name AS "ФИО", salary AS "Зарплата"
FROM robots_employees
ORDER BY salary DESC
LIMIT 1;


SELECT full_name AS "ФИО"
FROM robots_employees
ORDER BY full_name DESC;


SELECT 
    level AS "Уровень",
    MAX(EXTRACT(YEAR FROM AGE(CURRENT_DATE, start_date))) AS "Максимальный стаж (лет)"
FROM robots_employees
GROUP BY level;


SELECT 
    re.full_name AS "ФИО сотрудника", 
    d.department_name AS "Название отдела"
FROM robots_employees re
JOIN departments d ON re.department_id = d.department_id;


SELECT 
    d.department_name AS "Название отдела", 
    SUM(re.salary * (re.bonus_coefficient - 1)) AS "Общая премия (руб.)"
FROM robots_employees re
JOIN departments d ON re.department_id = d.department_id
GROUP BY d.department_name
ORDER BY "Общая премия (руб.)" DESC
LIMIT 1;


-- 1. Добавляем столбец для новой зарплаты
ALTER TABLE robots_employees ADD COLUMN indexed_salary NUMERIC(10,2);

-- 2. Рассчитываем новую зарплату на основе коэффициента премии
UPDATE robots_employees
SET indexed_salary = CASE 
    WHEN bonus_coefficient > 1.2 THEN salary * 1.20
    WHEN bonus_coefficient >= 1.0 AND bonus_coefficient <= 1.2 THEN salary * 1.10
    ELSE salary
END;

-- 3. Проверяем результат
SELECT full_name, salary, bonus_coefficient, indexed_salary FROM robots_employees;


WITH EmployeeGrades AS (
    -- Считаем количество оценок каждого типа для каждого сотрудника
    SELECT 
        robot_id,
        (CASE WHEN q1 = 'A' THEN 1 ELSE 0 END + CASE WHEN q2 = 'A' THEN 1 ELSE 0 END + CASE WHEN q3 = 'A' THEN 1 ELSE 0 END + CASE WHEN q4 = 'A' THEN 1 ELSE 0 END) AS count_a,
        (CASE WHEN q1 = 'B' THEN 1 ELSE 0 END + CASE WHEN q2 = 'B' THEN 1 ELSE 0 END + CASE WHEN q3 = 'B' THEN 1 ELSE 0 END + CASE WHEN q4 = 'B' THEN 1 ELSE 0 END) AS count_b,
        (CASE WHEN q1 = 'C' THEN 1 ELSE 0 END + CASE WHEN q2 = 'C' THEN 1 ELSE 0 END + CASE WHEN q3 = 'C' THEN 1 ELSE 0 END + CASE WHEN q4 = 'C' THEN 1 ELSE 0 END) AS count_c,
        (CASE WHEN q1 = 'D' THEN 1 ELSE 0 END + CASE WHEN q2 = 'D' THEN 1 ELSE 0 END + CASE WHEN q3 = 'D' THEN 1 ELSE 0 END + CASE WHEN q4 = 'D' THEN 1 ELSE 0 END) AS count_d,
        (CASE WHEN q1 = 'E' THEN 1 ELSE 0 END + CASE WHEN q2 = 'E' THEN 1 ELSE 0 END + CASE WHEN q3 = 'E' THEN 1 ELSE 0 END + CASE WHEN q4 = 'E' THEN 1 ELSE 0 END) AS count_e
    FROM quarterly_evaluations
)
SELECT 
    d.department_name AS "i. Название отдела",
    d.manager_name AS "ii. Руководитель",
    COUNT(re.robot_id) AS "iii. Кол-во сотрудников",
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, re.start_date))), 1) AS "iv. Ср. стаж (лет)",
    ROUND(AVG(re.salary), 2) AS "v. Ср. зарплата",
    COUNT(CASE WHEN re.level = 'jun' THEN 1 END) AS "vi. Jun",
    COUNT(CASE WHEN re.level = 'middle' THEN 1 END) AS "vii. Middle",
    COUNT(CASE WHEN re.level = 'senior' THEN 1 END) AS "viii. Senior",
    COUNT(CASE WHEN re.level = 'lead' THEN 1 END) AS "ix. Lead",
    
    SUM(re.salary) AS "x. ФОТ до индексации",
    SUM(re.indexed_salary) AS "xi. ФОТ после индексации",
    
    SUM(eg.count_a) AS "xii. Оценок A",
    SUM(eg.count_b) AS "xiii. Оценок B",
    SUM(eg.count_c) AS "xiv. Оценок C",
    SUM(eg.count_d) AS "xv. Оценок D",
    SUM(eg.count_e) AS "xvi. Оценок E",
    
    ROUND(AVG(re.bonus_coefficient), 2) AS "xvii. Ср. коэфф. премии",
    SUM(re.salary * (re.bonus_coefficient - 1)) AS "xviii. Общая премия (руб.)",
    
    -- Сумма с премией до индексации (ЗП + Премия)
    SUM(re.salary + (re.salary * (re.bonus_coefficient - 1))) AS "xix. ЗП+Премия ДО индексации",
    
    -- Сумма с премией после индексации (Проиндексированная ЗП + Премия)
    SUM(re.indexed_salary + (re.salary * (re.bonus_coefficient - 1))) AS "xx. ЗП+Премия ПОСЛЕ индексации",
    
    -- Разница в % между (xx) и (xix) 
    ROUND(
        ((SUM(re.indexed_salary + (re.salary * (re.bonus_coefficient - 1))) - SUM(re.salary + (re.salary * (re.bonus_coefficient - 1)))) 
        / SUM(re.salary + (re.salary * (re.bonus_coefficient - 1)))) * 100
    , 2) AS "xxi. Разница в %"

FROM departments d
LEFT JOIN robots_employees re ON d.department_id = re.department_id
LEFT JOIN EmployeeGrades eg ON re.robot_id = eg.robot_id
GROUP BY d.department_id, d.department_name, d.manager_name
ORDER BY d.department_id;

-- ==============================================================================
-- 1. СОЗДАНИЕ ТАБЛИЦ
-- ==============================================================================

-- Таблица отделов
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    expert_count INTEGER DEFAULT 0
);

-- Основная таблица (Роботы и Сотрудники)
CREATE TABLE robots_employees (
    robot_id SERIAL PRIMARY KEY,
    -- Характеристики робота
    model VARCHAR(50) NOT NULL,
    serial_number VARCHAR(50) UNIQUE NOT NULL,
    commissioning_date DATE NOT NULL,
    status BOOLEAN NOT NULL DEFAULT TRUE,
    power_type VARCHAR(30),
    max_load NUMERIC(10, 2),
    max_speed NUMERIC(10, 2),
    battery_level NUMERIC(5, 2),
    -- Данные сотрудника
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE,
    start_date DATE NOT NULL,
    position VARCHAR(50),
    level VARCHAR(10) CHECK (level IN ('jun', 'middle', 'senior', 'lead')),
    salary NUMERIC(10, 2),
    department_id INTEGER REFERENCES departments(department_id),
    has_license BOOLEAN DEFAULT FALSE
);

-- Таблица оценок за кварталы
CREATE TABLE quarterly_evaluations (
    evaluation_id SERIAL PRIMARY KEY,
    robot_id INTEGER REFERENCES robots_employees(robot_id) ON DELETE CASCADE,
    q1 CHAR(1) CHECK (q1 IN ('A', 'B', 'C', 'D', 'E')),
    q2 CHAR(1) CHECK (q2 IN ('A', 'B', 'C', 'D', 'E')),
    q3 CHAR(1) CHECK (q3 IN ('A', 'B', 'C', 'D', 'E')),
    q4 CHAR(1) CHECK (q4 IN ('A', 'B', 'C', 'D', 'E'))
);


-- ==============================================================================
-- 2. НАПОЛНЕНИЕ ДАННЫМИ (INSERT)
-- ==============================================================================

-- Добавляем начальные отделы
INSERT INTO departments (department_name, manager_name, expert_count) VALUES 
('IT отдел', 'Иванов И.И.', 2),
('МЧС', 'Петров П.П.', 1);

-- Добавляем 5 роботов/сотрудников в эти отделы
INSERT INTO robots_employees 
(model, serial_number, commissioning_date, status, power_type, max_load, max_speed, battery_level, full_name, birth_date, start_date, position, level, salary, department_id, has_license) 
VALUES
('R2-D2', 'SN-001', '2021-01-15', TRUE, 'Электричество', 50.0, 10.5, 85.0, 'Сидоров Алексей', '1990-05-12', '2021-01-15', 'Инженер', 'senior', 120000.00, 1, TRUE),
('C-3PO', 'SN-002', '2022-03-10', TRUE, 'Гибрид', 30.0, 5.0, 90.0, 'Кузнецов Дмитрий', '1985-11-20', '2022-03-10', 'Аналитик', 'middle', 90000.00, 1, TRUE),
('Wall-E', 'SN-003', '2020-06-01', FALSE, 'Солнечная', 100.0, 2.0, 15.0, 'Смирнов Олег', '1995-02-28', '2020-06-01', 'Уборщик', 'jun', 50000.00, 1, FALSE),
('Terminator', 'SN-004', '2019-12-12', TRUE, 'Ядерная', 200.0, 25.0, 100.0, 'Волков Андрей', '1980-08-08', '2019-12-12', 'Спасатель', 'lead', 150000.00, 2, TRUE),
('T-1000', 'SN-005', '2023-05-20', TRUE, 'Электричество', 80.0, 15.0, 60.0, 'Морозов Сергей', '1992-03-15', '2023-05-20', 'Спасатель', 'middle', 85000.00, 2, TRUE);

-- Добавляем оценки для этих 5 сотрудников
INSERT INTO quarterly_evaluations (robot_id, q1, q2, q3, q4) VALUES
(1, 'A', 'B', 'C', 'D'), -- Сидоров
(2, 'B', 'B', 'B', 'B'), -- Кузнецов
(3, 'E', 'D', 'C', 'B'), -- Смирнов
(4, 'A', 'A', 'A', 'A'), -- Волков
(5, 'C', 'C', 'D', 'E'); -- Морозов


-- Добавляем новый отдел "Интеллектуальный анализ данных" (Пункт 5 задания)
INSERT INTO departments (department_name, manager_name, expert_count) VALUES 
('Интеллектуальный анализ данных', 'Никитин Н.Н.', 2);

-- Добавляем руководителя и двух сотрудников в новый отдел
INSERT INTO robots_employees 
(model, serial_number, commissioning_date, status, power_type, max_load, max_speed, battery_level, full_name, birth_date, start_date, position, level, salary, department_id, has_license) 
VALUES
('DataBot-1', 'SN-006', '2024-01-10', TRUE, 'Электричество', 10.0, 5.0, 100.0, 'Никитин Никита', '1985-01-01', '2024-01-10', 'Руководитель отдела', 'lead', 180000.00, 3, TRUE),
('DataBot-2', 'SN-007', '2024-02-01', TRUE, 'Электричество', 5.0, 8.0, 100.0, 'Орлов Павел', '1998-07-22', '2024-02-01', 'Data Scientist', 'jun', 70000.00, 3, FALSE),
('DataBot-3', 'SN-008', '2024-02-15', TRUE, 'Гибрид', 8.0, 7.0, 95.0, 'Зайцева Анна', '1994-12-05', '2024-02-15', 'Data Engineer', 'middle', 110000.00, 3, TRUE);

-- Добавляем оценки для новых сотрудников
INSERT INTO quarterly_evaluations (robot_id, q1, q2, q3, q4) VALUES
(6, 'A', 'A', 'A', 'A'),
(7, 'B', 'C', 'B', 'A'),
(8, 'C', 'C', 'C', 'C');
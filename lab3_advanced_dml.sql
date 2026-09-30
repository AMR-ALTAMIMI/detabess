CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INT,
    manager_id INT
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE,
    budget INT
);

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (1, 'John', 'Doe', 'IT');

INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Alice', 'Smith', 'HR', DEFAULT, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id)
VALUES
    ('IT', 100000, 1),
    ('HR', 50000, 2),
    ('Sales', 75000, 3);

INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES ('Bob', 'Johnson', 'Finance', 50000 * 1.1, CURRENT_DATE);

CREATE TABLE temp_employees AS SELECT * FROM employees WHERE 1=0;

INSERT INTO temp_employees
SELECT * FROM employees
WHERE department = 'IT';

UPDATE employees
SET salary = salary * 1.10;

UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees
SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE departments d
SET budget = (
    SELECT AVG(salary) * 1.20
    FROM employees e
    WHERE e.department = d.dept_name
)
WHERE EXISTS (
    SELECT 1 FROM employees e WHERE e.department = d.dept_name
);

UPDATE employees
SET salary = salary * 1.15, status = 'Promoted'
WHERE department = 'Sales';

DELETE FROM employees
WHERE status = 'Terminated';

DELETE FROM employees
WHERE salary < 40000 AND hire_date > '2023-01-01' AND department IS NULL;

DELETE FROM departments
WHERE dept_id NOT IN (
    SELECT DISTINCT dept_id
    FROM projects
    WHERE dept_id IS NOT NULL
);

DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, salary, department)
VALUES ('Charlie', 'Brown', NULL, NULL);

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('David', 'Miller', 'IT', 65000)
RETURNING emp_id, (first_name || ' ' || last_name) AS full_name;

UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING emp_id, (salary - 5000) AS old_salary, salary AS new_salary;

DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

INSERT INTO employees (first_name, last_name, department, salary)
SELECT 'Eva', 'Green', 'Marketing', 55000
WHERE NOT EXISTS (
    SELECT 1 FROM employees WHERE first_name = 'Eva' AND last_name = 'Green'
);

UPDATE employees e
SET salary = CASE
    WHEN (SELECT budget FROM departments d WHERE d.dept_name = e.department) > 100000
        THEN salary * 1.10
    ELSE salary * 1.05
END
WHERE department IS NOT NULL;

INSERT INTO employees (first_name, last_name, department, salary) VALUES
('Emp1', 'Test', 'IT', 40000),
('Emp2', 'Test', 'IT', 42000),
('Emp3', 'Test', 'HR', 38000),
('Emp4', 'Test', 'Sales', 45000),
('Emp5', 'Test', 'Finance', 48000);

UPDATE employees
SET salary = salary * 1.10
WHERE first_name LIKE 'Emp%';

CREATE TABLE employee_archive AS SELECT * FROM employees WHERE 1=0;

WITH moved_rows AS (
    DELETE FROM employees
    WHERE status = 'Inactive'
    RETURNING *
)
INSERT INTO employee_archive
SELECT * FROM moved_rows;

UPDATE projects
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT d.dept_id
      FROM departments d
      JOIN employees e ON d.dept_name = e.department
      GROUP BY d.dept_id
      HAVING COUNT(e.emp_id) > 3
  );
+SELECT * FROM departments;
SELECT * FROM projects;
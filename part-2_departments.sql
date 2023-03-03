-- Delete the departments table and any dependees. 
DROP TABLE IF EXISTS departments CASCADE;

-- Counts the number of departments and the length of the longest
-- department name.
--
-- As part of normalisation I want to create a department dictionary
-- table as a reference for valid departments. A little utility
-- query does the job.
--
-- Results:
-- + number_of_departments = 12
-- + max_name_length = 19
SELECT
	COUNT(DISTINCT(department)) AS number_of_departments,
	MAX(LENGTH(department)) AS max_department_name_length
FROM employees;

-- Counts the number of sub departments and the length of the longest
-- sub department name.
--
-- Results:
-- + number_of_departments = 32
-- + max_name_length = 21
SELECT
	COUNT(DISTINCT(sub_department)) AS number_of_sub_departments,
	MAX(LENGTH(sub_department)) AS max_sub_department_name_length
FROM employees;

-- Selects all departments and sub departments. 
SELECT
	department,
	sub_department
FROM employees
GROUP BY sub_department, department
ORDER BY department;

-- Create a department dictionary table.
--
-- This table holds a list of unique departments and sub departments to
-- which each employee will belong to exactly one.
--
-- The SERIAL data type is used as the primary key so that ID's are
-- auto-generated.
--
-- The longest name is 21 characters so I'll give a max of 30 characters
-- for both fields; I can always extend it in future.
--
-- You'll notice a bunch of contraints applied here. After I ensured
-- there were no null or empty department values in the employees table
-- I moved to constrain the field. We want to make sure future additions
-- to this table always provide a unique name for the department.
--
-- There also appears to be another business constraint. There are mutliple
-- sub departments with the same name but with different parent departments.
-- I'll create a UNIQUE constraint to ensure that duplicate combinations of
-- the two columns can not be added.
CREATE TABLE departments (
	id SERIAL PRIMARY KEY,
	department     VARCHAR(30) NOT NULL CHECK (department <> ''),
	sub_department VARCHAR(30) NOT NULL CHECK (sub_department <> ''),
	UNIQUE(department, sub_department)
);

-- Insert all departments and sub departments from the employees table into
-- the new deaprtments table.
INSERT INTO departments (
	department,
	sub_department
)
SELECT
	department,
	sub_department    
FROM employees
GROUP BY department, sub_department;

-- Select all records from departments.
--
-- A quick check to make sure it all went in fine. There are 32 rows
-- which is the same we got when querying distinct values in the
-- employees table. Nice.
SELECT *
FROM departments
ORDER BY department;

-- Adds a department id column to the employees table.
--
-- I'd prefer to add constraints here but we cannot while there is
-- no data so we'll add after.
ALTER TABLE employees
ADD fk_department_id INT;

-- Set the new column as a foreign key to the id column in the
-- departments table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_department_id
FOREIGN KEY (fk_department_id)
REFERENCES departments(id);

-- Update the new column values with the employees department id.
UPDATE employees e
SET fk_department_id = d.id
FROM departments d 
WHERE e.sub_department = d.sub_department;

-- Add a not null constraint to the new foreign key field in the
-- employees table.
--
-- Some businesses my have staff that are not part of any
-- particular department. We could just allow nulls but null
-- has no semantics. This can cause confusion for those who no
-- nothing of the database's specific idiosyncrasies.
--
-- Instead, I recommend adding an entry into department with the name
-- 'No_department' or something similar. While it still may need
-- special treatment, e.g. filtering for reports, at least it's not
-- ambiguous in what it means.
-- 
-- This also ensures that queries on the employees table that try
-- to do something with the fk_department_id column don't fail due to
-- not null. Of course, allowing such failures has some benefits. 
ALTER TABLE employees
ALTER COLUMN fk_department_id SET NOT NULL;

-- Select the department information from both the employee and
-- new department tables.
--
-- This is so we can visually confirm the new realtionship.
SELECT
	e.fk_department_id,
	d.department,
	d.sub_department
FROM employees AS e
JOIN departments AS d
	ON e.fk_department_id = d.id
ORDER BY e.employee_id;

-- Drop the department and sub department columns from the employees
-- table.
--
-- The department column is now redundant. Keeping it could confuse
-- future database users.
ALTER TABLE employees
DROP COLUMN department,
DROP COLUMN sub_department;

-- Select all employees with their department and sub department names.
--
-- Inspecting my handiwork.
SELECT
	e.employee_id,
	e.job_level,
	e.employment_status,
	d.department,
	d.sub_department
FROM employees AS e
INNER JOIN departments AS d
	ON e.fk_department_id = d.id
ORDER BY e.employee_id;

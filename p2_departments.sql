
-------------------------
------ departments ------
-------------------------

-- Removes the departments table and any dependent artifacts. 
DROP TABLE IF EXISTS departments CASCADE;

-- Counts the number of departments and the length of the longest
-- department name.
--
-- As part of normalisation I want to create a department dictionary
-- table as a reference for valid departments. A little utility
-- query checks that we do in fact have a small enumeration and helps us figure
-- out how big the name text column should be.
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
--
-- It appears that all employees exist within a sub-department which has a
-- parent department. We can enforce this with NOT NULL constraints when the
-- time comes.
SELECT
	department,
	sub_department
FROM employees
GROUP BY sub_department, department
ORDER BY department;

-- Create a department dictionary table.
--
-- This table holds a list of unique departments and sub-departments to
-- which each employee will belong to exactly one.
--
-- The SERIAL data type is used as the primary key so that ID's are
-- auto-generated. I could have constructed a character based key from the
-- department and sub-department as this would allow quries on the employee
-- table knowledge of the employee's department info without joining this new
-- dictionary corner. I decided not too as I wanted to maintain a certain
-- consistencies of use across dictionaries.
--
-- The longest name is 21 characters so I'll give a max of 30 characters
-- for both fields; I can always extend it in future.
--
-- You'll notice a bunch of contraints applied here. After I ensured
-- there were no null or empty values in the employees table I moved to
-- constrain the fields. We want to make sure future additions to this table
-- always provide a unique combination of department and sub-department. This
-- is because there are several sub-departments with the same name but
-- different parent departments.
CREATE TABLE departments (
	id SERIAL PRIMARY KEY,
	department     VARCHAR(30) NOT NULL CHECK (department <> ''),
	sub_department VARCHAR(30) NOT NULL CHECK (sub_department <> ''),
	UNIQUE(department, sub_department)
);

-- Inserts all department and sub-department combinations from the employees
-- table into the new departments table.
--
-- Nothing special here. Just an insert that uses the select query written
-- further up in this document.
INSERT INTO departments (
	department,
	sub_department
)
SELECT
	department,
	sub_department    
FROM employees
GROUP BY department, sub_department
ORDER BY department;

-- Selects all records from departments.
--
-- A quick check to make sure it all went in fine. There are 32 rows which is
-- the same we got when querying distinct values in the employees table. Nice.
SELECT *
FROM departments;

-----------------------
------ employees ------
-----------------------

-- Adds a department id column to the employees table.
--
-- I'd prefer to add constraints here but we can't while the column contains
-- nulls. We'll alter the table after population to enforce aa NOT NULL rule.
ALTER TABLE employees
ADD fk_department_id INT;

-- Relates the employees table to the departments table via the new foreign
-- key column.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_department_id
FOREIGN KEY (fk_department_id)
REFERENCES departments(id);

-- Updates the new foreign key column using the values form the old department
-- and sub-department columns to look up its ID in the new departments table.
UPDATE employees e
SET fk_department_id = d.id
FROM departments d 
WHERE e.sub_department = d.sub_department;

-- Adds a not null constraint to the new foreign key field in the employees
-- table.
--
-- Some businesses my have staff that are not part of any particular
-- department. We could just allow nulls but null has no semantics. This can
-- cause confusion for those who no nothing of the database's specific
-- idiosyncrasies.
--
-- Instead, I recommend adding an entry into the departments table with the
-- name 'No_department' or something similar. While it still may need special
-- treatment, e.g. filtering for reports, at least it's not ambiguous in what
-- it means.
-- 
-- This also ensures that queries on the employees table that try to do
-- something with the fk_department_id column don't fail due to not null.
-- Of course, allowing such failures has some benefits. 
ALTER TABLE employees
ALTER COLUMN fk_department_id SET NOT NULL;

-- Removes the department and sub-department columns from the employees table.
--
-- The department columns are now redundant. Keeping it could confuse future
-- database users.
ALTER TABLE employees
DROP COLUMN department,
DROP COLUMN sub_department;

-- Selects all employees with their department and sub-department names.
--
-- This is so we can visually confirm the alterations and new realtionship is
-- as planned.
SELECT
	e.employee_id,
	d.department,
	d.sub_department
FROM employees AS e
LEFT JOIN departments AS d
	ON e.fk_department_id = d.id
ORDER BY e.employee_id;


DROP TABLE IF EXISTS genders CASCADE;

-- Results:
-- + number_of_genders = 3
-- + max_gender_name_length = 6
SELECT
	COUNT(DISTINCT(gender)) AS number_of_genders,
	MAX(LENGTH(gender)) AS max_gender_name_length
FROM employees;

-- Select all genders.
SELECT DISTINCT(gender)
FROM employees;

-- Create a genders dictionary table.
CREATE TABLE genders (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique genders into the new genders table.
INSERT INTO genders (name)
SELECT DISTINCT(gender) AS name
FROM employees;

-- Select all job levels.
SELECT *
FROM genders;

-- Adds a gender id column to the employees table.
ALTER TABLE employees
ADD fk_gender_id INT;

-- Set the new column as a foreign key to the id column in the
-- genders table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_gender_id
FOREIGN KEY (fk_gender_id)
REFERENCES genders(id);

-- Update the new column values with the employees gender id.
UPDATE employees e
SET fk_gender_id = g.id
FROM genders g 
WHERE e.gender = g.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_gender_id SET NOT NULL;

-- Drop the gender column from the employees table.
ALTER TABLE employees
DROP COLUMN gender;

-- Select all employees with their gender details.
SELECT *
FROM employees AS e
JOIN genders AS g
	ON e.fk_gender_id = g.id
ORDER BY e.employee_id;








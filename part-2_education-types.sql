
DROP TABLE IF EXISTS education_types CASCADE;

-- Results:
-- + number_of_education_types = 4
-- + max_education_type_name_length = 18
SELECT
	COUNT(DISTINCT(education)) AS number_of_education_types,
	MAX(LENGTH(education)) AS max_education_type_name_length
FROM employees;

-- Select all education types.
SELECT DISTINCT(education)
FROM employees;

-- Renaming education column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN education TO education_type;

-- Create an education types dictionary table.
CREATE TABLE education_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique education types into the new table.
INSERT INTO education_types (name)
SELECT DISTINCT(education_type) AS name
FROM employees;

-- Select all education types.
SELECT *
FROM education_types;

-- Adds an education type id column to the employees table.
ALTER TABLE employees
ADD fk_education_type_id INT;

-- Set the new column as a foreign key to the id column in the
-- education types table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_education_type_id
FOREIGN KEY (fk_education_type_id)
REFERENCES education_types(id);

-- Update the new column values with the employees education
-- level id.
UPDATE employees e
SET fk_education_type_id = et.id
FROM education_types et
WHERE e.education_type = et.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_education_type_id SET NOT NULL;

-- Drop the education type column from the employees table.
ALTER TABLE employees
DROP COLUMN education_type;

-- Select all employees with their education details.
SELECT *
FROM employees AS e
JOIN education_types AS et
	ON e.fk_education_type_id = et.id
ORDER BY e.employee_id;

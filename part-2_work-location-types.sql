
DROP TABLE IF EXISTS work_location_types CASCADE;

-- Results:
-- + number_of_work_location_types = 2
-- + max_work_location_type_name_length = 7
SELECT
	COUNT(DISTINCT(location)) AS number_of_work_location_types,
	MAX(LENGTH(location)) AS max_work_location_type_name_length
FROM employees;

-- Select all work location types.
SELECT DISTINCT(location)
FROM employees;

-- Renaming location column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN location TO work_location_type;

-- Create an work location types dictionary table.
CREATE TABLE work_location_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique work location types into the new table.
INSERT INTO work_location_types (name)
SELECT DISTINCT(work_location_type) AS name
FROM employees;

-- Select all work location types.
SELECT *
FROM work_location_types;

-- Adds a work location type id column to the employees table.
ALTER TABLE employees
ADD fk_work_location_type_id INT;

-- Set the new column as a foreign key to the id column in the
-- work location types table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_work_location_type_id
FOREIGN KEY (fk_work_location_type_id)
REFERENCES work_location_types(id);

-- Update the new column values with the employees work location
-- type id.
UPDATE employees e
SET fk_work_location_type_id = wlt.id
FROM work_location_types wlt
WHERE e.work_location_type = wlt.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_work_location_type_id SET NOT NULL;

-- Drop the work location type column from the employees table.
ALTER TABLE employees
DROP COLUMN work_location_type;

-- Select all employees with their work location details.
SELECT *
FROM employees AS e
JOIN work_location_types AS wlt
	ON e.fk_work_location_type_id = wlt.id
ORDER BY e.employee_id;

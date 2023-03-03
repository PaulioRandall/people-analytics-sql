
DROP TABLE IF EXISTS employment_statuses CASCADE;

-- Results:
-- + number_of_employment_statuses = 2
-- + max_employment_status_name_length = 9
SELECT
	COUNT(DISTINCT(employment_status)) AS number_of_employment_statuses,
	MAX(LENGTH(employment_status)) AS max_employment_status_name_length
FROM employees;

-- Select all unique employment statuses.
SELECT DISTINCT(employment_status)
FROM employees;

-- Create a employment statuses dictionary table.
CREATE TABLE employment_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique employment statuses into the new table.
INSERT INTO employment_statuses (name)
SELECT DISTINCT(employment_status) AS name
FROM employees;

-- Select all employment statuses.
SELECT *
FROM employment_statuses;

-- Adds a employment status id column to the employees table.
ALTER TABLE employees
ADD fk_employment_status_id INT;

-- Set the new column as a foreign key to the id column in the
-- employment statuses table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_employment_status_id
FOREIGN KEY (fk_employment_status_id)
REFERENCES employment_statuses(id);

-- Update the new column values with the employees employment
-- status id.
UPDATE employees e
SET fk_employment_status_id = es.id
FROM employment_statuses es
WHERE e.employment_status = es.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_employment_status_id SET NOT NULL;

-- Drop the employment status column from the employees table.
ALTER TABLE employees
DROP COLUMN employment_status;

-- Select all employees with their employment status.
SELECT *
FROM employees AS e
INNER JOIN employment_statuses AS ms
	ON e.fk_employment_status_id = ms.id
ORDER BY e.employee_id;

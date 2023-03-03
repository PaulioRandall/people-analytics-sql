
DROP TABLE IF EXISTS marital_statuses CASCADE;

-- Results:
-- + number_of_marital_statuses = 2
-- + max_marital_status_name_length = 7
SELECT
	COUNT(DISTINCT(marital_status)) AS number_of_marital_statuses,
	MAX(LENGTH(marital_status)) AS max_marital_status_name_length
FROM employees;

-- Select all unique marital statuses.
SELECT DISTINCT(marital_status)
FROM employees;

-- Create a marital statuses dictionary table.
CREATE TABLE marital_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique marital statuses into the new table.
INSERT INTO marital_statuses (name)
SELECT DISTINCT(marital_status) AS name
FROM employees;

-- Select all marital statuses.
SELECT *
FROM marital_statuses;

-- Adds a marital status id column to the employees table.
ALTER TABLE employees
ADD fk_marital_status_id INT;

-- Set the new column as a foreign key to the id column in the
-- marital statuses table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_marital_status_id
FOREIGN KEY (fk_marital_status_id)
REFERENCES marital_statuses(id);

-- Update the new column values with the employees marital
-- status id.
UPDATE employees e
SET fk_marital_status_id = ms.id
FROM marital_statuses ms
WHERE e.marital_status = ms.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_marital_status_id SET NOT NULL;

-- Drop the marital status column from the employees table.
ALTER TABLE employees
DROP COLUMN marital_status;

-- Select all employees with their marital status.
SELECT *
FROM employees AS e
INNER JOIN marital_statuses AS ms
	ON e.fk_marital_status_id = ms.id
ORDER BY e.employee_id;

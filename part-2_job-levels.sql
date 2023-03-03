DROP TABLE IF EXISTS job_levels CASCADE;

-- Results:
-- + number_of_job_levels = 4
-- + max_job_level_name_length = 22
SELECT
	COUNT(DISTINCT(job_level)) AS number_of_job_levels,
	MAX(LENGTH(job_level)) AS max_job_level_name_length
FROM employees;

-- Select all job levels.
SELECT DISTINCT(job_level)
FROM employees
ORDER BY job_level;

-- Create a job levels dictionary table.
CREATE TABLE job_levels (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all job levels into the new job levels table.
INSERT INTO job_levels (name)
SELECT DISTINCT(job_level) AS name
FROM employees;

-- Select all job levels.
SELECT *
FROM job_levels;

-- Adds a job_level id column to the employees table.
ALTER TABLE employees
ADD fk_job_level_id INT;

-- Set the new column as a foreign key to the id column in the
-- departments table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_job_level_id
FOREIGN KEY (fk_job_level_id)
REFERENCES job_levels(id);

-- Update the new column values with the employees job level id.
UPDATE employees e
SET fk_job_level_id = jl.id
FROM job_levels jl 
WHERE e.job_level = jl.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_job_level_id SET NOT NULL;

-- Drop the job level column from the employees table.
ALTER TABLE employees
DROP COLUMN job_level;

-- Select all employees with their job level details.
SELECT *
FROM employees AS e
INNER JOIN job_levels AS jl
	ON e.fk_job_level_id = jl.id
ORDER BY e.employee_id;

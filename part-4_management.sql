
------------------------
------ job_levels ------
------------------------

-- Remove table if rerunning script.
DROP TABLE IF EXISTS job_levels CASCADE;

-- Selects the number of job levels and the length of the
-- longest job level name.
--
-- Results:
-- + number_of_job_levels = 4
-- + max_job_level_name_length = 22
SELECT
	COUNT(DISTINCT(job_level)) AS number_of_job_levels,
	MAX(LENGTH(job_level)) AS max_job_level_name_length
FROM employees;

-- Selects all job levels.
SELECT DISTINCT(job_level)
FROM employees
ORDER BY job_level;

-- Creates a job levels dictionary table.
CREATE TABLE job_levels (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all job levels into the new table.
INSERT INTO job_levels (name)
SELECT DISTINCT(job_level) AS name
FROM employees;

-- Selects all job levels from the new table.
SELECT *
FROM job_levels;

-- Adds a job level id column to the employees table.
ALTER TABLE employees
ADD fk_job_level_id INT;

-- Constrains the new column as a foreign key to the id
-- column in the new job levels table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_job_level_id
FOREIGN KEY (fk_job_level_id)
REFERENCES job_levels(id);

-- Updates employees so that the job level reference
-- references the right column in the job levels table.
UPDATE employees e
SET fk_job_level_id = jl.id
FROM job_levels jl 
WHERE e.job_level = jl.name;

-- Add a not null constraint to the job level reference
-- in the employees table.
ALTER TABLE employees
ALTER COLUMN fk_job_level_id SET NOT NULL;

-- Remove the job level column from the employees table.
ALTER TABLE employees
DROP COLUMN job_level;

-- Select all employees with their job level details.
SELECT
	e.employee_id,
    jl.name AS job_level
FROM employees AS e
LEFT JOIN job_levels AS jl
	ON e.fk_job_level_id = jl.id
ORDER BY e.employee_id;

-----------------------
------ employees ------
-----------------------

-- Selects all employees who have the ID or have a
-- manager with the ID 5539617772;
--
-- Judging from the four management columns it looks as
-- though there are five emplyment layers to the
-- organisation.
--
-- There is a lot of duplicity here which I could remove.
--
-- I can just delete all but the first manager columns then
-- rename the first to 'manager'.
--
-- I can't see the reason for another table except as a
-- linking table that links a manager with many employees.
-- But it seems redundant I'm sure I could easily pick
-- out any management info from some simple quries.
--
-- I think the job level column is related to the management
-- level but I'm not going to pursue that just yet. I've
-- noted that no one has a fourth level manager.
--
-- Numerical job levels:
-- + Individual Contributor = 1st level
-- + Team Lead              = 2nd level
-- + Manager                = 3rd level
-- + Director               = 4th level
-- + ???                    = 5th level
SELECT
	employee_id,
    first_level_manager,
    second_level_manager,
    third_level_manager,
    fourth_level_manager
FROM employees
WHERE
	employee_id = 5539617772
OR first_level_manager = 5539617772
OR second_level_manager = 5539617772
OR third_level_manager = 5539617772
OR fourth_level_manager = 5539617772;

-- Renames the line manager column to manager.
ALTER TABLE employees
RENAME COLUMN first_level_manager TO manager;

-- Remove second, third, and fourth level manager columns.
ALTER TABLE employees
DROP COLUMN second_level_manager,
DROP COLUMN third_level_manager,
DROP COLUMN fourth_level_manager;

-- Selects all employees;
SELECT *
FROM employees;

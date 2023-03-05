
------------------------
------ job_levels ------
------------------------

-- Removes table if rerunning script.
DROP TABLE IF EXISTS job_levels CASCADE;

-- Selects the number of job levels and the length of the longest job level
-- name.
--
-- As suspected, another dictionary.
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

-- Inserts all job levels into the new job levels table.
INSERT INTO job_levels (name)
SELECT DISTINCT(job_level) AS name
FROM employees;

-- Selects all job levels from the new job levels table.
SELECT *
FROM job_levels;

-- Adds a job level id column to the employees table.
ALTER TABLE employees
ADD fk_job_level_id INT;

-- Adds a relationship where the ID column in the job levels table references
-- the new job level ID column in the employees table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_job_level_id
FOREIGN KEY (fk_job_level_id)
REFERENCES job_levels(id);

-- Updates the employees table so the job level column references the releevant
-- column in the job levels table.
UPDATE employees e
SET fk_job_level_id = jl.id
FROM job_levels jl 
WHERE e.job_level = jl.name;

-- Adds a not null constraint to the job level column in the employees table.
ALTER TABLE employees
ALTER COLUMN fk_job_level_id SET NOT NULL;

-- Removes the old job level column from the employees table.
ALTER TABLE employees
DROP COLUMN job_level;

-- Selects all employees with their job level details.
--
-- Visually inspect to ensure all is well.
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

-- Selects all employees who have the ID or have a manager with the ID
-- 5539617772;
--
-- With this query I'm trying to get a picture of the management structure.
--
-- Judging from the four management columns it looks as though there are five
-- management layers to the organisation.
--
-- There is a lot of duplicity here which I could remove. I can just delete all
-- but the first manager columns then rename the first to something like
-- 'manager_id'.
--
-- I can't see the reason for another table except as a linking table that
-- links a manager with many employees. But it seems redundant. I'm sure I
-- could easily pick out any management info from a simple query without it.
--
-- I think the job level column is related to the management level but I'm not
-- going to pursue that just yet. I've noted that no one has a fourth level
-- manager.
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

-- Renames the first level manager column to 'manager_id' for clarity.
ALTER TABLE employees
RENAME COLUMN first_level_manager TO manager_id;

-- Removes second, third, and fourth level manager columns.
--
-- Note that we can acquire this information by traversing the 'manager_id'
-- column in future.
ALTER TABLE employees
DROP COLUMN second_level_manager,
DROP COLUMN third_level_manager,
DROP COLUMN fourth_level_manager;

-- Selects all employees.
--
-- Check my handiwork.
SELECT *
FROM employees;

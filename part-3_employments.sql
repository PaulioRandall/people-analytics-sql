
---------------------------------
------ termination_reasons ------
---------------------------------

-- Remove if rerunning script.
DROP TABLE IF EXISTS termination_reasons CASCADE;

-- Counts the number of termination reasons and finds the length
-- of the longest reason.
--
-- It looks as though this is not a free text field as I had
-- originally thought, but values from a limited dictionary.
--
-- Results:
-- + number_of_termination_reasons = 10
-- + max_termination_reason_length = 26
SELECT
	COUNT(DISTINCT(term_reason)) AS number_of_termination_reasons,
	MAX(LENGTH(term_reason)) AS max_termination_reason_length
FROM employees;

-- Select all unique termination reasons.
SELECT DISTINCT(term_reason)
FROM employees
WHERE term_reason IS NOT NULL;

-- Creates a dictionary of reasons for termination.
CREATE TABLE termination_reasons (
	id SERIAL PRIMARY KEY,
	description VARCHAR(50) UNIQUE NOT NULL CHECK (description <> '')
);

-- Insert all unique termination reasons.
INSERT INTO termination_reasons (description)
SELECT DISTINCT(term_reason) AS description
FROM employees
WHERE term_reason IS NOT NULL;

------------------------
------ employment ------
------------------------

-- Select all unique termination types.
--
-- Excluding the null, there are two termination types.
--
-- I can't imagine any alternative type so I'm going to convert this
-- into a boolean column in the upcoming terminations table.
SELECT DISTINCT(term_type)
FROM employees;

-- Selects the termination details for only those employees who have
-- left the company.
--
-- Initially I thought 'term' meant 'employment term' but now that
-- I've worked with the fields I think it's supposed to be
-- 'termination'.
--
-- Since a majority of employees have not left, most of these fields
-- are null in the employees table. I think we can encapsualte this
-- information in a table of its own that references an employee
-- record.
--
-- The 'term_reason' column will be placed in a dictionary table and
-- referenced from the termination table.
--
-- The 'active_status' field is probably redundant once the employees
-- table contains a nullable reference to the termination table.
-- The presence of null indicates the employee is still with the
-- company.
--
-- The 'tenure' field will be renamed 'months_employed' so it now says
-- what it is.
SELECT
	term_reason,
	term_type,
    hire_date,
	term_date,
    tenure
FROM employees
WHERE active_status = 0;

-- Remove table if rerunning script.
DROP TABLE IF EXISTS employments CASCADE;

-- Creates a table of employment periods. 
CREATE TABLE employments (
	id BIGSERIAL PRIMARY KEY,
	fk_employee_id BIGINT NOT NULL,
	start_date DATE NOT NULL,
	months_employed INT,	
	end_date DATE,
	termination_type VARCHAR(20),
	fk_termination_reason_id INT
);

-- Reference the employee id in the employees table from
-- within the employments table.
ALTER TABLE employments
ADD CONSTRAINT fk_employments__fk_employee_id
FOREIGN KEY (fk_employee_id)
REFERENCES employees(employee_id);

-- Reference the id in the termination reason table from
-- within the terminations table.
ALTER TABLE employments
ADD CONSTRAINT fk_employments__fk_termination_reason_id
FOREIGN KEY (fk_termination_reason_id)
REFERENCES termination_reasons(id);

-- Insert the relevant data from the employees table into
-- the new terminations table.
INSERT INTO employments (
	fk_employee_id,
	start_date,
	months_employed,
	end_date,
	termination_type,
	fk_termination_reason_id
)
SELECT
	e.employee_id AS fk_employee_id,
    e.hire_date AS start_date,
    e.tenure AS months_employed,
    e.term_date AS end_date,
    e.term_type AS termination_type,
    tr.id AS fk_termination_reason_id
FROM employees AS e
LEFT JOIN termination_reasons AS tr
	ON e.term_reason = tr.description;

-- Selects all terminations.
SELECT *
FROM employments;

-----------------------
------ employees ------
-----------------------

-- Remove the columns that were moved to the employments
-- and termination reason tables from the employees table.
ALTER TABLE employees
DROP COLUMN active_status,
DROP COLUMN hire_date,
DROP COLUMN tenure,
DROP COLUMN term_date,
DROP COLUMN term_type,
DROP COLUMN term_reason;

-- Selects all employees and their employment period details
-- for only those who have been terminated.
SELECT
	e.employee_id,
    em.start_date,
    em.months_employed,
    em.end_date,
    em.termination_type,
    tr.description AS termination_reason
FROM employees AS e
INNER JOIN employments AS em
	ON e.employee_id = em.fk_employee_id
INNER JOIN termination_reasons AS tr
	ON em.fk_termination_reason_id = tr.id
WHERE em.end_date IS NOT NULL;


DROP TABLE IF EXISTS term_exit_types CASCADE;

-- Results:
-- + number_of_term_exit_types = 2
-- + max_term_exit_type_name_length = 11
SELECT
	COUNT(DISTINCT(term_type)) AS number_of_term_exit_types,
	MAX(LENGTH(term_type)) AS max_term_exit_type_name_length
FROM employees;

-- Select all unique term exit types.
SELECT DISTINCT(term_type)
FROM employees;

-- Renaming term type column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN term_type TO term_exit_type;

-- Renaming term date column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN term_date TO term_exit_date;

-- Renaming term reason column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN term_reason TO term_exit_reason;

-- Create a term exit types dictionary table.
CREATE TABLE term_exit_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique term exit types into the new table.
INSERT INTO term_exit_types (name)
SELECT DISTINCT(term_exit_type) AS name
FROM employees
WHERE term_exit_type IS NOT NULL;

-- Select all term exit types.
SELECT *
FROM term_exit_types;

-- Adds an term exit type id column to the employees table.
ALTER TABLE employees
ADD fk_term_exit_type_id INT;

-- Set the new column as a foreign key to the id column in the
-- term exit types table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_term_exit_type_id
FOREIGN KEY (fk_term_exit_type_id)
REFERENCES term_exit_types(id);

-- Update the new column values with the employees term exit
-- type id.
UPDATE employees e
SET fk_term_exit_type_id = tet.id
FROM term_exit_types tet
WHERE e.term_exit_type = tet.name;

-- Drop the term exit type column from the employees table.
ALTER TABLE employees
DROP COLUMN term_exit_type;

-- Select all employees with their term exit details.
SELECT *
FROM employees AS e
LEFT JOIN term_exit_types AS tet
	ON e.fk_term_exit_type_id = tet.id
ORDER BY tet.name, e.employee_id;

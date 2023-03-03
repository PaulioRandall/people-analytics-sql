
DROP TABLE IF EXISTS sexual_orientations CASCADE;

-- Results:
-- + number_of_sexual_orientations = 5
-- + max_sexual_orientation_name_length = 12
SELECT
	COUNT(DISTINCT(sexual_orientation)) AS number_of_sexual_orientations,
	MAX(LENGTH(sexual_orientation)) AS max_sexual_orientation_name_length
FROM employees;

-- Select all sexual orientations.
SELECT DISTINCT(sexual_orientation)
FROM employees;

-- Create a sexual orientations dictionary table.
CREATE TABLE sexual_orientations (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique sexual orientations into the new table.
INSERT INTO sexual_orientations (name)
SELECT DISTINCT(sexual_orientation) AS name
FROM employees;

-- Select all sexual orientations.
SELECT *
FROM sexual_orientations;

-- Adds a sexual orientation id column to the employees table.
ALTER TABLE employees
ADD fk_sexual_orientation_id INT;

-- Set the new column as a foreign key to the id column in the
-- sexual orientations table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_sexual_orientation_id
FOREIGN KEY (fk_sexual_orientation_id)
REFERENCES sexual_orientations(id);

-- Update the new column values with the employees sexual
-- orientation id.
UPDATE employees e
SET fk_sexual_orientation_id = so.id
FROM sexual_orientations so 
WHERE e.sexual_orientation = so.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_sexual_orientation_id SET NOT NULL;

-- Drop the sexual orientation column from the employees table.
ALTER TABLE employees
DROP COLUMN sexual_orientation;

-- Select all employees with their sexual orientation details.
SELECT *
FROM employees AS e
INNER JOIN sexual_orientations AS so
	ON e.fk_sexual_orientation_id = so.id
ORDER BY e.employee_id;

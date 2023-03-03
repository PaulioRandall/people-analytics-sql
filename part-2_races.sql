
DROP TABLE IF EXISTS races CASCADE;

-- Results:
-- + number_of_races = 6
-- + max_race_name_length = 16
SELECT
	COUNT(DISTINCT(race)) AS number_of_races,
	MAX(LENGTH(race)) AS max_race_name_length
FROM employees;

-- Select all races.
SELECT DISTINCT(race)
FROM employees;

-- Create a races dictionary table.
CREATE TABLE races (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Insert all unique races into the new table.
INSERT INTO races (name)
SELECT DISTINCT(race) AS name
FROM employees;

-- Select all races.
SELECT *
FROM races;

-- Adds a race id column to the employees table.
ALTER TABLE employees
ADD fk_race_id INT;

-- Set the new column as a foreign key to the id column in the
-- races table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_race_id
FOREIGN KEY (fk_race_id)
REFERENCES races(id);

-- Update the new column values with the employees race id.
UPDATE employees e
SET fk_race_id = r.id
FROM races r
WHERE e.race = r.name;

-- Add a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_race_id SET NOT NULL;

-- Drop the race column from the employees table.
ALTER TABLE employees
DROP COLUMN race;

-- Select all employees with their race details.
SELECT *
FROM employees AS e
INNER JOIN races AS r
	ON e.fk_race_id = r.id
ORDER BY e.employee_id;

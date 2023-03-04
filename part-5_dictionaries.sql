
---------------------
------ genders ------
---------------------

-- Remove genders table if rerunnng script;
DROP TABLE IF EXISTS genders CASCADE;

-- Selects the number of genders and the length of the
-- longest gender name.
--
-- Results:
-- + number_of_genders = 3
-- + max_gender_name_length = 6
SELECT
	COUNT(DISTINCT(gender)) AS number_of_genders,
	MAX(LENGTH(gender)) AS max_gender_name_length
FROM employees;

-- Select all distinct genders.
SELECT DISTINCT(gender)
FROM employees;

-- Creates a genders dictionary table.
CREATE TABLE genders (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique genders into the new genders table.
INSERT INTO genders (name)
SELECT DISTINCT(gender) AS name
FROM employees;

-- Select all genders from the new genders table.
SELECT *
FROM genders;

-- Adds a gender id column to the employees table.
ALTER TABLE employees
ADD fk_gender_id INT;

-- Constrains the new column as a foreign key to the
-- primary key of the new genders table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_gender_id
FOREIGN KEY (fk_gender_id)
REFERENCES genders(id);

-- Populates the foreign key values with the employees
-- gender id.
UPDATE employees e
SET fk_gender_id = g.id
FROM genders g 
WHERE e.gender = g.name;

-- Add a not null constraint to the new foreign key.
ALTER TABLE employees
ALTER COLUMN fk_gender_id SET NOT NULL;

-- Removes the old gender column from the employees table.
ALTER TABLE employees
DROP COLUMN gender;

-- Select all employees with their gender details.
SELECT
	e.employee_id,
    g.name
FROM employees AS e
LEFT JOIN genders AS g
	ON e.fk_gender_id = g.id
ORDER BY e.employee_id;

---------------------------------
------ sexual_orientations ------
---------------------------------

-- Remove table if rerunnng script.
DROP TABLE IF EXISTS sexual_orientations CASCADE;

-- Selects the number of orientations and the length of the
-- longest name.
--
-- Results:
-- + number_of_sexual_orientations = 5
-- + max_sexual_orientation_name_length = 12
SELECT
	COUNT(DISTINCT(sexual_orientation)) AS number_of_sexual_orientations,
	MAX(LENGTH(sexual_orientation)) AS max_sexual_orientation_name_length
FROM employees;

-- Selects all distinct sexual orientations.
SELECT DISTINCT(sexual_orientation)
FROM employees;

-- Creates a sexual orientation dictionary table.
CREATE TABLE sexual_orientations (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique sexual orientations into the new
-- dictionary table.
INSERT INTO sexual_orientations (name)
SELECT DISTINCT(sexual_orientation) AS name
FROM employees;

-- Selects all sexual orientations.
SELECT *
FROM sexual_orientations;

-- Adds a sexual orientation id column to the employees table.
ALTER TABLE employees
ADD fk_sexual_orientation_id INT;

-- Constrains the new column as a foreign key to the
-- primary key of the new sexual orientations table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_sexual_orientation_id
FOREIGN KEY (fk_sexual_orientation_id)
REFERENCES sexual_orientations(id);

-- Updates the new column values with the employees sexual
-- orientation id.
UPDATE employees e
SET fk_sexual_orientation_id = so.id
FROM sexual_orientations so 
WHERE e.sexual_orientation = so.name;

-- Adds a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_sexual_orientation_id SET NOT NULL;

-- Removes the old sexual orientation column from the employees table.
ALTER TABLE employees
DROP COLUMN sexual_orientation;

-- Selects all employees with their sexual orientation details.
SELECT
	e.employee_id,
    so.name
FROM employees AS e
LEFT JOIN sexual_orientations AS so
	ON e.fk_sexual_orientation_id = so.id
ORDER BY e.employee_id;

-------------------
------ races ------
-------------------

-- Remove table if rerunnng script.
DROP TABLE IF EXISTS races CASCADE;

-- Selects the number of races and the length of the
-- longest race name.
--
-- Results:
-- + number_of_races = 6
-- + max_race_name_length = 16
SELECT
	COUNT(DISTINCT(race)) AS number_of_races,
	MAX(LENGTH(race)) AS max_race_name_length
FROM employees;

-- Selects all distinct races.
SELECT DISTINCT(race)
FROM employees;

-- Creates a race dictionary table.
CREATE TABLE races (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique races into the new dictionary table.
INSERT INTO races (name)
SELECT DISTINCT(race) AS name
FROM employees;

-- Selects all races form the new races table.
SELECT *
FROM races;

-- Adds a race id column to the employees table.
ALTER TABLE employees
ADD fk_race_id INT;

-- Constrains the employee table race id column as a foreign key
-- to the primary key of the new races table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_race_id
FOREIGN KEY (fk_race_id)
REFERENCES races(id);

-- Updates the new column values with the employees race id.
UPDATE employees e
SET fk_race_id = r.id
FROM races r
WHERE e.race = r.name;

-- Adds a not null constraint to the new column.
ALTER TABLE employees
ALTER COLUMN fk_race_id SET NOT NULL;

-- removes the old race column from the employees table.
ALTER TABLE employees
DROP COLUMN race;

-- Selects all employees with their race details.
SELECT
	e.employee_id,
    r.name
FROM employees AS e
LEFT JOIN races AS r
	ON e.fk_race_id = r.id
ORDER BY e.employee_id;

-----------------------------
------ education_types ------
-----------------------------

-- Remove table if rerunning script.
DROP TABLE IF EXISTS education_types CASCADE;

-- Selects the number of education types and the length of
-- the longest type name.
--
-- Results:
-- + number_of_education_types = 4
-- + max_education_type_name_length = 18
SELECT
	COUNT(DISTINCT(education)) AS number_of_education_types,
	MAX(LENGTH(education)) AS max_education_type_name_length
FROM employees;

-- Selects all distinct education types.
SELECT DISTINCT(education)
FROM employees;

-- Renaming education column in employees table for clarity.
--
-- Will be removed completely at the end.
ALTER TABLE employees
RENAME COLUMN education TO education_type;

-- Creates an education type dictionary table.
CREATE TABLE education_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique education types into the new education
-- type table.
INSERT INTO education_types (name)
SELECT DISTINCT(education_type) AS name
FROM employees;

-- Selects all education types from the new education type table.
SELECT *
FROM education_types;

-- Adds an education type id column to the employees table.
ALTER TABLE employees
ADD fk_education_type_id INT;

-- Relates the employees table to the education types table via
-- the education type column in the employees table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_education_type_id
FOREIGN KEY (fk_education_type_id)
REFERENCES education_types(id);

-- Updates the new column values with the employees education
-- type id.
UPDATE employees e
SET fk_education_type_id = et.id
FROM education_types et
WHERE e.education_type = et.name;

-- Adds a not null constraint to the new education type column
-- in the employees table.
ALTER TABLE employees
ALTER COLUMN fk_education_type_id SET NOT NULL;

-- Removes the old education type column from the employees table.
ALTER TABLE employees
DROP COLUMN education_type;

-- Selects all employees with their education details.
SELECT
	e.employee_id,
    et.name
FROM employees AS e
INNER JOIN education_types AS et
	ON e.fk_education_type_id = et.id
ORDER BY e.employee_id;

---------------------------------
------ work_location_types ------
---------------------------------

-- Remove table if rerunning script.
DROP TABLE IF EXISTS work_location_types CASCADE;

-- Selects the number of work location types and the length
-- of the longest type name.
--
-- Results:
-- + number_of_work_location_types = 2
-- + max_work_location_type_name_length = 7
SELECT
	COUNT(DISTINCT(location)) AS number_of_work_location_types,
	MAX(LENGTH(location)) AS max_work_location_type_name_length
FROM employees;

-- Selects all distinct work location types.
SELECT DISTINCT(location)
FROM employees;

-- Renaming location column in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN location TO work_location_type;

-- Renaming location city in employees table for clarity.
ALTER TABLE employees
RENAME COLUMN location_city TO work_location_city;

-- Creates a work location type dictionary table.
CREATE TABLE work_location_types (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique work location types into the new 
-- work location types table.
INSERT INTO work_location_types (name)
SELECT DISTINCT(work_location_type) AS name
FROM employees;

-- Selects all work location types from the new work location
-- types table.
SELECT *
FROM work_location_types;

-- Adds a work location type id column to the employees table.
ALTER TABLE employees
ADD fk_work_location_type_id INT;

-- Relates the employees table to the work location types table
-- via the new work location type ID column in the employees table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_work_location_type_id
FOREIGN KEY (fk_work_location_type_id)
REFERENCES work_location_types(id);

-- Updates the new column in the employees table with the employees
-- work location type id from the new work location types table.
UPDATE employees e
SET fk_work_location_type_id = wlt.id
FROM work_location_types wlt
WHERE e.work_location_type = wlt.name;

-- Adds a not null constraint to the new column in the employees
-- table.
ALTER TABLE employees
ALTER COLUMN fk_work_location_type_id SET NOT NULL;

-- Removes the work location type column from the employees table.
ALTER TABLE employees
DROP COLUMN work_location_type;

-- Selects all employees with their work location details.
SELECT
	e.employee_id,
    wlt.name
FROM employees AS e
INNER JOIN work_location_types AS wlt
	ON e.fk_work_location_type_id = wlt.id
ORDER BY e.employee_id;

------------------------------
------ marital_statuses ------
------------------------------

-- Remove table if rerunning script.
DROP TABLE IF EXISTS marital_statuses CASCADE;

-- Selects the number of marital statuses and the length of the
-- longest status name.
--
-- Results:
-- + number_of_marital_statuses = 2
-- + max_marital_status_name_length = 7
SELECT
	COUNT(DISTINCT(marital_status)) AS number_of_marital_statuses,
	MAX(LENGTH(marital_status)) AS max_marital_status_name_length
FROM employees;

-- Selects all distinct marital statuses.
SELECT DISTINCT(marital_status)
FROM employees;

-- Creates a marital status dictionary table.
CREATE TABLE marital_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique marital statuses into the new marital statuses
-- table.
INSERT INTO marital_statuses (name)
SELECT DISTINCT(marital_status) AS name
FROM employees;

-- Selects all marital statuses from the new table.
SELECT *
FROM marital_statuses;

-- Adds a marital status id column to the employees table.
ALTER TABLE employees
ADD fk_marital_status_id INT;

-- Relates the employees table to the marital statuses table
-- via the marital status ID column in the employees table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_marital_status_id
FOREIGN KEY (fk_marital_status_id)
REFERENCES marital_statuses(id);

-- Updates the new column values with the employees marital
-- status id.
UPDATE employees e
SET fk_marital_status_id = ms.id
FROM marital_statuses ms
WHERE e.marital_status = ms.name;

-- Adds a not null constraint to the new column in the employees
-- table.
ALTER TABLE employees
ALTER COLUMN fk_marital_status_id SET NOT NULL;

-- Removes the old marital status column from the employees table.
ALTER TABLE employees
DROP COLUMN marital_status;

-- Selects all employees with their marital status.
SELECT
	e.employee_id,
    ms.name
FROM employees AS e
INNER JOIN marital_statuses AS ms
	ON e.fk_marital_status_id = ms.id
ORDER BY e.employee_id;

---------------------------------
------ employment_statuses ------
---------------------------------

-- Remove table if rerunning script.
DROP TABLE IF EXISTS employment_statuses CASCADE;

-- Selects the number of employment statuses and the length of the
-- longest status name.
--
-- Results:
-- + number_of_employment_statuses = 2
-- + max_employment_status_name_length = 9
SELECT
	COUNT(DISTINCT(employment_status)) AS number_of_employment_statuses,
	MAX(LENGTH(employment_status)) AS max_employment_status_name_length
FROM employees;

-- Selects all unique employment statuses.
SELECT DISTINCT(employment_status)
FROM employees;

-- Creates a employment status dictionary table.
CREATE TABLE employment_statuses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(30) UNIQUE NOT NULL CHECK (name <> '')
);

-- Inserts all unique employment statuses into the new employment
-- statuses table.
INSERT INTO employment_statuses (name)
SELECT DISTINCT(employment_status) AS name
FROM employees;

-- Selects all employment statuses from the new table.
SELECT *
FROM employment_statuses;

-- Adds am employment status id column to the employees table.
ALTER TABLE employees
ADD fk_employment_status_id INT;

-- Relates the employees table to the employment statuses table
-- via the new employment status ID column in the employees table.
ALTER TABLE employees
ADD CONSTRAINT fk_employees__fk_employment_status_id
FOREIGN KEY (fk_employment_status_id)
REFERENCES employment_statuses(id);

-- Updates the new employment status ID column values with the
-- employees employment status id.
UPDATE employees e
SET fk_employment_status_id = es.id
FROM employment_statuses es
WHERE e.employment_status = es.name;

-- Adds a not null constraint to the new column in the employees
-- table.
ALTER TABLE employees
ALTER COLUMN fk_employment_status_id SET NOT NULL;

-- Removes the old employment status column from the employees table.
ALTER TABLE employees
DROP COLUMN employment_status;

-- Selects all employees with their employment status.
SELECT
	e.employee_id,
    es.name
FROM employees AS e
INNER JOIN employment_statuses AS es
	ON e.fk_employment_status_id = es.id
ORDER BY e.employee_id;

-- Dataset: People Analytics Starter (https://www.stevenshoemaker.me/datasets/starter)
-- Unfortunatly, I could not find full metadata for the columns so I'm going on best guess.

-- Delete the main table and any dependees.
--
-- Required when I want to recreate the tables and reimport the data. 
DROP TABLE IF EXISTS employees CASCADE;

-- Employees table holds all the data before normalisation.
--
-- Best guess data types have been selected intially with my
-- intention of altering columns as I investigate the data and
-- normalise the database. What matters is that the no data is
-- lost or mangled in the ingestion process.
CREATE TABLE employees (
	employee_id          BIGINT PRIMARY KEY,
	department           VARCHAR(255),
	sub_department       VARCHAR(255),
	first_level_manager  BIGINT,
	second_level_manager BIGINT,
	third_level_manager  BIGINT,
	fourth_level_manager BIGINT,
	job_level            VARCHAR(255),
	gender               VARCHAR(255),
	sexual_orientation   VARCHAR(255),
	race                 VARCHAR(255),
	age                  INT,
	education            VARCHAR(255),
	location             VARCHAR(255),
	location_city        VARCHAR(255),
	marital_status       VARCHAR(255),
	employment_status    VARCHAR(255),
	salary               BIGINT,
	hire_date            DATE,
	term_date            DATE,
	tenure               INT,
	term_type            VARCHAR(255),
	term_reason          VARCHAR(255),
	active_status        INT
);

-- Ingest the CSV data ignoring the header line.
--
-- If you're running this statement don't forget to download the data
-- (https://www.stevenshoemaker.me/datasets/starter) and adjust the
-- FROM clause appropriately.
--
-- I'm working on Linux (Ubuntu) at the moment and encountered
-- some file permission issues. Throwing the file into /tmp was
-- the quickest way to solve them.
COPY employees
FROM '/tmp/people-analytics-employees.csv'
DELIMITER ','
CSV HEADER;

-- Selects all employees.
--
-- The simplest query allowing us to inspect the whole dataset.
SELECT *
FROM employees;

-- Counts the number of employees
--
-- Result: 4831
SELECT
	COUNT(employee_id) AS employee_count
FROM employees;

-- Count the employees in each department.
SELECT
	department,
	COUNT(employee_id) AS total_staff
FROM employees
GROUP BY department;

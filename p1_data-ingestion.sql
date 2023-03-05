-- Dataset: People Analytics Starter (https://www.stevenshoemaker.me/datasets/starter)
-- Unfortunatly, I could not find full metadata for the columns so I'm going on best guess.
--
-- In this project I will be transforming the CSV file contents into a
-- normalised table structure. The purpose is to show off table manipulation
-- within SQL.
-- 
-- Normally I would ingest the data into a super simple table or set of tables
-- then design a completely new normalised set. The data is then cleaned as it
-- is ported over to the new structure. However, that would be too easy. I'm
-- imposing an artifical constraint that forces me to alter the existing table
-- incrementally. To maximise growth you have to walk the hard road. 
--
-- I prefer to work by writing re-runnable scripts so when I screw up I can
-- quickly and easily get back to my previous state. Thinking in terms of
-- immutability. It's also nice if there may be more data to come later as the
-- script can be used to create staging tables for batches of incoming data.
--
-- This work is being done on a locally served postgresql database but a remote
-- one would be just the same; except for the security configurations.
--
-- It should be noted that this dataset doesn't really need any engineering
-- if data analysis is the only use case. It's small and clean enough to
-- start visualisation. In fact, noramlisation will make the actual analysis
-- harder, not easier.
-- 
-- To do a proper job requires a clear purpose, knowledge of the specific
-- organisation's business rules, and, ideally, an understanding of what and
-- how the database will be used. Without them I can only guess as to how
-- tables and relationships should be layed out. Despite this, I can identify
-- some areas ripe for normalisation.

-- Remove the main table and any dependent constraints.
--
-- Required when I want to recreate the tables and reimport the data. 
DROP TABLE IF EXISTS employees CASCADE;

-- Creates a table holding all employee data.
--
-- Best guess data types have been selected intially with my intention of
-- altering columns as I investigate the data and normalise the database.
-- What matters is that no data is lost or mangled in the ingestion process.
--
-- I've avoided adding constraints at this point as it will make altering the
-- table harder. These will be added as we progress with the normalisation.
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
-- (https://www.stevenshoemaker.me/datasets/starter) and adjust the FROM
-- clause appropriately.
--
-- I'm working on Linux (Ubuntu) at the moment and encountered some file
-- permission issues. Throwing the file into /tmp was the quickest way to
-- solve them.
COPY employees
FROM '/tmp/people-analytics-employees.csv'
DELIMITER ','
CSV HEADER;

-- Selects all employees.
--
-- The simplest of queries allowing us to inspect the whole dataset.
SELECT *
FROM employees;

-- Counts the number of employees.
--
-- Good to get an understanding of how much data we're dealing with. 4831 is
-- pretty low so I shouldn't be waiting on a query.
--
-- Result: 4831
SELECT COUNT(employee_id) AS employee_count
FROM employees;

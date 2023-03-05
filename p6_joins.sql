
-- Brings together all the data about each employee.
SELECT
	e.employee_id,
	e.age,
	e.salary,
	es.name  AS employment_status,
	ge.name  AS gender,
	so.name  AS sexual_orientation,
	r.name   AS race,
	ed.name  AS education,
	ms.name  AS marital_status,
	wlt.name AS work_location_type,
	e.work_location_city,
	e.manager_id,
	d.department,
	d.sub_department,
	jl.name AS job_level,
	em.start_date,
	em.months_employed,
	em.end_date,
	em.termination_type,
	tr.description AS termination_reason
FROM employees                AS e
LEFT JOIN genders             AS ge ON e.fk_gender_id = ge.id
LEFT JOIN sexual_orientations AS so ON e.fk_sexual_orientation_id = so.id
LEFT JOIN races               AS r ON e.fk_race_id = r.id
LEFT JOIN education_types     AS ed ON e.fk_education_type_id = ed.id
LEFT JOIN marital_statuses    AS ms ON e.fk_marital_status_id = ms.id
LEFT JOIN work_location_types AS wlt ON e.fk_work_location_type_id = wlt.id
LEFT JOIN employment_statuses AS es ON e.fk_employment_status_id = es.id
LEFT JOIN departments         AS d ON e.fk_department_id = d.id
LEFT JOIN job_levels          AS jl ON e.fk_job_level_id = jl.id
LEFT JOIN employments         AS em ON e.employee_id = em.fk_employee_id
LEFT JOIN termination_reasons AS tr ON em.fk_termination_reason_id = tr.id
ORDER BY e.employee_id;

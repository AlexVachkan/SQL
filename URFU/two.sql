--Общий вид таблицы
SELECT * FROM public.employee;

--Список имен всех сотрудников
SELECT DISTINCT("name") AS employee_name 
FROM public.employee;

--Кол-во сотрудников
SELECT COUNT("name") AS number_of_employees 
FROM public.employee;

--Имена сотрудников, работающих в определенную дату
SELECT "name",
	   CAST(begin_date AS DATE) AS day_job 
FROM public.employee
WHERE CAST(begin_date AS DATE) = '2021-09-07';

--Кол-во сотрудников, работающих в определенную дату
SELECT COUNT("name") AS number_of_employees,
       CAST(begin_date AS DATE) AS day_job 
FROM public.employee
WHERE CAST(begin_date AS DATE) = '2021-09-07'
GROUP BY day_job;

--Данные о сотрудниках с именим его руководителя для каждого сотрудника
SELECT *
FROM public.employee
WHERE "name" = 'Garza'; 
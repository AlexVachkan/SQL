--Общий вид таблицы
SELECT * FROM PUBLIC.log_urfu;

--Число уникальных пользователей в сетябре 2017 года
SELECT COUNT(DISTINCT(login)) AS number_of_students,
       EXTRACT(month FROM "time") AS "month"
FROM public.log_urfu
WHERE EXTRACT(month FROM "time") = 9
GROUP BY EXTRACT(month FROM "time");

--Число входов в систему в разбивке по неделям
SELECT EXTRACT(week FROM "time") AS week,
	   COUNT("time") AS	number_of_inputs   
FROM public.log_urfu
GROUP BY week
ORDER BY week;

--Число уникальных пользователей в разбивке по институтам формам обучения и уровня образования
WITH
table2 AS 
(SELECT institute,
        forma,
        COUNT(DISTINCT login) AS students_by_forma
FROM public.log_urfu
GROUP BY institute, forma),

table3 AS 
(SELECT institute,
        forma,
        "level",
        COUNT(DISTINCT login) AS students_by_level
FROM public.log_urfu
GROUP BY institute, forma, "level")

SELECT table1.institute,
        table1.students_by_institute,
        table2.forma,
        table2.students_by_forma,
		table3.level,
        table3.students_by_level
FROM (SELECT institute,
        COUNT(DISTINCT login) AS students_by_institute
FROM public.log_urfu
GROUP BY institute) AS table1
JOIN table2 ON table1.institute = table2.institute
INNER JOIN table3 ON table2.forma = table3.forma AND table2.institute = table3.institute

--Количество уникальных пользователей для каждой недели сентября
SELECT EXTRACT(week FROM "time") AS week,
	   COUNT(DISTINCT login) AS	number_of_students   
FROM public.log_urfu
GROUP BY week
ORDER BY week;
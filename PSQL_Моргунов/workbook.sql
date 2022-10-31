-- \dn вывод схем бд
-- \d public.aircrafts структура таблицы

-- ГЛАВА 3

create table public.aircrafts
(aircraft_code char(3) not null,
model text not null,
range integer not null,
check (range > 0),
primary key (aircraft_code)
);

insert into public.aircrafts(aircraft_code,model,range)
values  ('773',	'Боинг 777-300',	11100),
		('763',	'Боинг 767-300',	7900),
		('SU9',	'Сухой Суперджет-100',	3000),
		('320',	'Аэробус A320-200',	5700),
		('321',	'Аэробус A321-200',	5600),
		('319',	'Аэробус A319-100',	6700),
		('733',	'Боинг 737-300',	4200),
		('CN1',	'Сессна 208 Караван',	1200),
		('CR2',	'Бомбардье CRJ-200',	2700);

update public.aircrafts
set range = 3500
where aircraft_code='SU9';

delete from public.aircraft
where aircraft_code='CN1';

select * from public.aircrafts;

drop table public.aircrafts;
-----------------------------------
-- создаю таблицу seats. Это ссылающаяся таблица на aircrafts(ссылочная).
create table public.seats
(
	aircraft_code char(3) not null, -- обязательно три символа
	seat_no varchar(4) not null, -- не более 4х символов
	fare_condition varchar(10) not null,
	check 
	(fare_condition in ('economy', 'comfort', 'bisiness')), -- ограничение по трем словам
	primary key (aircraft_code, seat_no), -- составной первичный ключ
	foreign key (aircraft_code) -- вынешний ключ 
	  references public.aircrafts (aircraft_code) -- указываю на какая таблица ссылочная  и атрибут в жтой таблице
	  on delete cascade -- задаю каскадное удаление
);

-- проверим работу внешнего ключа
insert into public.seats values ('123', '1A', 'bisiness');
-- Ключ (aircraft_code)=(123) отсутствует в таблице "aircrafts".

-- Добавим данные в public.seats(Для работы будем использовать dookings.seats)
insert into public.seats
values 
('773', '1A', 'bisiness'),
('SU9', '1AB', 'comfort');

-- Приверим добавление данных
select * from public.seats

-- Посчитаем количество месть у SU9
select count(seat_no)
from bookings.seats
where aircraft_code='SU9';

-- Посчитаем количество месть у каждого самолета
select aircraft_code, count(seat_no)
from bookings.seats
group by aircraft_code 

-- Отсортируем количество месть у каждого самолета
select aircraft_code, count(seat_no)
from bookings.seats
group by aircraft_code
order by count(seat_no) desc -- desc от большего к меньшему, без - от меньшего к большему

-- Посчитаем количество месть у каждого самолета и каждого класса комфорта
select aircraft_code, fare_conditions, count(*) -- так как integer один атрибут, то можно использовать *
from bookings.seats
group by aircraft_code, fare_conditions
order by count(seat_no) desc

-- Контрольный вопросы ГЛАВЫ 3

--1
insert into public.aircrafts -- не пишу атрибуты 
values ('SU9', 'Сухой Суперджет-100', 3000)
-- ERROR: ОШИБКА:  повторяющееся значение ключа нарушает ограничение уникальности "aircrafts_pkey"
-- ОТВЕТ: Значения первичного ключа, как и любого возможного ключа, уникальны!

--2
select * 
from public.aircrafts
order by range desc

--3
update public.aircrafts 
set range = range * 2 -- можно писать арфиметичскоге выражения 
where aircraft_code='SU9';

select * from public.aircrafts;

--4
delete from public.aircrafts
where range<1000 or range>11200;
-- DELETE 0


-- ГЛАВА 4

-- Числовые типы:
 
целочисленные: smallint, integer, bigint
фиксир точность: numeric, decimal (numeric(6,4)=12,1525 точность-6, масштаб-4)
уникальные целые значения: serial
	create public.table_test 
	(column numeric(3,2));
	
-- Символьные типы:

Точное число символов: char(3)
Не более число символов: varchar(10)
Любое число символов(255): text
-- '...''...'(Е...\'..)  одна кoвычка в тексте
-- '...\n...'  след строка в тексте

-- Типы дата\время:
date - дата
time - время
timestamp - дата и время
timestamptz - дата и время с учетом часового пояса
interval - интервал 


	select '2016-12-31'::date;
	select 'Dec 31, 2016'::date;
	select current_date; - сегодняшняя дата
	select to_char(current_date, 'dd-mm-yyyy'); - изм. формата даты

	select '20:15:27'::time; или ('8:15:27 am(pm)')
	select current_time; - сегодняшняя время

	select timestamptz '2016-12-31 21:59:48' - с учетом часового пояса
	select timestamp '2016-12-31 21:59:48' - без учета часового пояса
	select current_timestamp; - текущая дата и время
	
	select '1 year 2 month ago'::interval; - ago добавляет минус
	select ('2016-12-20'::timestamp - '2016-12-10'::timestamp)::interval; - интервал как отрезок времени

	select date_trunc('hour', current_timestamp); - усекает время до часу
	select extract('hour', current_timestamp); - извлекает час из времени	   

-- логический тип:

boolean - 'true','y','yes','on','1'('false','n','not','off','0')

	create table public.test 
	(is_open_source boolean, 
	db_name text);
	
	insert into public.test 
	values(true, 'psql'),
		  (false, 'orac'),
		  (true, 'mysql'),
		  (false, 'mysql server');
		  
	select *
	from public.test;
	
	explain select *
	from public.test;
	
	select *
	from public.test
	where is_open_source; -- выводит только true

	drop table  public.test;

-- массивы:

	create table public.test
	(name text,
	 mas integer[]);
	
	insert into public.test
	values ('ivan', '{1,2,3,5,6,7}'::integer[]),
		   ('petr', '{1,2,3}'::integer[]),
		   ('igor', '{1,3,6}'::integer[]),
		   ('alex', '{1,6,7}'::integer[]);
	
	select *
	from public.test;
	
	explain select *
	from public.test;
	
	update public.test 
	set mas = mas || 7 -- добавляем в массив
	where name = 'igor';
	
	update public.test 
	set mas = array_append(mas, 2) -- добавляем в массив (array_remove - удалить)
	where name = 'igor';
	
	
	update public.test
	set mas[1]=13        -- заменяем значение по индексу (set mass[1:2]=ARRAY[13,14] или по срезу) 
	where name='igor';
	
	drop table  public.test;
	
-- основные операции с массивами	
	
	select *
	from public.test
	where array_position(mas, 13) is not null  -- выборка из таблицы, найдем тех у кого есть цифра 13
	
	select *
	from public.test
	where mas @> '{13,2}'::integer[];  -- @> - сравнивает левый и правый массив(и 13 и 2)	
	
	select *
	from public.test
	where mas && array[13,2];  -- && - сравнивает левый и и вхождение в правый массив(или 13 или 2)
	
	select *
	from public.test
	where not (mas && array[13,2]);  -- && - сравнивает левый и НЕ вхождение в правый массив(или 13 или 2)
	
	select unnest(mas) as massiv_table
	from public.test
	where name='igor'; -- разоваричиваение массива в виде столба
	
	drop table  public.test;
	
-- Типы JSON:

	CREATE TABLE public.test
	(name text,
	hobbi jsonb);


	INSERT INTO public.test
	VALUES ( 'Ivan',
	'{ "sports": [ "футбол", "плавание" ],
	"home_lib": true, "trips": 3
	}'::jsonb
	),
	( 'Petr',
	'{ "sports": [ "теннис", "плавание" ],
	"home_lib": true, "trips": 2
	}'::jsonb
	),
	( 'Pavel',
	'{ "sports": [ "плавание" ],
	"home_lib": false, "trips": 4
	}'::jsonb
	),
	( 'Boris',
	'{ "sports": [ "футбол", "плавание", "теннис" ],
	"home_lib": true, "trips": 0
	}'::jsonb
	);
	
	select *
	from public.test;

-- основные операции с json

	select *
	from public.test
	where hobbi @> '{ "sports":["футбол"] }'::jsonb; -- @> - сравнивает левый и правый массив
	
	select name, hobbi->'sports' as sports
	from public.test
	where hobbi->'sports' @> '["футбол"]'::jsonb; -- hobbi->'sports' обращение к ключу sports
	
	select count(*)
	from public.test
	where hobbi ? 'sports'; -- проверим сколько ключей 'sports'
	
	update public.test
	set hobbi = hobbi || '{ "sports":["хоккей"] }' -- изменение json
	where name = 'Boris';
	
	update public.test
	set hobbi = jsonb_set(hobbi, '{sports, 1}', '"футбол"') -- изменение json с помощью json_set, добавил элемент под индексом 1
	where name = 'Boris';	                                -- jsonb_set(target jsonb, path text[], new_value jsonb [, create_missing boolean]))
	
	drop table public.test;
-- Контрольный вопросы ГЛАВЫ 4

-- 1
create table public.test_numeric
(
number numeric(5,2),
descript text
);

insert into public.test_numeric (number, descript)
values 
    (999.9999, 'первое измен'),
	(999.9009, 'второе измен'),
	(999.1111, 'третье измен'),
	(998.9999, 'четвертое измен');
-- ОТВЕТ: ОШИБКА: переполнение поля numeric

drop table public.test_numeric;

-- 2
create table public.test_numeric
(
	number numeric,
	descript text
);

insert into public.test_numeric
values
(1234567890.0987654321, 'точность 20, масштаб 10'),
(1.5, 'точность 2, масштаб 1'),
(0.12345678901234567890, 'точность 21, масштаб 20'),
(1234567890, 'точность 10, масштаб 0');

select * from public.test_numeric;
	
drop table public.test_numeric;

-- 3
select 'nan'::numeric>1000; -- нумерик поддерживает нан

-- 4
select '5e-307'::double precision > '4e-307'::double precision; -- true. double precision диапазон(1е-307:1е307)
select '5e-324'::double precision > '4e-324'::double precision; -- false. Так как сильно выходит за диапазон

select '5e-37'::real > '4e-37'::real; -- true. double precision диапазон(1е-37:1е37)
select '5e-47'::real > '4e-47'::real; -- ОШИБКА:  "5e-47" вне диапазона для типа real.

-- 5
select '-inf'::double precision > '4e-307' -- double precision поддерживает inf и -inf
select '-inf'::real > '4e-37' -- real поддерживает inf и -inf

-- 6
select 0.0*'inf'::real; -- real and double precision поддерживает  NaN
select 'nan'::real>'inf'::real; -- nan больше любого друго числа

-- 7 
create table public.test_serial -- тип сериал служит для проствления суррогатны уникальных ключей
(
	id serial,
	name text
);

insert into public.test_serial (name)
values
('вишевая'),
('малиновая'),
('черниковая');

select * from public.test_serial;

insert into public.test_serial -- не влияет на автоматич проставление id
values
(10, 'ягодная');

select * from public.test_serial;

insert into public.test_serial(name)
values
('плодовая');

select * from public.test_serial;

drop table public.test_serial;
/*
id    name

1	"вишевая"
2	"малиновая"
3	"черниковая"
10	"ягодная"
4	"плодовая"
*/

-- 8 
create table public.test_serial 
(
	id serial primary key,
    name text
);

insert into public.test_serial(name) -- добавляю улицу
values('vishnevai');
select * from public.test_serial;

insert into public.test_serial(id, name) -- добавляю улицу с индексом
values(2, 'yablochnay');
select * from public.test_serial;

insert into public.test_serial(name) 
values('grushevay');
-- ошибка, повторяющейся первичный ключ
select * from public.test_serial;

insert into public.test_serial(name) 
values('grushevay');
select * from public.test_serial;

insert into public.test_serial(name) 
values('zelenay');
select * from public.test_serial;

delete from public.test_serial where id=4; -- удаляю улицу
select * from public.test_serial;

insert into public.test_serial(name) -- получаю пропуск id под номером 4
values('jultay');
select * from public.test_serial;
-- сериал распределяется последовательно!
drop table public.test_serial

-- 9
/* в psql исп григорианский календарь */ 

-- 10
/* ограничение даты: 4713 до н. э - 294276 н. э. точность 1 микросек */ 

-- 11
/* зададим точность времени */
select current_time::time;
select '2016-12-31'::timestamp;
select ('2016-12-31'::timestamp - '2016-12-21'::timestamp)::interval;

select current_time::time(0);
select '2016-12-31 08:34:29.663461'::timestamp(0);
select ('2016-12-31 08:34:29.663461'::timestamp - '2016-12-21 08:24:25.451278'::timestamp)::interval(0);

select current_time::time(3);
select '2016-12-31 08:34:29.663461'::timestamp(3);
select ('2016-12-31 08:34:29.663461'::timestamp - '2016-12-21 08:24:25.451278'::timestamp)::interval(3);
/* у date точность 1 1 день */

-- 12

show datestyle; -- формат даты

select '18-05-2016'::date;
-- ВЫВОД: 2016-05-18
select '18-05-2016 23:59:15.15'::timestamp;
-- ВЫВОД: 2016-05-18 23:59:15.15

select '05-18-2016'::date;
-- ОШИБКА:  значение поля типа date/time вне диапазона: "05-18-2016"
select '05-18-2016 23:59:15.15'::timestamp;
-- ОШИБКА: значение поля типа date/time вне диапазона: "05-18-2016 23:59:15.15"

set datestyle to 'MDY'; -- меняем формат ввода даты;

select '18-05-2016'::date; -- ТЕПЕРЬ эта запись вызывает ошибку!!
-- ОШИБКА:  значение поля типа date/time вне диапазона: "18-05-2016"

select '05-18-2016'::date;
-- ВЫВОД: 2016-05-18

set datestyle to default; -- приводим в исходное ссотоние формат записи даты

set datestyle to 'Postgres, MDY'; -- меняем формат ввода даты и iso на postgres;
show datestyle; -- формат даты

select '05-18-2016'::date;
-- ВЫВОД: 05-18-2016 (не переставляет местами как iso)
select '05-18-2016 23:59:15.15'::timestamp;
-- ВЫВОД: Wed May 18 23:59:15.15 2016 

set datestyle to default;
/* так же есть форматы дат: iso, postgres, sql, german */

-- 13
-- 14

-- 15
/*преобразует время в текст to_char(timestamp, text) */
select to_char(current_timestamp, 'mi:ss');
select to_char(current_timestamp, 'dd');
select to_char(current_timestamp, 'yyyy-mm-dd');

-- 16 
select 'feb 30, 2016'::date;
/* недопустимое значение  */ 

-- 17 
select '01:61:45.51'::time;
/* недопустимое значение  */ 

-- 18
select ('2016-12-31'::date - '2016-12-21'::date);
-- формат integer а не interval 

-- 19 
select ('11:59:45'::time - '11:49:45'::time);
-- формат interval

select ('11:59:45'::time + '11:49:45'::time);
-- ОШИБКА:  оператор не уникален:

-- 20 
select (current_timestamp - '2016-12-31 23:59:56.45'::timestamp);
-- формат interval

select (current_timestamp + '1 mon'::interval);
-- формат timestampЮ прибавляет 1 месяц к дате

-- 21
select ('2016-01-31'::date + '1 mon'::interval);
-- в итоге полчается послдений день ферваля
select ('2016-02-29'::date + '1 mon'::interval);
-- а тут 29 марта

-- 22
/* стиль ввода интервала */
show intervalstyle;
et intervalstyle to ( postgres_verbose, sql_standard )
set intervalstyle to default

-- 23
select ('2016-12-31'::date - '2016-12-21'::date);
-- тут получится чилсло в фрмате integer

select ('2016-12-31'::timestamp - '2016-12-21'::timestamp);
-- тут получится интервал в фрмате interval

-- 24
select ('20:59:45'::time - 1);
-- выдает ошибку ('1 h'::interval а вот так работает)

select ('2016-12-31'::date - 1);
-- выичтает 1 день

-- 25
/* усечение */
select date_trunc('sec', '2016-12-31 23:59:15.15'::timestamp); 

select date_trunc('week', '2016-12-31 23:59:15.15'::timestamp); 
-- вывод:  2016-12-26 00:00:00

-- 26
/* усечение */
select date_trunc('hour', '23:59:15.15'::interval)

-- 27
/* извлечение */
select extract('sec' from '2016-12-31 23:59:15.15'::timestamp);
-- формат numeric 

-- 28
/* извлечение */
select extract('minute' from '23:59:15.15'::interval)
-- формат numeric 

-- 29 
	create table public.test 
	(is_open_source boolean, 
	db_name text);
	
	insert into public.test 
	values(true, 'psql'),
		  (false, 'orac'),
		  (true, 'mysql'),
		  (false, 'mysql server'); 
		  
/* проверим равнозначность команд */
select * from public.test where not is_open_source; 
select * from public.test where is_open_source <> 'yes';
select * from public.test where is_open_source <> 't';
select * from public.test where is_open_source <> '1';
select * from public.test where is_open_source <> 1; -- ВЫДАЁТ ОШИБКУ boolean <> integer

drop table public.test;

-- 30
create table public.test
(
	a boolean,
	b text
)

INSERT INTO public.test VALUES ( TRUE, 'yes' );
INSERT INTO public.test VALUES ( yes, 'yes' );  --  столбец "yes" не существует   
INSERT INTO public.test VALUES ( 'yes', true );
INSERT INTO public.test VALUES ( 'yes', TRUE );
INSERT INTO public.test VALUES ( '1', 'true' );
INSERT INTO public.test VALUES ( 1, 'true' ); -- столбец "a" имеет тип boolean, а выражение - integer
INSERT INTO public.test VALUES ( 't', 'true' );
INSERT INTO public.test VALUES ( 't', truth ); -- столбец "truth" не существует
INSERT INTO public.test VALUES ( true, true );
INSERT INTO public.test VALUES ( 1::boolean, 'true' );
INSERT INTO public.test VALUES ( 111::boolean, 'true' );

select * from public.test;

drop table public.test;

-- 31 
create table public.test
(person text not null,
birthday date not null);

insert into public.test values ('Ken Thompson', '1955-03-23');
insert into public.test values ('Ben Johnson', '1971-03-19');
insert into public.test values ('Andy Gibson', '1987-08-12');

select * from public.test;

select * from public.test
where extract('mon' from birthday) = 3; 

/* кому на данный момент 40*/ 
select *, birthday + '40 years'::interval as years_40
from public.test
where birthday + '40 years'::interval < current_timestamp;

select *, birthday + '40 years'::interval as years_40
from public.test
where birthday + '40 years'::interval < current_date;

/* точный возраст каждого человека */
select *, 
(current_timestamp - birthday::timestamp) as days,  -- интервал с форматом date не работает!
age(birthday::timestamp)  
from public.test;

drop table public.test;

-- 32 
SELECT array_cat( ARRAY[ 1, 2, 3 ], ARRAY[ 3, 5 ] );
SELECT array_append( ARRAY[ 1, 2, 3 ], 5 );

SELECT array_remove( ARRAY[ 1, 2, 3 ], 3 );

/* https://postgrespro.ru/docs/postgresql/15/functions-array */ 

-- 33
CREATE TABLE public.test
( pilot_name text,
schedule integer[],
meal text[]
);

INSERT INTO public.test
VALUES ( 'Ivan', '{ 1, 3, 5, 6, 7 }'::integer[],
'{ "сосиска", "макароны", "кофе" }'::text[]
),
( 'Petr', '{ 1, 2, 5, 7 }'::integer [],
'{ "котлета", "каша", "кофе" }'::text[]
),
( 'Pavel', '{ 2, 5 }'::integer[],
'{ "сосиска", "каша", "кофе" }'::text[]
),
( 'Boris', '{ 3, 5, 6 }'::integer[],
'{ "котлета", "каша", "чай" }'::text[]
);

select * from public.test;

select * from public.test
where meal[1]='сосиска';

drop table public.test;

/* создать таблицу с двумерным массивом */ 
CREATE TABLE public.test
( pilot_name text,
schedule integer[],
meal text[]
);

INSERT INTO public.test
VALUES ( 'Ivan', '{ 1, 3, 5, 6, 7 }'::integer[],
'{ 
	{ "сосиска", "макароны", "кофе" },
	{ "котлета", "каша", "кофе" },
	{ "сосиска", "каша", "кофе" },
	{ "котлета", "каша", "чай" }  
}'::text[][]
),
( 'Petr', '{ 1, 2, 5, 7 }'::integer [],
'{ 
	{ "сосиска", "макароны", "кофе" },
	{ "котлета", "каша", "кофе" },
	{ "сосиска", "каша", "кофе" },
	{ "котлета", "каша", "чай" }  
}'::text[][]
),
( 'Pavel', '{ 2, 5 }'::integer[],
'{ 
	{ "сосиска", "макароны", "кофе" },
	{ "котлета", "каша", "кофе" },
	{ "сосиска", "каша", "кофе" },
	{ "котлета", "каша", "чай" }  
}'::text[][]
),
( 'Boris', '{ 3, 5, 6 }'::integer[],
'{ 
	{ "сосиска", "макароны", "кофе" },
	{ "котлета", "каша", "кофе" },
	{ "сосиска", "каша", "кофе" },
	{ "котлета", "каша", "чай" }  
}'::text[][]
);

select * from public.test;

select * from public.test
where meal[1][1]='сосиска';

drop table public.test;

-- 34 

CREATE TABLE public.test
	(name text,
	hobbi jsonb);


INSERT INTO public.test
	VALUES ( 'Ivan',
	'{ "sports": [ "футбол", "плавание" ],
	"home_lib": true, "trips": 3
	}'::jsonb
	),
	( 'Petr',
	'{ "sports": [ "теннис", "плавание" ],
	"home_lib": true, "trips": 2
	}'::jsonb
	),
	( 'Pavel',
	'{ "sports": [ "плавание" ],
	"home_lib": false, "trips": 4
	}'::jsonb
	),
	( 'Boris',
	'{ "sports": [ "футбол", "плавание", "теннис" ],
	"home_lib": true, "trips": 0
	}'::jsonb
	);
	
select *
from public.test;
	
	
/*Замена значений в json */
UPDATE public.test
SET hobbi = jsonb_set( hobbi, '{ trips }', '10' )
WHERE name = 'Pavel';

/*Разворачиваем json */
SELECT name, hobbi->'trips' AS trips FROM public.test;

/* изменения по ключу home_lib*/
update public.test
set hobbi = jsonb_set( hobbi, '{ home_lib }', 'true');

select name, hobbi -> 'home_lib' as home_lib 
from public.test;

drop table public.test;

-- 35
SELECT '{ "sports": "хоккей" }'::jsonb || '{ "trips": 5 }'::jsonb;

/* https://postgrespro.ru/docs/postgresql/15/functions-json */ 

-- 36 
CREATE TABLE public.test
	(name text,
	hobbi jsonb);


INSERT INTO public.test
	VALUES ( 'Ivan',
	'{ "sports": [ "футбол", "плавание" ],
	"home_lib": true, "trips": 3
	}'::jsonb
	),
	( 'Petr',
	'{ "sports": [ "теннис", "плавание" ],
	"home_lib": true, "trips": 2
	}'::jsonb
	),
	( 'Pavel',
	'{ "sports": [ "плавание" ],
	"home_lib": false, "trips": 4
	}'::jsonb
	),
	( 'Boris',
	'{ "sports": [ "футбол", "плавание", "теннис" ],
	"home_lib": true, "trips": 0
	}'::jsonb
	);
	
select *
from public.test;

insert into public.test
values
('Gosha', 
'{"sports": "tennis"}'::jsonb||
'{"trips": 15}'::jsonb ||
'{"home_lib": false}'::jsonb);
 
select *
from public.test;

-- 37 
select '{"a": "b", "c": "d"}'::jsonb - 'a';
-- ОТВЕТ: {"c": "d"}

update public.test
set name = name - 'Boris'; -- ?? не понял как с помощью оператора - удалить ключ ??

drop table public.test
 
-- ГЛАВА 5 

/* DEFAULT */
-- Значение по умолчанию, если его нет, то заполняется таблица null
create table public.test
( 
	name text not null,
	number numeric(2) default 25,
	text text default 'ok',
	number serial -- равно: integer DEFAULT nextval('products_product_no_seq') 
);

insert into public.test values
('igor'),
('stas');

select * from public.test;

drop table public.test

/* CHECK */ 
-- ограничения-проверки 
create table public.test
( 
	term numeric( 1 ), --CHECK ( term = 1 OR term = 2 ), Так дает имя ограничению автоматичсеки
	CONSTRAINT valid_term CHECK ( term = 1 OR term = 2 ), -- А так мы сами имя ограничения назначем
    mark numeric( 1 ), -- CHECK ( mark >= 3 AND mark <= 5 ),
	CONSTRAINT valid_mark CHECK ( mark >= 3 AND mark <= 5 )
);

insert into public.test values
(1,5),
(2,4);

select * from public.test;

psql: \d public.test -- структура таблицы
/* 
Таблица "public.test"
 Столбец |     Тип      | Правило сортировки | Допустимость NULL | По умолчанию
---------+--------------+--------------------+-------------------+--------------
 term    | numeric(1,0) |                    |                   |
 mark    | numeric(1,0) |                    |                   |
Ограничения-проверки:
    "valid_mark" CHECK (mark >= 3::numeric AND mark <= 5::numeric)
    "valid_term" CHECK (term = 1::numeric OR term = 2::numeric)
*/

drop table public.test



 
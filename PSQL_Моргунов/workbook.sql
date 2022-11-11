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

psql: \d public.test; -- структура таблицы
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

drop table public.test;

/* NOT NULL */ 
-- или CHECK ( column_name IS NOT NULL) 
create table public.test
( 
	term numeric( 1 ) not null
);

insert into public.test values
(1),
(5);

psql: \d public.test; -- структура таблицы
		/* 
		Таблица "public.test"
		 Столбец |     Тип      | Правило сортировки | Допустимость NULL | По умолчанию
		---------+--------------+--------------------+-------------------+--------------
		 term    | numeric(1,0) |                    | not null          |
		*/
drop table public.test;
 
/* unique */ 
-- все значения в стобце уникальные
CREATE TABLE public.test
( 
	doc_ser numeric( 4 ),
	doc_num numeric( 6 ),
	CONSTRAINT unique_passport UNIQUE ( doc_ser, doc_num )
);

psql: \d public.test; -- структура таблицы
		/* 
		Таблица "public.test"
		 Столбец |     Тип      | Правило сортировки | Допустимость NULL | По умолчанию		
		---------+--------------+--------------------+-------------------+--------------		
		 doc_ser | numeric(4,0) |                    |                   |					   
		 doc_num | numeric(6,0) |                    |                   |					   
		Индексы:
			"unique_passport" UNIQUE CONSTRAINT, btree (do
		c_ser, doc_num)
		*/
drop table public.test;

/* первичный ключ(primary key) */
-- первичный ключ = unique + not null
create table public.test 
(
	number_count numeric(5) primary key, -- задание первичного ключа (вар 1)
    ...
)

create table public.test 
(
	number_count numeric(5), -- задание первичного ключа (вар 2)
	primary key ( number_count )
    ...
)

--составной первичный ключ
...
primary key ( col_name_1, col_name_2 )
...

/* внешний ключ(foreign key) */

-- поддержание ссылочной целостности
/* 
ссылочная таблица - студенты
ссылающаяся таблица - предметы
*/
create table test
(
	predmet text references students( student_id ), -- создать внешний ключ в виде ограничения
	...
) -- нельзя в test.predmet внести строку которой нет в students.student_id

-- если внешний ключ ссылается на первичный то запись:
create table test
(
	predmet text references students, 
	...
);

-- можно так же записать как ограничение
create table test
(
	predmet text,
	... ,
	foreign key ( predmet )
		references students ( students_id )
);

-- каскадное удаление
create table test
(
	predmet text,
	... ,
	foreign key ( predmet )
	    references students ( student_id )
	    on cascade delete
);

-- запрет удаления если есть данные в ссылающейся таблице
create table test
(
	predmet text,
	... ,
	foreign key ( predmet )
	    references students ( student_id )
	    on delete restrict
);

       /* ИЛИ */
	   
create table test
(
	predmet text,
	... ,
	foreign key ( predmet )
	    references students ( student_id )
);

-- присваивание атрибутам внешнего ключа NULL
create table test
(
	predmet text, -- отсутсвует огранчение not null!
	... ,
	foreign key ( predmet )
	    references students ( students_id )
	    on delete set null
);

-- присваивание атрибутам внешнего ключа default(автоматом null)
create table test
(
	predmet text, -- отсутсвует огранчение not null!
	... ,
	foreign key ( predmet )
	    references students ( students_id )
	    on delete set default
);

-- при выполенение update
create table test
(
	predmet text, -- отсутсвует огранчение not null!
	... ,
	foreign key ( predmet )
	    references students ( students_id )
	    on update cascade
);
	   
-- СОЗДАДИМ теперь самостоятельно таблицу студенты и успеваемость

-- создадим базу данных
create database univer;

-- подключимся к ней
\connect database univer; -- в psql

-- создадим таблицу students
create table public.students
(
	record_book numeric(5) not null,
	name text not null,
	doc_ser numeric(4),
	doc_num numeric(6),
	primary key ( record_book )
);

-- создадим таблицу  progress
create table public.progress
(
	record_book numeric(5) not null,
	subject text not null,
	acad_year text not null,
	term numeric(1) not null check (term=1 or term=2),
	mark numeric(1) not null check (mark<=3 and mark<=5)
		default 5,
	foreign key ( record_book ) 
		references public.students (record_book)
		on delete cascade
		on update cascade
);

-- удаляем все это!	   
DROP DATABASE univer;
DROP table public.students;
DROP table public.progress;

-- Создание и удаление таблиц
-- Выберите в качестве текущей схемы схему bookings:
SET search_path TO bookings;

-- подключится к базе
\connect demo -- \c demo

-- Добавляем комментарий  к столбцу
COMMENT ON COLUMN airports.city IS 'Город';

-- Удвление по каскадной схеме
DROP TABLE aircrafts CASCADE;

-- Пропускаем удаленные таблицы, и удаляет другие по связям
DROP TABLE IF EXISTS aircrafts CASCADE;

-- ПРИМЕРЫ СОЗДАНИЯ ТАБЛИЦ ПРИВЕДЕНЫ В КНИГЕ, СЮДА ИХ КОПИРОВАТЬ НЕ БУДЕМ!

-- МОДИФИКАЦИЯ ТАБЛИЦ
ALTER TABLE table ADD COLUMN ... -- или DROP COLUMN, ADD CHECK, ADD CONSTRAINT

-- Пример
alter table aircrafts 
	add column speed integer not null check ( speed >= 300 );
-- выдаст ошибку так как в таблице уже были строки других атрибутов

-- РЕШЕНИЕ
alter table aircrafts add column speed integer; -- добавляем атрибут
-- ???
alter table test alter column speed drop not null; -- удаляем ограничение
alter table test drop constraint test_speed_check; -- удаляем ограничение

\d aircrafts_data; -- что бы выяснить ограничения

-- ИЗМЕНЕНИЕ ТИПА ДАННЫХ 
alter table test
	alter column speed set data type numeric(5,2),
	alter column weihgt set data type numeric(5,2);

-- меняет текстовый формат на числовой
ALTER TABLE seats 
	DROP CONSTRAINT seats_fare_conditions_check, -- удаляем органичение
	ALTER COLUMN fare_conditions SET DATA TYPE integer
		USING ( CASE WHEN fare_conditions = 'Economy' THEN 1
					WHEN fare_conditions = 'Business' THEN 2
					ELSE 3 END
			);

-- добавляем внешний ключ
ALTER TABLE seats
	ADD FOREIGN KEY ( fare_conditions )
		REFERENCES fare_conditions ( fare_conditions_code );
		
-- переименнуем столбец
ALTER TABLE seats
	RENAME COLUMN fare_conditions TO fare_conditions_code;

-- переименнуем ограничение
ALTER TABLE seats
	RENAME CONSTRAINT seats_fare_conditions_fkey
	TO seats_fare_conditions_code_fkey;
	
-- ПРЕДСТАВЛЕНИЯ
-- что бы не выполнять один и теже запросы, можно сохранить их в представления
create view bookings.test_view as 
	select count(aircraft_code)
	from aircrafts_data;
	
select *
from bookings.test_view;

\x -- psql отключение расширенного просмотра

DROP VIEW IF EXISTS flights_v; -- исключение ошибок при удаление представления

-- материализованное представление(сохраняет с данными) 
create materialized view bookings.test_mat_view as 
	select count(aircraft_code)
	from aircrafts_data
	WITH NO DATA; -- записываю его без даннных
	
REFRESH MATERIALIZED VIEW bookings.test_mat_view; -- обновляю данные
	
select *
from bookings.test_mat_view;

drop view bookings.test_view;
drop materialized view bookings.test_mat_view;

-- СХЕМА БАЗЫ ДАННЫХ
psql: \dn -- просмотр схем БД
SET search_path = bookings; -- организация доступа к схеме т.е. вместо (SELECT * FROM bookings.aircrafts;)

SHOW search_path; -- посмотреть значения

SELECT current_schema; -- узнать имя текущей схемы

-- Контрольные вопросы и задания
-- 1 
CREATE TABLE students
( record_book numeric( 5 ) NOT NULL,
  name text NOT NULL,
  doc_ser numeric( 4 ),
  doc_num numeric( 6 ),
  who_adds_row text DEFAULT current_user, -- добавленный столбец
  PRIMARY KEY ( record_book )
);

select *
from students;

alter table students
	add column add_time timestamp default current_timestamp;
	
insert into students (record_book, name, doc_ser, doc_num) values
(1, 'rob', 1, 1),
(2, 'bob', 2, 2);

/*
1	"rob"	1	1	"postgres"	"2022-11-08 10:32:05.386342"
2	"bob"	2	2	"postgres"	"2022-11-08 10:32:05.386342"
*/
DROP TABLE students;

-- 2
create table progress
(
	record_book numeric(5) not null,
	subject text not null,
	acad_year text not null,
	term numeric(1) not null check (term=1 or term=2),
	mark numeric(1) not null check (mark>=3 and mark<=5)
		default 5,
	foreign key ( record_book ) 
		references students (record_book)
		on delete cascade
		on update cascade
);

alter table progress
	add column test_form text not null,
	add check (
		test_form = 'экзамен' and mark in (3,4,5)
		or
		test_form = 'зачет' and term in (0,1)
		);

select * from progress;

insert into students (record_book, name, doc_ser, doc_num) values
(1, 'rob', 1, 1),
(2, 'bob', 2, 2);

DROP TABLE students;
DROP TABLE progress;

-- ГЛАВА 6

-- SELECT
select * from aircrafts;
select * from airports;

SELECT * FROM aircrafts WHERE model LIKE 'Airbus%'; -- начинеатся на Airbus

SELECT * FROM airports WHERE airport_name LIKE '___'; -- слово из трех букв

-- регулярными выражениями POSIX

SELECT * FROM aircrafts WHERE model ~ '^(A|Boe)';
-- ~ ищет совпадение с шаблоном
-- ^ в начале строки
-- \ начлие слова в составе строки
-- (A|Boe) альтернативный выбор
-- !~ (300$) конец строки 
-- $ привязка поиского шаблона к концу строки 

SELECT * FROM aircrafts WHERE range BETWEEN 3000 AND 6000; -- между диапозоном

SELECT model, range, round( range / 1.609, 2 ) AS miles
	FROM aircrafts; -- перевод в мили
	
SELECT * FROM aircrafts ORDER BY range DESC; -- сортировка от большего к меньшему

-- distinct невоторяющиеся значения и к столбцу обраились по порядковому номеру!
SELECT DISTINCT timezone FROM airports ORDER BY 1; 

-- limit и offset
SELECT airport_name, city, longitude
FROM airports
ORDER BY longitude DESC
LIMIT 3 -- оставляем три записи
OFFSET 3; -- пропускаем первые три записи

-- case when end 
SELECT model, range,
  CASE 
	WHEN range < 2000 THEN 'Ближнемагистральный'
	WHEN range < 5000 THEN 'Среднемагистральный'
	ELSE 'Дальнемагистральный'
  END AS type
FROM aircrafts
ORDER BY model;

-- СОЕДИНЕНИЯ 
-- inner join-внуто соед, left join, right join, full outer join-внешнее соед
SELECT s.seat_no, s.fare_conditions
FROM seats s
JOIN aircrafts a ON s.aircraft_code = a.aircraft_code
WHERE a.model ~ '^Cessna'
ORDER BY s.seat_no;

-- тоже самое 
SELECT a.aircraft_code, a.model, s.seat_no, s.fare_conditions
FROM seats s, aircrafts a
WHERE s.aircraft_code = a.aircraft_code
AND a.model ~ '^Cessna'
ORDER BY s.seat_no;

-- пример запроса
SELECT r.min_sum, r.max_sum, count( b.* )
FROM bookings b
RIGHT OUTER JOIN
( VALUES ( 0, 100000 ), ( 100000, 200000 ), -- создаем виртуальную таблицу
( 200000, 300000 ), ( 300000, 400000 ),
( 400000, 500000 ), ( 500000, 600000 ),
( 600000, 700000 ), ( 700000, 800000 ),
( 800000, 900000 ), ( 900000, 1000000 ),
( 1000000, 1100000 ), ( 1100000, 1200000 ),
( 1200000, 1300000 )
) AS r ( min_sum, max_sum )
ON b.total_amount >= r.min_sum AND b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
ORDER BY r.min_sum;

-- UNION для вычисления объединения множеств строк из двух выборок;
SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
UNION
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

-- INTERSECT для вычисления пересечения множеств строк из двух выборок;
SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
INTERSECT
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
ORDER BY arrival_city;

-- EXCEPT для вычисления разности множеств строк из двух выборок.
SELECT arrival_city FROM routes
WHERE departure_city = 'Санкт-Петербург'
EXCEPT
SELECT arrival_city FROM routes
WHERE departure_city = 'Москва'
ORDER BY arrival_city;

-- АГРЕГИРОВАНИЕ И ГРУППИРОВКА

-- avg(), min(), max(), count(*)
-- HAVING — уже после выполнения группировки

-- ОКОННЫЕ ФУНКЦИИ

count( * ) OVER ( -- оконная функция
PARTITION BY date_trunc( 'month', b.book_date ) -- правило разбиение строк
ORDER BY b.book_date
) AS count

SELECT airport_name, city, timezone, latitude,
first_value( latitude ) OVER tz AS first_in_timezone,
latitude - first_value( latitude ) OVER tz AS delta,
rank() OVER tz
FROM airports
WHERE timezone IN ( 'Asia/Irkutsk', 'Asia/Krasnoyarsk' )
WINDOW tz AS ( PARTITION BY timezone ORDER BY latitude DESC )
ORDER BY timezone, rank;

-- ПОДЗАПРОСЫ
-- SELECT, FROM, WHERE и HAVING, WITH - можно испол подзапросы

SELECT count( * ) FROM bookings
WHERE total_amount > -- или in что бы проверить принадлежность
( SELECT avg( total_amount ) FROM bookings );

-- определить факт наличия используем exsist
SELECT DISTINCT a.city
FROM airports a
WHERE NOT EXISTS (
SELECT * FROM routes r
WHERE r.departure_city = 'Москва'
AND r.arrival_city = a.city
)
AND a.city <> 'Москва'
ORDER BY city;

-- использование  string_agg
SELECT s2.model,
string_agg(
s2.fare_conditions || ' (' || s2.num || ')',
', '
)
FROM (
SELECT a.model,
s.fare_conditions,
count( * ) AS num
FROM aircrafts a
JOIN seats s ON a.aircraft_code = s.aircraft_code
GROUP BY 1, 2
ORDER BY 1, 2
) AS s2
GROUP BY s2.model
ORDER BY s2.model;
/* 
Подзапрос формирует временную таблицу в таком виде:
model | fare_conditions | num
---------------------+-----------------+-----
Airbus A319-100 | Business | 20
Airbus A319-100 | Economy | 96
...
Sukhoi SuperJet-100 | Business | 12
Sukhoi SuperJet-100 | Economy | 85
(17 строк)
А в главном (внешнем) запросе используется агрегатная функция string_agg 
model | string_agg
---------------------+--------------------------------------------
Airbus A319-100 | Business (20), Economy (96)
Airbus A320-200 | Business (20), Economy (120)
Airbus A321-200 | Business (28), Economy (142)
Boeing 737-300 | Business (12), Economy (118)
Boeing 767-300 | Business (30), Economy (192)
Boeing 777-300 | Business (30), Comfort (48), Economy (324)
Bombardier CRJ-200 | Economy (50)
Cessna 208 Caravan | Economy (12)
Sukhoi SuperJet-100 | Business (12), Economy (85)
(9 строк)
*/

-- общее табличное выражение (Common Table Expression — CTE).
-- испол констр WITH ts AS (...)
WITH ts AS
( SELECT f.flight_id,
f.flight_no,
f.scheduled_departure_local,
f.departure_city,
f.arrival_city,
f.aircraft_code,
count( tf.ticket_no ) AS fact_passengers,
( SELECT count( s.seat_no )
FROM seats s
WHERE s.aircraft_code = f.aircraft_code
) AS total_seats
FROM flights_v f
JOIN ticket_flights tf ON f.flight_id = tf.flight_id
WHERE f.status = 'Arrived'
GROUP BY 1, 2, 3, 4, 5, 6
)
SELECT ts.flight_id,
ts.flight_no,
ts.scheduled_departure_local,
ts.departure_city,
ts.arrival_city,
a.model,
ts.fact_passengers,
ts.total_seats,
round( ts.fact_passengers::numeric /
ts.total_seats::numeric, 2 ) AS fraction
FROM ts
JOIN aircrafts AS a ON ts.aircraft_code = a.aircraft_code
ORDER BY ts.scheduled_departure_local;

-- рекурсивного общего табличного выражения:
-- вместо вирт таблицу values (0,100000), (100000, 200000)...
WITH RECURSIVE ranges ( min_sum, max_sum ) AS
( VALUES ( 0, 100000 )
UNION ALL -- UNION выполняется устранение строк-дубликатов
SELECT min_sum + 100000, max_sum + 100000
FROM ranges
WHERE max_sum <
( SELECT max( total_amount ) FROM bookings )
)
SELECT * FROM ranges;

-- КОНТРОЛЬНЫЕ ВОПРОСЫ
-- Решение позже 

-- ГЛАВА 7

-- вставка строк в талицах
-- создадим временные таблицы 
CREATE TEMP TABLE aircrafts_tmp AS
	SELECT * FROM aircrafts WITH NO DATA;
	
CREATE TEMP TABLE aircrafts_log AS
	SELECT * FROM aircrafts WITH NO DATA;
	
SELECT * FROM aircrafts_tmp;
SELECT * FROM aircrafts_log;

drop table aircrafts_tmp;
drop table aircrafts_log;

-- создадим огрнаничения для временной таблицы
ALTER TABLE aircrafts_tmp
	ADD PRIMARY KEY ( aircraft_code );

ALTER TABLE aircrafts_tmp
	ADD UNIQUE ( model );

ALTER TABLE aircrafts_log
	ADD COLUMN when_add timestamp;

ALTER TABLE aircrafts_log
	ADD COLUMN operation text;

-- Алтернатива для создания временной(можно и постоянной) таблицы с like 
CREATE TEMP TABLE aircrafts_tmp
	( LIKE aircrafts INCLUDING CONSTRAINTS INCLUDING INDEXES );

-- в log мы записываем все операции что происходят с tmp
-- так же есть правила rules(правило перезаписи)
WITH add_row AS
( INSERT INTO aircrafts_tmp -- копируем данные из таблицы aircrafts
		SELECT * FROM aircrafts
		RETURNING * -- возвращает строки во внешний запрос
)
INSERT INTO aircrafts_log
	SELECT add_row.aircraft_code, add_row.model, add_row.range,
		current_timestamp as when_add, 'INSERT' as operation
	FROM add_row;
	
SELECT * FROM aircrafts_tmp;
SELECT * FROM aircrafts_log;

drop table aircrafts_tmp;
drop table aircrafts_log;

-- ON CONFLICT(обработка ошибок) при вставке новых строк если есть ошибка он ее не выдаст и 
-- строку не добавит 
WITH add_row AS
( INSERT INTO aircrafts_tmp
	VALUES ( 'SU6', 'Sukhoi SuperJet-100', 3000 ) -- SU9 insert 0 0(так как строка есть уже) SU7 insert 0 1
	ON CONFLICT DO NOTHING -- ON CONFLICT(aircraft_code) DO NOTHING так же можно указывать по столбцу что бы ошибки пропускал
	RETURNING *
)
INSERT INTO aircrafts_log
	SELECT add_row.aircraft_code, add_row.model, add_row.range,
		current_timestamp, 'INSERT'
	FROM add_row;

-- для массового ввод строк COPY

COPY aircrafts_tmp FROM '/home/postgres/aircrafts.txt'; -- из таблицы

COPY aircrafts_tmp TO '/home/postgres/aircrafts_tmp.txt' -- в таблицу
WITH ( FORMAT csv );

-- обновления строк в талицах
WITH update_row AS
( UPDATE aircrafts_tmp
	SET range = range * 1.5
	WHERE model ~ '^Su'
	RETURNING *
)
INSERT INTO aircrafts_log
	SELECT ur.aircraft_code, ur.model, ur.range,
		current_timestamp, 'UPDATE'
	FROM update_row ur;

SELECT * FROM aircrafts_tmp;
SELECT * FROM aircrafts_log;

drop table aircrafts_tmp;
drop table aircrafts_log;

-- удаление строк
WITH update_row AS
( DELETE from aircrafts_tmp
	WHERE model ~ '^Su'
	RETURNING *
)
INSERT INTO aircrafts_log
	SELECT ur.aircraft_code, ur.model, ur.range,
		current_timestamp, 'DELETE'
	FROM update_row ur;

SELECT * FROM aircrafts_tmp;
SELECT * FROM aircrafts_log;

drop table aircrafts_tmp;
drop table aircrafts_log;

-- c использованием using
WITH min_ranges AS
( SELECT aircraft_code,
		rank() OVER (
			PARTITION BY left( model, 6 )
			ORDER BY range
	) AS rank
  FROM aircrafts_tmp
  WHERE model ~ '^Airbus' OR model ~ '^Boeing'
)
DELETE FROM aircrafts_tmp a
USING min_ranges mr
WHERE a.aircraft_code = mr.aircraft_code
AND mr.rank = 1
RETURNING *;

-- удаляем все строки
DELETE FROM aircrafts_tmp;
TRUNCATE aircrafts_tmp;

drop table aircrafts_tmp;
drop table aircrafts_log;

-- ГЛАВА 8

-- создание индекса, так же индекс автоматом создается при задание первичного ключа
-- и огрначение уникальности

CREATE INDEX
  ON airports ( airport_name );
  
\timing on --включаем секундомер

SELECT count( * )
FROM tickets
WHERE passenger_name = 'IVAN IVANOV';

-- 191,862 мс, создаем индекс

CREATE INDEX passenger_name
ON tickets ( passenger_name );
-- 1,644 мс, время уменьшолсь значителньо!

\di -- посмотреть все индексы

-- удаление индекса
DROP INDEX имя-индекса;
--либо 
DROP INDEX passenger_name;

-- создание индекса по нескольким столбцам
CREATE INDEX tickets_book_ref_test_key
  ON tickets ( book_ref );

SELECT *
FROM tickets
ORDER BY book_ref
LIMIT 5;
-- 1,369 мс
DROP INDEX tickets_book_ref_test_key;

SELECT *
FROM tickets
ORDER BY book_ref
LIMIT 5;
-- 403,992 мс

CREATE INDEX имя-индекса
  ON имя-таблицы ( имя-столбца NULLS FIRST, ... );
CREATE INDEX имя-индекса
  ON имя-таблицы ( имя-столбца DESC NULLS LAST, ... ); -- убыв порядок индексов, null в конец
  
-- уникальные индексы
CREATE UNIQUE INDEX aircrafts_unique_model_key
  ON aircrafts_data ( model );
  
-- В этом случае мы уже не сможем ввести в таблицу aircrafts строки, имеющие оди-
-- наковые наименования моделей самолетов

-- индексы на основе выражений
CREATE UNIQUE INDEX aircrafts_unique_model_key
  ON aircrafts ( lower( model ) );
-- если захотим добавить модель отличную только регистром то выдаст ошибку
/*Ключ "(lower(model))=(cessna 208 caravan)" уже существует.*/

-- частичные индексы

CREATE INDEX bookings_book_date_part_key
  ON bookings ( book_date )
  WHERE total_amount > 1000000;
-- можно выйграть во времени, но не сильно относительно полных индексов

-- ГЛАВА 9

-- уровень изоляции Read Uncommitted

CREATE TABLE aircrafts_tmp
  AS SELECT * FROM aircrafts;

-- запустим парадллельно два psql и выполним 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SHOW transaction_isolation;

UPDATE aircrafts_tmp
  SET range = range + 100
  WHERE aircraft_code = 'SU9';

SELECT *
  FROM aircrafts_tmp
  WHERE aircraft_code = 'SU9';
-- мы увидим что второй psql не видит изменений в таблице  

-- отменим транзакцию
ROLLBACK;

-- Уровень изоляции Read Committed
CREATE TABLE aircrafts_tmp
  AS SELECT * FROM aircrafts;

-- запустим парадллельно два psql и выполним 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SHOW transaction_isolation;

UPDATE aircrafts_tmp
  SET range = range + 100
  WHERE aircraft_code = 'SU9';

SELECT *
  FROM aircrafts_tmp
  WHERE aircraft_code = 'SU9';
-- мы увидим что второй psql не видит изменений в таблице  

-- завершим транзакцию
END; -- или
COMMIT;

-- Уровень изоляции Repeatable Read

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

INSERT INTO aircrafts_tmp
  VALUES ( 'IL9', 'Ilyushin IL96', 9800 );
  
END; 
-- тут нельзя параллельно менять, пока незавершим первую транзакцию
  


-- Уровень изоляции Serializable

CREATE TABLE modes (
num integer,
mode text
);

INSERT INTO modes VALUES ( 1, 'LOW' ), ( 2, 'HIGH' );

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE modes
SET mode = 'HIGH'
WHERE mode = 'LOW'
RETURNING *;

-- тут  же меняю пераллеьно данные 
commit;

-- не даст закоммитеть, так как есть другие изменения 
-- только последовательно!

-- пример использования транзакции
BEGIN;
-- добавляем строку рейс, время сейчас, цену билетов равную 0
INSERT INTO bookings ( book_ref, book_date, total_amount )
VALUES ( 'ABC123', bookings.now(), 0 );

--добавляем два билета
INSERT INTO tickets ( ticket_no, book_ref, passenger_id, passenger_name)
VALUES ( '9991234567890', 'ABC123', '1234 123456', 'IVAN PETROV' );

INSERT INTO tickets ( ticket_no, book_ref, passenger_id, passenger_name)
VALUES ( '9991234567891', 'ABC123', '4321 654321', 'PETR IVANOV' );

-- считаем стоимость билетов и добавлям в атрибут тотал_амоунт
UPDATE bookings
SET total_amount =
  ( SELECT sum( amount )
    FROM ticket_flights
    WHERE ticket_no IN
       ( SELECT ticket_no
         FROM tickets
         WHERE book_ref = 'ABC123'
       )
    )
WHERE book_ref = 'ABC123';

SELECT *
FROM bookings
WHERE book_ref = 'ABC123';

/* 
book_ref  | book_date              | total_amount
----------+------------------------+--------------
ABC123    | 2016-10-13 22:00:00+08 | 42000.00
*/

COMMIT;

-- БЛОКИРОВКИ

SELECT *
FROM aircrafts_tmp
WHERE model ~ '^Air'
FOR UPDATE; -- блокируем отдельные строки

LOCK TABLE aircrafts_tmp -- блокируем таблицы
IN ACCESS EXCLUSIVE MODE; 
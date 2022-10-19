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
	
	
	
	
	
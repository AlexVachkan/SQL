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
/* 
целочисленные: smallint, integer, bigint
фиксир точность: numeric, decimal(numeric(6,4)=12,1525 точность-6, масштаб-4)






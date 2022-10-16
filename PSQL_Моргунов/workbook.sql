-- \dn вывод схем бд
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

drop table aircraft;
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

select * from bookings.seats


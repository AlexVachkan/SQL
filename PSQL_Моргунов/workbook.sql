create table public.aircraft
(aircraft_code char(3) not null,
model text not null,
range integer not null,
check (range > 0),
primary key (aircraft_code)
);

insert into public.aircraft(aircraft_code,model,range)
values  ('773',	'Боинг 777-300',	11100),
		('763',	'Боинг 767-300',	7900),
		('SU9',	'Сухой Суперджет-100',	3000),
		('320',	'Аэробус A320-200',	5700),
		('321',	'Аэробус A321-200',	5600),
		('319',	'Аэробус A319-100',	6700),
		('733',	'Боинг 737-300',	4200),
		('CN1',	'Сессна 208 Караван',	1200),
		('CR2',	'Бомбардье CRJ-200',	2700);


update public.aircraft
set range = 3500
where aircraft_code='SU9';

delete from public.aircraft
where aircraft_code='CN1';

select * from public.aircraft;

drop table aircraft
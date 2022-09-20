SELECT version();
-- PostgreSQL 14.5

--
-- Создаю таблицу test_data_contract 
--
CREATE TABLE test_data_contract
(customer_id varchar(255) NOT NULL, -- ID клиента.
 contract_id varchar(255) NOT NULL, -- ID контракта.
 contract_code varchar(255) NOT NULL, -- код контракта в CRM.
 marker_delete boolean NOT NULL, -- пометка на удаление.
 issue_dt date NOT NULL, -- дата заключения контракта.
 subdivision_id varchar(255) NOT NULL, -- ID подразделения, заключившего контракт.
 renewal_contract_id varchar(255), -- ID контракта, который стал причиной переоформления.
 PRIMARY KEY (contract_id)
);

--
-- Добавляю комментарий к таблице test_data_contract
--
COMMENT ON TABLE test_data_contract IS 'Общая информация о контрактах';

--
-- Добавляю данные в таблицу test_data_contract
--
COPY test_data_contract FROM	
'C:/Users/test_data_contract.csv'
WITH (FORMAT csv, header);

--
-- Создаю индексы таблицы test_data_contract
--
CREATE INDEX 
ON test_data_contract (contract_id, customer_id);

--
-- Создаю комментарии к колонкам таблицы test_data_contract
--
COMMENT ON COLUMN test_data_contract.customer_id	
IS 'ID клиента';		
COMMENT ON COLUMN test_data_contract.contract_id	
IS 'ID контракта';
COMMENT ON COLUMN test_data_contract.contract_code	
IS 'код контракта в CRM';
COMMENT ON COLUMN test_data_contract.marker_delete	
IS 'пометка на удаление';
COMMENT ON COLUMN test_data_contract.issue_dt	
IS 'дата заключения контракта';
COMMENT ON COLUMN test_data_contract.subdivision_id	
IS 'ID подразделения, заключившего контракт';
COMMENT ON COLUMN test_data_contract.renewal_contract_id	
IS 'ID контракта, который стал причиной переоформления';
-- 
-- ----------------------------------------------------------------------

--
-- Создаю таблицу test_data_contract_conditions 
--
CREATE TABLE test_data_contract_conditions
(condition_id varchar(255) NOT NULL, -- ID изменения условий контракта.
 condition_dt timestamp NOT NULL, -- дата изменения условия.
 contract_id varchar(255) NOT NULL, -- ID контракта.
 conducted boolean NOT NULL, -- признак проведения изменения в CRM.
 marker_delete boolean NOT NULL, -- пометка на удаление.
 operation_type varchar(255) NOT NULL, -- тип операции.
 condition_type varchar(255), -- тип изменения условий.
 condition_start_dt date, -- дата начала действия изменения условий. Относится к сроку действия контракта или продления.
 condition_end_dt date, -- дата окончания действия изменения условий. Относится к сроку действия контракта или продления.
 days numeric, -- срок действия изменения условий в днях.
 PRIMARY KEY (condition_id)
);

--
-- Добавляю комментарий к таблице test_data_contract
--
COMMENT ON TABLE test_data_contract_conditions IS 'Информация об изменении условий контракта, в том числе перенос срока и продление';

--
-- Добавляю данные в таблицу test_data_contract
--
COPY test_data_contract_conditions FROM	
'C:/Users/test_data_contract_conditions.csv'
WITH (FORMAT csv, header);

--
-- Создаю индексы таблицы test_data_contract
--
CREATE INDEX 
ON test_data_contract_conditions (condition_id, contract_id);

--
-- Создаю комментарии к колонкам таблицы test_data_contract
--
COMMENT ON COLUMN test_data_contract_conditions.condition_id	
IS 'ID изменения условий контракта';		
COMMENT ON COLUMN test_data_contract_conditions.condition_dt	
IS 'дата изменения условия';
COMMENT ON COLUMN test_data_contract_conditions.contract_id	
IS 'ID контракта';
COMMENT ON COLUMN test_data_contract_conditions.conducted	
IS 'признак проведения изменения в CRM';
COMMENT ON COLUMN test_data_contract_conditions.marker_delete	
IS 'пометка на удаление';
COMMENT ON COLUMN test_data_contract_conditions.operation_type	
IS 'тип операции';
COMMENT ON COLUMN test_data_contract_conditions.condition_type	
IS 'тип изменения условий';
COMMENT ON COLUMN test_data_contract_conditions.condition_start_dt	
IS 'дата начала действия изменения условий. Относится к сроку действия контракта или продления';
COMMENT ON COLUMN test_data_contract_conditions.condition_end_dt	
IS 'дата окончания действия изменения условий. Относится к сроку действия контракта или продления';
COMMENT ON COLUMN test_data_contract_conditions.days	
IS 'срок действия изменения условий в днях';
-- 
-- ----------------------------------------------------------------------

--
-- Создаю таблицу test_data_contract_conditions_payment_plan 
--
CREATE TABLE test_data_contract_conditions_payment_plan
(condition_id varchar(255) NOT NULL, -- ID изменения условий контракта.
 payment_dt date NOT NULL, -- дата платежа.
 loan_amount numeric NOT NULL--, -- сумма платежа.
 --PRIMARY KEY (condition_id)
);

--
-- Добавляю комментарий к таблице test_data_contract_conditions_payment_plan
--
COMMENT ON TABLE test_data_contract_conditions_payment_plan 
              IS 'План-график выплат по контракту. Генерируется для каждого изменения условий';

--
-- Добавляю данные в таблицу test_data_contract_conditions_payment_plan
--
COPY test_data_contract_conditions_payment_plan FROM	
'C:/Users/test_data_contract_conditions_payment_plan.csv'
WITH (FORMAT csv, header);

--
-- Создаю индексы таблицы test_data_contract_conditions_payment_plan
--
CREATE INDEX 
ON test_data_contract_conditions_payment_plan (condition_id);

--
-- Создаю комментарии к колонкам таблицы test_data_contract_conditions_payment_plan
--
COMMENT ON COLUMN test_data_contract_conditions_payment_plan.condition_id	
IS 'ID изменения условий контракта';		
COMMENT ON COLUMN test_data_contract_conditions_payment_plan.payment_dt	
IS 'дата платежа';
COMMENT ON COLUMN test_data_contract_conditions_payment_plan.loan_amount	
IS 'сумма платежа';
-- 
-- ----------------------------------------------------------------------

--
-- Создаю таблицу test_data_contract_status 
--
CREATE TABLE test_data_contract_status
(contract_id varchar(255) NOT NULL, -- ID контракта.
 status_dt timestamp NOT NULL, -- дата и время статуса контракта.
 status_type varchar(255) NOT NULL--, -- вид статуса контракта.
 --PRIMARY KEY (contract_id)
);

--
-- Добавляю комментарий к таблице test_data_contract_status
--
COMMENT ON TABLE test_data_contract_status 
              IS 'Информация об изменении статуса контракта';

--
-- Добавляю данные в таблицу test_data_contract_status
--
COPY test_data_contract_status FROM	
'C:/Users/test_data_contract_status.csv'
WITH (FORMAT csv, header);

--
-- Создаю индексы таблицы test_data_contract_status
--
CREATE INDEX 
ON test_data_contract_status (contract_id);

--
-- Создаю комментарии к колонкам таблицы test_data_contract_status
--
COMMENT ON COLUMN test_data_contract_status.contract_id	
IS 'ID контракта';		
COMMENT ON COLUMN test_data_contract_status.status_dt	
IS 'дата и время статуса контракта';
COMMENT ON COLUMN test_data_contract_status.status_type	
IS 'вид статуса контракта';
-- 
-- ----------------------------------------------------------------------


--
-- Создаю таблицу v_contract
--
CREATE TABLE v_contract
    (contract_id varchar(255), -- ID контракта.
     contract_code varchar(255), -- Код контракта.
     customer_id varchar(255), -- ID клиента.
	 condition_id varchar(255), -- ID документа о заключении контракта.
	 subdivision_id varchar(255), -- ID подразделения, заключившего контракт.
	 contract_serial_number  numeric not null,
	 contract_renewal_serial_number numeric not null, -- Порядковый номер контракта у клиента без учёта переоформлений.
	 is_renewal boolean, -- Является ли данный контракт переоформлением.
	 is_installment boolean, -- Является ли данный контракт долгосрочным (наличие нескольких платежей в плане погашений).
	 prolong_count numeric, -- Количество продлений.
	 first_issue_dt date, -- Дата первого контракта у клиента.
	 issue_dt date, -- Дата выдачи займа.
	 plan_dt date, -- Дата планового погашения займа.
	 loan_amount numeric, -- Сумма займа. Суммируются все платежи по графику.
	 total_loan_amount numeric, -- Сумма всех предыдущих займов.
	 min_loan_amount numeric, -- Минимальная сумма предыдущих займов.
     max_loan_amount numeric, -- Максимальная сумма предыдущих займов.
	 loan_term numeric, -- Срок займа в днях.
	 min_loan_term numeric, -- Минимальный срок предыдущих займов.
	 max_loan_term numeric, -- Максимальный срок предыдущих займов.
	 is_closed boolean, -- Является ли контракт закрытым на текущий момент.
	 usage_days interval) -- Количество дней фактического использования займа
	 

INSERT INTO v_contract (customer_id,
	       contract_code,
		   contract_id,
		   condition_id,
		   subdivision_id,
		   contract_serial_number,
 		   contract_renewal_serial_number,			
		   is_renewal,
		   is_installment,
		   prolong_count,
	 	   first_issue_dt,
	 	   issue_dt, 	   
		   plan_dt,
		   loan_amount,
	 	   total_loan_amount,
		   min_loan_amount,
     	   max_loan_amount,
		   loan_term,
		   min_loan_term,
		   max_loan_term,
		   is_closed,
		   usage_days)
						
    SELECT tdc.customer_id, -- ID контракта.
	       tdc.contract_code, -- Код контракта.
		   tdc.contract_id, -- ID клиента.
		   tdcc.condition_id, -- ID документа о заключении контракта.
		   tdc.subdivision_id, -- ID подразделения, заключившего контракт.
		   row_number() over (
			                partition by tdc.customer_id 
			                order by tdc.issue_dt asc) as contract_serial_number, -- Порядковый номер контракта у клиента.
		   dense_rank() over ( 
			                partition by tdc.customer_id 
			                order by tdc.contract_id  asc) as contract_renewal_serial_number, -- Порядковый номер контракта у клиента без учёта переоформлений. Если контракт является переоформлением, порядковый номер не должен увеличиваться.
		   							
		   irt.is_renewal, -- Является ли данный контракт переоформлением.
		   iit.is_installment, -- Является ли данный контракт долгосрочным (наличие нескольких платежей в плане погашений).
		   cc.prolong_count, -- Количество продлений.
	 	   fid.first_issue_dt, -- Дата первого контракта у клиента.
	 	   tdc.issue_dt, -- Дата выдачи займа.	  	   
		   pd.plan_dt, -- Дата планового погашения займа
		   la.loan_amount, -- Сумма займа. Суммируются все платежи по графику.
	 	   tla.total_loan_amount,  -- Сумма всех займов клиента
		   minla.min_loan_amount, -- Минимальная сумма предыдущих займов.
     	   maxla.max_loan_amount, -- Максимальная сумма предыдущих займов.
		   lt.loan_term, -- Срок займа в днях.
		   minlt.min_loan_term, -- Минимальный срок предыдущих займов.
		   maxlt.max_loan_term, -- Максимальный срок предыдущих займов.
		   ic.is_closed, -- Является ли контракт закрытым на текущий момент.
		   ud.usage_days -- Количество дней фактического использования займа
	 	   
    FROM test_data_contract AS tdc
	
	left JOIN test_data_contract_conditions AS tdcc
	  ON tdc.contract_id=tdcc.contract_id

	  
	left JOIN (SELECT contract_id, -- Выясняем является ли контракт переоформленным
				CASE 
				    WHEN renewal_contract_id is null THEN false
					ELSE true
				END as is_renewal
		  FROM test_data_contract) as irt 
	  ON tdc.contract_id=irt.contract_id
	  
	left JOIN (with table_test as -- Является ли контракт долгосрочным
			(select condition_id, count(loan_amount) as prolong_pay
			 from test_data_contract_conditions_payment_plan
			 group by condition_id)
		
		select condition_id, prolong_pay,
			CASE 
					WHEN prolong_pay > 1 THEN true
					ELSE false
			END AS is_installment
		from table_test) AS iit
	    ON tdcc.condition_id=iit.condition_id
	
	 left join (select contract_id, count(condition_type) as prolong_count -- Количество продлений
		   FROM test_data_contract_conditions
		   where condition_type='Продление'
		   group by contract_id) as cc
	   ON tdc.contract_id=cc.contract_id
						
	  left JOIN (SELECT customer_id, MIN(issue_dt) AS first_issue_dt -- Дата первого контракта у клиента
			FROM test_data_contract
			GROUP BY customer_id) AS fid 
	    ON tdc.customer_id=fid.customer_id
		
	   left JOIN (SELECT tdcc.contract_id, max(tdccpp.payment_dt) as plan_dt, tdcc.condition_type -- Дата планового погашения (последняя дата платежа)
				  FROM test_data_contract_conditions_payment_plan as tdccpp
				  right join test_data_contract_conditions as tdcc
				  on tdccpp.condition_id=tdcc.condition_id
				  group by tdcc.contract_id, tdcc.condition_type 
				  ORDER BY contract_id) as pd
			  ON tdc.contract_id=pd.contract_id
		
	  left JOIN (SELECT tdcc.contract_id, SUM(tdccpp.loan_amount) AS loan_amount -- Сумма займа по контракту
            FROM test_data_contract_conditions_payment_plan as tdccpp
			left join test_data_contract_conditions as tdcc on tdccpp.condition_id=tdcc.condition_id  
            GROUP BY tdcc.contract_id) AS la
	 	ON tdc.contract_id=la.contract_id
				 
	   left JOIN (SELECT tdc.customer_id, sum(tdccpp.loan_amount) as total_loan_amount -- Сумма всех займов клиента
				  FROM test_data_contract as tdc
				  LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
				  LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id
				  LEFT JOIN test_data_contract_conditions_payment_plan as tdccpp ON  tdcc.condition_id=tdccpp.condition_id
				  GROUP BY tdc.customer_id) as tla
	   ON tdc.customer_id=tla.customer_id
		
	  left JOIN (   select customer_id, min(min_loan_amount) as min_loan_amount   -- Минимальная сумма займа
					from (SELECT tdc.customer_id, tdcc.contract_id, sum(tdccpp.loan_amount) as min_loan_amount 
						  FROM test_data_contract as tdc
						  LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
						  LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id
						  LEFT JOIN test_data_contract_conditions_payment_plan as tdccpp ON  tdcc.condition_id=tdccpp.condition_id						  
						  GROUP BY tdc.customer_id, tdcc.contract_id) as mla_step
					group by customer_id) as minla
	   ON tdc.customer_id=minla.customer_id
		
	   left JOIN (  select customer_id, max(min_loan_amount) as max_loan_amount   -- максимальная сумма займа
					from (SELECT tdc.customer_id, tdcc.contract_id, sum(tdccpp.loan_amount) as min_loan_amount 
						  FROM test_data_contract as tdc
						  LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
						  LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id
						  LEFT JOIN test_data_contract_conditions_payment_plan as tdccpp ON  tdcc.condition_id=tdccpp.condition_id						  
						  GROUP BY tdc.customer_id, tdcc.contract_id) as mla_step
					group by customer_id) as maxla
	    ON tdc.customer_id=maxla.customer_id
		
		left JOIN ( select contract_id, sum(days) as loan_term   -- срок займа в днях
					from test_data_contract_conditions
					group by contract_id) as lt
	    ON tdc.contract_id=lt.contract_id

		left JOIN ( select minlt_step.customer_id, min(loan_term) as min_loan_term -- Минимальный срок предыдущих займов
					from (select tdc.customer_id, tdcc.contract_id, sum(days) as loan_term   
					from test_data_contract as tdc
				    left join test_data_contract_conditions as tdcc on tdc.contract_id=tdcc.contract_id
					group by tdc.customer_id, tdcc.contract_id) as minlt_step
				    group by minlt_step.customer_id) as minlt
	    ON tdc.customer_id=minlt.customer_id
				 
		left JOIN ( select minlt_step.customer_id, max(loan_term) as max_loan_term -- Максимальный срок предыдущих займов
					from (select tdc.customer_id, tdcc.contract_id, sum(days) as loan_term   
					from test_data_contract as tdc
				    left join test_data_contract_conditions as tdcc on tdc.contract_id=tdcc.contract_id
					group by tdc.customer_id, tdcc.contract_id) as minlt_step
				    group by minlt_step.customer_id) as maxlt
	    ON tdc.customer_id=maxlt.customer_id
				 
		left JOIN ( with is_closed as -- Является ли контракт закрытым на текущий момент
						(SELECT distinct(tdc.contract_id) as closed_contract 
						 FROM test_data_contract as tdc
						 LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
						 where tdcs.status_type='Закрыт' or tdcs.status_type='Договор закрыт с переплатой' or tdcs.status_type='Переоформлен')
					select contract_id,
						case
							when closed_contract is null then false
							else true
						end as is_closed
					from is_closed as ic
					right join test_data_contract as tdc on ic.closed_contract=tdc.contract_id) as ic
	    ON tdc.contract_id=ic.contract_id
				 
		left JOIN ( SELECT tdc.contract_id as closed_contract, min(tdc.issue_dt) as data_open,  -- Количество дней фактического использования займа (для закрытых)
						   max(status_dt) as data_closed, (max(status_dt)- min(tdc.issue_dt)) as usage_days 
					FROM test_data_contract as tdc
					LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
					where tdcs.status_type='Закрыт' or tdcs.status_type='Договор закрыт с переплатой' or tdcs.status_type='Переоформлен'
				   	group by tdc.contract_id) as ud				 	
	    ON tdc.contract_id=ud.closed_contract

--
----------------------------------------------------------------------------------------
--
--
--1. Выбрать клиентов, пришедших в 2019 году (т.е. первый договор датирован 2019 годом).
--
with temp_table as (
	select customer_id, min(issue_dt) as dt 
	from v_contract
	group by customer_id)
select *
from temp_table
where dt BETWEEN '2019-01-01' AND '2019-12-31'
/*214 клиентов пришли в 2019 году */
--
----------------------------------------------------------------------------------------
--

--
-- 2. Сгруппировать клиентов в группы по году и месяцу первого контракта.
--
with temp_table as (
	select customer_id, min(issue_dt) as dt_start 
	from v_contract
	group by customer_id)
select *, extract(year from dt_start) as year_start,  extract(month from dt_start) as month_start 
from temp_table 
order by year_start, month_start
--
----------------------------------------------------------------------------------------
--
--
-- 3. В каждой группе определить клиента (-ов) с максимальным порядковым номером контракта клиента.  ??????????
--
with temp_table as (
	select customer_id, min(issue_dt) as dt_start, max(contract_serial_number) as contract_serial_number 
	from v_contract
	group by customer_id)
select *, extract(year from dt_start) as year_start,  extract(month from dt_start) as month_start, contract_serial_number  
from temp_table 
order by year_start, month_start
--
----------------------------------------------------------------------------------------
--

--
-- 4. Определить во сколько раз увеличилась сумма последнего контракта относительно первого по найденным клиентам в каждой группе.???
--
select customer_id, min(contract_renewal_serial_number), max(contract_renewal_serial_number), sum(loan_amount)
from v_contract
group by customer_id
--
----------------------------------------------------------------------------------------
--


-- 
-- Тестовые запросы 
--
SELECT * FROM v_contract -- test_data_contract_conditions -- test_data_contract_conditions_payment_plan
					     -- test_data_contract_status -- test_data_contract -- v_contract
				 
SELECT * FROM test_data_contract_conditions 								
WHERE contract_id='2387d9eb-1492-11ed-b81f-3cfdfed12dbd'
						  

SELECT * FROM test_data_contract
WHERE customer_id='001ed94e-f655-11e3-b1c4-bfab163be34a'
WHERE contract_id='2387d9eb-1492-11ed-b81f-3cfdfed12dbd'

SELECT * FROM test_data_contract as tdc 
full join test_data_contract_status as tdcs on tdc.contract_id=tdcs.contract_id
full join test_data_contract_conditions as tdcc on tdc.contract_id=tdcc.contract_id
full join test_data_contract_conditions_payment_plan as tdccpp on tdcc.condition_id=tdccpp.condition_id				 
WHERE tdc.contract_id='67a2ff4e-7371-11ec-b81f-3cfdfed12dbd'                                                                                                                                                                                                                            				  
				 
SELECT * FROM test_data_contract_status -- котнракты без изменений и без статусов
WHERE contract_id in (select tdc.contract_id from test_data_contract as tdc -- конракты у которых нет изменений(41 контракт) 
left join test_data_contract_conditions as tdcc
on tdc.contract_id=tdcc.contract_id
where tdcc.contract_id is null)						  			 
				 
select tdc.contract_id from test_data_contract as tdc -- конракты у которых нет изменений(41 контракт) 
left join test_data_contract_conditions as tdcc
on tdc.contract_id=tdcc.contract_id
where tdcc.contract_id is null 


EXPLAIN SELECT * FROM v_contract;
DROP TABLE v_contract;

-- Вечканов АА 16.09.2022

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
	 loan_amount numeric, -- Сумма займа. Суммируются все платежи по графику.
	 total_loan_amount numeric, -- Сумма всех предыдущих займов.
	 min_loan_amount numeric, -- Минимальная сумма предыдущих займов.
     max_loan_amount numeric) -- Максимальная сумма предыдущих займов.
	 

INSERT INTO v_contract (contract_id,
						contract_code, 
						customer_id, 
						condition_id, 
						subdivision_id, 
						contract_serial_number,
					    contract_renewal_serial_number,
					    is_renewal,
					    is_installment,
					    prolong_count,
						first_issue_dt,
						issue_dt,
					    loan_amount,
					    total_loan_amount,
					    min_loan_amount,
     					max_loan_amount)
						
    SELECT tdc.customer_id, -- ID контракта.
--	       tdc.contract_code, -- Код контракта.
		   tdc.contract_id, -- ID клиента.
		   tdcc.condition_id, -- ID документа о заключении контракта.
--		   tdc.subdivision_id, -- ID подразделения, заключившего контракт.
		   row_number() over (
			                partition by tdc.customer_id 
			                order by tdc.issue_dt asc) as contract_serial_number, -- Порядковый номер контракта у клиента.
		   dense_rank() over ( 
			                partition by tdc.customer_id 
			                order by tdc.contract_id  asc) as contract_renewal_serial_number, -- Порядковый номер контракта у клиента без учёта переоформлений. Если контракт является переоформлением, порядковый номер не должен увеличиваться.
		   							
		   irt.is_renewal, -- Является ли данный контракт переоформлением.
		   iit.is_installment, -- Является ли данный контракт долгосрочным (наличие нескольких платежей в плане погашений).
		   cc.prolong_count--, -- Количество продлений.
--	 	   fid.first_issue_dt, -- Дата первого контракта у клиента.
--	 	   tdc.issue_dt, -- Дата выдачи займа.
--	  	   la.loan_amount--, -- Сумма займа. Суммируются все платежи по графику.
--	 	   tla_sum.total_loan_amount,  -- Сумма всех предыдущих займов.
--		   tla_min.min_loan_amount, -- Минимальная сумма предыдущих займов.
--     	   tla_max.max_loan_amount -- Максимальная сумма предыдущих займов.
	 	   
    FROM test_data_contract AS tdc
	
	JOIN test_data_contract_conditions AS tdcc
	  ON tdc.contract_id=tdcc.contract_id

	  
	JOIN (SELECT contract_id, -- Выясняем является ли контракт переоформленным
				CASE 
				    WHEN renewal_contract_id is null THEN false
					ELSE true
				END as is_renewal
		  FROM test_data_contract) as irt 
	  ON tdc.contract_id=irt.contract_id
	  
	JOIN (with table_test as -- Является ли контракт долгосрочным
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
	
	 join (select contract_id, count(condition_type) as prolong_count
		   FROM test_data_contract_conditions
		   where condition_type='Продление'
		   group by contract_id) as cc
	   ON tdc.contract_id=cc.contract_id
		
		
		
--	  JOIN (SELECT contract_id, MIN(issue_dt) AS first_issue_dt -- Дата первого контракта у клиента
--			FROM test_data_contract
--			GROUP BY contract_id) AS fid 
--	    ON fid.contract_id=tdc.contract_id
		
--	  JOIN (SELECT condition_id, SUM(loan_amount) AS loan_amount -- Сумма всех займов
--            FROM test_data_contract_conditions_payment_plan
--            GROUP BY condition_id) AS la
--	 	ON tdcc.condition_id=la.condition_id

--	  JOIN (SELECT tdccpp.condition_id, SUM(tdccpp.loan_amount) AS total_loan_amount -- Сумма предыдущих займов   
--		    FROM test_data_contract_conditions_payment_plan AS tdccpp
--            WHERE tdccpp.condition_id IN
--			  (SELECT tdcc.condition_id
--			   FROM test_data_contract as tdc
--			   LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
--			   LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id 
--			   WHERE tdcs.status_type = 'Закрыт'
--			   ORDER BY tdc.customer_id, tdc.contract_id, tdcs.status_dt)
--			GROUP BY tdccpp.condition_id) AS tla_sum
--	    ON tdcc.condition_id=tla_sum.condition_id
		
--	  JOIN (SELECT tdccpp.condition_id, MIN(tdccpp.loan_amount) AS min_loan_amount -- Сумма мин предыдущих займов 
--		    FROM test_data_contract_conditions_payment_plan AS tdccpp
--            WHERE tdccpp.condition_id IN
--			  (SELECT tdcc.condition_id
--			   FROM test_data_contract as tdc
--			   LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
--			   LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id 
--			   WHERE tdcs.status_type = 'Закрыт'
--			   ORDER BY tdc.customer_id, tdc.contract_id, tdcs.status_dt)
--			GROUP BY tdccpp.condition_id) AS tla_min
--	    ON tdcc.condition_id=tla_min.condition_id
		
--	  JOIN (SELECT tdccpp.condition_id, MAX(tdccpp.loan_amount) AS max_loan_amount -- Сумма мах предыдущих займов 
--		    FROM test_data_contract_conditions_payment_plan AS tdccpp
--            WHERE tdccpp.condition_id IN
--			  (SELECT tdcc.condition_id
--			   FROM test_data_contract as tdc
--			   LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
--			   LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id 
--			   WHERE tdcs.status_type = 'Закрыт'
--			   ORDER BY tdc.customer_id, tdc.contract_id, tdcs.status_dt)
--			GROUP BY tdccpp.condition_id) AS tla_max
--	    ON tdcc.condition_id=tla_max.condition_id
				
	 JOIN (SELECT tdc.customer_id, 
			   tdc.contract_id,  
			   sum(tdccpp.loan_amount) AS col1, 
			   min(tdccpp.loan_amount) AS col2, 
			   max(tdccpp.loan_amount) AS col3
				FROM test_data_contract_conditions_payment_plan AS tdccpp
				RIGHT JOIN test_data_contract_conditions AS tdcc ON tdcc.condition_id = tdccpp.condition_id
				RIGHT JOIN test_data_contract AS tdc ON tdc.contract_id = tdcc.contract_id
				WHERE tdccpp.condition_id IN
				  (SELECT tdcc.condition_id
				   FROM test_data_contract as tdc
				   LEFT JOIN test_data_contract_status as tdcs ON  tdc.contract_id=tdcs.contract_id
				   LEFT JOIN test_data_contract_conditions as tdcc ON  tdc.contract_id=tdcc.contract_id 
				   WHERE tdcs.status_type='Закрыт'
				   ORDER BY tdc.customer_id, tdc.contract_id, tdcs.status_dt)
				GROUP BY  tdc.customer_id,  tdc.contract_id) AS tla_sum_min_max
		ON tdc.contract_id=tla_sum_min_max.contract_id

--    LIMIT 1000;
--
-----------------------------------------------------------------------------
--

/*
	Спасибо за интересное тестовое, было увлекательно, большая витрина, думаю в будущем проверю данную витрину(когда доделаю) на чистоту данных с помощью
	python(pandas и numpy), так же интересно по ней сделать дашборд в Tableau.
	Не хватило времени сделать тестовое полностью... НО его я доделю для себя.
	Так же хотел попросить от Вас обратную связь, что можно сделать лучше, какой подход применить и тд.
	Телефон для связи 89122795209 Александр (telegram, whatsapp)
*/

-- 
-- Тестовые запросы 
--
SELECT * FROM test_data_contract_conditions; -- test_data_contract_conditions -- test_data_contract_conditions_payment_plan
						  -- test_data_contract_status -- test_data_contract -- v_contract
EXPLAIN SELECT * FROM v_contract;
DROP TABLE v_contract;

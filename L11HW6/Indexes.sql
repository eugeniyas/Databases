-- Создать индекс к какой-либо из таблиц вашей БД

-- Индекс по полю producer_id в таблице prod.product: используется для поиска всех товаров указанного производителя
CREATE INDEX product_producer_id_idx ON prod.product (producer_id); 
ANALYZE prod.product;

EXPLAIN 
SELECT 	* 
FROM 	prod.product 
WHERE 	producer_id = 1;

--Bitmap Heap Scan on product  (cost=4530.07..60293.76 rows=250535 width=383)
--  Recheck Cond: (producer_id = 1)
--  ->  Bitmap Index Scan on product_producer_id_idx  (cost=0.00..4467.44 rows=250535 width=0)
--        Index Cond: (producer_id = 1)

----------------------------------------------------------------

-- Реализовать индекс для полнотекстового поиска

-- Индекс по полю searchable_description в таблице prod.product: используется для полнотекстового поиска в описании товара
CREATE INDEX product_searchable_description_idx ON prod.product USING GIN (searchable_description);
ANALYZE prod.product;

EXPLAIN 
SELECT 	*
FROM 	prod.product
WHERE 	searchable_description @@ to_tsquery('ед & м');

--Bitmap Heap Scan on product  (cost=44.26..52.77 rows=2 width=729)
--  Recheck Cond: (searchable_description @@ to_tsquery('ед & м'::text))
--  ->  Bitmap Index Scan on product_searchable_description_idx  (cost=0.00..44.26 rows=2 width=0)
--        Index Cond: (searchable_description @@ to_tsquery('ед & м'::text))

----------------------------------------------------------------

-- Реализовать индекс на часть таблицы или индекс на поле с функцией

-- Индекс по полю title в таблице prod.product: используется для поиска названия товара в верхнем регистре
CREATE INDEX product_upper_title_idx ON prod.product (upper(title));
ANALYZE prod.product;

EXPLAIN
SELECT	* 
FROM 	prod.product 
where 	upper(title) ='РХКЪВЬИИЁДЗБПЗГЦМНШЭ';

--Index Scan using product_upper_title_idx on product  (cost=0.42..8.44 rows=1 width=729)
--  Index Cond: (upper((title)::text) = 'РХКЪВЬИИЁДЗБПЗГЦМНШЭ'::text)

----------------------------------------------------------------

-- Создать индекс на несколько полей

-- Составной индекс по полям customer_id, state в таблице order: используется для поиска всех заказов покупателя и фильтрации их по статусам
CREATE INDEX order_customer_id_state_idx ON ord.orders (customer_id,state);
ANALYZE ord.orders;

EXPLAIN 
SELECT 	* 
FROM 	ord.orders 
WHERE 	customer_id = 1;

--Bitmap Heap Scan on orders  (cost=4.44..12.22 rows=2 width=33)
--  Recheck Cond: (customer_id = 1)
--  ->  Bitmap Index Scan on order_customer_id_state_idx  (cost=0.00..4.43 rows=2 width=0)
--        Index Cond: (customer_id = 1)

EXPLAIN 
SELECT * 
FROM 	ord.orders 
WHERE 	customer_id = 1 AND 
		state = 4;

--Index Scan using order_customer_id_state_idx on orders  (cost=0.42..8.44 rows=1 width=33)
--  Index Cond: ((customer_id = 1) AND (state = 4))




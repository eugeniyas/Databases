-- 1. Написать запрос с конструкциями SELECT, JOIN

SELECT 	*
FROM 	prod.supply s
	INNER JOIN prod.supply_product sp ON sp.supply_id = s.supply_id 
	INNER JOIN prod.product p ON p.product_id = sp.product_id 
WHERE s.supplier_id = 1;

-- 2. Написать запрос с добавлением данных INSERT INTO

INSERT INTO prod.producer (producer_name) VALUES ('Berlingo');

-- 3. Написать запрос с обновлением данных с UPDATE FROM

UPDATE	prod.rest
SET	quantity = rest.quantity - ord.order_product.quantity
FROM 	ord.order_product
WHERE 	ord.order_product.order_id = 3 AND 
	ord.order_product.product_id = prod.rest.product_id;

-- 4. Использовать using для оператора DELETE

DELETE
FROM 	prod.product 
USING 	prod.producer
WHERE	prod.product.producer_id  = prod.producer.producer_id AND 
	prod.producer.producer_name = 'PARKER';

-- 5. Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.

SELECT 	*
FROM 	prod.product p 
WHERE 	title ~* 'ручк(а|и)';	-- регистронезависимый поиск товаров, у которых в названии присутствует слово "ручка" в ед. или мн. числе
	
-- 6. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, как порядок соединений в FROM влияет на результат? Почему?

-- Для INNER JOIN порядок соединений не влияет на результат
SELECT 	*
FROM 	prod.product p 
	INNER JOIN  prod.product_image pim ON pim.product_id = p.product_id 
	INNER JOIN prod.image i ON i.image_id = pim .image_id;
	
-- Для LEFT JOIN порядок соединений влияет на результат, т.к. внешние соединений не являются коммутативными	
SELECT 	*
FROM 	prod.product p 
	LEFT JOIN  prod.product_image pim ON pim.product_id = p.product_id 
	LEFT JOIN prod.image i ON i.image_id = pim .image_id;

-- 7. Напишите запрос на добавление данных с выводом информации о добавленных строках.

INSERT INTO prod.producer (producer_name) VALUES ('Pilot')
RETURNING producer_id, producer_name;
	
-- 8. Напишите запрос с обновлением данные используя UPDATE FROM.

UPDATE	prod.rest
SET	quantity = rest.quantity - op.quantity
FROM 	ord.order_product op
WHERE 	op.order_id = 3 AND 
	op.product_id = prod.rest.product_id;

-- 9. Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.

DELETE
FROM 	prod.product 
USING 	prod.producer
WHERE	prod.product.producer_id  = prod.producer.producer_id AND 
	prod.producer.producer_name = 'Pilot';

-- 10. Приведите пример использования утилиты COPY (по желанию)

COPY (SELECT * FROM prod.product)
TO 'C:/HW4_L7/prod/products.csv'
WITH CSV
DELIMITER ';'
HEADER;

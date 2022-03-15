-- Выборка товаров с указанием производителя (производитель указывается всегда)
SELECT 	p.product_id,
		p.code,
		p.title,
		pr.producer_name 
FROM 	store.product p 
		INNER JOIN store.producer pr ON pr.producer_id = p.producer_id;

-- Выборка товаров с указанием категории (категория может быть не указана)
SELECT 	p.product_id,
		p.code,
		p.title,
		c.description AS category
FROM 	store.product p 
		LEFT JOIN store.product_category pc ON pc.product_id = p.product_id 
		LEFT JOIN store.category c ON c.category_id = pc.category_id;

-- Поиск товара по артикулу
SELECT 	*
FROM 	store.product p 
WHERE 	code = '168713';

-- Выбока товаров, стоимость которых не превышает 50 руб
SELECT 	*
FROM 	store.product p 
WHERE 	p.price  < 50;

-- Выбока товаров, производителем которых является Berlingo 
SELECT 	*
FROM 	store.product p 
		INNER JOIN store.producer pr ON pr.producer_id = p.producer_id
WHERE 	pr.producer_name  = 'Berlingo';

-- Выбока товаров из категории "Ручки гелевые" 
SELECT 	*
FROM 	store.product p 
		LEFT JOIN store.product_category pc ON pc.product_id = p.product_id 
		LEFT JOIN store.category c ON c.category_id = pc.category_id
WHERE 	c.category_id = 3;

-- Новые заказы, оформленные сегодня
SELECT 	*
FROM 	store.orders o 
WHERE 	DATE(o.create_date) = CURDATE() AND o.state = 0;

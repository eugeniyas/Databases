-- ¬ыборка товаров с указанием производител€ (производитель указываетс€ всегда)
SELECT 	p.product_id,
		p.code,
		p.title,
		pr.producer_name 
FROM 	store.product p 
		INNER JOIN store.producer pr ON pr.producer_id = p.producer_id;

-- ¬ыборка товаров с указанием категории (категори€ может быть не указана)
SELECT 	p.product_id,
		p.code,
		p.title,
		c.description AS category
FROM 	store.product p 
		LEFT JOIN store.product_category pc ON pc.product_id = p.product_id 
		LEFT JOIN store.category c ON c.category_id = pc.category_id;

-- ѕоиск товара по артикулу
SELECT 	*
FROM 	store.product p 
WHERE 	code = '168713';

-- ¬ыбока товаров, стоимость которых не превышает 50 руб
SELECT 	*
FROM 	store.product p 
WHERE 	p.price  < 50;

-- ¬ыбока товаров, производителем которых €вл€етс€ Berlingo 
SELECT 	*
FROM 	store.product p 
		INNER JOIN store.producer pr ON pr.producer_id = p.producer_id
WHERE 	pr.producer_name  = 'Berlingo';

-- ¬ыбока товаров из категории "–учки гелевые" 
SELECT 	*
FROM 	store.product p 
		LEFT JOIN store.product_category pc ON pc.product_id = p.product_id 
		LEFT JOIN store.category c ON c.category_id = pc.category_id
WHERE 	c.category_id = 3;

-- Ќовые заказы, оформленные сегодн€
SELECT 	*
FROM 	store.orders o 
WHERE 	DATE(o.create_date) = CURDATE() AND o.state = 0;



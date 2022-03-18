-- максимальная и минимальная цена товара и кол-во предложений
SELECT 	MIN(price), 
	MAX(price), 
	COUNT(*) 
FROM 	store.product;

-- самый дорогой и самый дешевый товар в каждой категории
SELECT 	pc.category_id, 
	MIN(p.price), 
	MAX(p.price)
FROM 	store.product p 
	INNER JOIN store.product_category pc ON pc.product_id  = p.product_id
GROUP BY pc.category_id;

-- rollup с количеством товаров по категориям
SELECT 	IF(GROUPING(pc.category_id), 'All', pc.category_id) AS category, 
	COUNT(*)
FROM 	store.product p 
	INNER JOIN store.product_category pc ON pc.product_id  = p.product_id
GROUP BY pc.category_id WITH ROLLUP;

-- самый дорогой и самый дешевый товар в каждой категории, в которой насчитывается более 10 товаров
SELECT 	pc.category_id,
	MIN(CASE 
		WHEN p.price < 1 THEN 0 
		ELSE p.price
	    END) AS MinPrice, 
	MAX(p.price) AS MaxPrice, 
	COUNT(*) AS Count
FROM 	store.product p 
	INNER JOIN store.product_category pc ON pc.product_id  = p.product_id
GROUP BY pc.category_id 
HAVING COUNT(*) > 1;

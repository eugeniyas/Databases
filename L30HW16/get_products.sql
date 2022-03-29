-- выборка товаров с фильтрацией и постраничным выводом
DROP PROCEDURE IF EXISTS get_products;
DELIMITER //
CREATE PROCEDURE get_products(
	category_id INT(11), 
    producer_id INT(11), 
    price_min DECIMAL(9,2), 
    price_max DECIMAL(9,2), 
    page_number INT(11), 
    page_size INT(11), 
    sort_string VARCHAR(50))
SQL SECURITY INVOKER
BEGIN
	SET @cur_offset = (@page_number - 1) * @page_size;

	SET @str = CONCAT('
	SELECT 	p.product_id,
			p.code,
            p.title,
            p.description,
            p.price,
            c.category_id,
            c.title category_title
	FROM 	product p
			INNER JOIN product_category pc ON pc.product_id = p.product_id
			INNER JOIN category c ON c.category_id = pc.category_id 
	WHERE	c.category_id = ? AND
			p.producer_id = ? AND
			p.price >= ? AND p.price <= ?
	ORDER BY ', @sort_string, ' 
	LIMIT ? OFFSET ?;');

	PREPARE stmt FROM @str;
	EXECUTE stmt USING @category_id, @producer_id, @price_min, @price_max, @page_size, @cur_offset;
	DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

-- создание пользователя client с правом на выполнение процедуры get_products
CREATE USER IF NOT EXISTS 'client'@'store' IDENTIFIED BY '12345';
GRANT EXECUTE ON PROCEDURE store.get_products TO 'client'@'store';

-- выполнение прцедуры get_products
SET @category_id = 3;
SET @producer_id = 4;
SET @price_min = 5;
SET @price_max = 50;

SET @page_number = 1;
SET @page_size = 10;
SET @sort_string = 'p.product_id ASC';

CALL get_products(@category_id, @producer_id, @price_min, @price_max, @page_number, @page_size, @sort_string);
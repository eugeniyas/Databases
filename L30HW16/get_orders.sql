-- отчет по продажам
DROP PROCEDURE IF EXISTS get_orders;
DELIMITER //
CREATE PROCEDURE get_orders(
	period ENUM('hour', 'day', 'week'), 
    grouping_by ENUM('product', 'category', 'producer'))
SQL SECURITY INVOKER
BEGIN
	WITH order_products AS
    (
		SELECT	p.product_id,
				p.producer_id,
                pc.category_id,
                op.price,
                op.quantity,
                (op.price * op.quantity) cost,
                o.order_id
		FROM	orders o
				INNER JOIN order_product op ON op.order_id = o.order_id
				INNER JOIN product p ON p.product_id = op.product_id
                INNER JOIN product_category pc ON pc.product_id = p.product_id
		WHERE 	CASE 
					WHEN @period = 'hour' THEN create_date >= DATE_SUB(now(), INTERVAL 1 HOUR)
					WHEN @period = 'day' THEN create_date >= DATE_SUB(now(), INTERVAL 1 DAY)
					ELSE create_date >= DATE_SUB(now(), INTERVAL 1 WEEK)
				END
    )
    -- SELECT * FROM order_products;
    SELECT	CASE 
				WHEN @grouping_by = 'product' THEN product_id
                WHEN @grouping_by = 'category' THEN category_id
				ELSE producer_id
			END AS crit,
            SUM(cost) AS sum
    FROM	order_products
	GROUP BY (CASE 
				WHEN @grouping_by = 'product' THEN product_id
                WHEN @grouping_by = 'category' THEN category_id
				ELSE producer_id
			END);
END //
DELIMITER ;

-- создание пользователя manager с правом на выполнение процедуры get_orders
CREATE USER IF NOT EXISTS 'manager'@'store' IDENTIFIED BY '12345';
GRANT EXECUTE ON PROCEDURE store.get_orders TO 'manager'@'store';

-- выполнение прцедуры get_orders
SET @period = 'week';
SET @grouping_by = 'product';

CALL get_orders(@period, @grouping_by);
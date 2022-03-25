DROP PROCEDURE create_order;
delimiter //
CREATE PROCEDURE create_order()
BEGIN
	DECLARE order_id INT DEFAULT 0;
    
	INSERT INTO orders (customer_id, state, total, create_date, delivery_date)
    VALUES(1, 0, 1000, NOW(), DATE_ADD(CURDATE() , INTERVAL 1 DAY));
    
    SET order_id = LAST_INSERT_ID();
    
    INSERT INTO order_product (order_id, product_id, quantity, price)
    VALUES (order_id, 1, 1, 36);
END //

BEGIN;
CALL create_order();
SELECT * FROM orders;
SELECT 	* FROM 	order_product;
COMMIT;
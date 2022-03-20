CREATE FULLTEXT INDEX product_fulltext_idx ON product (title, description);

EXPLAIN
SELECT 	* 
FROM 	product 
WHERE 	MATCH (title, description) AGAINST ('неавтоматическая');

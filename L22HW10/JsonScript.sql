ALTER TABLE product
ADD COLUMN attributes JSON;

INSERT INTO product (
	code, 
	title, 
	description, 
	producer_id, 
	price, 
	unit, 
	attributes
)
VALUES (
	'A10383RT', 
	'����� ��������� "Berlingo"', 
	'���������� Smart Ink ����������e� ����������� ������. �������� ����������� �������� ������� ������� �������������� ������� ��� ������. ����� ������� ������� ���������� �����. ������� �������� ���� - 0,5 ��. ���� ������ - �����.', 
	1, 
	50, 
	1, 
	'{"color": "yellow", "inkcolor": "blue", "diameter": "0.5"}'
);

SELECT 	*
FROM	product
WHERE 	JSON_EXTRACT(`attributes` , '$.inkcolor') = "blue";


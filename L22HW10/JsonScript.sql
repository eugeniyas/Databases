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
	'Ручка шариковая "Berlingo"', 
	'Технология Smart Ink обеспечиваeт супермягкое письмо. Приятное бархатистое покрытие корпуса создает дополнительный комфорт при письме. Цвета корпуса ассорти пастельных тонов. Диаметр пишущего узла - 0,5 мм. Цвет чернил - синий.', 
	1, 
	50, 
	1, 
	'{"color": "yellow", "inkcolor": "blue", "diameter": "0.5"}'
);

SELECT 	*
FROM	product
WHERE 	JSON_EXTRACT(`attributes` , '$.inkcolor') = "blue";

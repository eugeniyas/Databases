# Домашнее задание по теме "Создаем БД в докере"

Поднять сервис db_va можно командой:

docker-compose up storedb

Для подключения к БД используйте команду:

docker-compose exec otusdb mysql -u root -p12345 store

Для использования в клиентских приложениях можно использовать команду:

mysql -u root -p12345 --port=3309 --protocol=tcp store

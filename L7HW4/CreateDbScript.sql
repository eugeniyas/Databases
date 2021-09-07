-- Создание табличных пространств

CREATE TABLESPACE tblspc_product
  OWNER postgres
  LOCATION 'C:\HW4_L7\prod';
 
CREATE TABLESPACE tblspc_order
  OWNER postgres
  LOCATION 'C:\HW4_L7\order';
 
-- Создание базы данных

CREATE DATABASE store
  WITH 
  OWNER = postgres
  ENCODING = 'UTF8'
  LC_COLLATE = 'Russian_Russia.utf8'
  LC_CTYPE = 'Russian_Russia.utf8'
  TABLESPACE = tblspc_product
  CONNECTION LIMIT = -1;
   
-- Создание схем

CREATE SCHEMA prod;
CREATE SCHEMA "order";
   
-- Создание ролей

CREATE ROLE store_admin WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
 
GRANT ALL ON DATABASE store TO store_admin;
  
CREATE ROLE store_read WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
 
GRANT SELECT ON ALL TABLES IN SCHEMA prod, "order" TO store_read;
    
CREATE ROLE store_write WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
 
GRANT ALL ON ALL TABLES IN SCHEMA prod, "order" TO store_write;

-- Создание таблиц

CREATE TABLE prod.producer (
	producer_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar(300) NOT NULL,
	country varchar(50) NULL,
	CONSTRAINT producer_pk PRIMARY KEY (producer_id)
) TABLESPACE tblspc_product;

CREATE TABLE prod.product (
	product_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	code varchar(50) NOT NULL,
	title varchar(250) NOT NULL,
	description varchar(1000) NOT NULL,
	producer_id int4 NOT NULL,
	price numeric(9,2) NOT NULL,
	unit int4 NOT NULL,
	CONSTRAINT product_pk PRIMARY KEY (product_id),
	CONSTRAINT product_un UNIQUE (code)
) TABLESPACE tblspc_product;

ALTER TABLE prod.product ADD CONSTRAINT product_producer_id_fk FOREIGN KEY (producer_id) REFERENCES prod.producer(producer_id);

CREATE TABLE prod.category (
	category_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	title varchar(150) NOT NULL,
	description varchar(1500) NOT NULL,
	parent_id int4 NULL,
	CONSTRAINT category_pk PRIMARY KEY (category_id),
	CONSTRAINT category_parent_id_fk FOREIGN KEY (parent_id) REFERENCES category(category_id)
) TABLESPACE tblspc_product;

CREATE TABLE prod.product_category (
	product_id int4 NOT NULL,
	category_id int4 NOT NULL,
	CONSTRAINT product_category_pk PRIMARY KEY (product_id, category_id)
) TABLESPACE tblspc_product;

ALTER TABLE prod.product_category ADD CONSTRAINT product_category_category_id_fk FOREIGN KEY (category_id) REFERENCES prod.category(category_id);
ALTER TABLE prod.product_category ADD CONSTRAINT product_category_product_id_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);

CREATE TABLE prod.image (
	image_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	"name" varchar(100) NOT NULL,
	file_path varchar(250) NOT NULL,
	CONSTRAINT image_pk PRIMARY KEY (image_id)
) TABLESPACE tblspc_product;

CREATE TABLE prod.product_image (
	product_id int4 NOT NULL,
	image_id int4 NOT NULL,
	CONSTRAINT product_image_pk PRIMARY KEY (product_id, image_id)
) TABLESPACE tblspc_product;

ALTER TABLE prod.product_image ADD CONSTRAINT product_image_image_id_fk FOREIGN KEY (image_id) REFERENCES prod.image(image_id);
ALTER TABLE prod.product_image ADD CONSTRAINT product_image_product_id_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);
 
CREATE TABLE prod.price (
	price_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	product_id int4 NOT NULL,
	begin_date timestamp NOT NULL,
	end_date timestamp NOT NULL,
	value numeric(9,2) NOT NULL,
	CONSTRAINT price_check CHECK ((begin_date <= end_date)),
	CONSTRAINT price_pk PRIMARY KEY (price_id)
) TABLESPACE tblspc_product;

ALTER TABLE prod.price ADD CONSTRAINT price_product_id_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);
 
CREATE TABLE prod.rest (
	product_id int4 NOT NULL,
	quantity int4 NOT NULL,
	CONSTRAINT rest_pk PRIMARY KEY (product_id)
) TABLESPACE tblspc_product;

ALTER TABLE prod.rest ADD CONSTRAINT rest_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);

CREATE TABLE prod.supplier (
	supplier_id int4 NOT NULL,
	"name" varchar(300) NOT NULL,
	phone varchar(10) NOT NULL,
	address varchar(500) NOT NULL,
	email varchar(50) NULL,
	CONSTRAINT supplier_pk PRIMARY KEY (supplier_id)
) TABLESPACE tblspc_product;

CREATE TABLE prod.supply (
	supply_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	code varchar(30) NOT NULL,
	"date" date NOT NULL,
	supplier_id int4 NOT NULL,
	total numeric(14,2) NOT NULL,
	CONSTRAINT supply_pk PRIMARY KEY (supply_id),
	CONSTRAINT supply_un UNIQUE (code)
) TABLESPACE tblspc_product;

ALTER TABLE prod.supply ADD CONSTRAINT supply_supplier_id_fk FOREIGN KEY (supplier_id) REFERENCES prod.supplier(supplier_id);

CREATE TABLE prod.supply_product (
	supply_id int4 NOT NULL,
	product_id int4 NOT NULL,
	quantity int4 NOT NULL,
	price numeric(9,2) NOT NULL,
	CONSTRAINT supply_product_pk PRIMARY KEY (supply_id, product_id)
) TABLESPACE tblspc_product;

ALTER TABLE prod.supply_product ADD CONSTRAINT supply_product_product_id_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);
ALTER TABLE prod.supply_product ADD CONSTRAINT supply_product_supply_id_fk FOREIGN KEY (supply_id) REFERENCES prod.supply(supply_id);

CREATE TABLE "order".customer (
	customer_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	last_name varchar(30) NULL,
	first_name varchar(30) NULL,
	middle_name varchar(30) NULL,
	email varchar(30) NOT NULL,
	phone varchar(10) NULL,
	address varchar(500) NULL,
	CONSTRAINT customer_pk PRIMARY KEY (customer_id),
	CONSTRAINT customer_un UNIQUE (email)
) TABLESPACE tblspc_order;

CREATE TABLE "order"."order" (
	order_id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	customer_id int4 NOT NULL,
	state int4 NOT NULL,
	total numeric(14,2) NOT NULL,
	create_date timestamp NOT NULL,
	delivery_date timestamp(0) NOT NULL,
	CONSTRAINT order_pk PRIMARY KEY (order_id)
) TABLESPACE tblspc_order;

ALTER TABLE "order"."order" ADD CONSTRAINT order_customer_id_fk FOREIGN KEY (customer_id) REFERENCES "order".customer(customer_id);

CREATE TABLE "order".order_product (
	order_id int4 NOT NULL,
	product_id int4 NOT NULL,
	quantity int4 NOT NULL,
	price numeric(9,2) NOT NULL,
	CONSTRAINT order_product_pk PRIMARY KEY (order_id, product_id)
) TABLESPACE tblspc_order;

ALTER TABLE "order".order_product ADD CONSTRAINT order_product_order_id_fk FOREIGN KEY (order_id) REFERENCES "order"."order"(order_id);
ALTER TABLE "order".order_product ADD CONSTRAINT order_product_product_id_fk FOREIGN KEY (product_id) REFERENCES prod.product(product_id);
 
-- Создание базы данных

CREATE DATABASE store;
USE store;
   
-- Создание ролей

CREATE ROLE store_admin;
GRANT ALL ON store.* TO store_admin;

CREATE ROLE store_read;
GRANT SELECT ON store.* TO store_read;

CREATE ROLE store_write;
GRANT INSERT, UPDATE, DELETE ON store.* TO store_write;

-- Создание таблиц

CREATE TABLE producer (
  producer_id int(11) NOT NULL AUTO_INCREMENT,
  producer_name varchar(300) NOT NULL,
  country varchar(50) DEFAULT NULL,
  PRIMARY KEY (producer_id)
);

CREATE TABLE product (
  product_id int(11) NOT NULL AUTO_INCREMENT,
  code varchar(50) NOT NULL,
  title varchar(250) NOT NULL,
  description varchar(1000) NOT NULL,
  producer_id int(11) NOT NULL,
  price decimal(9,2) NOT NULL,
  unit int(11) NOT NULL,
  PRIMARY KEY (product_id),
  UNIQUE KEY product_un (code),
  KEY product_producer_id_fk (producer_id),
  CONSTRAINT product_producer_id_fk FOREIGN KEY (producer_id) REFERENCES producer (producer_id)
);

CREATE TABLE category (
  category_id int(11) NOT NULL AUTO_INCREMENT,
  title varchar(150) NOT NULL,
  description varchar(1500) NOT NULL,
  parent_id int(11) DEFAULT NULL,
  PRIMARY KEY (category_id),
  KEY category_parent_id_fk (parent_id),
  CONSTRAINT category_parent_id_fk FOREIGN KEY (parent_id) REFERENCES category (category_id)
);

CREATE TABLE product_category (
  product_id int(11) NOT NULL,
  category_id int(11) NOT NULL,
  PRIMARY KEY (product_id,category_id),
  KEY product_category_category_id_fk (category_id),
  CONSTRAINT product_category_category_id_fk FOREIGN KEY (category_id) REFERENCES category (category_id),
  CONSTRAINT product_category_product_id_fk FOREIGN KEY (product_id) REFERENCES product (product_id)
);

CREATE TABLE image (
  image_id int(11) NOT NULL AUTO_INCREMENT,
  image_name varchar(100) NOT NULL,
  file_path varchar(250) NOT NULL,
  PRIMARY KEY (image_id)
);

CREATE TABLE product_image (
  product_id int(11) NOT NULL,
  image_id int(11) NOT NULL,
  PRIMARY KEY (product_id,image_id),
  KEY product_image_image_id_fk (image_id),
  CONSTRAINT product_image_image_id_fk FOREIGN KEY (image_id) REFERENCES image (image_id),
  CONSTRAINT product_image_product_id_fk FOREIGN KEY (product_id) REFERENCES product (product_id)
);
 
CREATE TABLE price (
  price_id int(11) NOT NULL AUTO_INCREMENT,
  product_id int(11) NOT NULL,
  begin_date timestamp NOT NULL,
  end_date timestamp NOT NULL,
  value decimal(9,2) NOT NULL,
  PRIMARY KEY (price_id),
  KEY price_product_id_fk (product_id),
  CONSTRAINT price_product_id_fk FOREIGN KEY (product_id) REFERENCES product (product_id)
);
 
CREATE TABLE rest (
  product_id int(11) NOT NULL,
  quantity int(11) NOT NULL,
  PRIMARY KEY (product_id),
  CONSTRAINT rest_fk FOREIGN KEY (product_id) REFERENCES product (product_id)
);

CREATE TABLE supplier (
  supplier_id int(11) NOT NULL,
  supplier_name varchar(300) NOT NULL,
  phone varchar(10) NOT NULL,
  address varchar(500) NOT NULL,
  email varchar(50) DEFAULT NULL,
  PRIMARY KEY (supplier_id)
);

CREATE TABLE supply (
  supply_id int(11) NOT NULL AUTO_INCREMENT,
  code varchar(30) NOT NULL,
  supply_date date NOT NULL,
  supplier_id int(11) NOT NULL,
  total decimal(14,2) NOT NULL,
  PRIMARY KEY (supply_id),
  UNIQUE KEY supply_un (code),
  KEY supply_supplier_id_fk (supplier_id),
  CONSTRAINT supply_supplier_id_fk FOREIGN KEY (supplier_id) REFERENCES supplier (supplier_id)
);

CREATE TABLE supply_product (
  supply_id int(11) NOT NULL,
  product_id int(11) NOT NULL,
  quantity int(11) NOT NULL,
  price decimal(9,2) NOT NULL,
  PRIMARY KEY (supply_id,product_id),
  KEY supply_product_product_id_fk (product_id),
  CONSTRAINT supply_product_product_id_fk FOREIGN KEY (product_id) REFERENCES product (product_id),
  CONSTRAINT supply_product_supply_id_fk FOREIGN KEY (supply_id) REFERENCES supply (supply_id)
);

CREATE TABLE customer (
  customer_id int(11) NOT NULL AUTO_INCREMENT,
  last_name varchar(30) DEFAULT NULL,
  first_name varchar(30) DEFAULT NULL,
  middle_name varchar(30) DEFAULT NULL,
  email varchar(30) NOT NULL,
  phone varchar(10) DEFAULT NULL,
  address varchar(500) DEFAULT NULL,
  PRIMARY KEY (customer_id),
  UNIQUE KEY customer_un (email)
);

CREATE TABLE orders (
  order_id int(11) NOT NULL AUTO_INCREMENT,
  customer_id int(11) NOT NULL,
  state int(11) NOT NULL,
  total decimal(14,2) NOT NULL,
  create_date timestamp NOT NULL,
  delivery_date timestamp NOT NULL,
  PRIMARY KEY (order_id),
  KEY order_customer_id_fk (customer_id),
  CONSTRAINT order_customer_id_fk FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

CREATE TABLE order_product (
  order_id int(11) NOT NULL,
  product_id int(11) NOT NULL,
  quantity int(11) NOT NULL,
  price decimal(9,2) NOT NULL,
  PRIMARY KEY (order_id,product_id),
  KEY order_product_product_id_fk (product_id),
  CONSTRAINT order_product_order_id_fk FOREIGN KEY (order_id) REFERENCES orders (order_id),
  CONSTRAINT order_product_product_id_fk FOREIGN KEY (product_id) REFERENCES product (product_id)
);
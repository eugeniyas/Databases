SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

DROP TABLE IF EXISTS test_load_table;

CREATE TABLE IF NOT EXISTS test_load_table (
	Handle text,
    Title text,
    Body text,
    Vendor text,
    Type text,
    Tags text,
    Published text,
    Option1_Name text,
    Option1_Value text,
    Option2_Name text,
    Option2_Value text,
    Option3_Name text,
    Option3_Value text,
    Variant_SKU text,
    Variant_Grams text,
    Variant_Inventory_Tracker text,
    Variant_Inventory_Qty text,
    Variant_Inventory_Policy text,
    Variant_Fulfillment_Service text,
    Variant_Price text,
    Variant_Compare_At_Price text,
    Variant_Requires_Shipping text,
    Variant_Taxable text,
    Variant_Barcode text,
    Image_Src text,
    Image_Alt_Text text,
    Gift_Card text,
    SEO_Title text,
    SEO_Description text,
    GS_Google_Product_Category text,
    GS_Gender text,
    GS_Age_Group text,
    GS_MPN text,
    GS_AdWords_Grouping text,
    GS_AdWords_Labels text,
    GS_Condition text,
    GS_Custom_Product text,
    GS_Custom_Label0 text,
    GS_Custom_Label1 text,
    GS_Custom_Label2 text,
    GS_Custom_Label3 text,
    GS_Custom_Label4 text,
    Variant_Image text,
    Variant_Weight_Unit text);
    
LOAD DATA LOCAL INFILE 'C:\\CSVs\\Apparel.csv'
	INTO TABLE test_load_table
 	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;
    
LOAD DATA LOCAL INFILE 'C:\\CSVs\\Bicycles.csv'
	INTO TABLE test_load_table
 	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;
    
LOAD DATA LOCAL INFILE 'C:\\CSVs\\Fashion.csv'
	INTO TABLE test_load_table
 	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;
    
LOAD DATA LOCAL INFILE 'C:\\CSVs\\jewelry.csv'
	INTO TABLE test_load_table
 	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;
    
LOAD DATA LOCAL INFILE 'C:\\CSVs\\SnowDevil.csv'
	INTO TABLE test_load_table
 	FIELDS TERMINATED BY ',' ENCLOSED BY '"'
	LINES TERMINATED BY '\n'
    IGNORE 1 LINES;
            
SELECT * FROM test_load_table;

TRUNCATE test_load_table;

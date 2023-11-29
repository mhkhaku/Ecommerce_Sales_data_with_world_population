-- CREATING TABLE AND UPLOADING DATA THROUGH CSV IMPORT
-- CREATING ECOMMERCE DATA

DROP TABLE ecom_data;

CREATE TABLE ecom_data (
	InvoiceNo VARCHAR,
	StockCode VARCHAR,
	Description VARCHAR,
	Quantity INT,
	InvoiceDate VARCHAR,
	UnitPrice DECIMAL(10,2),
	CustomerID INT,
	Country TEXT
);

-- CREATING WORLD POPULATION TABLE

CREATE TABLE world_population (
	Rank INT,
	CCA3 VARCHAR,
	Country TEXT,
	Capital TEXT,
	Continent TEXT,
	Population INT
);

-- CHECKING UPLOAD
SELECT * FROM ecom_data;
SELECT * FROM world_population;

-- COUNTING TOTAL NUMBER OF ROWS
SELECT COUNT(*) FROM ecom_data;
SELECT COUNT(*) FROM world_population;

-- COUNTING NULL VALUES IN THE TABLES
SELECT
    SUM(CASE WHEN InvoiceNo IS NULL OR InvoiceNo = '' THEN 1 ELSE 0 END) AS Missing_InvoiceNo,
    SUM(CASE WHEN StockCode IS NULL OR StockCode = '' THEN 1 ELSE 0 END) AS Missing_StockCode,
    SUM(CASE WHEN Description IS NULL OR Description = '' THEN 1 ELSE 0 END) AS Missing_Description,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS Missing_Quantity,
    SUM(CASE WHEN InvoiceDate IS NULL OR InvoiceDate = '' THEN 1 ELSE 0 END) AS Missing_InvoiceDate,
    SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) AS Missing_UnitPrice,
    SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS Missing_CustomerID,
    SUM(CASE WHEN Country IS NULL OR Country = '' THEN 1 ELSE 0 END) AS Missing_Country
FROM ecom_data;

SELECT 
	SUM(CASE WHEN Rank IS NULL THEN 1 ELSE 0 END) AS Missing_Rank,
	SUM(CASE WHEN CCA3 IS NULL OR CCA3 = '' THEN 1 ELSE 0 END) AS Missing_CCA3,
	SUM(CASE WHEN Country IS NULL OR Country = '' THEN 1 ELSE 0 END) AS Missing_Country,
	SUM(CASE WHEN Capital IS NULL OR Capital = '' THEN 1 ELSE 0 END) AS Missing_Capital,
	SUM(CASE WHEN Continent IS NULL OR Continent = '' THEN 1 ELSE 0 END) AS Missing_Continent,
	SUM(CASE WHEN Population IS NULL THEN 1 ELSE 0 END) AS Missing_Population
FROM world_population;

-- REMOVING BLANKS OR NULL FROM ecom_data ONLY AS THERE ARE NO BLANKS OR NULL IN WORLD POPULATION TABLE

DELETE FROM ecom_data WHERE Description IS NULL OR Description = '' OR CustomerID IS NULL;

SELECT COUNT(*) FROM ecom_data;

-- CONVERTING invoicedate FROM VARCHAR TO TIMESTAMP

ALTER TABLE ecom_data ADD COLUMN InvoiceTimeStamp TIMESTAMP;

UPDATE ecom_data SET InvoiceTimestamp = TO_TIMESTAMP(InvoiceDate, 'MM/DD/YYY HH24:MI')

ALTER TABLE ecom_data DROP COLUMN InvoiceDate;

SELECT * FROM ecom_data;

-- ADDING TOTAL PRICE COLUMN

ALTER TABLE ecom_data ADD COLUMN TotalAmount DECIMAL(10,2);

UPDATE ecom_data SET TotalAmount = quantity * unitprice;

-- SORTING COUNTRY WITH HIGHEST TOTAL SALE

SELECT country, SUM(TotalAmount) AS TotalSalesCountry FROM ecom_data
GROUP BY country
ORDER BY SUM(TotalAmount) DESC;

-- FINDING TOTAL # OF ORDERS PER COUNTRY

SELECT country, COUNT(InvoiceNo) FROM ecom_data
GROUP BY country
ORDER BY COUNT(TotalAmount) DESC;

-- CREATING TEMPORARY TABLE
CREATE TEMPORARY TABLE temp_sales (
	id SERIAL PRIMARY KEY,
	QuantitySold INT,
	TotalSales DECIMAL(10,2),
	Country TEXT,
	Population INT
	
);

-- INSERTING DATA INTO TEMP TABLE USING JOIN
INSERT INTO temp_sales (QuantitySold, TotalSales, Country, Population)
SELECT
	e.quantity,
	e.totalamount,
	e.Country,
	w.Population
FROM ecom_data AS e
JOIN world_population w ON e.country = w.country;

SELECT * FROM temp_sales;

-- CREATING CONTINENT SALES DATA FROM TEMP SALES TABLE AND WORLD POPULATION

CREATE TABLE continent_sales (
	id SERIAL PRIMARY KEY,
	Continent TEXT,
	ContinentPopulation INT,
	ContinentQtySold INT,
	ContinentSales DECIMAL(15,2)
);

-- UPDATING COLUMN TYPE TO BIG INTEGER

ALTER TABLE continent_sales
ALTER COLUMN ContinentPopulation TYPE BIGINT,
ALTER COLUMN ContinentQtySold TYPE BIGINT;

INSERT INTO continent_sales (Continent, ContinentPopulation, ContinentQtySold, ContinentSales)
SELECT
	w.Continent,
	SUM(w.population),
	SUM(ts.QuantitySold),
	SUM(ts.TotalSales)
FROM
	temp_sales AS ts
JOIN
	world_population w ON ts.country = w.country
GROUP BY
	w.continent;
	
SELECT * FROM continent_sales;

ALTER TABLE continent_sales DROP COLUMN ContinentPopulation;

ALTER TABLE continent_sales
RENAME COLUMN continentqtysold TO continent_qty_sold;

ALTER TABLE continent_sales
RENAME COLUMN continentsales TO continent_sales;

-- CREATE TABLE AS SELECT (CTAS) FUNCTION

CREATE TABLE continent_qty AS (
SELECT id, continent, continent_qty_sold
FROM continent_sales
WHERE continent LIKE '%America');
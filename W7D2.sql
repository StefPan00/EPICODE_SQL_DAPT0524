-- esercizio W7D2
-- 1.Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
-- Quali considerazioni/ragionamenti è necessario che tu faccia? 
SELECT ProductKey , count(*)
FROM dimproduct
GROUP BY ProductKey
HAVING count(*)>1 ;

/*alternativa*/
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONTRAINT_NAME='PRIMARY';

SHOW KEYS 
FROM dimproduct 
WHERE KEY_NAMe='PRIMARY';

SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_SCHEMA='ADV' AND CONSTRAINT_NAME like 'FK%';

-- 2. Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK
SELECT SalesOrderNumber, SalesOrderLineNumber, count(*)
FROM factresellersales 
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING count(*) > 1;

-- 3. Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020
SELECT OrderDate, count( distinct SalesOrderNumber) AS transactions -- il distinct!
FROM factresellersales
WHERE OrderDate>='2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;

/*4 Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) 
e il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. 
Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. 
I campi in output devono essere parlanti*/
SELECT 
    p.ProductKey,
    p.EnglishProductName AS ProductName,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.OrderQuantity) AS TotalQuantity,
    CAST(SUM(s.SalesAmount) / SUM(S.OrderQuantity) AS DECIMAL (10 , 2 )) AS AverangePrice
FROM
    factresellersales AS f
        INNER JOIN -- potrei anche usare LEFT OUTER JOIN perchè c'è il filtro sulla tabella della join
    dimproduct AS p ON f.ProductKey = p.ProductKey
WHERE
    f.OrderDate >= '2020-01-01'
GROUP BY p.ProductKey , p.EnglishProductName
ORDER BY TotalSales DESC;

-- 5 Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) 
-- per Categoria prodotto (DimProductCategory). Il result set deve esporre pertanto il nome della categoria prodotto, 
-- il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti
SELECT 
    c.EnglishProductCategoryName AS Category,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.OrderQuantity) AS TotalQuantitySales,
    SUM(SalesAmount)/SUM(OrderQuantity) AS Mean_category
FROM
    factresellersales AS f
        LEFT JOIN 
	dimproduct AS p ON f.ProductKey = p.ProductKey
        LEFT JOIN 
	dimproductsubcategory AS s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
        LEFT JOIN 
	dimproductcategory AS c ON s.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.EnglishProductCategoryName;


-- 6 Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
-- Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.
SELECT 
	g.City,
	SUM(f.SalesAmount) AS TotalSales
FROM 
	factresellersales AS f
		INNER JOIN dimgeography AS g ON f.SalesTerritoryKey=g.SalesTerritoryKey
WHERE f.OrderDate>='2020-01-01'
GROUP BY g.City
HAVING SUM(f.SalesAmount) > 60000
ORDER BY g.City;




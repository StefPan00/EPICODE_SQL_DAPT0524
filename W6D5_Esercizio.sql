-- 1.Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory)
SELECT dp.ProductKey, dp.ProductAlternateKey, dp.EnglishProductName AS ProductName, dps.EnglishProductSubcategoryName AS SubcategoryName
FROM dimproduct AS dp 
LEFT OUTER JOIN dimproductsubcategory AS dps
ON dps.ProductSubcategoryKey = dp.ProductSubcategoryKey;

-- 2.Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory).
SELECT 
    dp.ProductKey,
    dp.ProductAlternateKey,
    dp.EnglishProductName AS ProductName,
    dps.EnglishProductSubcategoryName AS SubcategoryName,
    dpc.EnglishProductCategoryName AS CategoryName
FROM dimProduct AS dp
INNER JOIN dimProductSubcategory dps 
ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN dimProductCategory dpc 
ON dps.ProductCategoryKey = dpc.ProductCategoryKey;

-- 3.Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales).
SELECT DISTINCT dp.EnglishProductName AS ProductName, dp.ProductKey
FROM dimproduct AS dp
INNER JOIN factresellersales AS frs
ON dp.ProductKey = frs.ProductKey;

-- 4.Esponi l’elenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1)
SELECT 
    dp.ProductKey,
    dp.ProductAlternateKey,
    dp.EnglishProductName AS ProductName,
    frs.ProductKey,
    dp.FinishedGoodsFlag
FROM
    DimProduct dp
        LEFT JOIN
    FactResellerSales frs ON dp.ProductKey = frs.ProductKey
WHERE
    frs.ProductKey IS NULL
        AND dp.FinishedGoodsFlag = 1;
        
-- 5. Esponi l’elenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct)
SELECT 
    dp.EnglishProductName, 
    frs.*
FROM
    factresellersales AS frs
        INNER JOIN
    dimproduct AS dp ON frs.ProductKey = dp.ProductKey;

-- 6. Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
SELECT 
	frs.ProductKey,
	dpc.EnglishProductCategoryName AS CategoryName,
	frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost
FROM factresellersales AS frs
LEFT OUTER JOIN dimproduct AS dp
ON frs.ProductKey = dp.ProductKey
LEFT OUTER JOIN dimproductsubcategory AS dps
ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
LEFT OUTER JOIN dimproductcategory AS dpc
ON dps.ProductCategoryKey = dpc.ProductCategoryKey;

-- 7.Esplora la tabella DimReseller.
SELECT *
FROM dimreseller as dr;

-- 8. Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica
SELECT *
FROM dimgeography; -- city, StateProvinceName 

-- join
SELECT
dr.ResellerKey,
dr.ResellerName,
dg.City,
dg.StateProvinceName
FROM dimreseller AS dr
INNER JOIN dimgeography AS dg
ON dr.GeographyKey = dg.GeographyKey;

-- 9. Esponi l’elenco delle transazioni di vendita. Il result set deve esporre i campi: 
-- SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
-- Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l’area geografica.

SELECT
    frs.SalesOrderNumber,
    dp.EnglishProductName,
    dpc.EnglishProductCategoryName,
    dr.ResellerName,
    dg.City,
    dg.StateProvinceName,
    dg.EnglishCountryRegionName,
    frs.SalesOrderLineNumber,
    frs.OrderDate,
    frs.UnitPrice,
    frs.OrderQuantity,
    frs.TotalProductCost
FROM factresellersales AS frs
LEFT JOIN dimproduct AS dp ON frs.ProductKey = dp.ProductKey
LEFT JOIN dimproductsubcategory AS dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
LEFT JOIN dimproductcategory AS dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
LEFT JOIN dimreseller AS dr ON frs.ResellerKey = dr.ResellerKey
LEFT JOIN dimgeography AS dg ON dr.GeographyKey = dg.GeographyKey;







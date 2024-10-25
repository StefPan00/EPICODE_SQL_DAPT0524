/*Esercizio facoltativo*/
/* 1 Implementa una vista denominata Product al fine di creare un’anagrafica (dimensione) prodotto completa. 
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, 
il nome della sottocategoria associata e il nome della categoria associata.*/
CREATE VIEW SP_VIEW_PRODUCT AS(
SELECT 
	p.productKey, 
	p.EnglishProductName AS Nome_Prodotto,
	c.EnglishProductCategoryName AS Categoria,
    s.EnglishProductSubcategoryName AS Sottocategoria
FROM dimproduct AS p
JOIN dimproductsubcategory AS s ON p.ProductSubcategoryKey= s.ProductSubcategoryKey
JOIN dimproductcategory AS c ON s.ProductCategoryKey=c.ProductCategoryKey);


/*2 Implementa una vista denominata Reseller al fine di creare un’anagrafica (dimensione) reseller completa. 
La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, 
il nome della città e il nome della regione.*/
CREATE VIEW SP_VIEW_RESELLER AS(
SELECT 
	r.ResellerKey,
	r.ResellerName,
	g.City,
	g.EnglishCountryRegionName AS Region
FROM dimreseller AS r
JOIN dimgeography AS g ON r.GeographyKey=g.GeographyKey);

/*3 Crea una vista denominata Sales che deve restituire la data dell’ordine, 
il codice documento, la riga di corpo del documento, 
la quantità venduta, l’importo totale e il profitto.*/

CREATE VIEW SSP_VIEW_SALES AS(
SELECT
r.ProductKey
,r.ResellerKey as Cliente
,r.OrderDate
, r.SalesOrderNumber
,r.SalesOrderLineNumber
, concat(r.SalesOrderNumber, r.SalesOrderLineNumber) as Corpo_Doc
, r.OrderQuantity
, r.SalesAmount
, 'RESSELLER' as Tipo_vednita
, case 
	when TotalProductCost is null then (r.SalesAmount - StandardCost*r.OrderQuantity)
else (r.SalesAmount- TotalProductCost)
end as Profit
FROM factresellersales as r
inner join dimproduct p
on r.ProductKey=p.ProductKey

UNION ALL

SELECT
i.ProductKey
,i.CustomerKey
,i.OrderDate
, i.SalesOrderNumber
,i.SalesOrderLineNumber
, concat(i.SalesOrderNumber, i.SalesOrderLineNumber) as Corpo_Doc
, i.OrderQuantity
, i.SalesAmount
, 'INTERNET' as Tipo_Vendita
, case 
	when TotalProductCost is null then (i.SalesAmount- StandardCost*i.OrderQuantity)
else (i.SalesAmount- TotalProductCost)
end as Profit
FROM factinternetsales as i
inner join dimproduct p
on i.ProductKey=p.ProductKey
order by SalesOrderNumber);



/*4 Crea un report in Excel che consenta ad un utente di analizzare quantità venduta, importo totale e profitti per prodotto/categoria prodotto e reseller/regione*/
/* Esplora la tabella DimProduct*/

SELECT count(*),count(distinct ProductKey) 
FROM dimproduct; -- check PK

/*Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi 
ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno*/

SELECT 
	ProductKey, 
    ProductAlternateKey, 
    EnglishProductName, 
    Color, 
    StandardCost, 
    FinishedGoodsFlag
FROM dimproduct;


/*Partendo dalla query scritta nel passaggio precedente, 
esponi in output i soli prodotti finiti cioè quelli 
per cui il campo FinishedGoodsFlag è uguale a 1.*/
SELECT 
	ProductKey, 
    ProductAlternateKey, 
    EnglishProductName, 
    Color, 
    StandardCost, 
    FinishedGoodsFlag
FROM dimproduct
WHERE FinishedGoodsFlag=1; -- facciamo comparire FGF per avere ad occhio una certezza

/*Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello (ProductAlternateKey) 
comincia con FR oppure BK. Il result set deve contenere il codice prodotto (ProductKey), 
il modello, il nome del prodotto, il costo standard (StandardCost) e il prezzo di listino (ListPrice).*/
SELECT 
	ProductKey, 
    ProductAlternateKey, 
    EnglishProductName, 
    Color, 
    StandardCost, 
    ListPrice
FROM dimproduct
WHERE ProductAlternateKey like 'FR%' 
OR ProductAlternateKey like 'BK%';


/*Arricchisci il risultato della query scritta nel passaggio precedente 
del Markup applicato dall’azienda (ListPrice - StandardCost)*/

SELECT 
	ProductKey, 
    ProductAlternateKey, 
    EnglishProductName, 
    Color, 
    StandardCost, 
    ListPrice - StandardCost AS Markup
FROM dimproduct
WHERE ProductAlternateKey like 'FR%' 
OR ProductAlternateKey like 'BK%';

/*Scrivi un’altra query al fine di esporre l’elenco dei prodotti 
finiti il cui prezzo di listino è compreso tra 1000 e 2000.*/
SELECT 
	ProductKey, 
    ProductAlternateKey, 
    EnglishProductName, 
    Color, 
    StandardCost, 
    ListPrice,
    ListPrice - StandardCost AS Markup
FROM dimproduct
WHERE FinishedGoodsFlag = 1
AND ListPrice BETWEEN 1000 AND 2000
order by ListPrice ASC; -- ASC oppure DESC


/*Esplora la tabella degli impiegati aziendali (DimEmployee)
Si scopre che questa tabella è in relazione con se stessa*/
SELECT* 
FROM dimemployee;

SELECT count(*), count(distinct EmployeeKey)
FROM dimemployee; -- controllo PK

/*Esponi, interrogando la tabella degli impiegati aziendali, 
l’elenco dei soli agenti. Gli agenti sono i dipendenti per i 
quali il campo SalespersonFlag è uguale a 1.*/
SELECT 
	EmployeeKey,
    FirstName,
    LastName,
    MiddleName,
    SalesPersonFlag
FROM dimemployee
WHERE SalesPersonFlag=1;

/*Interroga la tabella delle vendite (FactResellerSales). 
Esponi in output l’elenco delle transazioni registrate a partire dal 1 gennaio 2020 
dei soli codici prodotto: 597, 598, 477, 214. Calcola per ciascuna transazione il 
profitto (SalesAmount - TotalProductCost).*/
SELECT *
FROM factresellersales
WHERE ProductKey in (597, 598, 477, 214)
and OrderDate >= '2020-01-01'
ORDER BY OrderDate;
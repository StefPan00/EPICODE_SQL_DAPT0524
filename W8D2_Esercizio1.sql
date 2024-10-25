/*Esercizio W8D2--> Database Sakila*/
-- 1 Effettuate un’esplorazione preliminare del database. Di cosa si tratta? Quante e quali tabelle contiene? 
-- Fate in modo di avere un’idea abbastanza chiara riguardo a con cosa state lavorando.

SELECT *
FROM 	address;
    
SELECT 	*
FROM 	customer;

SELECT 	*
FROM 	payment;

SELECT 	*
FROM 	rental;
	

-- 2 Scoprite quanti clienti si sono registrati nel 2006
SELECT 
	COUNT(*) AS Clienti_Registrati_2006
FROM 
	customer
WHERE 
	YEAR(create_date) = 2006;
-- tutti i cliente si sono registrato nel 2006

-- 3 trovate il numero totale di noleggi effettuati il giorno 1/1/2006
SELECT 
	DATE(rental_date),
	COUNT(*) AS Noleggi_1gen2006
FROM 
	rental 
WHERE 
	DATE(rental_date) = 2006-01-01
GROUP BY
	DATE(rental_date);
-- non si hanno noleggio in quella data. 
    
-- 4 Elencate tutti i film noleggiati nell’ultima settimana e tutte le informazioni legate al cliente che li ha noleggiati
SELECT 
	YEAR (rental_date) Anno,
   --  WEEK (rental_date) Settimana,
    COUNT(*) Noleggi
FROM 
	rental
GROUP BY YEAR(rental_date) -- , WEEK(rental_date)
ORDER BY YEAR(rental_date) -- , WEEK(rental_date);
;

SELECT 
	MAX(rental_date)
FROM 
	rental;

SELECT  
	-- DATE_SUB(MIN(rental_date), INTERVAL 1 WEEK) AS Data_LW,
    r.rental_date AS Data_LW,
    f.title,
    c.first_name,
    c.last_name,
    c.email
FROM 
	film as f
JOIN 
	inventory i ON f.film_id = i.film_id
JOIN 
	rental AS r ON i.inventory_id = r.inventory_id
JOIN 
	customer c ON r.customer_id = c.customer_id
WHERE 
	r.rental_date >= (SELECT DATE_SUB(MAX(rental_date), INTERVAL 7 DAY) 
						FROM rental)
ORDER BY 
	Data_LW ASC;


-- 5 Calcolate la durata media del noleggio per ogni categoria di film.
SELECT 
	c.name AS Category_name,
    ROUND(AVG(DATEDIFF(r.return_date, r.rental_date)), 1) AS Durata_media
FROM 
	category AS c
		LEFT OUTER JOIN
	film_category AS fc ON c.category_id=fc.category_id
		LEFT OUTER JOIN 
	film AS f ON f.film_id=fc.film_id
		LEFT OUTER JOIN 
	inventory AS i ON i.film_id=f.film_id
		LEFT OUTER JOIN 
	rental AS r ON r.inventory_id=i.inventory_id
GROUP BY 
	C.name;


-- 6 Calcolate la durata del noleggio più lungo
SELECT
	r.rental_date,
    DATEDIFF(r.return_date, r.rental_date) AS durata
    FROM Rental AS r
WHERE r.return_date is not null
ORDER BY durata DESC 
LIMIT 1;

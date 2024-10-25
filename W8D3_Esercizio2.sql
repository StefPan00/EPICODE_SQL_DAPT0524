/*ESERCIZIO W8D3*/
-- 1. Identificate tutti i clienti che non hanno effettuato nessun noleggio a gennaio 2006
SELECT 
    *
FROM 
	rental
WHERE YEAR(rental_date)=2006 AND MONTH(rental_date)= 1; -- nessun cliente a gennaio 2006


-- 2.Elencate tutti i film che sono stati noleggiati più di 10 volte nell’ultimo quarto del 2005
SELECT 
	YEAR(r.rental_date) AS Anno
    , QUARTER(r.rental_date) AS Quarto_di_anno2005
    , COUNT(r.rental_id) AS conteggio_film
FROM film f
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON i.inventory_id=r.inventory_id
WHERE YEAR(r.rental_date)=2005 AND QUARTER(r.rental_date)='4' -- commento questo per vedere se la query funziona
GROUP BY YEAR(r.rental_date), QUARTER(r.rental_date), f.film_id
HAVING  COUNT(r.rental_id) >=10; -- risultato:0


-- 3.Trovate il numero totale di noleggi effettuati il giorno 1/1/2006
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


-- 4.Calcolate la somma degli incassi generati nei weekend (sabato e domenica)
SELECT 
	SUM(p.amount) AS incassi
FROM 
	payment AS p
WHERE dayofweek(p.payment_date) IN ('1', '7');


-- 5. Individuate il cliente che ha speso di più in noleggi
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS spesa
FROM payment p
JOIN customer c ON p.customer_id=c.customer_id
GROUP BY c.customer_id
ORDER BY SUM(p.amount) DESC
LIMIT 1;


-- 6. Elencare i 5 film con la maggior durata media di noleggio
SELECT
	f.film_id,
    f.title,
    DATEDIFF(r.return_date, r.rental_date) AS durata
FROM Rental AS r
JOIN inventory i ON r.inventory_id=i.inventory_id
JOIN film f ON i.film_id=f.film_id    
WHERE r.return_date is not null
ORDER BY durata DESC 
LIMIT 5;


-- 7.Calcolate il tempo medio tra due noleggi consecutivi da parte di un cliente
SELECT DISTINCT
	t.customer_id,
    ROUND(AVG(t.Tempo_Tra_noleggi),1) AS tempo_medio_tra2_noleggi
FROM (
		SELECT 
		customer_id,
        DATEDIFF(rental_date, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date)) AS Tempo_Tra_noleggi
        FROM 
        rental
	) AS t
WHERE t.Tempo_Tra_noleggi IS NOT NULL
GROUP BY t.customer_id
;

-- 8. Individuate il numero di noleggi per ogni mese del 2005
SELECT 
	YEAR (rental_date) Anno,
    MONTH (rental_date) Mese,
    COUNT(*) Noleggi
FROM 
	rental
WHERE YEAR(rental_date) = 2005
GROUP BY YEAR (rental_date), MONTH(rental_date)
ORDER BY MONTH(rental_date);


-- 9.Trovate i film che sono stati noleggiati almeno due volte lo stesso giorno
SELECT
	f.title,
    DATE(r.rental_date) AS Data_noleggio,
    COUNT(*) AS conteggio_noleggi
FROM rental r
JOIN inventory i ON r.inventory_id=i.inventory_id
JOIN film f ON i.film_id=f.film_id
GROUP BY f.title , DATE(r.rental_date)
HAVING COUNT(*) >= 2;


-- 10 Calcolate il tempo medio di noleggio
SELECT
    ROUND(AVG(DATEDIFF(r.return_date, r.rental_date)),1) AS durata
    FROM Rental AS r
WHERE r.return_date is not null;



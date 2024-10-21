/*Esercizio pratica W7D5*/
-- 1 Elencate il numero di tracce per ogni genere in ordine discendente, escludendo quei generi che hanno meno di 10 tracce
SELECT 
	g.name AS Genere,
    count(t.TrackId) AS numero_tracce
FROM track AS t
		JOIN genre AS g
	ON t.GenreId=g.GenreId
GROUP BY 
	g.GenreId
HAVING 
	COUNT(t.TrackId)>10
ORDER BY 
	numero_tracce DESC;
    
-- 2 Trovare le 3 canozni più costose
SELECT 
	Name,
    UnitPrice
FROM 
	track 
ORDER BY UnitPrice DESC
LIMIT 3;

-- 3 Elencate gli artisti che hanno canzoni più lunghe di 6 minuti
SELECT DISTINCT 
	a.Name
FROM 
	track AS t
		LEFT OUTER JOIN 
	album AS al ON t.AlbumId=al.AlbumId
		LEFT OUTER JOIN 
	artist AS a ON a.ArtistId=al.ArtistId
WHERE (t.Milliseconds/60000) > 6
ORDER BY a.name;

-- 4 Individuate la durata media delle tracce per ogni genere
SELECT 
	g.name AS Genere,
	ROUND(AVG(t.Milliseconds/60000),2) AS durata_media
FROM 
	track AS t
		LEFT OUTER JOIN 
	genre AS g ON t.GenreId=g.GenreId
GROUP BY g.name;

-- 5 Elencate tutte le canzoni con la parola “Love” nel titolo, ordinandole alfabeticamente prima per genere e poi per nome
SELECT 
	g.name AS genre,
	t.name AS track_name
FROM 
	track AS t
		LEFT OUTER JOIN 
	genre AS g ON t.GenreId=g.GenreId
WHERE t.Name LIKE '%Love %' OR t.Name LIKE '% Love' OR t.Name LIKE 'Love'
ORDER BY g.Name ASC, t.name ASC;

-- 6 Trova il costo medio per ogni tipologia di media 
SELECT 
	m.MediaTypeId,
    m.name AS Media_name,
    ROUND(AVG(t.UnitPrice),2)
FROM 
	mediatype AS m
		LEFT OUTER JOIN 
	track AS t ON m.MediaTypeId=t.MediaTypeId
GROUP BY m.MediaTypeId, m.name;


-- 7 Individuate il genere con più tracce
SELECT 
	g.GenreId,
    g.name,
    COUNT(t.TrackId) AS Numero_tracce
FROM 	
	track AS t
		LEFT OUTER JOIN 
	genre AS g ON t.GenreId=g.GenreId
GROUP BY g.GenreId, g.name
ORDER BY Numero_tracce DESC
LIMIT 1;

-- 8 Trovate gli artisti che hanno lo stesso numero di album dei Rolling Stones
SELECT
	ar.Name,
    COUNT(al.AlbumId)
FROM 
	artist AS ar
		JOIN
	album AS al ON ar.ArtistId=al.ArtistId
GROUP BY ar.Name
HAVING COUNT(al.AlbumId) = (SELECT count(al2.AlbumId)
						FROM album AS al2
                        INNER JOIN artist AS ar2
                        ON al2.ArtistId=ar2.ArtistId
                        WHERE ar2.name LIKE "The Rolling Stones")
ORDER BY ar.name;

-- 9 Trovate l’artista con l’album più costoso
SELECT 
	a.Name,
    al.Title,
    SUM(t.UnitPrice) AS Price
FROM 
	track AS t
		LEFT OUTER JOIN 
	album AS al ON t.AlbumId=al.AlbumId
		LEFT OUTER JOIN 
	artist AS a ON a.ArtistId=al.ArtistId
GROUP BY 	a.Name,
			al.Title
ORDER BY SUM(t.UnitPrice) DESC
LIMIT 1;





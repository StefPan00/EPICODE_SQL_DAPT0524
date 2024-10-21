/* 1. esplorazione Fate un elenco di tutte le tabelle. 
Visualizzate le prime 10 righe della tabella Album. Trovate il numero totale di canzoni della tabella Tracks. 
Trovate i diversi generi presenti nella tabella Genre.*/
SELECT *
FROM album 
LIMIT 10;

SELECT 
	count(distinct Name) AS Song 
FROM 
	track;
    
SELECT 
	GenreId, Name AS Genre
FROM 
	genre;
    
-- 2. Recuperate il nome di tutte le tracce e del genere associato.

SELECT 
	t.name AS song,
    g.name AS genre
FROM 
	track AS t
		LEFT OUTER JOIN 
	genre AS g ON t.GenreId=g.GenreId;
    
-- 3 Recuperate il nome di tutti gli artisti che hanno almeno un album nel database. Esistono artisti senza album nel database?
SELECT DISTINCT 
	ar.name AS Artist
   -- al.title AS Album 
FROM 
	artist as ar
		LEFT OUTER JOIN 
	album as al ON ar.artistID = al.ArtistId
WHERE al.title is not null;

SELECT DISTINCT
    ar.name AS artist -- al.Title AS album
FROM
    artist AS ar
        LEFT OUTER JOIN
    album AS al ON ar.ArtistId = al.ArtistId
WHERE
    al.title IS NULL;
    
SELECT count(distinct artistid)
FROM artist; -- partizione ok 204+71=275

SELECT
    AR.ARTISTID,
    AR.NAME AS ARTIST_NAME,
    CASE
        WHEN AL.TITLE IS NULL THEN 'NESSUN ALBUM PRESENTE'
        ELSE 'ALMENO UN ALBUM PRESENTE'
    END AS CHECK_ALBUM,
    COUNT(DISTINCT ALBUMID) AS NUM_ALBUM
FROM
    ARTIST AR
        LEFT JOIN
    ALBUM AL ON AL.ARTISTID = AR.ARTISTID
GROUP BY AR.ARTISTID , ARTIST_NAME , CHECK_ALBUM
ORDER BY CHECK_ALBUM;

-- 4 Recuperate il nome di tutte le tracce, del genere e della tipologia di media. Esiste un modo per recuperare il nome della tipologia di media?
SELECT 
	t.TrackId,
	t.name AS traccia,
    g.name AS genere,
    m.Name AS media
FROM 	
	track as t
		INNER JOIN 
	genre AS g ON t.GenreId=g.GenreId
		INNER JOIN 
	mediatype as m ON t.MediaTypeId=m.MediaTypeId;
	
-- 5 Elencate i nomi di tutti gli artisti e dei loro album
SELECT 
	a.name AS Artista,
    al.title AS Album
FROM 
	artist as a
		LEFT JOIN 
	album as al ON a.ArtistId=al.ArtistId
ORDER BY 
	a.name;


/*ESERCIZIO FACOLTATIVO 2*/
-- 1Recuperate tutte le tracce che abbiano come genere “Pop” o “Rock”
SELECT 
	t.name,
    g.name
FROM 
	track as t
		INNER JOIN
	genre as g ON t.GenreId=g.GenreId
WHERE g.name IN ('Pop', 'Rock');

-- 2 Elencate tutti gli artisti e/o gli album che inizino con la lettera “A”.
SELECT 
	ar.name,
    al.title
FROM 
	artist AS ar
		LEFT OUTER JOIN
	album as al ON ar.ArtistId=al.ArtistId
WHERE 
	ar.name like ('A%') OR al.title like ('A%');

-- 3.Elencate tutte le tracce che hanno come genere “Jazz” o che durano meno di 3 minuti
SELECT 
	t.name AS traccia,
	g.name AS Genere,
	round(t.Milliseconds/60000,2) AS durata
FROM 
	track as t
		LEFT OUTER JOIN 
	genre as g ON t.GenreId=g.GenreId
WHERE 
	g.name in ('jazz') OR t.Milliseconds/60000 <=3;
    
-- 4 Recuperate tutte le tracce più lunghe della durata media
SELECT 
	t.name AS traccia,
    ROUND(t.milliseconds / 1000 / 60,2) AS durata
FROM 
	track as t
WHERE
	t.Milliseconds > (SELECT 
            AVG(milliseconds)
        FROM
            track);
            
-- 5. Individuate i generi che hanno tracce con una durata media maggiore di 4 minuti.
SELECT 
	g.Name,
	t.name AS traccia,
    AVG (ROUND(t.milliseconds / 60000,2)) AS durata
FROM 
	genre as g
		LEFT JOIN 
	track AS t ON g.GenreId=t.GenreId
GROUP BY 
	g.name, t.name
HAVING AVG(ROUND(milliseconds /60000,2)) >= 4;
    
-- 6 Individuate gli artisti che hanno rilasciato più di un album
SELECT 
    ar.name AS artist, 
    COUNT(al.title) AS n_album
FROM
    artist AS ar
        LEFT JOIN
    album AS al ON ar.ArtistId = al.ArtistId
GROUP BY ar.name
HAVING COUNT(al.title) > 1;

-- 7 Trovate la traccia più lunga in ogni album.
SELECT 
    al.title AS album,
    t.name AS traccia,
    ROUND(t.milliseconds/60000,2) AS val_max_minute
FROM
    Track AS t
        LEFT JOIN
    album AS al ON t.AlbumId = al.AlbumId
WHERE 
	t.Milliseconds= (SELECT MAX(tr.Milliseconds)
					FROM track AS tr 
                    WHERE tr.AlbumId=al.AlbumId)
ORDER BY 
	al.title;
    
-- 8 Individuate la durata media delle tracce per ogni album.
SELECT 
	al.title AS Album,
	ROUND(AVG(t.Milliseconds/60000),2) AS durata_media
FROM 
	track as t
		LEFT JOIN 
	Album AS al ON t.AlbumId=al.AlbumID
GROUP BY al.title;

-- 9 Individuate gli album che hanno più di 20 tracce e mostrate il nome dell’album e il numero di tracce in esso contenute.
SELECT 
    al.title AS album,
    COUNT(t.name) AS numero_tracce
FROM 	
	album as al
		left join 
	track as t on al.AlbumId=t.AlbumId
GROUP BY 
	al.title
HAVING count(t.name) >20;
    
    


	
	

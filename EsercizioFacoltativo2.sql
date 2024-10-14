/*Esercizio 2  prodotti facoltativo*/

CREATE SCHEMA Esercizio_2_prodotto;
USE Esercizio_2_prodotto;

CREATE TABLE Prodotto (
	id_prodotto INT NOT NULL,
    nome_prodotto VARCHAR(100),
    prezzo DECIMAL (10,2),
    CONSTRAINT PK_id_prodotto PRIMARY KEY (id_prodotto));

CREATE TABLE Cliente (
	id_cliente INT NOT NULL,
    nome VARCHAR(50),
    Email VARCHAR(100),
    CONSTRAINT PK_id_cliente PRIMARY KEY (id_cliente));
    
CREATE TABLE Ordine (
	id_ordine INT NOT NULL,
    id_prodotto INT NOT NULL,
    id_cliente INT NOT NULL,
    quantità INT NOT NULL,
    CONSTRAINT PK_id_ordine PRIMARY KEY (id_ordine),
    CONSTRAINT FK_id_prodotto FOREIGN KEY (id_prodotto) REFERENCES Prodotto (id_prodotto),
    CONSTRAINT FK_id_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente));
    
CREATE TABLE Dettaglio_Ordine (
	id_ordine INT NOT NULL,
    id_prodotto INT NOT NULL,
    id_cliente INT NOT NULL,
    prezzo_totale DECIMAL(10,2),
    CONSTRAINT PK_id_ordine_id_prodotto_id_cliente PRIMARY KEY (id_ordine, id_prodotto, id_cliente),
    CONSTRAINT FK_id_ordine FOREIGN KEY (id_ordine) REFERENCES Ordine (id_ordine),
    CONSTRAINT FK_id_prodotto_dettaglio FOREIGN KEY (id_prodotto) REFERENCES Prodotto (id_prodotto),
    CONSTRAINT FK_id_cliente_dettaglio FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente));

INSERT INTO Prodotto VALUES 
(1,"Tablet",300),
(2,"Mouse",20),
(3,"Tastiera",25),
(4,"Monitor",180),
(5,"HHD",90),
(6,"SSD",200),
(7,"RAM",100),
(8,"Router",80),
(9,"Webcam",45),
(10,"GPU",1250),
(11,"Trackpad",500),
(12,"Techmagazine",5),
(13,"Martech",50);

INSERT INTO Cliente VALUES 
(1,"Antonio",NULL),
(2,"Battista","battista@mailmail.it"),
(3,"Maria","maria@posta.it"),
(4,"Franca","franca@lettere.it"),
(5,"Ettore",NULL),
(6,"Arianna","arianna@posta.it"),
(7,"Piero","piero@lavoro.it");

INSERT INTO Ordine VALUES
(1,2,1,10),
(2,6,2,2),
(3,5,3,3),
(4,1,3,1),
(5,9,7,1),
(6,4,6,2),
(7,11,7,6),
(8,10,1,2),
(9,3,5,3),
(10,3,3,1),
(11,2,2,1);

INSERT INTO Dettaglio_Ordine VALUES
(1,2,1,55.50),
(2,6,2,47.75),
(3,5,3,173),
(4,1,3,1742.99);


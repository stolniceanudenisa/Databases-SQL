/*
Creati baza de date a unei aplicatii care tine evidenta tablourilor unor
pictori si a clientilor acestora. Entitatile de interes pentru domeniul
problemei sunt Tablou, Pictor, Galerie si Client. Un tablou are un titlu,
un an cand a fost pictat, un pret si un autor (pictor). Pictorii au un nume
si o adresa. Un pictor picteaza mai multe tablouri, un tablou fiind creatia
unui singur pictor. O galerie are un numesi o adresa. Intr-o galerie sunt expuse
mai multe tablouri, iar un tablou poate fi expus in mai multe galerii (in momente
de timp diferite). Pentru fiecare tablou expus intr-o anumita galerie se memoreaza
un interval delimitat de o data de inceput si o data de sfarsit. Un client are un
nume si un numar de telefon. Un client poate achizitiona mai multe tablouri.

Cerinte:
1. Scrieti un script SQL pentru a crea baza de date relationala corespunzatoare
reprezentarii datelor necesare. (5 puncte)
2. Scrieti o functie care primeste ca parametru id-ul unui pictor si returneaza
id-ul galeriei, numele galeriei si numarul de picturi expuse ale acestui pictor. (4 puncte)

create database Arta
GO
USE Arta

create table Pictor
(
id int primary key,
nume varchar(100) not null,
adresa varchar(150) not null
);

create table Galerie
(
id int primary key,
nume varchar(100) not null,
adresa varchar(150) not null,
);

create table Tablou
(
id int primary key,
titlu varchar(100) not null,
an int not null,
pret double precision not null,
id_autor int foreign key references Pictor(id)
on delete set null
on update cascade,
id_galerie int foreign key references Galerie(id)
on delete set null
on update cascade,
expunere date not null,
retragere date not null
);

create table Client
(
id int primary key,
nume varchar(100) not null,
nr_telefon varchar(10) not null,
id_tablou_cumparat int foreign key references tablou(id)
);

insert into Pictor values
(1,'Leonardo da Vinci','Anchiano Italia'),
(2,'Vincent van Gogh','Zundert, Olanda'),
(3,'Nicolae Grigorescu','Pitaru, Romania');

insert into Galerie values 
(1,'Luvru','Paris, Franta'),
(2,'Istoria Artei','Viena, Austria'),
(3,'Arte frumoase','Budapesta, Ungaria');

insert into Tablou values
(4,'Desen Tudor Suiu cls a IV-a',2002,10,1,3,'1945-02-23','2005-04-01'),
(1,'Gioconda',1797,13000000,1,1,'2002-09-12','2025-09-12'),
(2,'Starry Night',1889,1000000,2,3,'2012-05-29','2022-01-20'),
(3,'Car cu boi',1931,245000,3,2,'1945-02-23','2005-04-01');

insert into Client values
(1,'Tudor Suiu','0753912113',2),
(2,'Tudor Suiu','0753912113',1),
(3,'Alexandru Topan','0712345678',3);

CREATE FUNCTION getGalerieAndNrPicturi(@id_pictor INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT g.id AS gallery_id, g.nume AS gallery_name, COUNT(t.id) AS nr_tablouri
    FROM Galerie g
    JOIN Tablou t 
	ON t.id_galerie = g.id
    WHERE t.id_autor = @id_pictor
    GROUP BY g.id, g.nume
)

drop procedure getGalerieAndNrPicturi

*/

select * from getGalerieAndNrPicturi(2)
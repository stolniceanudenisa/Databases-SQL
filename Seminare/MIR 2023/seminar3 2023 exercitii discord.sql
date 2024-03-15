
CREATE DATABASE SEM3;

USE SEM3;

CREATE TABLE Categorie(
	id_cat INT NOT NULL PRIMARY KEY,
	nume NVARCHAR(30),
	descriere NVARCHAR(100)
);


create table Publicatie(
    id_publ int primary key not null,
    titlu nvarchar(255),
    abstract nvarchar(255),
    autorp nvarchar(255),
    id_cat int,
    foreign key (id_cat) references Categorie(id_cat)
)

create table Biblioteca(
    id_biblio int primary key not null,
    nume nvarchar(255),
    site nvarchar(255)
)

create table Indexare(
    id_publ int not null,
    id_biblio int not null,
    constraint pk_indexare primary key (id_publ, id_biblio),
    foreign key (id_biblio) references Biblioteca(id_biblio),
    foreign key (id_publ) references Publicatie(id_publ)
)

INSERT INTO Biblioteca VALUES(1, 'NUME1', 'NUME1.ro')
INSERT INTO Biblioteca VALUES(2, 'NUME2', 'NUME2.ro')
INSERT INTO Biblioteca VALUES(3, 'NUME3', 'NUME3.ro')
INSERT INTO Biblioteca VALUES(4, 'NUME4', 'NUME4.ro')
INSERT INTO Biblioteca VALUES(5, 'NUME5', 'NUME5.ro')

INSERT INTO Categorie VALUES(1,'Fiction','DESCRIERE1')
INSERT INTO Categorie VALUES(2,'Non-Fiction','DESCRIERe2')
INSERT INTO Categorie VALUES(3,'Adventure','DESCRIERE3')
INSERT INTO Categorie VALUES(4,'Memoir','DESCRIERE4')
INSERT INTO Categorie VALUES(5,'Action','DESCRIERE5')

INSERT INTO Publicatie VALUES(1,'TITLU1', 'ABSTRACT1', 'ROMAN RAUL ION',1)
INSERT INTO Publicatie VALUES(2,'TITLU1', 'ABSTRACT2', 'TICLEA VERONICA',1)
INSERT INTO Publicatie VALUES(3,'TITLU1', 'ABSTRACT3', 'RUST VASTI',3)
INSERT INTO Publicatie VALUES(4,'TITLU1', 'ABSTRACT4', 'TODORUT MARIUS IONUT',5)
INSERT INTO Publicatie VALUES(5,'TITLU1', 'ABSTRACT5', 'ROMAN RAUL ION',2)

INSERT INTO Indexare VALUES(1,3);
INSERT INTO Indexare VALUES(2,5);
INSERT INTO Indexare VALUES(1,2);
INSERT INTO Indexare VALUES(3,1);
INSERT INTO Indexare VALUES(5,4);

SELECT site, nume FROM Biblioteca

SELECT DISTINCT id_publ FROM Indexare

SELECT titlu FROM Publicatie
WHERE autorp='ROMAN RAUL ION'

SELECT titlu FROM Publicatie
WHERE autorp='ROMAN RAUL ION' AND id_cat=1

SELECT site FROM Biblioteca
WHERE nume='ACM' OR nume='DBLP'

SELECT titlu FROM Publicatie
WHERE autorp LIKE '%ION%'

SELECT nume, descriere FROM Categorie
WHERE id_cat != 3 AND id_cat != 2 AND id_cat != 1

SELECT nume, descriere FROM Categorie
WHERE id_cat NOT IN (1,2,3)

UPDATE Biblioteca
set nume='ACM'
WHERE id_biblio%2=1

UPDATE Biblioteca
set nume='DBLP'
WHERE id_biblio%2=0


select Publicatie.titlu,Categorie.nume 
from Publicatie
inner join  Categorie on Publicatie.id_cat = Categorie.id_cat
where autorp = 'Roman Raul Ion'


select Publicatie.titlu
from Publicatie
left join Indexare on Publicatie.id_publ = Indexare.id_publ


select autorp from Publicatie
inner join Categorie on Publicatie.id_cat=Categorie.id_cat
where Categorie.nume = 'Fiction'
union
select autorp from Publicatie
inner join Categorie on Publicatie.id_cat=Categorie.id_cat
where Categorie.nume = 'Adventure'
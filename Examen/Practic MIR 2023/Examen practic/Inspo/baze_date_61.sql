/*
Creati baza de date a unei aplicatii care tine evidenta unor ateliere de placi de 
surf. Entitatile de interes pentru domeniul problemei sunt: Placa, Creator, Atelier, 
Client. O placa de surf (intelegem aici un model de placa) are o denumire si e creata
de un creator. Un creator are un nume si un numar de telefon. Un creator creeaza mai 
multe placi (modele), iar o placa e creata de un singur creator. Un atelier are un
nume si o adresa. Un atelier vinde mai multe placi iar o placa (model se vinde intr-un 
singur atelier). Un client poate cumpara mai multe placi iar o placa poate fi vanduta 
mai multor clienti. Pentru fiecare placa vanduta unui client se inregistreaza pretul
si data.

1. Scrieti un script SQL pentru a crea baza de date relationala corespunzatoare 
reprezentarii datelor necesare. (5 puncte)

create database CrearePlaci
GO
USE CrearePlaci

create table creator
(
id int primary key,
nume varchar(100),
nr_telefon varchar(10)
)

create table atelier
(
id int primary key,
nume varchar(100),
adresa varchar(100),
)

create table placa
(
id int primary key,
denumire varchar(100),
id_creator int foreign key references creator(id),
id_atelier int foreign key references atelier(id)
)

create table client
(
id int primary key,
nume varchar(100),
nr_telefon varchar(10)
)

create table tranzactie
(
id int primary key,
id_placa int foreign key references placa(id),
id_client int foreign key references client(id),
pret double precision,
datat date
)

INSERT INTO creator (id, nume, nr_telefon) VALUES (1, 'Ion Popescu', '070123456');
INSERT INTO creator (id, nume, nr_telefon) VALUES (2, 'Maria Vasilescu', '070123457');
INSERT INTO creator (id, nume, nr_telefon) VALUES (3, 'Vasile Georgescu', '070123458');

INSERT INTO atelier (id, nume, adresa) VALUES (1, 'Atelierul Ion Popescu', 'Strada A, nr. 1');
INSERT INTO atelier (id, nume, adresa) VALUES (2, 'Atelierul Maria Vasilescu', 'Strada B, nr. 2');
INSERT INTO atelier (id, nume, adresa) VALUES (3, 'Atelierul Vasile Georgescu', 'Strada C, nr. 3');

INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (1, 'Placa 1', 1, 1);
INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (2, 'Placa 2', 2, 2);
INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (3, 'Placa 3', 3, 3);
INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (4, 'Placa 4', 3, 2);
INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (5, 'Placa 5', 3, 3);
INSERT INTO placa (id, denumire, id_creator, id_atelier) VALUES (6, 'Placa 6', 3, 1);


INSERT INTO client (id, nume, nr_telefon) VALUES (1, 'Ion Ionescu', '070123459');
INSERT INTO client (id, nume, nr_telefon) VALUES (2, 'Maria Marin', '070123460');
INSERT INTO client (id, nume, nr_telefon) VALUES (3, 'Vasile Vasi', '070123461');

INSERT INTO tranzactie (id, id_placa, id_client, pret, datat) VALUES (1, 1, 1, 100, '2022-01-01');
INSERT INTO tranzactie (id, id_placa, id_client, pret, datat) VALUES (2, 2, 2, 200, '2022-02-01');
INSERT INTO tranzactie (id, id_placa, id_client, pret, datat) VALUES (3, 3, 3, 300, '2022-03-01');


2. Scrieti o functie care primeste ca parametru id-ul unui creator si returneaza
id-ul atelierului, numele atelierului si numarul de placi create ale acelui creator. 
(4 puncte)

create function getModeleCreate(@id_creator int)
returns table
as
return
(
select a.id, a.nume, count(p.id) as nr_placi
from Atelier a
join Placa p
on a.id = p.id_atelier
where p.id_creator = @id_creator
group by a.id, a.nume
)

select * from getModeleCreate(3)
*/

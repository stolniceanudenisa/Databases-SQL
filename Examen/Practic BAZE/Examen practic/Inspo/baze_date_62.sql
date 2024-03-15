/*
Creati baza de date a unei apl;icatii care tine evidenta unui complex acvatic si a clientilor acestuia. Entitatile de interes
pentru domenul problemei sunt Complex, Piscina, Tratament si Client. Un complex acvatic are un nume si o adresa. Complexul 
acvatic pune la dispozitia clientilor mai multe tratamente si mai multe piscine. Un tratament poarta o denumire si are un pret.
O piscina are un nume si un tip (adulti, copii, caini, etc). Un client are nume si numar de telefon. Un client poate beneficia 
de mai multe tratemente intr-un complex acvatic, acelasi tratament putand fi oferit mai multor clienti. Pentru fiecare tratament
pe care il face un client se inregistreaza data. 

Cerinte:
1. Scrieti un script SQL pentru a crea baza de date relationala corespunzatoare reprezentarii datelor necesare. (5 puncte)
2. Scrieti un view care afiseaza pentru data de 01 decembrie 2019 numele fiecarui client si suma de bani cheltuita de acesta pentru
eventuale tratamente efectuate in acea zi. (4 puncte)

create database ComplexManager
GO
USE ComplexManager

create table complex 
(
id int primary key,
nume varchar(100),
adresa varchar(100),
)

create table tratament
(
id int primary key,
denumire varchar(100),
pret double precision,
id_complex int foreign key references complex(id)
)

create table piscina
(
id int primary key,
nume varchar(100),
tip varchar(100),
id_complex int foreign key references complex(id)
)

create table client
(
id int primary key,
nume varchar(100),
nr_telefon varchar(10)
)

create table plantratament
(
id int primary key,
id_client int foreign key references client(id),
id_tratament int foreign key references tratament(id),
datat date
)

INSERT INTO complex VALUES 
(1, 'Complexul Sportiv 1', 'Strada Principala nr. 10');

INSERT INTO tratament VALUES 
(1, 'Tratament cu clor', 50, 1),
(2, 'Masaj', 150, 1),
(3, 'Mers pe carbuni', 60,1);

INSERT INTO piscina VALUES 
(1, 'Piscina cu Clor', 'Copii', 1),
(2, 'Piscina cu H20', 'Adulti', 1),
(3, 'Piscina cu gay de pl sa ma iei', 'Gay',1);

INSERT INTO client VALUES 
(1, 'Ion Popescu', '0712345678'),
(2, 'Alexandru Topan', '0701234567');

INSERT INTO plantratament VALUES 
(3,1,1,'2022-01-01'),
(1, 1, 1, '2022-01-01'),
(2, 1, 2,'2022-01-01');

2. Scrieti un view care afiseaza pentru data de 01 ianuarie 2022 numele fiecarui client si suma de bani cheltuita de acesta pentru
eventuale tratamente efectuate in acea zi. (4 puncte)

create view getClientsAndSumPrices
as
select c.nume, sum(t.pret) as total
from client c
join plantratament p
on c.id = p.id_client
join tratament t
on p.id_tratament = t.id
where p.datat = '2022-01-01'
group by c.nume;
*/

select * from getClientsAndSumPrices

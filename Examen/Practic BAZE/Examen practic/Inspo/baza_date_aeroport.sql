/*
Creati baza date a unei aplicatii de management a transportului aviatic. Entitatile relevante sunt: pasager, aeroport, zbor, bilet, companie aeriana, tara.
Un pasager are nume, sex, data nasterii si cetatenie.
Un aeroport are cod, nume, tara.
Un zbor are cod, companie aeriana, aeroport origine, aeroport destinatie. 
O tare are cod si nume.
O companie aeriana are cod, nume, tara.
Un bilet are pasager, data, clasa, pret.

Cerinte:
1. Scrieti un scrip SQL pentru a crea si popula baza de date relationala corespunzatoare reprezentarii datelor necesare. (5 puncte)

create database companie
GO
USE companie

create table pasager
(
cod int primary key,
nume varchar(100),
sex varchar(50),
data_nasterii date,
cetatenie varchar(50)
)

create table aeroport
(
cod int primary key,
nume varchar(50),
tara varchar(50)
)

create table tara
(
cod int primary key,
nume varchar(100)
)

create table companie_aeriana
(
cod int primary key,
nume varchar(100),
cod_tara int foreign key references tara(cod)
)

create table zbor
(
cod int primary key,
cod_companie int foreign key references companie_aeriana(cod),
cod_aeroport_origine int foreign key references aeroport(cod),
cod_aeroport_destinatie int foreign key references aeroport(cod)
)

create table bilet
(
cod int primary key,
cod_pasager int foreign key references pasager(cod),
datab date,
clasa int,
pret double precision,
cod_zbor int foreign key references zbor(cod)
)

Insert into pasager (cod, nume, sex, data_nasterii, cetatenie) values (1, 'John Doe', 'masculin', '1990-01-01', 'România');
Insert into pasager (cod, nume, sex, data_nasterii, cetatenie) values (2, 'Jane Smith', 'feminin', '1995-05-15', 'SUA');
Insert into aeroport (cod, nume, tara) values (1, 'Henri Coandă', 'România');
Insert into aeroport (cod, nume, tara) values (2, 'John F. Kennedy', 'SUA');
Insert into tara (cod, nume) values (1, 'România');
Insert into tara (cod, nume) values (2, 'SUA');
Insert into companie_aeriana (cod, nume, cod_tara) values (1, 'Air Romania', 1);
Insert into companie_aeriana (cod, nume, cod_tara) values (2, 'American Airlines', 2);
Insert into bilet (cod, cod_pasager, datab, clasa, pret,cod_zbor) values (1, 1, '2022-12-25', 2, 200,1);
Insert into bilet (cod, cod_pasager, datab, clasa, pret,cod_zbor) values (2, 2, '2022-12-25', 1, 250,2);
Insert into zbor (cod, cod_companie, cod_aeroport_origine, cod_aeroport_destinatie) values (1, 1, 1, 2);
Insert into zbor (cod, cod_companie, cod_aeroport_origine, cod_aeroport_destinatie) values (2, 2, 2, 1);

2. Scrieti o functie care primeste ca parametru o tara si returneaza numele si data nasterii pentru toti pasagerii cetateni ai acelei tari care au un bilet
cu destiantia in acea tara.
Exemplu: toti pasagerii cetateni romani care au bilet catre oricare din Bucuresti,Cluj,Iasi,etc.).
*/

create function getTicketsForCitizensFromGivenCountry(@tara varchar(100))
returns table
as
return
(
	select p.nume, p.data_nasterii
	from Bilet b
	join Pasager p
	on b.cod_pasager = p.cod
	join Zbor z
	on b.cod_zbor = z.cod
	join Aeroport a
	on z.cod_aeroport_destinatie = a.cod
	where p.cetatenie = @tara and a.tara = @tara
)

drop function getTicketsForCitizensFromGivenCountry

select * getTicketsForCitizensFromGivenCountry('Romania')


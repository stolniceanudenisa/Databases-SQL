/*
Creati baza de date a unei aplicatii care tine evidenta unui complex acvatic si a clientilor acestuia. Entitatile de interes
pentru domenul problemei sunt: Complex, Piscina, Tratament si Client. Un complex acvatic are un nume si o adresa. Complexul 
acvatic pune la dispozitia clientilor mai multe tratamente si mai multe piscine. Un tratament poarta o denumire si are un pret.
O piscina are un nume si un tip (ex: adulti, copii, caini, etc). Un client are nume si numar de telefon. Un client poate beneficia 
de mai multe tratemente intr-un complex acvatic, acelasi tratament putand fi oferit mai multor clienti. Pentru fiecare tratament
pe care il face un client se inregistreaza data. 

Cerinte:
1. Scrieti un script SQL pentru a crea baza de date relationala corespunzatoare reprezentarii datelor necesare.
2. Scrieti un view care afiseaza pentru data de 01 decembrie 2019 numele fiecarui client si suma de bani cheltuita de acesta pentru
eventuale tratamente efectuate in acea zi. 

*/

create database CreateComplex
GO
USE CreateComplex

create table complex (id_complex int primary key,nume_complex varchar(100),adresa varchar(100))

create table tratament(id_tratament int primary key,denumire_tratament varchar(100),pret double precision,id_complex int foreign key references complex(id_complex))

create table piscina(id_piscina int primary key,nume_piscina varchar(100),tip varchar(100),id_complex int foreign key references complex(id_complex))

create table client(id_client int primary key,nume_client varchar(100),nr_telefon varchar(10))

create table programare(id_programare int primary key,id_client int foreign key references client(id_client),id_tratament int foreign key references tratament(id_tratament),datat date)

INSERT INTO complex(id_complex, nume_complex, adresa) VALUES 
(1, 'Complex 1', 'Strada 1'),
(2, 'Complex 2', 'Strada 2'),
(3, 'Complex 3', 'Strada 3');

INSERT INTO tratament(id_tratament, denumire_tratament, pret, id_complex) VALUES 
(1, 'Tratament 1', 50, 1),
(2, 'Tratament 2', 150, 1),
(3, 'Tratament 3', 60,1);

INSERT INTO piscina(id_piscina, nume_piscina, tip, id_complex) VALUES 
(1, 'Piscina 1', 'Tip 1', 1),
(2, 'Piscina 2', 'Tip 1', 2),
(3, 'Piscina 3', 'Tip 1',2);

INSERT INTO client(id_client, nume_client, nr_telefon) VALUES 
(1, 'Stanciu Alexandra', '0756333259'),
(2, 'Alexandru Topan', '0788956412'),
(3, 'Suiu Tudor', '0798565656'),
(4, 'Stejeroiu Oana', '0784542321');

INSERT INTO programare(id_programare, id_client, id_tratament, datat) VALUES 
(1,1,1,'2019-12-01'),
(2, 4, 1, '2022-01-01'),
(3, 3, 2,'2019-12-01'),
(4, 4, 3, '2022-12-01'),
(5, 1, 2,'2019-01-05'), 
(6, 1, 2,'2019-12-01');


/*
2. Scrieti un view care afiseaza pentru data de 01 decembrie 2019 numele fiecarui client si suma de bani cheltuita de acesta pentru
eventuale tratamente efectuate in acea zi. 
*/


create view getClientiSuma
as
select c.nume_client, sum(t.pret) as total
from client c
join programare p
on c.id_client = p.id_client
join tratament t
on p.id_tratament = t.id_tratament
where p.datat = '2019-12-01'
group by c.nume_client;


select * from getClientiSuma

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
*/

create database CrearePlaci
GO
USE CrearePlaci

create table creator(id_creator int primary key,nume_creator varchar(100), nr_telefon_creator varchar(10))

create table atelier(id_atelier int primary key,nume_atelier varchar(100),adresa varchar(100))

create table placa(id_placa int primary key,denumire_placa varchar(100),id_creator int foreign key references creator(id_creator),id_atelier int foreign key references atelier(id_atelier))

create table client(id_client int primary key,nume_client varchar(100),nr_telefon_client varchar(10))

create table tranzactie(id_tranzactie int primary key,id_placa int foreign key references placa(id_placa),id_client int foreign key references client(id_client),pret double precision,data_tranzactie date)



INSERT INTO creator (id_creator, nume_creator, nr_telefon_creator) VALUES 
(1, 'Stanciu Alexandra', '0768468025'),
(2, 'Suiu Tudor', '0756215589'),
(3, 'Topan Alexandru', '0798555632');



INSERT INTO atelier (id_atelier, nume_atelier, adresa) VALUES 
(1, 'Atelier 2', 'Strada A, nr. 1'),
(2, 'Atelier 3', 'Strada B, nr. 2'),
(3, 'Atelier 4', 'Strada C, nr. 3');



INSERT INTO placa (id_placa, denumire_placa, id_creator, id_atelier) VALUES 
/*(1, 'Placa 1', 1, 1),
(2, 'Placa 2', 1, 2),
(3, 'Placa 3', 1, 3),
(4, 'Placa 4', 2, 3),
*/
(5, 'Placa 5', 3, 2),
(6, 'Placa 6', 3, 1);



INSERT INTO client (id_client, nume_client, nr_telefon_client) VALUES 
(1, 'Zarnescu Bogdan', '0798532665'),
(2, 'Tamasan Andreea', '0789563215'),
(3, 'Veltan Vlad', '0789541239'),
(4, 'Stejeroiu Oana', '0795121369');


INSERT INTO tranzactie (id_tranzactie, id_placa, id_client, pret, data_tranzactie) VALUES
(1, 1, 1, 100, '2023-01-01'),
(2, 1, 2, 200, '2024-01-01'),
(3, 3, 2, 500, '2025-01-01');



/*
2. Scrieti o functie care primeste ca parametru id-ul unui creator si returneaza
id-ul atelierului, numele atelierului si numarul de placi create ale acelui creator. 
(4 puncte)
*/

create function getModeleCreate(@id_creator int)
returns table
as
return
(
select a.id_atelier, a.nume_atelier, count(p.id_placa) as nr_placi
from Atelier a
join Placa p
on a.id_atelier = p.id_atelier
where p.id_creator = @id_creator
group by a.id_atelier, a.nume_atelier
)


select * from getModeleCreate(3)


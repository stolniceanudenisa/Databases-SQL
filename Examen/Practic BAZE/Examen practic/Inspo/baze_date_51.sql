/* 
Creati baza de date a unei aplicatii  care tine evidenta unor posibili angajati. Entitatile de interes
sunt: Persoana, CV, Educatie si Informatii_Educator. O persoana are date de tipul CNP, Nume, Data nasterii.
Un CV contine date despre Persoana (ID) care-l detine si Educatia (ID) acelei persoane. Educatia contine informatii
despre numele unei unitati educationale, nivelul educational maxim oferit (primar, gimnazial, liceal,licenta,masterat,
doctorat) si cati ani sunt necesari pentru a completa nivelul educational. Informatiil despre Educator contine numele 
Educatorului, ID-ul organizatiei educationale din care face parte si un nr. de telefon si email.

Cerinte:
1. Scrieti un script SQL pentru a crea baza de date relationala corespunzatoare reprezentarii datelor necesare. (5p)
2. Scrieti un trigger de inserare care sa afiseze pe ecran daca CV-ul a fost adaugat cu succes. (4p)
*/

/* 
create database Firma
GO 
USE Firma

create table persoana
(
id int primary key, 
cnp varchar(13) not null, 
nume varchar(100) not null, 
data_nasterii date not null
);

create table educatie
(
id int primary key, 
nume varchar(100) not null, 
nivel varchar(10) not null, 
ani int not null
);

create table cv
(
id_persoana int foreign key references persoana(id) 
on delete cascade 
on update cascade, 
id_educatie int foreign key references educatie(id) 
on delete cascade
on update cascade, 
constraint pk_CV primary key (id_persoana, id_educatie)
);

create table educator
(
id int primary key, 
nume varchar(100) not null, 
id_organizatie int foreign key references educatie(id)
on update cascade 
on delete cascade, 
nr_telefon varchar(10) not null, 
email varchar(100) not null
);
*/

/*
INSERT INTO Persoana VALUES
(1,'1234567890123','Bafta Charlie','2001-03-01'),
(2,'2345678901234','Kim Possible','2004-12-23'),
(3,'3456789012345','Perry Ornitorincul','1990-10-06');

INSERT INTO Educatie VALUES
(1,'Scoala Gimnaziala Varucu','gimnazial',9),
(2,'Liceul Intergalactic "Petru Rares"','liceal',4),
(3,'Facultatea de Matematica-Smecherie','masterat',5);

INSERT INTO CV VALUES
(1,1),
(2,3),
(3,2);

INSERT INTO Educator VALUES
(1,'Doofensmirtz Maleficul',3,'0712345678','doofy@gmail.com'),
(2,'Dragon American',1,'0723456789','americandrim@gmail.com'),
(3,'Selena Gomez',2,'0734567890','selenasely95@gmail.com');

create or alter trigger trigger_cv_insert on CV instead of insert
as
begin
declare @id_persoana int
declare @id_educatie int
select @id_persoana = id_persoana, @id_educatie = id_educatie from inserted

insert into cv values(@id_persoana, @id_educatie);
print 'CV-ul a fost adaugat cu succes!'
end 

delete from cv where id_persoana = 1;
delete from cv where id_persoana = 2;
delete from cv where id_persoana = 3;

INSERT INTO CV VALUES(1,1); 
*/


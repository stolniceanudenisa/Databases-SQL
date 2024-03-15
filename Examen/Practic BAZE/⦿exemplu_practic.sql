/* 
Creati o baza de date pentru gestiunea unui spital. 

Entitatile de interes pentru baza de date sunt: departamente, doctori, pacienti, boli, tratamente.

Un departament are un nume, poate fi disponibil non stop si are o lista de doctori. 

Un doctor are un nume si data nasterii. Poate fi responsabil de 
mai multi pacienti.

Un pacient are un nume, data nasterii si poate suferi de mai multe boli. Un pacient poate frecventa mai multi doctori.

Bolile au o denumire si pot avea mai multe tratamente.

Un tratament are o descriere si poate fi folosit in tratarea mai multor boli.

	1. Reprezenta?i diagrama bazei de date rela?ionale descrise în enun?. 
	2. Scrie?i o interogare SQL care s? afi?eze toate departamentele a caror denumire contine termenul "pediatrie".
	3. Crea?i o functie care returneaza cate boli de care sufera mai mult de 3 pacienti exista.
	4. Crea?i un view care afi?eaz? acele tratamente care incep cu litera “A” si sunt folosite pentru mai mult de 2 boli.
	5. Crea?i un view care afi?eaz? acele departamente disponibile non stop care au mai mult de 3 doctori asignati.
*/

CREATE TABLE Departamente(
	id_departament int primary key,
	nume varchar(50),
	non_stop bit,
);

CREATE TABLE Doctori(
	id_doctor int primary key,
	nume varchar(50),
	data_nasterii date,
	id_departament int foreign key references Departamente(id_departament)
);

CREATE TABLE Pacienti(
	id_pacient int primary key,
	nume varchar(50),
	data_nasterii date,
);

CREATE TABLE DoctoriPacienti(
	id_doctor int foreign key references Doctori(id_doctor),
	id_pacient int foreign key references Pacienti(id_pacient),
	PRIMARY KEY(id_doctor, id_pacient)
);

/*CREATE TABLE Programare(
	id_programare int primary key,
	id_doctor int foreign key references Doctori(id_doctor),
	id_pacient int foreign key references Pacienti(id_pacient),
	data_programare date,
	durata int,
	pret float
);*/

CREATE TABLE Boli(
	id_boala int primary key,
	denumire varchar(100),
);

CREATE TABLE BoliPacienti(
	id_boala int foreign key references Boli(id_boala),
	id_pacient int foreign key references Pacienti(id_pacient)
);

CREATE TABLE Tratamente(
	id_tratament int primary key,
	denumire varchar(60),
);

CREATE TABLE BoliTratamente(
	id_boala int foreign key references Boli(id_boala),
	id_tratament int foreign key references Tratamente(id_tratament),
	primary key(id_boala, id_tratament)
);

--	2. Scrie?i o interogare SQL care s? afi?eze toate departamentele a caror denumire contine termenul "pediatrie".
SELECT *
FROM Departamente
WHERE nume LIKE '%pediatrie%';

--	3. Crea?i o functie care returneaza cate boli de care sufera mai mult de 3 pacienti exista.

	SELECT id_boala
	FROM BoliPacienti
	GROUP BY id_boala
	HAVING count(*) > 3;

go
CREATE FUNCTION udfNrBoli ()
RETURNS int
AS
BEGIN 

 RETURN 0;

END;
go


--	4. Crea?i un view care afi?eaz? acele tratamente care incep cu litera “A” si sunt folosite pentru mai mult de 2 boli.

GO
CREATE VIEW vwTrat AS
	SELECT BT.id_tratament
	FROM Tratamente T INNER JOIN BoliTratamente BT ON T.id_tratament = BT.id_tratament
	WHERE denumire LIKE 'A%'
	GROUP BY BT.id_tratament
	HAVING COUNT(*) > 2;
GO

--	5. Crea?i un view care afi?eaz? acele departamente disponibile non stop care au mai mult de 1 doctori asignati.

GO
CREATE VIEW vwDept AS
	SELECT Departamente.id_departament
	FROM Departamente INNER JOIN Doctori ON Departamente.id_departament = Doctori.id_departament
	WHERE non_stop = 1 
	GROUP BY Departamente.id_departament
	HAVING COUNT(*) > 1;
GO
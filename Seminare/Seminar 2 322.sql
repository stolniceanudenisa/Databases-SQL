CREATE DATABASE Seminar2_322;
GO
USE Seminar2_322;
CREATE TABLE Persoane
(cod_p INT PRIMARY KEY IDENTITY,
nume VARCHAR(100),
prenume VARCHAR(100),
localitate VARCHAR(100)
);

INSERT INTO Persoane (nume, prenume, localitate) VALUES ('Pop','Mihai','Oradea'),
('Pop','Andrei','Cluj-Napoca'),('Popescu','Mihai','Sibiu');

SELECT * FROM Persoane;

UPDATE Persoane SET localitate='Floresti++', prenume='Gabi' 
WHERE nume='Popescu' AND prenume='Mihai';

SELECT * FROM Persoane;

DELETE FROM Persoane WHERE nume='Pop';

SELECT * FROM Persoane;

INSERT INTO Persoane (nume, prenume, localitate) VALUES 
('Popescu','Andrei',NULL), ('Pop','Anamaria','Sibiu'),
('Ion','Andreea','Cluj-Napoca'), ('Pop','Ioana','Floresti++');

SELECT * FROM Persoane;

SELECT nume FROM Persoane;

SELECT DISTINCT nume, prenume FROM Persoane;

INSERT INTO Persoane (nume, prenume, localitate) VALUES ('p','nu stim', NULL);

SELECT * FROM Persoane WHERE nume > 'p';

SELECT * FROM Persoane WHERE nume IN ('Pop','p');

SELECT * FROM Persoane WHERE nume='Pop' OR nume='p';

SELECT nume, prenume, cod_p, cod_p * 2 AS [cod inmultit cu 2] FROM Persoane;

SELECT * FROM Persoane;

SELECT * FROM Persoane WHERE localitate IS NULL;

SELECT * FROM Persoane WHERE localitate IS NOT NULL;

CREATE TABLE Orase
(cod_o INT PRIMARY KEY IDENTITY,
nume VARCHAR(100)
);
CREATE TABLE Locuitori
(cod_l INT PRIMARY KEY IDENTITY,
nume_l VARCHAR(100),
an_nastere INT,
cod_o INT FOREIGN KEY REFERENCES Orase(cod_o)
);

INSERT INTO Orase (nume) VALUES ('Cluj-Napoca'),('Sibiu'), ('Floresti++'),
('Brasov'), ('Galati');

INSERT INTO Locuitori  (nume_l, an_nastere, cod_o) VALUES ('Bob',2000,NULL),
('Ion',1990, 1), ('Ana',1998,1), ('Maria', 1970, 2), ('Mihai',1987,3);

SELECT * FROM Orase;
SELECT * FROM Locuitori;

SELECT * FROM Orase O INNER JOIN Locuitori L ON O.cod_o=L.cod_o;

SELECT * FROM Orase O LEFT JOIN Locuitori L ON O.cod_o=L.cod_o;

SELECT * FROM Orase O RIGHT JOIN Locuitori L ON O.cod_o=L.cod_o;

SELECT * FROM Orase O FULL JOIN Locuitori L ON O.cod_o=L.cod_o;

SELECT * FROM Locuitori;
--calculeaza numarul de locuitori si valoarea maxima a anului de nastere pentru fiecare cod_o 
SELECT cod_o, COUNT(cod_l) AS [numar locuitori], MAX(an_nastere) AS [maxim an nastere]
FROM Locuitori
GROUP BY cod_o;

--calculeaza numarul de locuitori si valoarea maxima a anului de nastere pentru fiecare cod_o
--si afiseaza doar inregistrarile pentru care numarul de locuitori este mai mare ca 1
SELECT cod_o, COUNT(cod_l) AS [numar locuitori], MAX(an_nastere) AS [maxim an nastere]
FROM Locuitori
GROUP BY cod_o
HAVING COUNT(cod_l)>1;

--afisam toate orasele care au cel putin un locuitor
SELECT nume FROM Orase WHERE cod_o IN (SELECT cod_o FROM Locuitori);
--varianta cu JOIN
SELECT DISTINCT O.nume FROM Orase O JOIN Locuitori L ON O.cod_o=L.cod_o;
--varianta cu EXISTS
SELECT O.nume FROM Orase O WHERE EXISTS (SELECT * FROM Locuitori L
WHERE L.cod_o=O.cod_o);
--afisam toate orasele care nu au niciun locuitor
SELECT nume FROM Orase WHERE cod_o NOT IN (SELECT cod_o FROM Locuitori 
WHERE cod_o IS NOT NULL);
--varianta cu NOT EXISTS 
SELECT O.nume FROM Orase O WHERE NOT EXISTS (SELECT * FROM Locuitori L
WHERE L.cod_o=O.cod_o);
--varianta cu EXCEPT
SELECT O.nume FROM Orase O
EXCEPT
SELECT O.nume FROM Orase O INNER JOIN Locuitori L ON O.cod_o=L.cod_o;
--codurile oraselor care nu au niciun locuitor
SELECT cod_o FROM Orase
EXCEPT
SELECT cod_o FROM Locuitori;
--codurile oraselor care au cel putin un locuitor
SELECT cod_o FROM Orase
INTERSECT 
SELECT cod_o FROM Locuitori;
--toate codurile de orase din Orase si din Locuitori
SELECT cod_o FROM Orase
UNION ALL
SELECT cod_o FROM Locuitori;


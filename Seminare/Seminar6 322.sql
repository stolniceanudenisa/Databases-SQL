CREATE DATABASE Trenuri1
GO
Use Trenuri1



CREATE TABLE Tipuri_de_trenuri
(
id INT PRIMARY KEY IDENTITY,
descriere VARCHAR(100)
)



CREATE TABLE Trenuri
(
id INT PRIMARY KEY IDENTITY,
nume VARCHAR(100),
tip_id INT FOREIGN KEY REFERENCES Tipuri_de_trenuri(id)
)



CREATE TABLE Rute
(
id Int PRIMARY KEY IDENTITY,
nume VARCHAR(100),
tren_id INT FOREIGN KEY REFERENCES Trenuri(id)
)



CREATE TABLE Statii
(
id INT PRIMARY KEY IDENTITY,
nume VARCHAR(100)
)



CREATE TABLE Rute_Statii
(
ruta_id INT FOREIGN KEY REFERENCES Rute(id),
statie_id INT FOREIGN KEY REFERENCES Statii(id),
ora_plecarii TIME,
ora_sosirii TIME,



PRIMARY KEY(ruta_id, statie_id)
)

GO
CREATE PROCEDURE usp_adauga_tip_de_tren
@descriere VARCHAR(100)
AS
BEGIN
	IF @descriere NOT IN (SELECT descriere FROM Tipuri_de_trenuri)
		INSERT INTO Tipuri_de_trenuri (descriere) values (@descriere)
	ELSE
		PRINT 'Exista deja acest tip'
END

EXEC usp_adauga_tip_de_tren 'marfar'
EXEC usp_adauga_tip_de_tren 'marfar'
EXEC usp_adauga_tip_de_tren 'international'
EXEC usp_adauga_tip_de_tren 'personal'
EXEC usp_adauga_tip_de_tren 'de jucarie'
EXEC usp_adauga_tip_de_tren 'interregional'
SELECT * FROM Tipuri_de_trenuri

GO
CREATE PROCEDURE usp_adauga_tren
@nume VARCHAR(100),
@descriere VARCHAR(100)
AS
BEGIN
DECLARE @id INT = 0
IF @descriere IN (SELECT descriere FROM Tipuri_de_trenuri)
BEGIN
SET @id = (SELECT TOP 1 id FROM Tipuri_de_trenuri WHERE descriere=@descriere)
INSERT INTO Trenuri (nume, tip_id) VALUES (@nume, @id)
END
ELSE
RAISERROR('Nu exista acest tip', 15, 1)

END

EXEC usp_adauga_tren 'Thomas', 'international'
EXEC usp_adauga_tren 'Tren1', 'personal'
EXEC usp_adauga_tren 'Tren2', 'asdf'
EXEC usp_adauga_tren 'Tren3', 'internsdfgational'

SELECT * FROM Trenuri

GO
CREATE PROCEDURE usp_adauga_ruta
@nume_ruta VARCHAR(100),
@nume_tren VARCHAR(100)
AS
BEGIN
DECLARE @id_tren INT = 0
IF @nume_tren IN (SELECT nume FROM Trenuri)
BEGIN
SET @id_tren = (SELECT TOP 1 id FROM Trenuri WHERE nume = @nume_tren)
INSERT INTO Rute (nume, tren_id) VALUES (@nume_ruta, @id_tren)
END
ELSE
RAISERROR('Nu exista acest tren', 15, 1)
END

GO

EXEC usp_adauga_ruta 'Ruta1', 'Tren1'
EXEC usp_adauga_ruta 'Ruta2', 'Tren2'
EXEC usp_adauga_ruta 'Ruta3', 'Tren0'
EXEC usp_adauga_ruta 'Ruta3', 'Tren3'
EXEC usp_adauga_ruta 'Ruta4', 'Tren4'

SELECT * FROM Rute

go
create procedure usp_adauga_statie
@nume_statie varchar(100)
as
begin
if @nume_statie not in(select nume from Statii)
begin
insert into Statii(nume) values(@nume_statie)
end
end



exec usp_adauga_statie 'Statie1'
exec usp_adauga_statie 'Statie1'
exec usp_adauga_statie 'Statie2'
exec usp_adauga_statie 'Statie3'

select * from Statii


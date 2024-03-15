CREATE DATABASE Petrecere
GO

USE Petrecere

CREATE TABLE Tipuri_petrecere
(
id INT PRIMARY KEY IDENTITY,
nume VARCHAR(50),
descriere VARCHAR(50)
)

CREATE TABLE Petrecere
(
id INT PRIMARY KEY IDENTITY,
nume VARCHAR(50),
buget MONEY,
data_petrecerii DATETIME,
spatiu_organizare VARCHAR(50),
tip_id INT FOREIGN KEY REFERENCES Tipuri_petrecere(id)
)

GO
CREATE PROCEDURE uspAdaugaTip
(@nume VARCHAR(50),
@descriere VARCHAR(50))
AS
BEGIN
INSERT INTO Tipuri_petrecere (nume, descriere) VALUES (@nume, @descriere)
END
GO

EXEC uspAdaugaTip 'vintage', 'cool'
EXEC uspAdaugaTip 'halloween', 'cool'
EXEC uspAdaugaTip 'christmas', 'too cool'

SELECT * FROM Tipuri_petrecere

GO
CREATE PROCEDURE uspAdaugaPetrecere
(
@nume VARCHAR(50),
@buget MONEY,
@data_petrecerii DATETIME,
@spatiu_organizare VARCHAR(50),
@nume_tip VARCHAR(50)
)
AS
BEGIN
DECLARE @id_tip INT = 0;
SELECT TOP 1 @id_tip = id FROM Tipuri_petrecere WHERE nume = @nume_tip;
IF @id_tip = 0
	RAISERROR('Nu s-a gasit tipul cu acest nume',11,1);
ELSE
	INSERT INTO Petrecere (nume,buget,data_petrecerii,spatiu_organizare,tip_id) VALUES (@nume,@buget,@data_petrecerii,
@spatiu_organizare,@id_tip);
END
GO
EXEC uspAdaugaPetrecere '80''s', 200,'19721201  10:00:00 AM', 'DANCE PUB', 'vintage'
EXEC uspAdaugaPetrecere '80''s', 200,'19721201  10:00:00 AM', 'DANCE PUB', 'vintage'
EXEC uspAdaugaPetrecere '80''s', 200,'19721201  10:00:00 AM', 'DANCE PUB', 'vintage'

EXEC uspAdaugaPetrecere 'another party', 200,'19721201  10:00:00 AM', 'DANCE PUB', 'vintage111'

SELECT * FROM Petrecere;

GO
CREATE PROCEDURE uspCalculeazaProfit
(@tip_id INT,
@buget MONEY OUTPUT)
AS
BEGIN
SELECT @buget=SUM(buget) FROM Petrecere WHERE @tip_id=tip_id
END
GO
DECLARE @budget AS INT
SET @budget=0
EXEC uspCalculeazaProfit 1,@buget=@budget OUTPUT;
PRINT @budget

GO 
CREATE PROCEDURE uspAfisatiPetreceriDeLaData
(@date DATETIME)
AS
BEGIN
DECLARE @numberOfParties INT = 0;
SELECT @numberOfParties = COUNT(*) FROM Petrecere WHERE @date= data_petrecerii;
IF @numberOfParties = 0
	RAISERROR('Nu exista petreceri in aceasta data',1,11)
ELSE
	SELECT nume,buget,spatiu_organizare FROM Petrecere
END
GO 
EXEC uspAfisatiPetreceriDeLaData '19721201  10:00:00 AM';
GO 
EXEC uspAfisatiPetreceriDeLaData '19221201  10:00:00 AM';
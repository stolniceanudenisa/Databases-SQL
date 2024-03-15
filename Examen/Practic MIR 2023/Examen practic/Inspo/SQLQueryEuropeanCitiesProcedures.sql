-- create a new database for this assignment
create database versionsEuropeanCities;
use versionsEuropeanCities;

-- create some tables
create table Country
(
	CountryName varchar(50) Primary Key,
	PopulationNumber int,
	Currency varchar(20)
)

create table City
(
	CityName varchar(50) NOT NULL,
	CountryName varchar(50),
	PopulationNumber int,
)

create table Landmark
(
	LandmarkId int Primary Key identity(1,1),
	LandmarkName varchar(50),
	CityName varchar(50),
)

create table TravelRoute
(
	TravelRouteId int Primary key identity(1,1),
	NumberOfCities int,
	NumberOfCountries int,
	StartDate date,
	EndDate date
)

create table Book
(
	BookId int,
	BookName varchar(70),
	Author varchar(70),
	DateOfPublication date
)

create table Movie
(
	MovieName varchar(50),
	CityName varchar(50),
	[Year] int
)

--------------------------------------------- STORED PROCEDURES -------------------------------------
-- a. modify the type of a column;
-- modify the type of column PopulationNumber from table Country from int to bigint
CREATE PROCEDURE usp_Modify_Type_PopulationNumber_Country_bigint
AS
	ALTER TABLE Country
	ALTER COLUMN PopulationNumber bigint
GO
EXEC usp_Modify_Type_PopulationNumber_Country_bigint
-- modify the type of column PopulationNumber from table Country from bigint to int
CREATE PROCEDURE usp_Modify_Type_PopulationNumber_Country_int
AS
	ALTER TABLE Country
	ALTER COLUMN PopulationNumber int
GO
EXEC usp_Modify_Type_PopulationNumber_Country_int


-- b. add / remove a column;
-- add the column CreationDate to table Landmark
CREATE PROCEDURE usp_Add_CreationDate_Landmark
AS
	ALTER TABLE Landmark
	ADD CreationDate int
GO
EXEC usp_Add_CreationDate_Landmark
-- delete the column CreationDate from table Landmark
CREATE PROCEDURE usp_Delete_CreationDate_Landmark
AS
	ALTER TABLE Landmark
	DROP COLUMN CreationDate
GO
EXEC usp_Delete_CreationDate_Landmark


-- c. add / remove a DEFAULT constraint;
-- add 0 as default value for column NumberOfCities in table TravelRoute
CREATE PROCEDURE usp_Add_Default_Constraint_NumberOfCities_TravelRoute
AS
	ALTER TABLE TravelRoute
	ADD CONSTRAINT default_NumberOfCities
	DEFAULT 0 FOR NumberOfCities
GO
EXEC usp_Add_Default_Constraint_NumberOfCities_TravelRoute
-- delete the default value for column NumberOfCities in table TravelRoute
CREATE PROCEDURE usp_Delete_Default_Constraint_NumberOfCities_TravelRoute
AS
	ALTER TABLE TravelRoute
	DROP CONSTRAINT default_NumberOfCities
GO
EXEC usp_Delete_Default_Constraint_NumberOfCities_TravelRoute


-- d. add / remove a primary key;
-- add CityName as primary key in table City
CREATE PROCEDURE usp_Add_Primary_Key_City_CityName
AS
	ALTER TABLE City
	ADD CONSTRAINT PK_City PRIMARY KEY (CityName)
GO
EXEC usp_Add_Primary_Key_City_CityName
-- delete the CityName primary key from table City
CREATE PROCEDURE usp_Delete_Primary_Key_City_CityName
AS
	ALTER TABLE City
	DROP CONSTRAINT PK_City
GO
EXEC usp_Delete_Primary_Key_City_CityName


-- e. add / remove a candidate key;
-- add (MovieName, Year) as unique key in table Movie
CREATE PROCEDURE usp_Add_Candidate_Key_Movie
AS
	ALTER TABLE Movie
	ADD CONSTRAINT UQ_Movie UNIQUE(MovieName, [Year])
GO
EXEC usp_Add_Candidate_Key_Movie
-- delete (MovieName, Year) unique key from table Movie
CREATE PROCEDURE usp_Delete_Candidate_Key_Movie
AS
	ALTER TABLE Movie
	DROP CONSTRAINT UQ_Movie
GO
EXEC usp_Delete_Candidate_Key_Movie


-- f. add / remove a foreign key;
-- add CountryName as foreign key in table CountryName
CREATE PROCEDURE usp_Add_Foreign_Key_City_CountryName
AS
	ALTER TABLE City
	ADD CONSTRAINT FK_City
	FOREIGN KEY (CountryName) REFERENCES Country(CountryName)
GO
EXEC usp_Add_Foreign_Key_City_CountryName
-- delete CountryName foreign key from table CountryName
CREATE PROCEDURE usp_Delete_Foreign_Key_City_CountryName
AS
	ALTER TABLE City
	DROP CONSTRAINT FK_City
GO
EXEC usp_Delete_Foreign_Key_City_CountryName


-- g. create / drop a table
-- create table Music
CREATE PROCEDURE usp_Create_Table_Music
AS
	CREATE TABLE Music
	(
		SongTitle varchar(50),
		ArtistFirstName varchar(50),
		ArtistLastName varchar(50)
	)

GO
EXEC usp_Create_Table_Music

-- delete table Music
CREATE PROCEDURE usp_Delete_Table_Music
AS
	DROP TABLE Music
GO
EXEC usp_Delete_Table_Music

----------------------------------- TABLE OF PROCEDURES -------------------------
CREATE TABLE Procedure_Versions
(
	ProcedureName VARCHAR(100) PRIMARY KEY,
	FromVersion int,
	ToVersion int
)

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Modify_Type_PopulationNumber_Country_bigint', 0, 1);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Modify_Type_PopulationNumber_Country_int', 1, 0);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Add_CreationDate_Landmark', 1, 2);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_CreationDate_Landmark', 2, 1);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Add_Default_Constraint_NumberOfCities_TravelRoute', 2, 3);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_Default_Constraint_NumberOfCities_TravelRoute', 3, 2);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Add_Primary_Key_City_CityName', 3, 4);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_Primary_Key_City_CityName', 4, 3);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Add_Candidate_Key_Movie', 4, 5);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_Candidate_Key_Movie', 5, 4);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Add_Foreign_Key_City_CountryName', 5, 6);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_Foreign_Key_City_CountryName', 6, 5);

INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Create_Table_Music', 1, 2);
INSERT Procedure_Versions(ProcedureName, FromVersion, ToVersion)
VALUES ('usp_Delete_Table_Music', 2, 1);

SELECT *
FROM Procedure_Versions

----------------------------------- TABLE CURRENT VERSION -----------------
CREATE TABLE CurrentVersion
(
	VersionNumber int
)

-- currenr version is 0
INSERT CurrentVersion(VersionNumber)
VALUES (0);

SELECT *
FROM CurrentVersion

CREATE OR ALTER PROCEDURE ChangeVersion(@NewVersion int)
AS
BEGIN
	--validate input parameter
	DECLARE @MaxVersion INT
	DECLARE @MinVersion INT

	SELECT @MaxVersion = MAX(FromVersion)
	FROM Procedure_Versions
	SELECT @MinVersion = MIN(FromVersion)
	FROM Procedure_Versions

	IF (@NewVersion < @MinVersion OR @NewVersion > @MaxVersion)
	BEGIN
		RAISERROR('The version number is invalid', 10, 1)
		RETURN
	END

	-- take the current version from the table CurrentVersion
	DECLARE @OldVersion int
	SELECT @OldVersion = VersionNumber
	FROM CurrentVersion

	PRINT 'Initial version is ' + CAST(@OldVersion AS VARCHAR)

	DECLARE @ProcedureToExecute VARCHAR(100)
	DECLARE @IntermediateVersion INT

	IF (@OldVersion < @NewVersion)
		WHILE (@OldVersion < @NewVersion)
		BEGIN
			-- declare a cursor to store all rows in table Procedure_Versions which have FromVersion = @OldVersion
			DECLARE ProceduresCursor CURSOR FOR
			SELECT ProcedureName, ToVersion
			FROM Procedure_Versions
			WHERE FromVersion = @OldVersion AND FromVersion < ToVersion

			OPEN ProceduresCursor
			FETCH ProceduresCursor
			INTO @ProcedureToExecute, @IntermediateVersion

			PRINT 'Will switch from version ' + CAST(@OldVersion AS VARCHAR) + ' to version ' + CAST(@IntermediateVersion AS VARCHAR)

			WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT 'Execute procedure ' + @ProcedureToExecute
					EXEC @ProcedureToExecute

					FETCH ProceduresCursor
					INTO @ProcedureToExecute, @IntermediateVersion
				END
			
			CLOSE ProceduresCursor
			DEALLOCATE ProceduresCursor
			
			SET @OldVersion = @IntermediateVersion
			-- update the new version in CurrentVersion Table
			UPDATE CurrentVersion
			SET VersionNumber = @OldVersion
		END

	ELSE IF (@OldVersion > @NewVersion)
		WHILE (@OldVersion > @NewVersion)
		BEGIN
			-- declare a cursor to store all rows in table Procedure_Versions which have FromVersion = @OldVersion
			DECLARE ProceduresCursor CURSOR FOR
			SELECT ProcedureName, ToVersion
			FROM Procedure_Versions
			WHERE FromVersion = @OldVersion AND FromVersion > ToVersion

			OPEN ProceduresCursor
			FETCH ProceduresCursor
			INTO @ProcedureToExecute, @IntermediateVersion

			PRINT 'Will switch from version ' + CAST(@OldVersion AS VARCHAR) + ' to version ' + CAST(@IntermediateVersion AS VARCHAR)

			WHILE @@FETCH_STATUS = 0
				BEGIN
					PRINT 'Execute procedure ' + @ProcedureToExecute
					EXEC @ProcedureToExecute

					FETCH ProceduresCursor
					INTO @ProcedureToExecute, @IntermediateVersion
				END
			
			CLOSE ProceduresCursor
			DEALLOCATE ProceduresCursor
			
			SET @OldVersion = @IntermediateVersion
			-- update the new version in CurrentVersion Table
			UPDATE CurrentVersion
			SET VersionNumber = @OldVersion
		END

	ELSE
		PRINT'The current version and new version are  the same'
	
	-- update the new version in CurrentVersion Table
	UPDATE CurrentVersion
	SET VersionNumber = @NewVersion

	PRINT 'Current version is ' + CAST(@NewVersion AS CHAR)
END
GO

EXEC ChangeVersion 6

select *
from CurrentVersion

select *
from Procedure_Versions
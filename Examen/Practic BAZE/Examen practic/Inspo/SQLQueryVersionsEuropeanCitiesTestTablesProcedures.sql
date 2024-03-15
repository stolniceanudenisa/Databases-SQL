
-- create a new database
create database testsEuropeanCities;
use testsEuropeanCities;

-------------------------------------------- CREATE TABLES ---------------------------------------------
-- table with a primary key and no foreign keys
create table Country
(
	CountryId int Primary Key identity(1,1),
	CountryName varchar(50),
	PopulationNumber int,
	Currency varchar(20)
)

-- table with primary key and a foreign key
create table City
(
	CityId int Primary Key identity(1,1),
	CityName varchar(50),
	CountryId int,
	PopulationNumber int,
	Foreign Key (CountryId) references Country(CountryId)
)

create table Landmark
(
	LandmarkId int Primary Key identity(1,1),
	LandmarkName varchar(50),
	CityName varchar(50),
)

-- table with multicolumn primary key
create table Movie
(
	MovieName varchar(50),
	CityName varchar(50),
	[Year] int,
	NrActors int
	Primary Key ([Year], NrActors)
)

create table RepresentativePerson
(
	PersonId int Primary Key identity(1,1),
	PersonFirstName varchar(50),
	PersonLastName varchar(50),
	PersonRole varchar(50),
	Accomplishment varchar(50),
	CityId int,
	CONSTRAINT FK_ReprPers_CityId FOREIGN KEY (CityId) REFERENCES City(CityId)
	-- Foreign Key (CityId) references City(CityId)
)

select *
from sys.foreign_keys
drop table RepresentativePerson
---------------------------------------------------- EMPTY TABLE PROCEDURE ------------------------------------------------

-- procedure for deleting all entities in a table
CREATE OR ALTER PROCEDURE EmptyTable(@tableName varchar(200))
AS
	-- validate the parameter
	-- check whether the @tableName exists in the database
	IF (NOT EXISTS (
					SELECT *
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'City')
		)
		BEGIN
			RAISERROR('The table does not exist in the database', 10, 1)
			RETURN
		END

	EXEC('DELETE FROM ' + @tableName)
GO

exec EmptyTable 'City'

select *
from City


----------------------------------------------------- GENERATE RANDOM NUMBERS FUNCTION --------------------------------------

-- generate a random digit
CREATE OR ALTER VIEW RandomDigit
AS
    SELECT ROUND((9 - 1) * RAND(CHECKSUM(NEWID())), 0) + 1 AS value
GO

-- generate a random digit for the foreign key between lowerLimit and upperLimit
CREATE OR ALTER FUNCTION GetRandomNumberFK(@uniqueId uniqueidentifier, @lowerLimit int, @upperLimit int)
RETURNS INT
AS
BEGIN
	-- validate input parameters (the limits)
	IF (@lowerLimit < 0 OR @upperLimit > 1000000)
		BEGIN
			RETURN -1
		END

	DECLARE @RandDigit INT  = ABS(CHECKSUM(@uniqueId))% (@upperLimit - @lowerLimit + 1) + @lowerLimit
    RETURN @RandDigit
END
GO

-- generate a random number
CREATE OR ALTER FUNCTION GetRandomValue()
RETURNS VARCHAR(MAX) 
AS
BEGIN
    DECLARE @length INT

    DECLARE @contor INT = 0
    DECLARE @result VARCHAR(MAX)
    DECLARE @number INT = 0

	-- set @length to a random digit
	SET @length = (SELECT Value FROM RandomDigit)
    --SET @upper_limit = 9
    SET @result = ''

	-- generate a number of @length digits
    WHILE (@contor < @length)
    BEGIN
        SET @number = (SELECT Value FROM RandomDigit)
        SET @result = @result + CONVERT(varchar(12), @number);
        SET @contor = @contor + 1
    END
    RETURN @result
END
GO

-- TEST GetRandomValue
PRINT dbo.GetRandomValue()

DECLARE @valueListTest varchar(20)
EXEC @valueListTest = dbo.GetRandomValue
PRINT @valueListTest

------------------------------------------------ INSERT INTO TABLE PROCEDURE ---------------------------------------------

-- procedure that inserts @numberOfInsertions rows 
CREATE OR ALTER PROCEDURE InsertIntoTable(@tableName varchar(50), @numberOfInsertions int) 
AS
BEGIN
	-- validate the parameters
	-- check whether the @tableName exists in the database
	IF (NOT EXISTS (
					SELECT *
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'City')
		)
		BEGIN
			RAISERROR('The table does not exist in the database', 10, 1)
			RETURN
		END
	-- check whether the @numberOfInsertions is a negative number
	IF (@numberOfInsertions < 0)
		BEGIN
			RAISERROR('The number of insertions is a negative number', 10, 1)
			RETURN
		END

	-- variables for the columnCursor
	declare @columnName varchar(100)
	declare @columnType varchar(50)
	-- variable used in generating random values for columns
	declare @randomValue varchar(10)

	-- columnList and valueList will keep the data for executing the INSERT dinamically
	DECLARE @columnList varchar(max)
	DECLARE @valueList varchar(max)

	---- in case of MULTICOLUMN PRIMARY KEY, keep 2 contors in order to generate different primary keys
	--DECLARE @FirstPKContor INT = 1
	--DECLARE @SecondPKContor INT = 1


		-- for the case of MULTICOLUMN PRIMARY KEY
		DECLARE @NumberPK INT = (SELECT COUNT(COLUMN_NAME)
								FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS [tc]
								JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE [ku] ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
								AND ku.table_name = @tableName AND CONSTRAINT_TYPE = 'PRIMARY KEY')
		
		-- the table has MULTICOLUMN PRIMARY KEY
		IF @NumberPK > 1
		BEGIN
			-- declare CursorPK to take the primary key columns
			DECLARE CursorPK CURSOR FOR
				SELECT COLUMN_NAME
				FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS [tc]
				JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE [ku] ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
				AND ku.table_name = @tableName AND CONSTRAINT_TYPE = 'PRIMARY KEY'

			-- in case of MULTICOLUMN PRIMARY KEY, keep 2 contors in order to generate different primary keys
			DECLARE @FirstPKContor INT = 1
			DECLARE @SecondPKContor INT = 1
			-- declare the variables to keep the primary key columns
			DECLARE @FirstPK VARCHAR(MAX)
			DECLARE @SecondPK VARCHAR(MAX)

			-- fetch the first PK
			OPEN CursorPK
			FETCH CursorPK
			INTO @FirstPK

			-- fetch the second PK
			FETCH CursorPK
			INTO @SecondPK

			DECLARE @PKList VARCHAR(MAX)
			SET @PKList = @FirstPK + ', ' + @SecondPK

			CLOSE CursorPK
			DEALLOCATE CursorPK
		END

	-- insert @numberOfInsertions rows into the table
	DECLARE @contor INT = 0
	WHILE(@contor < @numberOfInsertions)
	BEGIN

		-- WILL GENERATE A RANDOM VALUE FOR THE COLUMNS IN THE TABLE, EXCEPT THE COLUMNS WITH PRIMARY KEY CONSTRAINTS (INCLUDING MULTICOLUMN PRIMAY KEY)

		-- THE PRIMARY KEY WILL BE GENERATED USING IDENTITY, NO NEED TO INSERT A VALUE FOR IT
		-- THE FOREIGN KEY WILL BE RANDOMLY TAKEN FROM THE TABLE IT REFERENCES
		-- THE MULTICOLUMN PRIMARY KEY WILL BE RANDOMLY GENERATED SEPARATELY

		-- DECLARE A CURSOR FOR ALL COLUMNS AND THEIR DATA TYPES FROM A TABLE, EXCEPT THE COLUMNS WHICH ARE PRIMARY KEYS
		declare columnCursor cursor for
		SELECT DISTINCT C.COLUMN_NAME, COLUMN_TYPE = (SELECT DATA_TYPE
														FROM INFORMATION_SCHEMA.COLUMNS
														WHERE
														TABLE_NAME = @tableName AND
														COLUMN_NAME = C.COLUMN_NAME)
		FROM INFORMATION_SCHEMA.COLUMNS C
		WHERE COLUMN_NAME IN (
								SELECT COLUMN_NAME
								FROM INFORMATION_SCHEMA.COLUMNS
								WHERE TABLE_NAME = @tableName

								EXCEPT

								SELECT COLUMN_NAME
								FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS [tc]
								JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE [ku] ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
								AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
								AND ku.table_name = @tableName
							)


		-- open the cursor and fetch the first row
		OPEN columnCursor
		FETCH columnCursor
		INTO @columnName, @columnType

		-- check if the column references a FOREIGN KEY
		-- will search the substring @columnName in the name of the foreign key
		declare @isForeignKey int = (SELECT count(*)
										FROM (SELECT
													name AS Foreign_Key
													FROM sys.foreign_keys FK
													WHERE parent_object_id = OBJECT_ID(@tableName)
												)AS FK
													WHERE (CHARINDEX(@columnName, FK.Foreign_Key) > 0)
									)


		if @isForeignKey > 0
		begin
			-- the column is a foreign key, get a value from the table it references it

			-- DECLARE A FKCURSOR TO TAKE THE TABLE AND COLUMN REFERENCED BY THE FOREIGN KEY (IN THE TABLE WHERE IT IS A PRIMARY KEY)
			DECLARE FKCursor CURSOR FOR
			SELECT
				OBJECT_NAME(referenced_object_id) AS [PK Table],
				ColumnName = (
						SELECT Col.Column_Name from 
						INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
						INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
						WHERE
						Col.Constraint_Name = Tab.Constraint_Name
						AND Col.Table_Name = Tab.Table_Name
						AND Constraint_Type = 'PRIMARY KEY'
						AND Col.Table_Name = OBJECT_NAME(referenced_object_id)
							)
			FROM sys.foreign_keys
			WHERE parent_object_id = OBJECT_ID(@tableName)

			-- declare variables for the cursor
			DECLARE @FKTableName VARCHAR(100)
			DECLARE @FKColumnName VARCHAR(100)

			-- open and fetch the first (only) row
			OPEN FKCursor
			FETCH FKCursor
			INTO @FKTableName, @FKColumnName

			-- take the min and max value of FKColumnName (identity id, consecutive values) from FKTableName

			DECLARE @minValueFK INT
			DECLARE @maxValueFK INT

			-- take the min and max value of the foreign key
			declare @sql nvarchar(max)
			set @sql = 'SET @min  = ( SELECT MIN(' + @FKColumnName + ') From ' + @FKTableName + ')'
			exec sp_executesql @sql, N'@min INT OUTPUT', @min = @minValueFK OUTPUT
			set @sql = 'SET @max  = ( SELECT MAX(' + @FKColumnName + ') From ' + @FKTableName + ')'
			exec sp_executesql @sql, N'@max INT OUTPUT', @max = @maxValueFK OUTPUT

			-- generate a random value for the foregin key between minValueFK and maxValueFK
			DECLARE @randomValueFK INT
			SET @randomValueFK = (SELECT dbo.GetRandomNumberFK(NEWID(), @minValueFK, @maxValueFK))
			-- check if it is a valid value
			IF(@randomValueFK = -1)
				BEGIN
					RAISERROR('The value is a negative number', 10, 1)
					RETURN
				END

			-- close and deallocate cursor
			CLOSE FKCursor
			DEALLOCATE FKCursor


			-- add the column name to columnList and value to valueList
			-- are the first values in the list
			SET @columnList = @columnName
			SET @valueList = CONVERT(VARCHAR(MAX), @randomValueFK)
		end

		else
		begin
			-- the column is not a foreign key, generate a random value
			SET @columnList = @columnName
			EXEC @valueList = dbo.GetRandomValue
		end
										

		-- fetch the second row and begin the while loop
		FETCH columnCursor
		INTO @columnName, @columnType

		WHILE @@FETCH_STATUS = 0
		BEGIN

			-- check if the column references a FOREIGN KEY
			-- will search the substring @columnName in the name of the foreign key
			SET @isForeignKey = (SELECT count(*)
											FROM (SELECT
														name AS Foreign_Key
														FROM sys.foreign_keys FK
														WHERE parent_object_id = OBJECT_ID(@tableName)
													)AS FK
														WHERE (CHARINDEX(@columnName, FK.Foreign_Key) > 0)
										)


			if @isForeignKey > 0
			begin
				-- the column is a foreign key, get a value from the table it references it

				-- DECLARE A FKCURSOR TO TAKE THE TABLE AND COLUMN REFERENCED BY THE FOREIGN KEY
				DECLARE FKCursor CURSOR FOR
				SELECT
					OBJECT_NAME(referenced_object_id) AS [PK Table],
					ColumnName = (
							SELECT Col.Column_Name from 
							INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
							INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
						WHERE
							Col.Constraint_Name = Tab.Constraint_Name
							AND Col.Table_Name = Tab.Table_Name
							AND Constraint_Type = 'PRIMARY KEY'
							AND Col.Table_Name = OBJECT_NAME(referenced_object_id)
								)
				FROM sys.foreign_keys
				WHERE parent_object_id = OBJECT_ID(@tableName)


				-- open and fetch the first (only) row
				OPEN FKCursor
				FETCH FKCursor
				INTO @FKTableName, @FKColumnName

				-- take the min and max value of FKColumnName (identity id, consecutive values) from FKTableName

				set @sql = 'SET @min  = ( SELECT MIN(' + @FKColumnName + ') From ' + @FKTableName + ')'
				exec sp_executesql @sql, N'@min INT OUTPUT', @min = @minValueFK OUTPUT
				set @sql = 'SET @max  = ( SELECT MAX(' + @FKColumnName + ') From ' + @FKTableName + ')'
				exec sp_executesql @sql, N'@max INT OUTPUT', @max = @maxValueFK OUTPUT

				-- generate a random value for the foregin key between minValueFK and maxValueFK
				SET @randomValueFK = (SELECT dbo.GetRandomNumberFK(NEWID(), @minValueFK, @maxValueFK))
				IF(@randomValueFK = -1)
				BEGIN
					RAISERROR('The value is a negative number', 10, 1)
					RETURN
				END

				-- close and deallocate cursor
				CLOSE FKCursor
				DEALLOCATE FKCursor


				-- generate a random Foreign Key
				SET @randomValue = CONVERT(VARCHAR(MAX), @randomValueFK)
			end

			else
			begin
				-- the column is not a foreign key, generate a random value
				EXEC @randomValue = dbo.GetRandomValue
			end

			-- add the column and the value to the lists
			SET @columnList = @columnList + ', ' + @columnName
			SET @valueList = @valueList + ', ' + @randomValue

			FETCH columnCursor
			INTO @columnName, @columnType
		END
			
		CLOSE columnCursor
		DEALLOCATE columnCursor


		-- AFTER ADDING ALL THE COLUMNS, CHECK THE CASE OF MULTICOLUMN PRIMARY KEY
		-- THE PK COLUMNS WILL BE THE LAST ONES IN THE TABLE
		IF @NumberPK > 1
		BEGIN
			-- PK will consist of pairs of numbers between 1 and 10
			IF @SecondPKContor < 10
				SET @SecondPKContor = @SecondPKContor + 1
			ELSE
				BEGIN
					SET @SecondPKContor = 1
					SET @FirstPKContor = @FirstPKContor + 1
				END

			DECLARE @PKValueList VARCHAR(MAX)
			SET @PKValueList = CONVERT(VARCHAR(MAX), @FirstPKContor) + ', ' + CONVERT(VARCHAR(MAX), @SecondPKContor)

			-- ADD THE PK COLUMNS AND THE PK VALUES TO THE COLUMN LIST AND VALUE LIST
			-- THE PK COLUMNS WILL BE THE LAST ONES IN THE TABLE
			SET @columnList = @columnList + ', ' + @PKList
			SET @valueList = @valueList + ', ' + @PKValueList

		END


		-- insert the values into the table
		EXEC('INSERT ' + @tableName + '(' + @columnList + ') VALUES (' + @valueList + ')')

		-- increase the contor, go to the next row
		SET @contor = @contor + 1
		
	--PRINT @columnList
	--PRINT @valueList
	END

	--PRINT @columnList
	--PRINT @valueList
END
GO

delete from Country
-- TEST InsertIntoTable
exec InsertIntoTable @tableName = 'Country', @numberOfInsertions = 3
exec InsertIntoTable @tableName = 'Landmark', @numberOfInsertions = 4

select *
from Landmark

exec EmptyTable 'Landmark'

exec InsertIntoTable 'Movie', 12

select *
from Movie

delete from Movie

-- TABLE for current test id
--create table CurrentTestId
--(
--	testId int
--)

--insert CurrentTestId(testId) values (0)

--select testId
--from CurrentTestId

--------------------------------------------------------------- RUN TEST PROCEDURE ----------------------------------------------------

CREATE OR ALTER PROCEDURE RunTest(@testId int)
AS
BEGIN
	-- VALIDATION OF PARAMETER
	-- CHECK IF TEST ID IS IN TESTS
	IF (NOT EXISTS (
					SELECT *
					FROM Tests
					WHERE TestID = @testId)
		)
		BEGIN
			RAISERROR('The testId does not exist in table Tests', 10, 1)
			RETURN
		END

	-- declare variables for the tableCursor
	declare @TableName varchar(max)
	declare @NumberOfInsertions int

	-- declare variables for start and end time for the table (will be added into TestRunTables)
	DECLARE @StartAtTable datetime2 = SYSDATETIME()
    DECLARE @EndAtTable datetime2 = SYSDATETIME()

	-- declare variables for start and end time for entire test (will be added into TestRuns)
    DECLARE @StartAt datetime2 = SYSDATETIME()
    DECLARE @EndAt datetime2 = SYSDATETIME()

	-- convert testId from int to varchar and insert it as Decsription into TestRuns table
	declare @testIdStr varchar(max) = CONVERT(VARCHAR(MAX), @testId)
	-- insert the values of the test run into TestRunTables, we will update the EndAt time at the end
	INSERT INTO TestRuns(Description, StartAt, EndAt)
	VALUES (@testIdStr, @StartAt, @EndAt)

	-- take the new testRunId from TestRuns table (it was generated at the last INSERT)
	-- it is the last row inserted, the first if sorted in desc order by TestRunId
	declare @testRunId int = (select top 1 T.TestRunId 
								from TestRuns T
								order by TestRunID desc)



	---------------------------- DELETE DATA FROM TABLE -----------------------
	-- declare cursor for tables DELETE
	-- delete in reverse order of Position
	DECLARE tableCursor CURSOR FOR   
    SELECT (SELECT T.Name FROM TABLES T WHERE T.TableId = TT.TableId) AS TbName
    FROM TestTables TT
    WHERE TT.TestID = @testId ORDER BY TT.Position DESC

	-- open the cursor and fetch the first row
	open tableCursor
	fetch tableCursor
	into @TableName

	WHILE @@FETCH_STATUS = 0
		BEGIN
			EXEC EmptyTable @tableName
			-- fetch the next table
			FETCH tableCursor
			INTO @TableName
		END

	-- close and deallocate the cursor
	CLOSE tableCursor
	DEALLOCATE tableCursor

	---------------------------- INSERT DATA INTO TABLE ------------------------------
	-- declare cursor for tables INSERT
	-- insert in ascending order of Position
	DECLARE tableCursor CURSOR FOR   
    SELECT (SELECT T.Name FROM TABLES T WHERE T.TableId = TT.TableId) AS TbName, TT.noOfRows
    FROM TestTables TT
    WHERE TT.TestID = @testId ORDER BY TT.Position ASC

	-- open the cursor and fetch the first row
	open tableCursor
	fetch tableCursor
	into @TableName, @NumberOfInsertions

	-- for all the testsRuns of a given testId
	WHILE @@FETCH_STATUS = 0
		BEGIN

			-- set StartAt, execute the insertion and set the EndAt for a table
			SET @StartAtTable = SYSDATETIME()
			EXEC InsertIntoTable @TableName, @NumberOfInsertions
			SET @EndAtTable = SYSDATETIME()

			-- take the table id
			declare @TableId int = (SELECT T.TableID FROM Tables T WHERE T.Name = @TableName)

			-- insert the values of the test run into TestRunTables
			INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt)
			VALUES (@testRunId, @TableId, @StartAtTable, @EndAtTable)

			-- fetch the next table
			FETCH tableCursor
			into @TableName, @NumberOfInsertions
		END
	-- close and deallocate the cursor
	CLOSE tableCursor
	DEALLOCATE tableCursor



	------------------------------------------ EVALUATE THE VIEWS -------------------------------------
	-- DECLARE CURSOR FOR THE VIEWS
    DECLARE viewCursor CURSOR FOR    
        SELECT (SELECT V.Name FROM Views V WHERE V.ViewId = TV.ViewID) AS VName
        FROM TestViews TV
        WHERE TV.TestID = @testId
    
	-- variable for the cursor
    DECLARE @ViewName VARCHAR(MAX)

	-- open the viewCursor and fetch the first row
    OPEN viewCursor
    FETCH viewCursor
    INTO @ViewName

	-- declare variables for start and end time for the view (will be added into TestRunViews)
    DECLARE @StartAtView DATETIME2
    DECLARE @EndAtView  DATETIME2 

    WHILE @@FETCH_STATUS = 0
    BEGIN
		-- set the StartAtView time, execute the select and set the EndAtView
        SET @StartAtView = SYSDATETIME()
        EXEC ('SELECT * FROM ' + @ViewName)
        SET @EndAtView = SYSDATETIME()

		-- take the view id from table Views
        DECLARE @ViewID INT = (SELECT V.ViewID FROM Views V WHERE V.Name = @ViewName)

		-- insert the values of the test run into TestRunViews
		INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt)
		VALUES (@testRunId, @ViewID, @StartAtView, @EndAtView)

        FETCH viewCursor
        INTO @ViewName
    END

	CLOSE viewCursor
	DEALLOCATE viewCursor


	-- UPDATE THE GLOBAL END AT IN TEST RUNS
    SET @EndAt = SYSDATETIME()
    UPDATE TestRuns
    SET EndAt = @EndAt
    WHERE TestRunID = @testRunId

	--set @StopAt = SYSDATETIME()
	--INSERT INTO TestRuns(TestRunID, Description, StartAt, EndAt)
	--VALUES (@testIdStr, @StartAt, @StopAt)

END
GO

-- INSERT INTO TABLES
INSERT INTO Tables(Name) VALUES
-- A. a table with a single-column primary key and no foreign keys
('Country'),
-- B. a table with a single-column primary key and at least one foreign key
('City'),
-- C. a table with a multicolumn primary key
('Movie'),
('RepresentativePerson')
GO
SELECT * from Tables


-- INSERT INTO TESTS
INSERT INTO Tests(Name) VALUES
('AddIntoCountry10Rows'),
('AddIntoCountry10RowsAddIntoCity5Rows'),
('AddIntoMovie20Rows'),
('AddCountry10City10RepresentativePerson10')

SELECT * from Tests

--delete from Tests
--delete from TestViews
--delete from TestTables
--delete from TestRuns
--delete from TestRunTables
--delete from TestRunViews


-- INSERT INTO TEST TABLES
INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
-- A. a table with a single-column primary key and no foreign keys
-- AddIntoCountry10Rows
(3, 1, 10, 0),
-- B. a table with a single-column primary key and at least one foreign key
-- AddIntoCountry10RowsAddIntoCity5Rows
(4, 1, 10, 0),
(4, 2, 5, 1),
-- C. a table with a multicolumn primary key
-- AddIntoMovie20Rows
(5, 3, 20, 0),
-- AddCountry10City10RepresentativePerson10
(6, 1, 10, 0),
(6, 2, 10, 1),
(6, 4, 10, 2)


INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
-- A. a table with a single-column primary key and no foreign keys
-- AddIntoCountry10Rows
(3, 2, 10, 1),
(3, 4, 10, 2),
(4, 4, 5, 2)


SELECT * from Tables
SELECT * FROM TestTables

-- AddIntoCountry10Rows
exec RunTest 3

select *
from Country

-- AddIntoCountry10RowsAddIntoCity5Rows
exec RunTest 4

select *
from Country
select *
from City

-- AddIntoMovie20Rows
exec RunTest 5

select *
from Movie

-- AddCountry10City10RepresentativePerson10
exec RunTest 6

select *
from TestRuns

select *
from Country
select *
from City
select *
from RepresentativePerson

-- error
exec RunTest 1



select *
from Tests
select *
from TestTables
select *
from TestRuns

select *
from TestRunTables
select *
from Country
select *
from City
select *
from Movie



--------------------------------------------------------------- VIEWS ---------------------------------------------

-----------------------------------CREATE VIEWS--------------------------------------
--A. a view with a SELECT statement operating on one table

-- SELECT THE NAME AND POPULATION OF THE COUNTRIES WITH A POPULATION GREAATER THAN 200
CREATE OR ALTER VIEW  ViewCountry200
AS
	select CO.CountryName, CO.PopulationNumber
	from Country CO
	where CO.PopulationNumber > 200
GO

--B. a view with a SELECT statement operating on at least 2 tables

-- FIND THE CITIES THAT HAVE A REPRESENTATIVE PERSON
CREATE OR ALTER VIEW ViewCityReprPerson
AS
	select City.CityId, City.CityName, RP.PersonId, RP.PersonFirstName
	from City, RepresentativePerson RP
	where City.CityId = RP.CityId
GO

select *
from RepresentativePerson


--C. a view with a SELECT statement that has a GROUP BY clause and operates on at least 2 tables

-- FOR EACH COUNTRY FIND THE NUMBER OF CITIES WITH MORE THAN 1 CITY

CREATE OR ALTER VIEW ViewCountryCity
AS
	select C.CountryId, count(*) as nrCities
	from City C
	group by C.CountryId
	having count(CityName) > 1
GO
select *
from ViewCountryCity

CREATE OR ALTER VIEW  ViewCountry
AS
	SELECT *
	FROM Country
GO

CREATE OR ALTER VIEW ViewCity
AS
	SELECT *
	FROM City
GO

CREATE OR ALTER VIEW ViewMovie
AS
	SELECT *
	FROM Movie
GO

CREATE OR ALTER VIEW ViewRepresentativePerson
AS
	SELECT *
	FROM RepresentativePerson
GO

INSERT INTO Views(Name) VALUES
('ViewCountry'),
('ViewCityReprPerson'),
('ViewCountryCity'),
('ViewCity'),
('ViewMovie'),
('ViewRepresentativePerson'),
('ViewCountry200')

-- add TestViews into Tests
INSERT INTO Tests(Name) VALUES
('ViewCountry200'),
('ViewCityReprPerson'),
('ViewCountryCity'),
('ExecuteView1View2'),
('ExecuteAllViews')
GO

select *
from Tests
select *
from Views

select *
from TestTables

--DECLARE @var VARCHAR(MAX)
----SET @var = (SELECT Name From Views WHERE ViewId = 1)
--SET @var = 'ThirdSelectView' 

--EXEC ('SELECT * FROM ' + @var)



-- insert data into TestViews
INSERT INTO TestViews(TestID, ViewID) VALUES
-- VIEW FOR AddIntoCountry10Rows
(3, 1),
-- VIEW FOR AddIntoCountry10RowsAddIntoCity5Rows
(4, 1),
(4, 6),
(4, 3),
-- VIEW FOR AddIntoMovie20Rows
(5, 7),
-- VIEW FOR AddCountry10City10RepresentativePerson10
(6, 1),
(6, 6),
(6, 8),
-- TEST VIEWS
-- ViewCountry200
(7, 9),
-- ViewCityReprPerson
(8, 2),
-- ViewCountryCity
(9, 3),
-- ExecuteView1View2
(10, 9),
(10, 2),
-- ExecuteAllViews
(11, 9),
(11, 2),
(11, 3)
GO
select *
from TestViews

select *
from Tables


-- INSERT INTO TEST TABLES THE TABLES WHICH NEED DATA FOR THE TEST VIEWS
INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
-- TEST VIEWS
-- ViewCountry200
(7, 1, 20, 0),
-- ViewCityReprPerson
(8, 1, 10, 0),
(8, 2, 20, 1),
(8, 4, 30, 2),
-- ViewCountryCity
(9, 1, 10, 0),
(9, 2, 30, 1),
-- ExecuteView1View2
(10, 1, 10, 0),
(10, 2, 20, 1),
(10, 4, 30, 2),
-- ExecuteAllViews
(11, 1, 10, 0),
(11, 2, 20, 1),
(11, 4, 30, 2)

INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES
-- TEST VIEWS
-- ViewCountry200
(7, 2, 20, 1),
(7, 4, 20, 2),
(9, 4, 10, 2)


exec RunTest 3
exec RunTest 4
exec RunTest 5
exec RunTest 6
exec RunTest 7
exec RunTest 8
exec RunTest 9
exec RunTest 10
exec RunTest 11

select *
from TestRuns

select *
from TestRunTables

select *
from TestRunViews



------------------------------------------- OTHER ------------------------------------------------------------------------

select o.name, c.name
from sys.objects o inner join sys.columns c on o.object_id = c.object_id
where o.type = 'U'

select *
from sys.types


SELECT
OBJECT_NAME(parent_object_id) AS [FK Table],
name AS [Foreign Key],
OBJECT_NAME(referenced_object_id) AS [PK Table],
ColumnName = (
	SELECT Col.Column_Name from 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
    AND Constraint_Type = 'PRIMARY KEY'
    AND Col.Table_Name = OBJECT_NAME(referenced_object_id)
	)
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('City');


-- 
SELECT
OBJECT_NAME(parent_object_id) AS [FK Table],
name AS [Foreign Key],
OBJECT_NAME(referenced_object_id) AS [PK Table],
ColumnName = (
	SELECT Col.Column_Name from 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
    AND Constraint_Type = 'PRIMARY KEY'
    AND Col.Table_Name = OBJECT_NAME(referenced_object_id)
	)
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('City');




SELECT Col.Column_Name from 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
WHERE
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
    AND Constraint_Type = 'FOREIGN KEY'
    AND Col.Table_Name = 'City'




-- CHECK IF A SUBSTRING IS PART OF A STRING
-- CHARINDEX RETURNS 0 IF SUBSTRING IS NOT FOUND
if CHARINDEX('City', 'CityName') > 0
begin
	print 'yes'
end


SELECT DISTINCT A.COLUMN_NAME, COLUMN_TYPE = (SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
TABLE_NAME = @tbName AND
COLUMN_NAME = A.COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS A
WHERE COLUMN_NAME IN (
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @tbName

 EXCEPT

 SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS [tc]
JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE [ku] ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
AND ku.table_name = @tbName
)



-- SELECT ALL COLUMNS AND THEIR DATA TYPES FROM A TABLE, EXCEPT THE COLUMNS WITH CONSTRAINTS
SELECT DISTINCT C.COLUMN_NAME, COLUMN_TYPE = (SELECT DATA_TYPE
												FROM INFORMATION_SCHEMA.COLUMNS
												WHERE
												TABLE_NAME = 'City' AND
												COLUMN_NAME = C.COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS C
WHERE COLUMN_NAME IN (
						SELECT COLUMN_NAME
						FROM INFORMATION_SCHEMA.COLUMNS
						WHERE TABLE_NAME = 'City'

						EXCEPT

						SELECT COLUMN_NAME
						FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS [tc]
						JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE [ku] ON tc.CONSTRAINT_NAME = ku.CONSTRAINT_NAME
						AND ku.table_name = 'City'
					)


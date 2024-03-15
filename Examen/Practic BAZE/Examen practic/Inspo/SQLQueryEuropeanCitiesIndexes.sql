
create database indexesEuropeanCities;
use indexesEuropeanCities;

--Work on 3 tables of the form Ta(aid, a2, …), Tb(bid, b2, …), Tc(cid, aid, bid, …), where:
--aid, bid, cid, a2, b2 are integers;
--the primary keys are underlined;
--a2 is UNIQUE in Ta;
--aid and bid are foreign keys in Tc, referencing the primary keys in Ta and Tb, respectively


CREATE TABLE City
(
	CityId int Primary Key,
	CityNumber int unique,
	CityName varchar(50)
)

CREATE TABLE Book
(
	BookId int Primary Key,
	NumberLanguages int,
	BookName varchar(70)
)

CREATE TABLE BookReferencesCity
(
	BookReferenceId int Primary Key,
	CityId int,
	Foreign Key (CityId) references City(CityId),
	BookId int,
	Foreign Key (BookId) references Book(BookId),
	PageReference int
)

-- INSERT DATA

-- insert CITIES --
insert City (CityId, CityNumber, CityName)
values (1, 1888000, 'Vienna');
insert City (CityId, CityNumber, CityName)
values (3, 730000, 'Frankfurt');
insert City (CityId, CityNumber, CityName)
values (2, 380000, 'Florence');
insert City (CityId, CityNumber, CityName)
values (4, 16000000, 'Barcelona');
insert City (CityId, CityNumber, CityName)
values (5, 1883000, 'Bucharest');
insert City (CityId, CityNumber, CityName)
values (6, 180000, 'Brussels');
insert City (CityId, CityNumber, CityName)
values (7, 260000, 'Venice');
insert City (CityId, CityNumber, CityName)
values (8, 2148000, 'Paris');

insert City (CityId, CityNumber, CityName)
values (9, 270000, 'Strasbourg');
insert City (CityId, CityNumber, CityName)
values (10, 3800000, 'Berlin');
insert City (CityId, CityNumber, CityName)
values (11, 2600000, 'Rome');
insert City (CityId, CityNumber, CityName)
values (12, 700000, 'Seville');
insert City (CityId, CityNumber, CityName)
values (13, 707000, 'Cluj-Napoca');
insert City (CityId, CityNumber, CityName)
values (14, 1752000, 'Budapest');
insert City (CityId, CityNumber, CityName)
values (15, 976000, 'Stockholm');

select *
from City



-- insert BOOK --
insert Book(BookId, NumberLanguages, BookName)
values (1, 20, 'Inferno');
insert Book(BookId, NumberLanguages, BookName)
values (2, 15, 'Call from an angel');
insert Book(BookId, NumberLanguages, BookName)
values (3, 10, 'When Nietzsche wept');
insert Book(BookId, NumberLanguages, BookName)
values (4, 20, 'The world of yesterday');
insert Book(BookId, NumberLanguages, BookName)
values (5, 25, 'Origin');
insert Book(BookId, NumberLanguages, BookName)
values (6, 12, 'The house of Medici: Its rise and fall');

insert Book(BookId, NumberLanguages, BookName)
values (7, 25, 'The Brothers Karamazov');
insert Book(BookId, NumberLanguages, BookName)
values (8, 20, 'Ancient Rome');
insert Book(BookId, NumberLanguages, BookName)
values (9, 13, 'The Prize');
insert Book(BookId, NumberLanguages, BookName)
values (10, 5, 'Antoni Gaudi');

select * from City
select * from Book
select * from BookReferencesCity

-- insert BOOK REFERENCES CITY --
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(10, 2, 1, 100);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(11, 7, 1, 290);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(12, 8, 2, 10);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(13, 1, 3, 30);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(14, 1, 4, 60);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(15, 4, 5, 12);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(16, 2, 6, 120);

insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(18, 11, 8, 120);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(19, 15, 9, 120);
insert BookReferencesCity(BookReferenceId, CityId, BookId, PageReference)
values(20, 4, 10, 120);


--a. Write queries on Ta such that their execution plans contain the following operators:

sp_helpindex City

--clustered index scan;
-- the condition is on column CityName, which is not an index
select CityId, CityName
from City
where CityName LIKE 'B%'
-- ESC: 0.0032985


--clustered index seek;
-- the condition is on column CityId, primary key
select CityId, CityName
from City
where CityId = 1
-- ESC: 0.0032831


--nonclustered index scan;
-- CityNumber is a nonclustered index (unique)
-- the where clause does not exist, therefore it will go through all the rows (index scan)
select CityNumber
from City
-- ESC: 0.0032985


--nonclustered index seek;
-- CityNumber is a nonclustered index (unique)
select CityId
from City
where CityNumber = 380000
-- ESC: 0.0032831

select * from City


--key lookup.
select CityName
from City
where CityNumber = 380000
-- ESC: 0.0032831
-- nonclustered index seek + key lookup


-- b. Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan.
-- Create a nonclustered index that can speed up the query.
-- Examine the execution plan again.
select BookId
from Book
where NumberLanguages = 20
-- clustered index scan
-- ESC: 0.003293

-- by default non-clustered
create INDEX index_Book_NumberLanguages ON Book(NumberLanguages)
drop INdex index_Book_NumberLanguages ON Book

select BookId
from Book
where NumberLanguages = 20
-- non-clustered index seek
-- ESC: 0.0032853


-- c. Create a view that joins at least 2 tables.
-- Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

create or alter view City_Book
as
	select C.CityName, B.BookName
	from City C
	inner join BookReferencesCity BRC
	on C.CityId = BRC.CityId
	inner join Book B
	on BRC.BookId = B.BookId
	where B.NumberLanguages > 10
go

select *
from City_Book
-- ESC: 0.0124688
-- clustered index seek (Book.BookId) + clustered index scan (BRC.Id) for BRC.BookId and BRC.CityId + clustered index seek (City.CityId)
-- cannot be optimized: the index scan is needed, as it has to go through all rows to check the condition NumberLanguages > 10
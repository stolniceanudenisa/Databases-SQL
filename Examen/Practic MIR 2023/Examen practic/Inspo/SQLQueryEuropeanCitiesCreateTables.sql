create database EuropeanCities;

use EuropeanCities;

-- n:1 relationship
--		City - Country
--		Landmark - City
--		RepresentativePerson - City
--		SpecificDish - Country

create table Country
(
	CountryName varchar(50) Primary Key,
	PopulationNumber int,
	Currency varchar(20)
)

create table City
(
	CityName varchar(50) Primary Key,
	CountryName varchar(50),
	PopulationNumber int,
	Foreign Key (CountryName) references Country(CountryName)
)

alter table Country
add DateEUJoin date

create table Landmark
(
	LandmarkId int Primary Key identity(1,1),
	LandmarkName varchar(50),
	CityName varchar(50),
	Foreign Key (CityName) references City(CityName),
	DateOfCreation date
)

create table TravelRoute
(
	TravelRouteId int Primary key identity(1,1),
	NumberOfCities int,
	NumberOfCountries int,
	StartDate date,
	EndDate date
)

create table RepresentativePerson
(
	PersonId int Primary Key identity(1,1),
	PersonFirstName varchar(50),
	PersonLastName varchar(50),
	PersonRole varchar(50),
	Accomplishment varchar(50),
	CityName varchar(50),
	Foreign Key (CityName) references City(CityName)
)

create table Book
(
	BookId int Primary Key identity(1,1),
	BookName varchar(70),
	Author varchar(70),
	DateOfPublication date
)

create table SpecificDish
(
	DishName varchar(50) Primary Key,
	CountryName varchar(50),
	Foreign Key (CountryName) references Country(CountryName)
)

create table Languages
(
	LanguageName varchar(50) Primary Key
)

-- m:n relationship
create table City_TravelRoute
(
	CityName varchar(50),
	TravelRouteId int,
	Foreign Key (CityName) references City(CityName),
	Foreign Key (TravelRouteId) references TravelRoute(TravelRouteId),
	Primary Key(CityName, TravelRouteId),
	StartDate date,
	EndDate date
)

create table BookReferencesCity
(
	BookId int,
	CityName varchar(50),
	Foreign Key (BookId) references Book(BookId),
	Foreign Key (CityName) references City(CityName),
	Primary Key(BookId, CityName)
)

create table SpokenLanguage
(
	LanguageName varchar(50),
	CountryName varchar(50),
	Foreign Key (LanguageName) references Languages(LanguageName),
	Foreign Key (CountryName) references Country(CountryName),
	Primary Key (LanguageName, CountryName)
)

create table InnovationAwards
(
	Year int Primary Key,
	BigPrize int,
	SmallPrize int
)

create table CityNominated
(
	CityNominatedId int Primary Key identity(1,1),
	CityName varchar(50),
	AwardYear int
)

alter table Country
alter column DateEUJoin datetime

alter table Landmark
alter column DateOfCreation datetime

alter table TravelRoute
alter column StartDate datetime
alter table TravelRoute
alter column EndDate datetime

alter table Book
alter column DateOfPublication datetime

alter table TravelRoute
add constraint NumberOfCountries_Constraint check(NumberOfCountries < 5);

alter table Landmark
drop constraint FK__Landmark__CityName;

create table Movie
(
	MovieName varchar(50),
	CityName varchar(50),
	[Year] int
)

alter table Movie
alter column MovieName varchar(50);
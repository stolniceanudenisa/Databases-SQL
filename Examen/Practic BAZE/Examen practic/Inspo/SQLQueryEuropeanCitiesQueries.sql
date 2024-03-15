use EuropeanCities;

set dateformat dmy;

-- INSERT --
insert Country(CountryName, PopulationNumber, Currency, DateEUJoin)
values('Poland', NULL, NULL, NULL);

insert City (CityName, CountryName, PopulationNumber)
values ('Valencia', 'Spain', 800000);
insert City (CityName, CountryName, PopulationNumber)
values ('Linz', 'Austria', 190000);
insert City (CityName, CountryName, PopulationNumber)
values ('Warsaw', 'Poland', NULL);

insert Landmark(LandmarkName, CityName)
values ('Uffizi Gallery', 'Florence');

insert Landmark(LandmarkName, CityName)
values ('Tour Eiffel', NULL);

insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Wolfgang Amadeus', 'Mozart', 'Composer', 'Requiem', 'Vienna');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Marie', 'Curie', 'Scientist', 'Radioactivity', 'Warsaw');

insert Book([BookName], [Author], DateOfPublication)
values ('The Da Vinci Code', 'Dan Brown', convert(datetime, '1-1-2003'));

-- VIOLATES INTEGRITY CONSTRAINT (NR OF COUNTRIES HAS TO BE < 5)
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (7, 5, convert(datetime, '10/11/2021'), convert(datetime, '25/11/2021'));

insert Languages(LanguageName)
values ('Norwegian')
insert Languages(LanguageName)
values ('English')

-- CASCADE --
alter table City
add constraint delete_constraint foreign key (CountryName) references Country(CountryName) on delete cascade;
alter table City
add constraint update_constraint foreign key (CountryName) references Country(CountryName) on update cascade;
alter table Landmark
add constraint delete_constraint_Landmark foreign key (CityName) references City(CityName) on delete cascade;
alter table Landmark
add constraint update_constraint_Landmark foreign key (CityName) references City(CityName) on update cascade;
alter table RepresentativePerson
add constraint delete_constraint_RepresentativePerson foreign key (CityName) references City(CityName) on delete cascade;
alter table RepresentativePerson
add constraint update_constraint_RepresentativePerson foreign key (CityName) references City(CityName) on update cascade;
alter table SpecificDish
add constraint delete_constraint_SpecificDish foreign key (CountryName) references Country(CountryName) on delete cascade;
alter table SpecificDish
add constraint update_constraint_SpecificDish foreign key (CountryName) references Country(CountryName) on update cascade;
alter table City_TravelRoute
add constraint delete_constraint_City_TravelRoute_City foreign key (CityName) references City(CityName) on delete cascade;
alter table City_TravelRoute
add constraint update_constraint_City_TravelRoute_City foreign key (CityName) references City(CityName) on update cascade;
alter table City_TravelRoute
add constraint delete_constraint_City_TravelRoute_TravelRoute foreign key (TravelRouteId) references TravelRoute(TravelRouteId) on delete cascade;
alter table City_TravelRoute
add constraint update_constraint_City_TravelRoute_TravelRoute foreign key (TravelRouteId) references TravelRoute(TravelRouteId) on update cascade;
alter table BookReferencesCity
add constraint delete_constraint_BookReferencesCity_City foreign key (CityName) references City(CityName) on delete cascade;
alter table BookReferencesCity
add constraint update_constraint_BookReferencesCity_City foreign key (CityName) references City(CityName) on update cascade;
alter table BookReferencesCity
add constraint delete_constraint_BookReferencesCity_Book foreign key (BookId) references Book(BookId) on delete cascade;
alter table BookReferencesCity
add constraint update_constraint_BookReferencesCity_Book foreign key (BookId) references Book(BookId) on update cascade;
alter table SpokenLanguage
add constraint delete_constraint_SpokenLanguage_Language foreign key (LanguageName) references Languages(LanguageName) on delete cascade;
alter table SpokenLanguage
add constraint update_constraint_SpokenLanguage_Language foreign key (LanguageName) references Languages(LanguageName) on update cascade;
alter table SpokenLanguage
add constraint delete_constraint_SpokenLanguage_Country foreign key (CountryName) references Country(CountryName) on delete cascade;
alter table SpokenLanguage
add constraint update_constraint_SpokenLanguage_Country foreign key (CountryName) references Country(CountryName) on update cascade;

-- UPDATE --

-- BETWEEN --
update City
set PopulationNumber = PopulationNumber + 1000
where PopulationNumber between 10000 and 1000000;
-- OR --
update City
set PopulationNumber = PopulationNumber + 200
where CountryName = 'Sweden' or CountryName = 'Hungary';
-- <= --
update TravelRoute
set StartDate = convert(datetime, '9-11-2020')
where TravelRouteId <= 22;
-- IN --
update Country
set PopulationNumber = PopulationNumber + 100
where CountryName in ('Italy', 'Germany');

-- DELETE --

-- IS NULL --
delete from Landmark
where CityName IS NULL;

-- LIKE --
delete from City
where CityName like 'G%';

-- DELETE WITH CASCADE --
delete from TravelRoute
where TravelRouteId = 23;

-- a. UNION OPERATION: UNION [ALL] AND OR --

-- SELECT THE COUNTRIES THAT HAVE THE POPULATION > 50.000.000 OR HAVE JOINED THE EU BEFORE 1970
-- OR HAVE AT LEAST A CITY WITH POPULATION > 2.000.000
select CO.CountryName
from Country CO
where ((CO.PopulationNumber > 50000000) OR (CO.DateEUJoin < convert(datetime, '01/01/1970')))
UNION
select C.CountryName
from City C
where C.PopulationNumber > 2000000

-- SELECT THE CITIES FROM GERMANY OR AUSTRIA OR THAT HAVE AT LEAST A BOOK THAT REFERENCES IT
select C.CityName
from City C
where (C.CountryName = 'Germany' OR C.CountryName = 'Austria')
UNION
select BC.CityName
from BookReferencesCity BC

-- SELECT THE CITIES THAT ARE NOT FROM GERMANY OR AUSTRIA, OR THAT HAVE AT LEAST A BOOK THAT REFERENCES IT
select C.CityName
from City C
where NOT (C.CountryName = 'Germany' OR C.CountryName = 'Austria')
UNION
select BC.CityName
from BookReferencesCity BC

-- b. INTERSECTION OPERATION: INTERSECT AND IN --

-- SELECT THE CITIES FROM ITALY AND SPAIN THAT HAVE A REPRESENTATIVE PERSON
select C.CityName
from City C
where C.CountryName IN ('Italy', 'Spain')
INTERSECT
select RP.CityName
from RepresentativePerson RP

-- SELECT THE COUNTRIES THAT HAVE FRENCH, GERMAN OR ROMANIAN AS THEIR OFFICIAL LANGUAGE AND HAVE AT LEAST A SPECIFIC DISH
select SL.CountryName
from SpokenLanguage SL
where SL.LanguageName IN ('French', 'German', 'Romanian')
INTERSECT
select SD.CountryName
from SpecificDish SD

-- c. DIFFERENCE OPERATION: EXCEPT AND NOT IN --

-- SELECT THE CITIES THAT BELONG TO AT LEAST A TRAVEL ROUTE BUT ARE ONLY FROM GERMANY AND AUSTRIA
select CTR.CityName
from City_TravelRoute CTR
EXCEPT
select C.CityName
from City C
where C.CountryName NOT IN ('Austria', 'Gemany')

-- SELECT THE CITIES THAT BELONG TO A TRAVEL ROUTE BUT THE TRAVEL ROUTE DOES NOT CONTAIN A NUMBER OF 1 OR 2 CITIES
select CTR.CityName
from City_TravelRoute CTR
EXCEPT
select CTR.CityName
from City_TravelRoute CTR, TravelRoute TR
where CTR.TravelRouteId = TR.TravelRouteId and TR.NumberOfCities NOT IN (1, 2)

-- d. INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN --

-- INNER JOIN
-- FIND FOR EACH CITY WHICH IS THE OFFICIAL LANGUAGE AND DISPLAY THE COUNTRY, THE LANGUAGE AND THE DOUBLE POPULATION OF THE CITY
-- JOIN 3 TABLES
select C.CityName, C.CountryName, SL.LanguageName, doublePoulation = C.PopulationNumber * 2 
from City C
INNER JOIN Country CO ON C.CountryName = CO.CountryName
INNER JOIN SpokenLanguage SL on SL.CountryName = CO.CountryName

-- LEFT JOIN
-- FIND FOR EACH COUNTRY WHAT SPECIFIC DISH A TRAVELER COULD EAT, BUT ALSO INCLUDE THE COUNTRIES WHICH DO NOT HAVE A SPECIFIC DISH YET
select CO.CountryName, SD.DishName
from Country CO
LEFT JOIN SpecificDish SD ON CO.CountryName = SD.CountryName

-- FIND FOR EACH CITY WHAT SPECIFIC DISH A TRAVELER COULD EAT, BUT ALSO INCLUDE THE CITIES WHICH DO NOT HAVE A SPECIFIC DISH YET
select C.CityName, SD.DishName
from City C
LEFT JOIN Country CO ON C.CountryName = CO.CountryName
LEFT JOIN SpecificDish SD ON CO.CountryName = SD.CountryName

-- RIGHT JOIN
-- FIND FOR EACH COUNTRY THE YEAR(S) IT WAS NOMINATED FOR THE EUROPEAN INNOVATION AWARDS, THE YEAR BEFORE AND 
-- INCLUDE THE YEARS FOR THE COUNTRIES THAT ARE NOT IN THE DATABASES
select DISTINCT C.CountryName, CN.AwardYear, AwardYear2 = CN.AwardYear - 1
from City C
RIGHT JOIN CityNominated CN on C.CityName = CN.CityName

-- FULL JOIN
-- FIND FOR EACH CITY IF IT WAS NOMINATED FOR THE INNOVATION AWARDS AND THE YEARS AND ALSO INCLUDE THE YEARS WHERE THE AWARDS
-- WERE ORGANIZED, BUT THE CITY NOMINATED IS NOT IN THE DATABASE
select C.CityName, CN.AwardYear
from City C
FULL JOIN CityNominated CN on C.CityName = CN.CityName;

-- FIND THE CITIES THAT BELONG TO A TRAVEL ROUTE AND HAVE A BOOK REFERENCING IT. INCLUDE THE CITIES THAT DO NOT HAVE
-- A BOOK REFERENCING IT AND BOOK THAT DO NOT REFER A CITY THAT BELONGS TO A ROUTE
-- 2 MANY-TO-MANY RELATIONSHIPS
select CTR.CityName, CTR.TravelRouteId, B.BookName
from City_TravelRoute CTR
FULL JOIN BookReferencesCity BRC on CTR.CityName = BRC.CityName
FULL JOIN Book B on B.BookId = BRC.BookId;

-- e. IN + SUBQUERY IN WHERE + SUBQUERY IN SUBQUERY IN WHERE --
-- FIND THE CITIES THAT HAVE BEEN NOMINATED TO THE INNOVATION AWARDS in year 2020
select *
from City
where City.CityName in (select CN.CityName
						from CityNominated CN
						where CN.AwardYear = 2020)

-- FIND THE BOOKS WHICH HAVE A REFERENCE TO A CITY THAT HAS BEEN NOMINATED TO THE INNOVATION AWARDS
select *
from Book
where Book.BookId in (select BRC.BookId
					  from BookReferencesCity BRC
					  where BRC.CityName in (select CN.CityName
											 from CityNominated CN))

-- f. EXISTS + SUBQUERY IN WHERE CLAUSE --
-- FIND THE COUNTRIES THAT HAVE A CITY WITH A POPULATION between 900.000 and 5.000.000
select *
from Country
where exists (select *
			  from City
			  where (City.CountryName = Country.CountryName and (City.PopulationNumber > 900000 and City.PopulationNumber < 5000000)))

-- FIND THE CITIES THAT HAVE A REPRESENTATIVE PERSON WHO WAS A POLYMATH, SCIENTIST, ARCHITECT OR COMPOSER
select *
from City
where exists (select *
			  from RepresentativePerson RP
			  where RP.CityName = City.CityName and RP.PersonRole in ('Polymath', 'Scientist', 'Architect', 'Composer'))

-- g. SUBQUERY IN FROM CLAUSE --

-- SELECT THE FIRST 3 DISTINCT CITIES ORDERED BY POPULATION WHICH HAVE 
-- A REPRESENTATIVE PERSON THAT IS A POLYMATH, SCIENTIST, ARCHITECT OR COMPOSER
-- TOP, ORDER BY, DISTINCT
select DISTINCT TOP 3 C.*
from City C INNER JOIN
	(select *
	from RepresentativePerson RP
	where RP.PersonRole IN ('Polymath', 'Scientist', 'Architect', 'Composer')) RP2
	ON RP2.CityName = C.CityName
	ORDER BY C.PopulationNumber DESC

-- SELECT THE FIRST 2 CITIES NOMINATED IN 2020 OR 2018 ORDERED BY POPULATION
-- TOP, ORDER BY
select DISTINCT TOP 4 C.*
from City C INNER JOIN
		(select *
		from CityNominated CN
		where CN.AwardYear = 2020 OR CN.AwardYear = 2018) CNYear
		ON C.CityName = CNYear.CityName
		ORDER BY C.PopulationNumber DESC

-- h. GROUP BY + 3 HAVING CLAUSE + 2 SUBQUERY IN HAVING CLAUSE + COUNT, SUM, AVG, MIN, MAX --

-- FOR EACH CITY FIND THE NUMBER OF BOOKS THAT REFERENCES IT
select BRC.CityName, count(*) as nrBooks
from BookReferencesCity BRC
group by BRC.CityName

-- FOR EACH COUNTRY FIND THE NUMBER OF CITIES AND ORDER THE ONES WITH MORE THAN 1 CITY IN DESCENDING ORDER BY THIS NUMBER
select C.CountryName, count(*) as nrCities
from City C
group by C.CountryName
having count(CityName) > 1
order by nrCities DESC

-- SELECT THE COUNTRY AND THE MAXIMUM POPULATION OF THE CITY FOR THE COUNTRIES THAT HAVE A MAX CITY POPULATION
-- GREATER THAN THE AVERAGE POPULATION OF ALL THE CITIES
select C.CountryName, MAX(C.PopulationNumber) AS maxCityPopulation
from City C
group by C.CountryName
having MAX(C.PopulationNumber) > 
		(select avg(C2.PopulationNumber)
		 from City C2)

-- SELECT THE CITIES AND THE LATEST AWARD YEAR FOR THE INNOVATION AWARDS WHICH HAVE THE LATEST AWARD YEAR GREATER OR EQUAL
-- TO THE AVERAGE YEAR OF THE AWARDS
select CN.CityName, max(CN.AwardYear) as latestAwardYear
from CityNominated CN
group by CN.CityName
having max(CN.AwardYear) >=
		(select avg(CN2.AwardYear)
		from CityNominated CN2)

-- i. ANY, ALL FOR SUBQUERY IN WHERE CLAUSE + REWRITE 2 WITH AGGREGATION OPERATORS, 2 WITH IN/NOT IN --

-- SELECT THE CITIES AND THEIR POPULATION FOR WHICH THE POPULATION IS GREATER THAN THE ONE OF SOME CITY IN GERMANY
select C.CityName, C.PopulationNumber
from City C
where C.PopulationNumber > ANY
		(select C2.PopulationNumber
		from City C2
		where C2.CountryName = 'Germany')
-- EQUIVALENT QUERY WITH AGGREGATION OPERATOR MIN
select C.CityName, C.PopulationNumber
from City C
where C.PopulationNumber >
		(select MIN(C2.PopulationNumber)
		from City C2
		where C2.CountryName = 'Germany')

-- SELECT THE TRAVEL ROUTES AND THEIR START DATE FOR WHICH THE START DATE IS EARLIER THAN ALL THE START DATES OF THE
-- TRAVEL ROUTES WHICH VISIT MORE THAN 2 COUNTRIES, COMPUTE THE NR OF CITIES IF THE TRAVEL ROUTE WOULD CONTAIN 2 MORE CITIES
select TR.TravelRouteId, TR.StartDate, plusNrCities = TR.NumberOfCities + 2
from TravelRoute TR
where TR.StartDate < ALL
		(select TR2.StartDate
		from TravelRoute TR2
		where TR2.NumberOfCountries > 2)
-- EQUIVALENT QUERY WITH AGGREGATION OPERATOR MIN
select TR.TravelRouteId, TR.StartDate
from TravelRoute TR
where TR.StartDate <
		(select MIN(TR2.StartDate)
		from TravelRoute TR2
		where TR2.NumberOfCountries > 2)

-- SELECT THE COUNTRIES WHICH HAVE AT LEAST ONE CITY THAT HAS BEEN NOMINATED TO THE INNOVATION AWARDS
select CO.CountryName
from Country CO
where CO.CountryName = ANY
		(select C.CountryName
		from City C
		where C.CityName = ANY
				(select CN.CityName
				from CityNominated CN))
-- EQUIVALENT QUERY WITH IN OPERATOR
select CO.CountryName
from Country CO
where CO.CountryName IN
		(select C.CountryName
		from City C
		where C.CityName IN
				(select CN.CityName
				from CityNominated CN))

-- SELECT THE REPRESENTATIVE PEOPLE AND THEIR CITY FOR THE CITIES THAT DO NOR BELONG TO ANY TRAVEL ROUTE
select RP.PersonFirstName, RP.PersonLastName, RP.CityName
from RepresentativePerson RP
where RP.CityName <> ALL
		(select CTR.CityName
		from City_TravelRoute CTR)
-- EQUIVALENT QUERY WITH NOT IN OPERATOR
select RP.PersonFirstName, RP.PersonLastName, RP.CityName
from RepresentativePerson RP
where RP.CityName NOT IN
		(select CTR.CityName
		from City_TravelRoute CTR)

--------------------------------------- 3 QUERIES - ARITHMETIC EXPRESSIONS -------------------------------------------

-- INNER JOIN
-- FIND FOR EACH CITY WHICH IS THE OFFICIAL LANGUAGE AND DISPLAY THE COUNTRY, THE LANGUAGE AND THE DOUBLE POPULATION OF THE CITY
-- JOIN 3 TABLES
select C.CityName, C.CountryName, SL.LanguageName, doublePoulation = C.PopulationNumber * 2 
from City C
INNER JOIN Country CO ON C.CountryName = CO.CountryName
INNER JOIN SpokenLanguage SL on SL.CountryName = CO.CountryName

-- RIGHT JOIN
-- FIND FOR EACH COUNTRY THE YEAR(S) IT WAS NOMINATED FOR THE EUROPEAN INNOVATION AWARDS, THE YEAR BEFORE AND 
-- INCLUDE THE YEARS FOR THE COUNTRIES THAT ARE NOT IN THE DATABASES
select DISTINCT C.CountryName, CN.AwardYear, AwardYear2 = CN.AwardYear - 1
from City C
RIGHT JOIN CityNominated CN on C.CityName = CN.CityName

-- SELECT THE TRAVEL ROUTES AND THEIR START DATE FOR WHICH THE START DATE IS EARLIER THAN ALL THE START DATES OF THE
-- TRAVEL ROUTES WHICH VISIT MORE THAN 2 COUNTRIES, COMPUTE THE NR OF CITIES IF THE TRAVEL ROUTE WOULD CONTAIN 2 MORE CITIES
select TR.TravelRouteId, TR.StartDate, plusNrCities = TR.NumberOfCities + 2
from TravelRoute TR
where TR.StartDate < ALL
		(select TR2.StartDate
		from TravelRoute TR2
		where TR2.NumberOfCountries > 2)


--------------------------------------- 3 QUERIES - AND, OR, NOT + PARANTHESIS IN WHERE CLAUSE -----------------------

-- SELECT THE COUNTRIES THAT HAVE THE POPULATION > 50.000.000 OR HAVE JOINED THE EU BEFORE 1970
-- OR HAVE AT LEAST A CITY WITH POPULATION > 2.000.000
select CO.CountryName
from Country CO
where ((CO.PopulationNumber > 50000000) OR (CO.DateEUJoin < convert(datetime, '01/01/1970')))
UNION
select C.CountryName
from City C
where C.PopulationNumber > 2000000

-- SELECT THE CITIES FROM GERMANY OR AUSTRIA OR THAT HAVE AT LEAST A BOOK THAT REFERENCES IT
select C.CityName
from City C
where (C.CountryName = 'Germany' OR C.CountryName = 'Austria')
UNION
select BC.CityName
from BookReferencesCity BC

-- FIND THE COUNTRIES THAT HAVE A CITY WITH A POPULATION between 900.000 and 5.000.000
select *
from Country
where exists (select *
			  from City
			  where (City.CountryName = Country.CountryName and (City.PopulationNumber > 900000 and City.PopulationNumber < 5000000)))

-- SELECT THE CITIES THAT ARE NOT FROM GERMANY OR AUSTRIA, OR THAT HAVE AT LEAST A BOOK THAT REFERENCES IT
select C.CityName
from City C
where NOT (C.CountryName = 'Germany' OR C.CountryName = 'Austria')
UNION
select BC.CityName
from BookReferencesCity BC




--------------------------------------- 3 QUERIES - DISTINCT, 2 QUERIES - ORDER BY, 2 QUERIES - TOP -----------------------

-- FIND FOR EACH COUNTRY THE YEAR(S) IT WAS NOMINATED FOR THE EUROPEAN INNOVATION AWARDS AND INCLUDE THE YEARS FOR THE COUNTRIES
-- THAT ARE NOT IN THE DATABASES
-- DISTINCT
select DISTINCT C.CountryName, CN.AwardYear
from City C
RIGHT JOIN CityNominated CN on C.CityName = CN.CityName

-- SELECT THE FIRST 3 DISTINCT CITIES AND ITS REPRESENTATIVE PERSON ORDERED BY POPULATION WHICH HAVE 
-- A REPRESENTATIVE PERSON THAT IS A POLYMATH, SCIENTIST, ARCHITECT OR COMPOSER
-- TOP, ORDER BY, DISTINCT
select DISTINCT TOP 3 C.*, RP2.PersonFirstName, RP2.PersonLastName, RP2.PersonRole
from City C INNER JOIN
	(select *
	from RepresentativePerson RP
	where RP.PersonRole IN ('Polymath', 'Scientist', 'Architect', 'Composer')) RP2
	ON RP2.CityName = C.CityName
	ORDER BY C.PopulationNumber DESC

-- SELECT THE FIRST 2 CITIES NOMINATED IN 2020 OR 2018 ORDERED BY POPULATION
-- TOP, ORDER BY, DISTINCT
select DISTINCT TOP 4 C.*
from City C INNER JOIN
		(select *
		from CityNominated CN
		where CN.AwardYear = 2020 OR CN.AwardYear = 2018) CNYear
		ON C.CityName = CNYear.CityName
		ORDER BY C.PopulationNumber DESC

-- FOR EACH COUNTRY FIND THE NUMBER OF CITIES AND ORDER THE ONES WITH MORE THAN 1 CITY IN DESCENDING ORDER BY THIS NUMBER
-- ORDER BY
select C.CountryName, count(*) as nrCities
from City C
group by C.CountryName
having count(CityName) > 1
order by nrCities DESC
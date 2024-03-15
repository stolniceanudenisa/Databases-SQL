use EuropeanCities;

set dateformat dmy;

-- insert COUNTRIES --
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Austria', 8859000, 'Euro', convert(datetime, '1-1-1995'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('France', 67081000, 'Euro', convert(datetime, '1-1-1958'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Germany', 83166000, 'Euro', convert(datetime, '1-1-1958'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Italy', 60317000, 'Euro', convert(datetime, '1-1-1958'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Spain', 47431000, 'Euro', convert(datetime, '1-1-1986'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Romania', 19317000, 'Ron', convert(datetime, '1-1-2007'));
insert Country (CountryName, PopulationNumber, Currency, DateEUJoin)
values ('Hungary', 9772000, 'Forint', convert(datetime, '1-1-2004'));
insert Country (CountryName, PopulationNumber, [Currency], DateEUJoin)
values ('Sweden', 10343000, 'Swedish krona', convert(datetime, '1-1-1995'));
insert Country (CountryName, PopulationNumber, [Currency], DateEUJoin)
values ('Belgium', 11460000, 'Euro', convert(datetime, '1-1-1958'));

update Country
set DateEUJoin = cast('1-1-1995' as datetime) where CountryName in ('Austria', 'Sweden');
update Country
set DateEUJoin = cast('1-1-1958' as datetime) where CountryName in ('France', 'Germany', 'Italy', 'Belgium');
update Country
set DateEUJoin = cast('1-1-1986' as datetime) where CountryName = 'Spain';
update Country
set DateEUJoin = cast('1-1-2007' as datetime) where CountryName = 'Romania';
update Country
set DateEUJoin = cast('1-1-2004' as datetime) where CountryName = 'Hungary';

-- insert CITIES --
insert City (CityName, CountryName, PopulationNumber)
values ('Vienna', 'Austria', 1888000);
insert City (CityName, CountryName, PopulationNumber)
values ('Paris', 'France', 2148000);
insert City (CityName, CountryName, PopulationNumber)
values ('Strasbourg', 'France', 270000);
insert City (CityName, CountryName, PopulationNumber)
values ('Berlin', 'Germany', 3800000);
insert City (CityName, CountryName, PopulationNumber)
values ('Frankfurt', 'Germany', 730000);
insert City (CityName, CountryName, PopulationNumber)
values ('Florence', 'Italy', 380000);
insert City (CityName, CountryName, PopulationNumber)
values ('Barcelona', 'Spain', 16000000);
insert City (CityName, CountryName, PopulationNumber)
values ('Venice', 'Italy', 260000);
insert City (CityName, CountryName, PopulationNumber)
values ('Rome', 'Italy', 2600000);
insert City (CityName, CountryName, PopulationNumber)
values ('Seville', 'Spain', 700000);
insert City (CityName, CountryName, PopulationNumber)
values ('Bucharest', 'Romania', 1883000);
insert City (CityName, CountryName, PopulationNumber)
values ('Cluj-Napoca', 'Romania', 707000);
insert City (CityName, CountryName, PopulationNumber)
values ('Budapest', 'Hungary', 1752000);
insert City (CityName, CountryName, PopulationNumber)
values ('Stockholm', 'Sweden', 976000);
insert City (CityName, CountryName, PopulationNumber)
values ('Gothenburg', 'Sweden', 579000);
insert City (CityName, CountryName, PopulationNumber)
values ('Brussels', 'Belgium', 180000);
insert City (CityName, CountryName, PopulationNumber)
values ('Leuven', 'Belgium', 93000);

-- insert LANDMARKS --
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Belvedere Palace', 'Vienna', 1-1-1723);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('The Hofburg', 'Vienna', 1-1-1279);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Louvre', 'Paris', 10-8-1793);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Brandenburg Gate', 'Berlin', 6-8-1791);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Palazzo Vecchio', 'Florence', 6-8-1299);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Park Guell', 'Barcelona', 1-1-1914);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Trevi Fountain', 'Rome', 1-1-1762);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Romanian Athenaeum', 'Bucharest', 1-1-1888);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Church Saint Michael', 'Cluj-Napoca', 1-1-1447);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Atomium', 'Brussels', 25-3-1958);
insert Landmark(LandmarkName, CityName, DateOfCreation)
values ('Musical Instruments Museum', 'Brussels', 1-1-1877);

-- there are dates < '1-1-1753' which is the first date that can appear in sql
alter table Landmark
drop column DateOfCreation;

-- insert TRAVEL ROUTE --
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (3, 2, convert(datetime, '10/11/2020'), convert(datetime, '17/11/2020'));
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (1, 1, convert(datetime, '5/6/2021'), convert(datetime, '7/6/2021'));
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (4, 3, convert(datetime, '10/4/2021'), convert(datetime, '25/4/2021'));
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (2, 1, convert(datetime, '17/1/2021'), convert(datetime, '24/1/2021'));
insert TravelRoute(NumberOfCities, NumberOfCountries, StartDate, EndDate)
values (2, 2, convert(datetime, '17/3/2021'), convert(datetime, '22/3/2021'));

-- insert REPRESENTATIVE PERSON --
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Gustav', 'Klimt', 'Painter', 'The Kiss', 'Vienna');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Ludwig', 'van Beethoven', 'Composer', 'Symphony No. 9', 'Vienna');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Sigmund', 'Freud', 'Psychiatrist', 'Psychoanalysis', 'Vienna');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Leonardo', 'da Vinci', 'Polymath', 'Mona Lisa', 'Florence');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Antoni', 'Gaudi', 'Architect', 'La Sagrada Familia', 'Barcelona');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Julius', 'Caesar', 'Political Leader', 'The Roman Empire', 'Rome');
insert RepresentativePerson(PersonFirstName, PersonLastName, PersonRole, Accomplishment, CityName)
values ('Marco', 'Polo', 'Explorer', 'TheTravels of Marco Polo', 'Venice');

-- insert BOOK --
insert Book(BookName, Author, DateOfPublication)
values ('Inferno', 'Dan Brown', convert(datetime, '1-5-2013'));
insert Book(BookName, Author, DateOfPublication)
values ('Call from an angel', 'Guillaume Musso', convert(datetime, '1-1-2011'));
insert Book(BookName, Author, DateOfPublication)
values ('When Nietzsche wept', 'Irvin Yalom', convert(datetime, '1-1-1992'));
insert Book(BookName, Author, DateOfPublication)
values ('The world of yesterday', 'Stefan Zweig', convert(datetime, '1-1-1941'));
insert Book(BookName, Author, DateOfPublication)
values ('Origin', 'Dan Brown', convert(datetime, '1-1-2017'));
insert Book(BookName, Author, DateOfPublication)
values ('The house of Medici: Its rise and fall', 'Christopher Hibbert', convert(datetime, '1-1-1974'));

-- insert SPECIFIC DISH --
insert SpecificDish(DishName, CountryName)
Values('Wiener Schnitzel', 'Austria');
insert SpecificDish(DishName, CountryName)
Values('Apfelstrudel', 'Austria');
insert SpecificDish(DishName, CountryName)
Values('Wurst', 'Germany');
insert SpecificDish(DishName, CountryName)
Values('Croissant', 'France');
insert SpecificDish(DishName, CountryName)
Values('Crepes', 'France');
insert SpecificDish(DishName, CountryName)
Values('French Cheese', 'France');
insert SpecificDish(DishName, CountryName)
Values('Gaufre', 'Belgium');
insert SpecificDish(DishName, CountryName)
Values('Moules-frites', 'Belgium');
insert SpecificDish(DishName, CountryName)
Values('Paella', 'Spain');
insert SpecificDish(DishName, CountryName)
Values('Pasta', 'Italy');
insert SpecificDish(DishName, CountryName)
Values('Cinnamon Bun', 'Sweden');

-- insert LANGUAGE --
insert Languages(LanguageName)
values('German');
insert Languages(LanguageName)
values('French');
insert Languages(LanguageName)
values('Italian');
insert Languages(LanguageName)
values('Romanian');
insert Languages(LanguageName)
values('Spanish');
insert Languages(LanguageName)
values('Swedish');

-- m:n relationships

-- insert CITY_TRAVEL ROUTE --
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Florence', 22, convert(datetime, '10-11-2020'), convert(datetime, '12-11-2020'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Venice', 22, convert(datetime, '12-11-2020'), convert(datetime, '14-11-2020'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Paris', 22, convert(datetime, '14-11-2020'), convert(datetime, '17-11-2020'));

insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Vienna', 23, convert(datetime, '5-6-2021'), convert(datetime, '7-6-2021'));

insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Bucharest', 24, convert(datetime, '10-4-2021'), convert(datetime, '12-4-2021'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Cluj-Napoca', 24, convert(datetime, '12-4-2021'), convert(datetime, '17-4-2021'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Budapest', 24, convert(datetime, '17-4-2021'), convert(datetime, '21-4-2021'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Vienna', 24, convert(datetime, '21-4-2021'), convert(datetime, '25-4-2021'));

insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Brussels', 25, convert(datetime, '17-1-2021'), convert(datetime, '20-1-2021'));
insert City_TravelRoute(CityName, TravelRouteId, StartDate, EndDate)
values('Leuven', 25, convert(datetime, '20-1-2021'), convert(datetime, '24-1-2021'));

-- insert BOOK REFERENCES CITY --
insert BookReferencesCity(BookId, CityName)
values(1, 'Florence');
insert BookReferencesCity(BookId, CityName)
values(1, 'Venice');
insert BookReferencesCity(BookId, CityName)
values(2, 'Paris');
insert BookReferencesCity(BookId, CityName)
values(3, 'Vienna');
insert BookReferencesCity(BookId, CityName)
values(4, 'Vienna');
insert BookReferencesCity(BookId, CityName)
values(5, 'Barcelona');
insert BookReferencesCity(BookId, CityName)
values(6, 'Florence');

-- insert SPOKEN LANGUAGE --
insert SpokenLanguage(LanguageName, CountryName)
values('French', 'France');
insert SpokenLanguage(LanguageName, CountryName)
values('German', 'Germany');
insert SpokenLanguage(LanguageName, CountryName)
values('Italian', 'Italy');
insert SpokenLanguage(LanguageName, CountryName)
values('French', 'Belgium');
insert SpokenLanguage(LanguageName, CountryName)
values('German', 'Belgium');
insert SpokenLanguage(LanguageName, CountryName)
values('Romanian', 'Romania');
insert SpokenLanguage(LanguageName, CountryName)
values('Spanish', 'Spain');

select *
from TravelRoute;

-- insert INNOVATION AWARDS --
insert InnovationAwards([Year], BigPrize, SmallPrize)
values(2020, 1000000, 100000);
insert InnovationAwards([Year], BigPrize, SmallPrize)
values(2019, 600000, 100000);
insert InnovationAwards([Year], BigPrize, SmallPrize)
values(2018, 900000, 90000);

-- insert CITY NOMINATED --
insert CityNominated(CityName, AwardYear)
values('Cluj-Napoca', 2020);
insert CityNominated(CityName, AwardYear)
values('Vienna', 2020);
insert CityNominated(CityName, AwardYear)
values('Leuven', 2020);
insert CityNominated(CityName, AwardYear)
values('Espoo', 2020);

insert CityNominated(CityName, AwardYear)
values('Nantes', 2019);
insert CityNominated(CityName, AwardYear)
values('Bristol', 2019);
insert CityNominated(CityName, AwardYear)
values('Rotterdam', 2019);
insert CityNominated(CityName, AwardYear)
values('Espoo', 2019);

insert CityNominated(CityName, AwardYear)
values('Athens', 2018);
insert CityNominated(CityName, AwardYear)
values('Hamburg', 2018);
insert CityNominated(CityName, AwardYear)
values('Leuven', 2018);
insert CityNominated(CityName, AwardYear)
values('Toulouse', 2018);

select *
from Movie;

insert Movie(MovieName, CityName, [Year])
values('Amelie', 'Paris', 2001);
insert Movie(MovieName, CityName, [Year])
values('Before Sunrise', 'Vienna', 1995);
insert Movie(MovieName, CityName, [Year])
values('Amadeus', 'Prague', 1985);
insert Movie(MovieName, CityName, [Year])
values('Bridge of Spies', 'Berlin', 2015);
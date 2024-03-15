INSERT INTO Prezentare_de_moda.dbo.Agentie(id_agentie, id_eveniment, id_sponsor, nume_agentie, nume_reprezentant)
VALUES(1,1,1,'Skims','Kim Kardashian'),
(2,1,3,'Victoria Secrets','Roy Raymond'),
(3,2,1,'Good American','Khloe Kardashian');


INSERT INTO Prezentare_de_moda.dbo.casa_de_moda(id_casa, id_model, nr_angajati, locatie)
VALUES(1,2,11500,'New York'),
(2,1,15200,'Los Angeles'),
(3,3,13400,'Los Angeles');


INSERT INTO Prezentare_de_moda.dbo.Eveniment(id_evenimet, id_creator, locatie, data)
VALUES(1,2,'New York','2023-10-23'),
(2,1,'Milano','2022-05-12'),
(3,3,'Londra','2019-02-11'),
(4,2,'Shanghai','2020-12-28'),
(5,3,'Paris','2017-05-19'),
(6,1,'Tokyo','2022-08-03');


INSERT INTO Prezentare_de_moda.dbo.model(id_model, nume, data_nasterii, salariu)
VALUES(1,'Gigi Hadid','1995-04-23',20000),
(2,'Kendall Jenner','1995-11-03',18000),
(3,'Winnie Harlow','1994-07-27',15000),
(4,'Bella Hadid','1996-10-09',23000),
(5,'Hayden Graye','1998-04-29',19000),
(6,'Kourtney Kardashian','1979-04-18',21000);


INSERT INTO Prezentare_de_moda.dbo.Sponsor(id_sponsor, id_eveniment, suma)
VALUES(1,2,4000000),
(2,1,10000000),
(3,3,2500000),
(4,6,3000000),
(5,4,2200000),
(6,3,1500000),
(7,5,3500000),
(8,2,5000000),
(9,6,3500000);
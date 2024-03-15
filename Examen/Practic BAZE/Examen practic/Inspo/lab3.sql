USE Prezentare_de_moda
GO

/*combina locatiile din cele 2 tabele (casa de moda si eveniment)*/
SELECT DISTINCT locatie from casa_de_moda
UNION
SELECT DISTINCT locatie from Eveniment
ORDER BY locatie;

/*uneste tabelele sponsor si eveniment */
SELECT Sponsor.id_eveniment, Eveniment.locatie
FROM Sponsor
INNER JOIN Eveniment ON Sponsor.id_eveniment = Eveniment.id_evenimet
WHERE Sponsor.suma > 3220000 AND Sponsor.suma < 3600000;

/*uneste tabelele casa de moda si model*/
SELECT casa_de_moda.id_model, model.data_nasterii
FROM casa_de_moda
INNER JOIN model ON model.id_model = casa_de_moda.id_model;

/* ia partea stanga din intersectia tabelelor*/
SELECT casa_de_moda.nr_angajati, Sponsor.id_sponsor
FROM casa_de_moda
LEFT JOIN Sponsor ON casa_de_moda.id_casa = Sponsor.id_sponsor
ORDER BY casa_de_moda.nr_angajati

/*grupeaza suma dupa id eveniment si afiseaza numarul de id_sponsor i care au suma egala, ordonati descrescator*/
SELECT COUNT(id_sponsor), suma
FROM Sponsor
GROUP BY suma
ORDER BY COUNT(id_sponsor) DESC;

/*grupeaza suma dupa id eveniment si afiseaza suma minima, dar mai mare decat 20000 */
SELECT MIN(Sponsor.suma) as Nr_min_id_eveniment, id_eveniment 
FROM Sponsor
GROUP BY id_eveniment
HAVING MIN(suma) > 20000

/*grupeaza suma dupa id eveniment si afiseaza suma maxima, dar mai mica decat 5000000*/
SELECT MAX(Sponsor.suma) as Nr_max_id_eveniment, id_eveniment 
FROM Sponsor
GROUP BY id_eveniment
HAVING MAX(suma) < 5000000

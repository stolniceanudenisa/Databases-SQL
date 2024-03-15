
use STORE


----REUNIUNEA Titlu cărți și nume autori
SELECT book_name AS Title, 'Book' AS Type
FROM Books
UNION
SELECT author_name AS Title, 'Author' AS Type
FROM Authors;

 --REUNIUNEA ID-urilor cărților și ID-urilor autorilor
SELECT book_id AS ID, NULL AS AuthorID, 'Book' AS Type
FROM Books
UNION
SELECT NULL AS BookID, author_id AS AuthorID, 'Author' AS Type
FROM Authors;

----REUNIUNEA tuturor Entităților Customer și Genre
SELECT customer_id AS EntityID, customer_name AS EntityName, 'Customer' AS EntityType
FROM Customers
UNION ALL
SELECT genre_id AS EntityID, genre_name AS EntityName, 'Genre' AS EntityType
FROM Genres;

--Intersecția ID-urilor de Gen între Cărți și Autori
SELECT genre_id
FROM BookGenres
INTERSECT
SELECT genre_id
FROM AuthorGenres;

--INSERT INTO AuthorGenres (author_id, genre_id)
--VALUES
--    (1, 1), --  author_id 1 associated with genre_id 1  
--    (2, 2), --  author_id 2 is associated with genre_id 2 
--    (3, 5); --  author_id 3 is associated with genre_id 5  


--Selectarea numelor de genuri comune între cărți și autori:
--selectează numele de genuri (din tabela "Genres") care sunt comune atât în tabela 
--"BookGenres" (prin genurile asociate cărților), cât și în tabela "AuthorGenres"
-- (prin genurile asociate autorilor).

SELECT G.genre_name
FROM Genres G
WHERE G.genre_id IN (
    SELECT BG.genre_id
    FROM BookGenres BG
    INTERSECT
    SELECT AG.genre_id
    FROM AuthorGenres AG
);

 --Selectarea autorilor care NU au scris cărți:
SELECT author_id, author_name
FROM Authors
EXCEPT
SELECT a.author_id, a.author_name
FROM Authors a
INNER JOIN BooksAuthors ba ON a.author_id = ba.author_id



--Selectarea autorilor distincti care au scris cărți:
SELECT DISTINCT a.author_id, a.author_name
FROM Authors a
INNER JOIN BooksAuthors ba ON a.author_id = ba.author_id

 
--Selectarea informațiilor despre clienți și cărți achiziționate
SELECT c.customer_id, c.customer_name, b.book_id, b.book_name
FROM Customers c
INNER JOIN BookCustomers bc ON c.customer_id = bc.customer_id
INNER JOIN Books b ON bc.book_id = b.book_id;


--Selectarea informațiilor despre cărți, genuri și autori asociate
SELECT b.book_name, g.genre_name, a.author_name
FROM Books b
INNER JOIN BookGenres bg ON b.book_id = bg.book_id
INNER JOIN Genres g ON bg.genre_id = g.genre_id
INNER JOIN BooksAuthors ba ON b.book_id = ba.book_id
INNER JOIN Authors a ON ba.author_id = a.author_id;

----Selectarea informațiilor despre autori și cărțile asociate (inclusiv autorii fără cărți)
SELECT a.author_id, a.author_name, b.book_id, b.book_name
FROM Authors a
LEFT JOIN BooksAuthors ba ON a.author_id = ba.author_id
LEFT JOIN Books b ON ba.book_id = b.book_id;


--Selectarea informațiilor despre autori și cărți (utilizând RIGHT JOIN):
--include toate înregistrările din tabela "BooksAuthors" și "Books," 
--chiar dacă nu există o potrivire în tabela "Authors."
-- Dacă un autor nu are nicio carte asociată, se vor afișa NULL în coloanele corespunzătoare.
SELECT a.author_id, a.author_name, b.book_id, b.book_name
FROM Authors a
RIGHT JOIN BooksAuthors ba ON a.author_id = ba.author_id
RIGHT JOIN Books b ON ba.book_id = b.book_id;


--Selectarea informațiilor despre clienți și cărți achiziționate (utilizând RIGHT JOIN):
--include toate înregistrările din tabela "BookCustomers" și "Books," chiar dacă nu există 
--o potrivire în tabela "Customers." Dacă un client nu a achiziționat nicio carte, se vor afișa NULL
SELECT c.customer_id, c.customer_name, b.book_id, b.book_name
FROM Customers c
RIGHT JOIN BookCustomers bc ON c.customer_id = bc.customer_id
RIGHT JOIN Books b ON bc.book_id = b.book_id;

 --Selectarea informațiilor despre cărți, autori și genuri (utilizând INNER JOIN)

SELECT b.book_name, a.author_name, g.genre_name
FROM Books b
INNER JOIN BooksAuthors ba ON b.book_id = ba.book_id
INNER JOIN Authors a ON ba.author_id = a.author_id
INNER JOIN AuthorGenres ag ON a.author_id = ag.author_id
INNER JOIN Genres g ON ag.genre_id = g.genre_id;
 
 
 -- Selectarea informațiilor despre cărți și genuri asociate
SELECT Books.book_id, Books.book_name, Genres.genre_name
FROM Books
INNER JOIN BookGenres ON Books.book_id = BookGenres.book_id
INNER JOIN Genres ON BookGenres.genre_id = Genres.genre_id;


--Selectarea informațiilor despre cărți, autori și genuri asociate:
SELECT Books.book_id, Books.book_name, Authors.author_id, Authors.author_name, Genres.genre_id, Genres.genre_name
FROM Books
INNER JOIN BooksAuthors ON Books.book_id = BooksAuthors.book_id
INNER JOIN Authors ON BooksAuthors.author_id = Authors.author_id
INNER JOIN AuthorGenres ON Authors.author_id = AuthorGenres.author_id
INNER JOIN Genres ON AuthorGenres.genre_id = Genres.genre_id;

--Selectarea informațiilor despre autori și genuri asociate (inclusiv autorii fără genuri)
SELECT Authors.author_id, Authors.author_name, Genres.genre_name
FROM Authors
LEFT JOIN AuthorGenres ON Authors.author_id = AuthorGenres.author_id
LEFT JOIN Genres ON AuthorGenres.genre_id = Genres.genre_id;

--Selectarea informațiilor despre cărți și autori (utilizând RIGHT JOIN)
SELECT Books.book_id, Books.book_name, Authors.author_id, Authors.author_name
FROM BooksAuthors
RIGHT JOIN Books ON BooksAuthors.book_id = Books.book_id
RIGHT JOIN Authors ON BooksAuthors.author_id = Authors.author_id;

--Selectarea informațiilor despre cărți și genuri (utilizând RIGHT JOIN)
SELECT Books.book_id, Books.book_name, Genres.genre_id, Genres.genre_name
FROM BookGenres
RIGHT JOIN Books ON BookGenres.book_id = Books.book_id
RIGHT JOIN Genres ON BookGenres.genre_id = Genres.genre_id;

--Selectarea informațiilor despre autori și cărți asociate (utilizând RIGHT JOIN)
SELECT Authors.author_id, Authors.author_name, BooksAuthors.book_id
FROM Authors
RIGHT JOIN BooksAuthors ON Authors.author_id = BooksAuthors.author_id;


--UNION intre informații despre cărți și autori folosind LEFT JOIN și UNION
SELECT Books.book_id, Books.book_name, Authors.author_id, Authors.author_name
FROM Books
LEFT JOIN BooksAuthors ON Books.book_id = BooksAuthors.book_id
LEFT JOIN Authors ON BooksAuthors.author_id = Authors.author_id
UNION
SELECT Books.book_id, Books.book_name, Authors.author_id, Authors.author_name
FROM Authors
LEFT JOIN BooksAuthors ON Authors.author_id = BooksAuthors.author_id
LEFT JOIN Books ON BooksAuthors.book_id = Books.book_id;


INSERT INTO Books (book_name, book_price, year_of_appearance)
VALUES ('And Then There Were None', 50, 1939);

INSERT INTO BookGenres (book_id, genre_id)
VALUES
    (8, 8)

--Selectarea cărților cu un anumit gen ('History')
SELECT book_id, book_name
FROM Books
WHERE book_id IN (
    SELECT book_id
    FROM BookGenres
    WHERE genre_id IN (
        SELECT genre_id
        FROM Genres
        WHERE genre_name IN ('History')
    )
);
 
  
INSERT INTO AuthorGenres (author_id, genre_id)
VALUES
    (4, 9), -- Terry Pratchett is associated with the 'Fantasy' genre
    (5, 9), -- nec1 is associated with the 'Fantasy' genre
    (6, 9), -- nec2 is associated with the 'Fantasy' genre
    (7, 9); -- nec3 is associated with the 'Fantasy' genre


--Selectarea autorilor care scriu genul 'Fantasy'
SELECT author_id, author_name
FROM Authors AS A
WHERE EXISTS (
    SELECT author_id
    FROM AuthorGenres AS AG
    WHERE AG.author_id = A.author_id
    AND AG.genre_id = (
        SELECT genre_id
        FROM Genres
        WHERE genre_name = 'Fantasy'
    )
);

--Numărul total de cărți scrise de fiecare autor
SELECT Authors.author_id, Authors.author_name, COUNT(BooksAuthors.book_id) AS TotalBooks
FROM Authors
LEFT JOIN BooksAuthors ON Authors.author_id = BooksAuthors.author_id
GROUP BY Authors.author_id, Authors.author_name;


--Media cărților per autor
SELECT Authors.author_id, Authors.author_name, AVG(BooksAuthors.book_id) AS AverageBooksPerAuthor
FROM Authors
LEFT JOIN BooksAuthors ON Authors.author_id = BooksAuthors.author_id
GROUP BY Authors.author_id, Authors.author_name;


--Autorii cu cel mai mare număr de cărți (în caz de egalitate, se afișează toți)
SELECT Authors.author_id, Authors.author_name, COUNT(BooksAuthors.book_id) AS BookCount
FROM Authors
LEFT JOIN BooksAuthors ON Authors.author_id = BooksAuthors.author_id
GROUP BY Authors.author_id, Authors.author_name
HAVING COUNT(BooksAuthors.book_id) = (
    SELECT MAX(BookCount)
    FROM (
        SELECT COUNT(book_id) AS BookCount
        FROM BooksAuthors AS BA
        WHERE BA.author_id = Authors.author_id
        GROUP BY BA.author_id
    ) AS BookCounts
);


--Selectarea tuturor informațiilor despre cărțile cu cel mai mic preț
SELECT *
FROM Books
WHERE book_price = (
    SELECT MIN(book_price)
    FROM Books
);

--pret minim carte
SELECT MIN(book_price) AS MinPrice
FROM Books;

--Afișarea celei mai ieftine cărți folosind TOP 1 și ORDER BY:
SELECT TOP 1 book_id, book_name, book_price AS MinPrice
FROM Books
ORDER BY book_price;


--suma preturilor tuturor cartilor
SELECT SUM(book_price) AS TotalPriceOfBooks
FROM Books;

 

--CREATE TABLE Orders (
--    order_id INT PRIMARY KEY,
--    customer_id INT,
--    order_total DECIMAL(10, 2)
--);

--INSERT INTO Orders (order_id, customer_id, order_total) VALUES
--(1, 101, 500),
--(2, 102, 1200),
--(3, 101, 800),
--(4, 103, 300),
--(5, 104, 2200),
--(6, 102, 700);

--clienți cu vânzări totale mai mari de 1000
SELECT customer_id, SUM(order_total) AS TotalSales
FROM Orders
GROUP BY customer_id
HAVING SUM(order_total) > 1000;


--genuri de cărți și cel mai mare preț al unei cărți din fiecare gen
SELECT g.genre_name, MAX(b.book_price) AS HighestPrice
FROM Genres g
INNER JOIN BookGenres bg ON g.genre_id = bg.genre_id
INNER JOIN Books b ON bg.book_id = b.book_id
GROUP BY g.genre_name;


--autori și numărul total de cărți scrise de fiecare autor
SELECT A.author_id, A.author_name, COUNT(BA.book_id) AS TotalBooksWritten
FROM Authors A
LEFT JOIN BooksAuthors BA ON A.author_id = BA.author_id
GROUP BY A.author_id, A.author_name;

--Afișarea autorilor și anului primei apariții a celei mai vechi cărți scrise de fiecare autor
SELECT a.author_name, MIN(b.year_of_appearance) AS OldestBookYear
FROM Authors a
INNER JOIN BooksAuthors ba ON a.author_id = ba.author_id
INNER JOIN Books b ON ba.book_id = b.book_id
GROUP BY a.author_name;

--Afișarea autorilor și prețul mediu al cărților scrise de fiecare autor
SELECT A.author_id, A.author_name, AVG(B.book_price) AS AvgBookPrice
FROM Authors A
JOIN BooksAuthors BA ON A.author_id = BA.author_id
JOIN Books B ON BA.book_id = B.book_id
GROUP BY A.author_id, A.author_name;


--Afișarea autorilor și genurilor asociate, excluzând genul 'Mystery' pt autorul 'Agatha Christie'
SELECT DISTINCT A.author_name, G.genre_name
FROM Authors A
JOIN AuthorGenres AG ON A.author_id = AG.author_id
JOIN Genres G ON AG.genre_id = G.genre_id
WHERE NOT (G.genre_name = 'Mystery' AND A.author_name = 'Agatha Christie');

 
--Afișarea cărților care NU sunt din genul 'Fantasy' și au fost publicate în afara anilor 2010-2020
SELECT book_name, year_of_appearance
FROM Books
WHERE (year_of_appearance < 2010 OR year_of_appearance > 2020)
AND NOT (book_id IN (
    SELECT book_id
    FROM BookGenres
    WHERE genre_id = (
        SELECT genre_id
        FROM Genres
        WHERE genre_name = 'Fantasy'
    )
));

--Afișarea numelor clienților care au achiziționat cel puțin o carte publicată în anul cu cea mai recentă apariție
SELECT customer_name
FROM Customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM BookCustomers
    WHERE book_id IN (
        SELECT book_id
        FROM Books
        WHERE year_of_appearance = (SELECT MAX(year_of_appearance) FROM Books)
    )
);

-- varianta 2 la interogarea de mai sus ce are si book name
SELECT C.customer_name, B.book_name
FROM Customers C
JOIN BookCustomers BC ON C.customer_id = BC.customer_id
JOIN Books B ON BC.book_id = B.book_id
WHERE B.year_of_appearance = (SELECT MAX(year_of_appearance) FROM Books);

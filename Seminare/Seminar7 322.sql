CREATE DATABASE Seminar7322;
GO 
USE Seminar7322;
CREATE TABLE FriendRequests
(
	cod_fr	INT PRIMARY KEY IDENTITY,
	date_of_request DATE,
	request_status VARCHAR(2),
	from_person VARCHAR(100),
	to_person VARCHAR(100)
)
INSERT INTO FriendRequests (date_of_request, request_status, from_person, to_person) VALUES ('2022-01-04','P','PERSON 1','PERSON 2')
INSERT INTO FriendRequests (date_of_request, request_status, from_person, to_person) VALUES ('2022-01-04','A','PERSON 3','PERSON 4')
INSERT INTO FriendRequests (date_of_request, request_status, from_person, to_person) VALUES ('2022-01-04','C','PERSON 5','PERSON 6')
INSERT INTO FriendRequests (date_of_request, request_status, from_person, to_person) VALUES ('2022-01-04',NULL,'PERSON 7','PERSON 8')

SELECT	cod_fr, from_person, to_person, excplained_status = 
CASE request_status
WHEN 'P' THEN 'PENDING'
WHEN 'A' THEN 'ACCEPTED'
WHEN 'C' THEN 'REJECTED'
ELSE 'UNKNOWN'
END
FROM Friendrequests

SELECT date_of_request, request_status, from_person, to_person, date_status = (
CASE
WHEN (date_of_request <='2022-01-02') THEN 'old'
WHEN (date_of_request <='2022-01-03') THEN 'recent'
WHEN (date_of_request >'2022-01-04') THEN 'fresh'
ELSE 'unknown status'
END)
FROM FriendRequests
USE [Ceainarie]
GO
/****** Object:  StoredProcedure [dbo].[D1]    Script Date: 06.11.2018 11:18:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[D1] 
AS BEGIN
	ALTER TABLE Comanda
	ALTER COLUMN Pret FLOAT NOT NULL
END

EXEC D1

-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Institution (	
	[Name] [varchar](250) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](3) NULL,
	[Country] [varchar](3) NULL,
	[Postal] [varchar](15) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,	
	[GRID] [varchar](250) NULL
)

GO

BULK INSERT #Institution
FROM 'C:\icrp\database\DataUpload\NewInstitutions-NCI.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #Institution

IF EXISTS (SELECT * FROM #Institution t JOIN Institution i ON t.Name = i.Name AND t.City = i.City)
BEGIN
	PRINT 'Checking Duplicate Institutions   ==> ERROR'
	SELECT t.* FROM #Institution t JOIN Institution i ON t.Name = i.Name AND t.City = i.City
END
ELSE
	PRINT 'Checking Duplicate Institutions   ==> Pass'


BEGIN TRANSACTION

INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) SELECT * FROM #Institution

SELECT Name, City FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

--commit

rollback

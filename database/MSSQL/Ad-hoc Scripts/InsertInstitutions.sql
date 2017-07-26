--drop table #Institution
--GO
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
	[State] [varchar](50) NULL,
	[Country] [varchar](3) NULL,
	[Postal] [varchar](50) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,	
	[GRID] [varchar](250) NULL
)

GO

BULK INSERT #Institution
--FROM 'C:\icrp\database\DataUpload\ICRPDataSubmission_CAC2_Institutions.csv'
FROM 'C:\icrp\database\DataUpload\ICRPSubmission_CCRA_Institutions.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #Institution

SELECT i.* INTO #exist 
FROM #Institution t JOIN Institution i ON t.Name = i.Name AND t.City = i.City

IF EXISTS (SELECT * FROM #exist)
BEGIN
	PRINT 'Checking Duplicate Institutions   ==> ERROR'
	SELECT * FROM #exist
END
ELSE
	PRINT 'Checking Duplicate Institutions   ==> Pass'


BEGIN TRANSACTION
-- 177 institutions
INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] FROM #Institution i
LEFT JOIN #exist e ON i.Name = e.Name AND i.City = e.City
WHERE (e.Name IS NULL)

SELECT Name, City FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

--commit

rollback

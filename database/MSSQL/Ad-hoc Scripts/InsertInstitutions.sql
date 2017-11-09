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
	[Country] [varchar](50) NULL,
	[Postal] [varchar](50) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,	
	[GRID] [varchar](250) NULL
)

GO

BULK INSERT #Institution
FROM 'C:\icrp\database\DataImport\CurrentRelease\Institutions\NIHCollaboratorInstitutions.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select i.* from #Institution i
left join country c ON i.Country = c.Name
where c.Name is null

select * from country where name like '%Taiw%'



SELECT i.* INTO #exist 
FROM #Institution t JOIN Institution i ON t.Name = i.Name AND t.City = i.City

SELECT i.*, t.*
FROM #Institution t JOIN Institution i ON t.Name = i.Name AND t.City = i.City

Shenzen

Shenzhen

select * from #exist
select
IF EXISTS (SELECT * FROM #exist)
BEGIN
	PRINT 'Checking Existing Institutions   ==> ERROR'
	SELECT * FROM #exist
END
ELSE
	PRINT 'Checking Existing Institutions   ==> Pass'


BEGIN TRANSACTION
-- 177 institutions
INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] FROM #Institution i
LEFT JOIN #exist e ON i.Name = e.Name AND i.City = e.City
WHERE (e.Name IS NULL)

SELECT Name, City FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

SELECT m.* INTO #dup FROM 
	InstitutionMapping m
	join Institution i ON m.oldname=i.Name AND m.oldcity = i.city
	join Institution i2 ON m.newname=i2.Name AND m.newcity = i2.city

IF EXISTS (SELECT * FROM #dup)
BEGIN
	PRINT 'Checking Duplicate Institutions   ==> ERROR'
	SELECT * FROM #dup
END
ELSE
	PRINT 'Checking Duplicate Institutions   ==> Pass'

--commit

rollback


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



select * from #Institution
update #Institution set city ='Montréal' where city='Montreal'
update #Institution set city ='Québec' where city='Quebec'
update #Institution set city ='Zürich' where city='Zurich'
update #Institution set city ='Pierre-Bénite' where city='Pierre-Benite'
update #Institution set city ='Umeå' where city='Umea'


update tmp_LoadInstitutions set name = 'Francis Crick Institute' where name ='London Research Institute'
update tmp_LoadInstitutions set city  = 'Parkville' where name ='Ludwig Institute for Cancer Research' and city ='Melbourne'

-- Any Country not exist in lookup?
select i.* from #Institution i
left join country c ON i.Country = c.Abbreviation
where c.Name is null

select * from #Institution where ISNULL(Name, '') = '' OR ISNULL(City, '') = ''
select * from #Institution where ISNULL(latitude, 0) = 0 OR ISNULL(longitude, 0) = 0

-- duplicates (same city+name)
select i.* into #dup from #Institution i
join (SELECT Name, City FROM #Institution GROUP BY Name, City having count(*) > 1) u ON i.name=u.name AND i.CIty = u.City
order by i.Name, i.city

select * from #dup order by Name, city

-- duplicates (same coordinates)
--drop table #dupcoord
select distinct i.* into #dupcoord from #Institution i
JOIN (SELECT latitude, longitude  FROM #Institution GROUP BY latitude, longitude having count(*) > 1) d ON d.latitude = i.latitude AND d.longitude = i.longitude
WHERE i.name NOT IN (SELECT Name FROM #dup) 


select * from #dupcoord ORDER BY latitude, longitude  -- but it's okay if their cities are the same

--select * from #dupcoord ORDER BY latitude, longitude

-- already exist in lookup
--drop table #exist

DELETE #Institution WHERE Name = 'Institute of Molecular and Cell Biology'

SELECT i.Name AS icrpInstitution, i.City AS ICRPCity, i.latitude AS ICRPLat, i.Longitude AS ICRPLong, t.Name AS newInstitution, t.City AS NewCity,  t.latitude, t.Longitude INTO #exist 
FROM #Institution t 
JOIN Institution i ON t.Name = i.Name AND t.City = i.City

select * from #exist

-- "St Mary's Hospital" and "University of the West Indies" are okay, they are different sites
SELECT t.*, i.*
FROM #Institution t JOIN Institution i ON t.Name = i.Name 


IF EXISTS (SELECT * FROM #exist)
BEGIN
	PRINT 'Checking Existing Institutions   ==> ERROR'
	SELECT * FROM #exist
END
ELSE
	PRINT 'Checking Existing Institutions   ==> Pass'


SELECT Name, City, count(*) FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

BEGIN TRANSACTION

-- 1,199 institutions
INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] 
	FROM #Institution i
	LEFT JOIN #exist e ON i.Name = e.icrpInstitution AND i.City = e.ICRPCity
WHERE (e.icrpInstitution IS NULL)  

UPDATE Institution SET City = 'Singapore', GRID='grid.418812.6 ' WHERE Name = 'Institute of Molecular and Cell Biology'

SELECT Name, City, count(*) FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

SELECT m.* INTO #dup2 FROM 
	InstitutionMapping m
	join Institution i ON m.oldname=i.Name AND m.oldcity = i.city
	join Institution i2 ON m.newname=i2.Name AND m.newcity = i2.city

IF EXISTS (SELECT * FROM #dup2)
BEGIN
	PRINT 'Checking Duplicate Institutions   ==> ERROR'
	SELECT * FROM #dup
END
ELSE
	PRINT 'Checking Duplicate Institutions   ==> Pass'

--commit

rollback

--select * from Institution where name in ('IIT Research Institute', 'Louisiana State University Health Sciences Center New Orleans')

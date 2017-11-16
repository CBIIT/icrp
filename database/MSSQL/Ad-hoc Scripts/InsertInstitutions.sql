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
ORDER BY latitude, longitude

--select * from #dupcoord ORDER BY latitude, longitude

-- already exist in lookup
SELECT i.*  INTO #exist 
FROM #Institution t 
JOIN Institution i ON t.Name = i.Name AND t.City = i.City

select * from #exist

SELECT t.*
FROM #Institution t JOIN Institution i ON t.Name = i.Name 




IF EXISTS (SELECT * FROM #exist)
BEGIN
	PRINT 'Checking Existing Institutions   ==> ERROR'
	SELECT * FROM #exist
END
ELSE
	PRINT 'Checking Existing Institutions   ==> Pass'

BEGIN TRANSACTION
-- 1,237 institutions
INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] FROM #Institution i
LEFT JOIN #exist e ON i.Name = e.Name AND i.City = e.City
WHERE (e.Name IS NULL) 

UPDATE Institution SET City = 'Singapore', GRID='grid.418812.6 ' WHERE Name = 'Institute of Molecular and Cell Biology'

SELECT Name, City, count(*) FROM Institution GROUP BY Name, City HAVING COUNT(*) >1

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

--select * from Institution where name in ('IIT Research Institute', 'Louisiana State University Health Sciences Center New Orleans')


Name	City	(No column name)
Queen Elizabeth Central Hospital	Blantyre	2
Instituto Nacional de Cancerología	Bogota	2
Fundación Huesped	Buenos Aires	2
Centre National de Reference en Matière de VIH/SIDA	Bujumbura	2
IIT Research Institute	Chicago	2
University Hospital Cologne	Cologne	2
Kaohsiung Medical University	Kaohsiung City	2
Udaan Trust	Navi Mumbai	2
Louisiana State University Health Sciences Center New Orleans	New Orleans	2
Policlinica Augusto Amaral Peixoto	Rio de Janeiro 	2
Instituto Salvadoreño Del Seguro Social	San Salvador	2
Chang Gung Memorial Hospital	Taipei	2
National Taiwan University Hospital	Taipei	2
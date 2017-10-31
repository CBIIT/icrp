--drop table lu_CityCoordinates
--GO
----------------------------------------------------------------------------------
-- Insert City Ccordinates based on City Coordinates dataset downloaded from internet
---------------------------------------------------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE lu_CityCoordinates (	
	[Country] varchar(250) NULL,
	[City] varchar(250) NULL,		
	[CityAccent] varchar(250) NULL,	
	[Region] varchar(250) NULL,
	[Population] float NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL	
)

GO

INSERT INTO lu_CityCoordinates SELECT DISTINCT Country, CAST(Name AS VARCHAR(250)), CAST(AccentName AS VARCHAR(250)), Region, Population, Latitude, Longitude FROM icrp_data.dbo.lu_City_Global

UPDATE lu_CityCoordinates SET CityAccent='Montréal' WHERE Country = 'CA' AND CityAccent='montreal'
UPDATE lu_CityCoordinates SET CityAccent='Québec' WHERE Country = 'CA' AND CityAccent='Quebec'
UPDATE lu_CityCoordinates SET CityAccent='Zürich' WHERE Country = 'CH' AND CityAccent='Zurich'
UPDATE lu_CityCoordinates SET CityAccent='Münster' WHERE Country = 'DE' AND CityAccent='Munster'

-- truncate table lu_City_Test
INSERT INTO lu_City (Name, Country, State, Latitude, Longitude)   -- 847
SELECT DISTINCT l.[CityAccent], l.Country, i.State, l.Latitude, l.Longitude 
FROM (SELECT * FROM lu_CityCoordinates WHERE Country ='us') l
JOIN Institution i ON l.Country = i.Country AND l.[CityAccent] = i.City AND ISNULL(l.Region, '') = ISNULL(i.State, '')

INSERT INTO lu_City (Name, Country, State, Latitude, Longitude)   -- 317
SELECT DISTINCT l.[CityAccent], l.Country, i.State, l.Latitude, l.Longitude FROM
(SELECT Country, [CityAccent] FROM lu_CityCoordinates WHERE Country <> 'us' GROUP BY [CityAccent], Country Having count(*) = 1) u
JOIN lu_CityCoordinates l ON l.Country = u.Country AND l.[CityAccent] = u.[CityAccent]
JOIN Institution i ON u.Country = i.Country AND u.[CityAccent] = i.City

--select * from lu_City

--drop table #MissingCityCoordinates
--go


----------------------------------------------------------------------------------
-- Insert City Ccordinates based on Brian's FinfCityCoordinates Tool
---------------------------------------------------------------------------------
CREATE TABLE #MissingCityCoordinates (	
	[City] varchar(50) NULL,
	[State] varchar(50) NULL,
	[Country] varchar(2) NULL,
	[Latitude] [decimal](15, 7) NULL,
	[Longitude] [decimal](15, 7) NULL,
	[OrgCity] varchar(50) NULL,
	[OrgState] varchar(50) NULL,
	[OrgCountry] varchar(2) NULL
)

GO

BULK INSERT #MissingCityCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Coordinates\MissingCityCoordinatesFixed.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

BULK INSERT #MissingCityCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Coordinates\MissingCityCoordinates2Fixed.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #MissingCityCoordinates where country <> orgcountry

select i.Name, i.City, i.State, i.Country, 'Should state be ' + s.State + '?' AS CorrectedState from (select * from #MissingCityCoordinates where State <> OrgState and country = 'US') s
join institution i on s.orgcity = i.city and  s.orgstate = i.state 

SELECT COUNT(*) FROM lu_City
SELECT Name, State, Country FROM lu_City GROUP BY Name, State, Country Having Count(*) > 1

BEGIN TRANSACTION

INSERT INTO lu_City SELECT OrgCity, OrgCountry, OrgState, [Latitude], [Longitude] FROM #MissingCityCoordinates

COMMIT

-- test
SELECT i.Country, i.City, ISNULL(i.State, ''), i.Country, '' AS Latitude, '' AS Longitude 
FROM Institution i
LEFT JOIN lu_City l ON i.City = l.Name AND i.Country = l.Country AND ISNULL(i.State, '') = ISNULL(l.State, '')
WHERE l.name is null and i.city <> 'Missing'


	

--select DISTINCT i.Country, i.City, i.State, a.Region 
--from institution i
--LEFT JOIN lu_City_Test l ON i.Country = l.Country AND i.City = l.Name
--LEFT JOIN lu_CityCoordinates a ON a.Country = i.Country AND a.City = i.City
--WHERE l.Name is null and i.City <> 'Missing' and a.region is NOT null
--order by Country, i.City, i.State

--select * from lu_City_test
--select * from institution where City='Buenos Aires' and country='AR'
--select * from lu_City_test where Name='Buenos Aires' and country='AR'
--select * from lu_MajorCityCoordinates where [CityAccent]='Buenos Aires' and CountryCode2='AR'

--select distinct CountryCode2, [Region] from lu_MajorCityCoordinates
--select * from lu_MajorCityCoordinates where CityAccent='Springfield' and CountryCode2='US'
--select * from institution where City='Springfield' and Country='US'




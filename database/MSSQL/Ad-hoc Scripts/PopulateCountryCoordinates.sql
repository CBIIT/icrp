--SET NOCOUNT ON;  
--GO 

drop table #MissingCityCoordinates
go

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

BULK INSERT #MissingCityCoordinates2
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Coordinates\MissingCityCoordinatesFixed.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #MissingCityCoordinates where Country <> OrgCountry

SELECT COUNT(*) FROM lu_City
SELECT Name, State, Country FROM lu_City GROUP BY Name, State, Country Having Count(*) > 1

BEGIN TRANSACTION

INSERT INTO lu_City SELECT OrgCity, OrgCountry, OrgState, [Latitude], [Longitude] FROM #MissingCityCoordinates

COMMIT

-- test
SELECT i.Country, i.City, ISNULL(i.State, ''), i.Country, '' AS Latitude, '' AS Longitude FROM Institution i
LEFT JOIN lu_City l ON i.City = l.Name AND i.Country = l.Country AND ISNULL(i.State, '') = ISNULL(l.State, '')
WHERE l.name is null and i.city <> 'Missing'





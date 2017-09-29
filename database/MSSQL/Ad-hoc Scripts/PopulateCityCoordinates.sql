--drop table #CityCoordinates
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CityCoordinates (	
	[Country] varchar(2) NULL,
	[City] varchar(250) NULL,
	[CityAccent] varchar(250) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO


BULK INSERT #CityCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\CityCoordinates3.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

UPDATE #CityCoordinates SET Country='UK' WHERE Country='GB'
UPDATE #CityCoordinates SET Country='TW' WHERE City='Taipei'

INSERT INTO lu_City SELECT c.[CityAccent], c.Country, CAST(c.Latitude AS DECIMAL(9,6)), CAST(c.Longitude AS DECIMAL(9,6))	
	FROM (SELECT Country, City, CityAccent, MIN([Latitude]) AS [Latitude], MIN([Longitude]) AS [Longitude] FROM #CityCoordinates GROUP BY Country, City, CityAccent) c
	JOIN (SELECT DISTINCT Country, CIty FROM Institution) i ON c.country = i.country AND (c.City = i.city OR c.[CityAccent] = i.city)


--select * from #CityCoordinates c -- where country='uk'
----join (SELECT DISTINCT Country, City FROM institution WHERE ISNULL(Country, '') <> '') i ON c.country = i.country AND (c.City = i.city OR c.[CityAccent] = i.city)  -- 1286 city (only 305 populate)
--RIGHT join (SELECT DISTINCT Country, City FROM institution WHERE ISNULL(Country, '') <> '') i ON c.country = i.country AND (c.City = i.city OR c.[CityAccent] = i.city)-- 1286 city
--where c.Country is null

--select name, country  from lu_city group by name, country
--select * from lu_city where name ='Philadelphia'
--select * from lu_City where country ='ca'
--select * from #CityCoordinates where city = 'Taipei'
--select * from #CityCoordinates where city like '%Akron%'
--select * from institution where city = 'Akron'

--select * from #CityCoordinates where country = 'us'
--select * from lu_City -- where [Longitude] is null

--drop table #CountryCoordinates
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CountryCoordinates (	
	[Country] varchar(2) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO

BULK INSERT #CountryCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Country\CountryCoordinates.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

select * from #CountryCoordinates -- where country='uk'

UPDATE Country SET [Latitude] = cc.[Latitude], [Longitude]= cc.[Longitude]
FROM Country c
JOIN #CountryCoordinates cc ON cc.Country = c.Abbreviation

-- testing
select 'Check Missing Country Coord.' AS Issue, * FROM (select distinct country from Institution) i
JOIN Country c ON i.Country = c.Abbreviation
WHERE c.Latitude is null or c.Longitude is null


--select * from #CountryCoordinates where country = 'us'
--select * from country where [Longitude] is null
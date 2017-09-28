--drop table #Region
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Region (	
	[Country] [varchar](25) NOT NULL,
	[Region] [varchar](100) NOT NULL
)

GO

BULK INSERT #Region
FROM 'C:\ICRP\database\DataImport\CountryRegionMappings.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

select distinct Country, Region from #Region

UPDATE Country SET RegionID = l.RegionID
FROM #Region r
JOIN lu_Region l ON r.Region = l.Name
JOIN Country c ON r.Country = c.Abbreviation

--select * from country where regionID is null


--select RegionID, count(*) from country group by RegionID
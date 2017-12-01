--drop table #CountryMapLayer
--GO
-----------------------------------------
-- Insert CountryMapLayer
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CountryMapLayer (	
	[CountryID] [int] NOT NULL,
	[Abbreviation] [varchar](3) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[IncomeBand] [varchar](15) NOT NULL,
	[Currency] [varchar](15) NOT NULL,
	[Region] [varchar](100) NOT NULL,
	[Incidence] [varchar](100) NOT NULL,
	[Mortality] [varchar](100) NOT NULL,
	[Prevalence] [varchar](100) NOT NULL
)

GO

BULK INSERT #CountryMapLayer
FROM 'C:\icrp\database\DataImport\CurrentRelease\MapLayer\CountryLayerMappings.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

--select * from #CountryMapLayer where [Abbreviation] in ('IR')
--select * from country
--select * from CountryMapLayer
--truncate table CountryMapLayer

INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
	SELECT 1, 999, c.[Abbreviation], [Incidence]
FROM #CountryMapLayer l
JOIN Country c ON c.[Abbreviation] = l.[Abbreviation]

INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
	SELECT 2, 999, c.[Abbreviation], [Mortality]
FROM #CountryMapLayer l
JOIN Country c ON c.[Abbreviation] = l.[Abbreviation]

INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
	SELECT 3, 999, c.[Abbreviation], [Prevalence]
FROM #CountryMapLayer l
JOIN Country c ON c.[Abbreviation] = l.[Abbreviation]

INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
	SELECT 4, 999, c.[Abbreviation], l.[IncomeBand]
FROM #CountryMapLayer l
JOIN Country c ON c.[Abbreviation] = l.[Abbreviation]

UPDATE CountryMapLayer SET VALUE = NULL WHERE Value = 'NULL' OR Value = ''

-- Layer Cancer Incidence
UPDATE CountryMapLayer SET MapLayerLegendID = 
(CASE  
  WHEN  CAST([Value] AS decimal(9,1)) > 244.2 THEN 1
  WHEN  (CAST([Value] AS decimal(9,1)) > 174.3) AND (CAST([Value] AS decimal(9,1)) <= 244.2) THEN 2
  WHEN  (CAST([Value] AS decimal(9,1)) > 137.6 ) AND (CAST([Value] AS decimal(9,1)) <= 174.3) THEN 3  
  WHEN  (CAST([Value] AS decimal(9,1)) > 101.6) AND (CAST([Value] AS decimal(9,1)) <= 137.6) THEN 4
  WHEN  (CAST([Value] AS decimal(9,1)) > 0) AND (CAST([Value] AS decimal(9,1)) <= 101.6) THEN 5  
  ELSE 6
END)
FROM CountryMapLayer
WHERE MapLayerID=1

-- Layer Cancer Mortality
UPDATE CountryMapLayer SET MapLayerLegendID = 
(CASE  
  WHEN  CAST([Value] AS decimal(9,1)) > 117.0 THEN 11
  WHEN  (CAST([Value] AS decimal(9,1)) > 99.9) AND (CAST([Value] AS decimal(9,1)) <= 117.0) THEN 12  -- 99.9-117.0
  WHEN  (CAST([Value] AS decimal(9,1)) > 89.8 ) AND (CAST([Value] AS decimal(9,1)) <= 99.9) THEN 13    -- 89.8-99.9
  WHEN  (CAST([Value] AS decimal(9,1)) > 74.0) AND (CAST([Value] AS decimal(9,1)) <= 89.8) THEN 14 --74.0-89.8
  WHEN  (CAST([Value] AS decimal(9,1)) > 0) AND (CAST([Value] AS decimal(9,1)) <= 74.0) THEN 15    -- < 74.0  
  ELSE 16
END)
FROM CountryMapLayer
WHERE MapLayerID=2

-- Layer Cancer Prevalence
UPDATE CountryMapLayer SET MapLayerLegendID = 
(CASE   
  WHEN  CAST([Value] AS decimal(9,1)) > 328.7 THEN 21  -- > 328.7
  WHEN  (CAST([Value] AS decimal(9,1)) > 139.6) AND (CAST([Value] AS decimal(9,1)) <= 328.7) THEN 22  -- 139.6-328.7
  WHEN  (CAST([Value] AS decimal(9,1)) > 85.7 ) AND (CAST([Value] AS decimal(9,1)) <= 139.6) THEN 23   -- 85.7-139.6
  WHEN  (CAST([Value] AS decimal(9,1)) > 62.6) AND (CAST([Value] AS decimal(9,1)) <= 85.7) THEN 24 --62.6-85.7
  WHEN  (CAST([Value] AS decimal(9,1)) > 0) AND (CAST([Value] AS decimal(9,1)) <= 62.6) THEN 25  -- < 62.6  
  ELSE 26
END)
FROM CountryMapLayer
WHERE MapLayerID=3

-- Layer World Bank Income Bands
UPDATE CountryMapLayer SET MapLayerLegendID = 
(CASE   
  WHEN  ([Value] = 'H') THEN 31
  WHEN  ([Value] = 'MU') THEN 32
  WHEN  ([Value] = 'ML') THEN 33
  WHEN  ([Value] = 'L') THEN 34
  ELSE 35
END)
FROM CountryMapLayer
WHERE MapLayerID=4

--select * from CountryMapLayer

--select * from lu_maplayer


/****** Script for SelectTopNRows command from SSMS  ******/
-- SELECT *  FROM [icrp_data_dev].[dbo].[lu_MapLayerLegend] where maplayerid = 4
--select * from CountryMapLayer where maplayerid = 4
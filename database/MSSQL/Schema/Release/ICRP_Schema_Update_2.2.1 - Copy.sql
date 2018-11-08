/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_MapLayer]') AND name = 'Year')
	ALTER TABLE lu_MapLayer ADD Year int NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_MapLayerLegend]') AND name = 'Year')
	ALTER TABLE lu_MapLayerLegend ADD Year int NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CountryMapLayer]') AND name = 'Year')
	ALTER TABLE CountryMapLayer ADD Year int NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CountryMapLayer]') AND name = 'CreatedDate')
	ALTER TABLE CountryMapLayer ADD CreatedDate DateTime NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CountryMapLayer]') AND name = 'UpdatedDate')
	ALTER TABLE CountryMapLayer ADD UpdatedDate DateTime NULL
GO

/*************************************************/
/******					Data				******/
/*************************************************/
UPDATE lu_MapLayer SET Year = 2012 WHERE Name IN ('Cancer Incidence', 'Cancer Mortality') OR ParentMapLayerID IN (1,2) 

--select * from lu_MapLayerLegend

---------------------------------------------------------------------
-- Legends
---------------------------------------------------------------------
-- parent layer
UPDATE lu_MapLayerLegend SET Year = 2012
FROM lu_MapLayerLegend l
	JOIN lu_MapLayer m ON l.MapLayerID = m.ParentMapLayerID
	JOIN lu_MapLayer p ON m.ParentMapLayerID = p.MapLayerID 
WHERE p.Name IN ('Cancer Incidence', 'Cancer Mortality')

-- children layer
UPDATE lu_MapLayerLegend SET Year = 2012
FROM lu_MapLayerLegend l
	JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID 
	JOIN lu_MapLayer p ON m.ParentMapLayerID = p.MapLayerID 
WHERE p.Name IN ('Cancer Incidence', 'Cancer Mortality') 

---------------------------------------------------------------------
-- Country Data
---------------------------------------------------------------------
UPDATE CountryMapLayer SET CreatedDate = '2017-12-20 17:16:05.010' WHERE MapLayerID <= 4
UPDATE CountryMapLayer SET UpdatedDate = '2017-12-20 17:16:05.010' WHERE MapLayerID <= 4

UPDATE CountryMapLayer SET CreatedDate = '2018-05-08 21:24:34.677' WHERE MapLayerID > 4
UPDATE CountryMapLayer SET UpdatedDate = '2018-05-08 21:24:34.677' WHERE MapLayerID > 4

--UPDATE CountryMapLayer SET Year = NULL
-- parent layer
UPDATE CountryMapLayer SET Year = 2012
FROM CountryMapLayer l
	JOIN lu_MapLayer m ON l.MapLayerID = m.ParentMapLayerID
	JOIN lu_MapLayer p ON m.ParentMapLayerID = p.MapLayerID 
WHERE p.Name IN ('Cancer Incidence', 'Cancer Mortality')

-- children layer
UPDATE CountryMapLayer SET Year = 2012
FROM CountryMapLayer l
	JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID 
	JOIN lu_MapLayer p ON m.ParentMapLayerID = p.MapLayerID 
WHERE p.Name IN ('Cancer Incidence', 'Cancer Mortality') 

--select * from lu_MapLayer 
select * from CountryMapLayer order by MapLayerID
	
/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/


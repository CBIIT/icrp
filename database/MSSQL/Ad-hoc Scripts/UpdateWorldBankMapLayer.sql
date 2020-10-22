/********************************************************************************/
/*																				*/
/* Buck load World Bank MapLayer 									 		    */
/*																				*/
/********************************************************************************/
-- drop table #WorldBankMapLayer

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #WorldBankMapLayer (
    [CountryName] [varchar](100) NULL,
	[CountryCode3] [varchar](100) NULL,
	[IncomeBand] [varchar](100) NULL	
)

GO

BULK INSERT #WorldBankMapLayer
FROM 'C:\ICRP\database\DataImport\MapLayers\2020 WorldBank\WorldBankDataFY2020.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

DROP Table #CountryCodeMapping
GO 

CREATE TABLE #CountryCodeMapping (
    [CountryName] [varchar](100) NULL,
    [CountryCode2] [varchar](50) NULL,
	[CountryCode3] [varchar](50) NULL
)

GO

BULK INSERT #CountryCodeMapping
FROM 'C:\ICRP\database\DataImport\MapLayers\2020 WorldBank\CountryCodeMappings.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

select * from #CountryCodeMapping

/********************************************************************************/
/*																				*/
/* Update World Bank Data Source 												*/
/*																				*/
/********************************************************************************/
-----------------------------------------
-- Update Parent MapLayer - lookup
----------------------------------------
-- select * from lu_MapLayer
DECLARE @Summary VARCHAR(255) = 'This layer displays the 2018 World Bank country classifications by income level, based on gross national income per capita for 2017'
DECLARE @Description VARCHAR(255) = 'This layer displays the 2018 World Bank country classifications by income level, based on gross national income per capita for 2017'
DECLARE @DataSource VARCHAR(255) = 'World Bank Income Bands'

begin transaction

UPDATE lu_MapLayer SET Summary=@Summary, Description=@Description, DataSource=@DataSource, UpdatedDate=getdate()
WHERE MapLayerID = 4

select 'lu_MapLayer', * from lu_MapLayer WHERE MapLayerID = 4
commit
--rollback

-----------------------------------------
-- World Bank MapLayer Legend
----------------------------------------
select 'lu_MapLayerLegend', * from lu_MapLayerLegend where MapLayerID=4 

-----------------------------------------
-- Update World Bank MapLayer - Country data
----------------------------------------
-- Save current Map Layer
SELECT  * into #tmp FROM CountryMapLayer WHERE MapLayerID = 4
select * from #tmp

begin transaction
UPDATE CountryMapLayer SET 
    MapLayerLegendID = 
        CASE wb.IncomeBand
			WHEN 'High income' THEN 31
			WHEN 'Upper middle income' THEN 32
			WHEN 'Lower middle income' THEN 33
			WHEN 'Low income' THEN 34
        END,
    Value = 
	    CASE wb.IncomeBand 
			WHEN 'High income' THEN 'H'
			WHEN 'Upper middle income' THEN 'MU'
			WHEN 'Lower middle income' THEN 'ML'
			WHEN 'Low income' THEN 'L'
        END,
    UpdatedDate = getdate()
FROM CountryMapLayer cm 
JOIN (SELECT c.CountryCode2, w.IncomeBand FROM #WorldBankMapLayer w 
        JOIN #CountryCodeMapping c ON w.CountryCode3 = c.CountryCode3) wb ON wb.CountryCode2 = cm.Country
WHERE cm.MapLayerID = 4  -- World Bank Map

SELECT  * FROM CountryMapLayer WHERE MapLayerID = 4

-- Show changes
SELECT m.CountryName, cm.Country, t.Value AS OldBand, cm.Value AS NewBand FROM #tmp t
join CountryMapLayer cm on t.Country = cm.Country
join #CountryCodeMapping m ON cm.Country = m.CountryCode2
where t.Value != cm.Value and cm.MapLayerID = 4

commit
--rollback





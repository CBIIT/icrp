drop table #CountryMapLayer
GO
drop table #MapLayerLegend
GO

CREATE TABLE #MapLayerLegend (	
	[displayorder] [int] NULL,
	[layerFullName] [varchar](100) NULL,
	[layerName] [varchar](100) NULL,
	[ParentName] [varchar](250) NULL,
	[legendcolor] [varchar](10) NULL,
	[Summary] [varchar](1000) NULL,
	[Description] [varchar](1000) NULL,
	[Min] [varchar](100) NULL,
	[Max] [varchar](100) NULL,
	[DataSource] [varchar](1000) NULL
)

GO

BULK INSERT #MapLayerLegend
FROM 'C:\icrp\database\DataImport\MapLayers\2018 Globocan Layers-legendColors.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from lu_MapLayer

select * from #MapLayerLegend

update #MapLayerLegend set Min = replace(Min, '<', '<= ')
update #MapLayerLegend set Max = replace(Max, '>=', '> ')
----------------------------------------------------------
-- Data Check
----------------------------------------------------------
-- data check - parent name
IF EXISTS (select * from #MapLayerLegend m
			LEFT join lu_MapLayer l on m.ParentName = l.Name
			WHERE m.ParentName IS NULL)
	PRINT 'Parent Name Not Found'
ELSE
	PRINT 'Pass'	

-- data check - Unique Data Source 
DECLARE @layerCount int
DECLARE @ImportlayerCount int

SELECT @layerCount=COUNT(*) FROM lu_MapLayer where ParentMapLayerID <> 0
PRINT @layerCount

select @ImportlayerCount = COUNT(*) FROM (SELECT distinct layername, summary, description, datasource from #MapLayerLegend) i
PRINT @ImportlayerCount

IF @layerCount <> @ImportlayerCount
	PRINT 'Unique DataSource Error'
ELSE
	PRINT 'Pass'

-- data check - full layer name
update #MapLayerLegend set layerfullname = REPLACE(layerfullname, ' - ', ' ')

--select layerFullName from #MapLayerLegend

IF EXISTS (select layerfullname,* from #MapLayerLegend i
	left join lu_MapLayer m on i.layerFullName = m.DisplayedName
	where m.DisplayedName is null)

	PRINT 'Incorrect LayerFullName'
ELSE
	PRINT 'Pass'
	

	--select * from lu_MapLayer order by MapLayerID desc
-----------------------------------------------------------------------------------------
--***** Recreate Lu_MapLayer with Identity
-----------------------------------------------------------------------------------------
CREATE TABLE [dbo].[lu_MapLayer2](
	[MapLayerID] [int] IDENTITY(1,1) NOT NULL,
	[ParentMapLayerID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Summary] [varchar](500) NULL,
	[Description] [varchar](500) NULL,
	[DataSource] [varchar](500) NULL,
	[DisplayedName] [varchar](50) NULL,
	[Year] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL	
 CONSTRAINT [PK_Lu_MapLayer] PRIMARY KEY CLUSTERED 
(
	[MapLayerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [lu_MapLayer2] ON; 

INSERT INTO [lu_MapLayer2] ([MapLayerID],[ParentMapLayerID],[Name],[Summary],[Description],[DataSource],[DisplayedName],[Year],[CreatedDate],[UpdatedDate])
	SELECT [MapLayerID],[ParentMapLayerID],[Name],[Summary],[Description],[DataSource],[DisplayedName],[Year],[CreatedDate],[UpdatedDate] FROM lu_MapLayer

SET IDENTITY_INSERT [lu_MapLayer2] OFF; 

Drop Table [lu_MapLayer]
GO 

EXEC sp_rename 'dbo.lu_MapLayer2', 'lu_MapLayer';  
-----------------------------------------------------------------------------------------
--***** Insert MapLayer DataSource/Summary/Description
-----------------------------------------------------------------------------------------
--select * from lu_maplayer  where year = 2018
--delete lu_maplayer where year = 2018
--DBCC CHECKIDENT ('[lu_MapLayer]', RESEED, 24)

begin transaction
-- parent legends
INSERT INTO lu_MapLayer ([ParentMapLayerID], [Name], [Summary],	[Description], [DataSource], [CreatedDate], [UpdatedDate], [DisplayedName], [Year])
SELECT DISTINCT 0, Name, Summary, [Description], DataSource, getdate(), getdate(), [DisplayedName], 2018
	FROM lu_MapLayer WHERE ParentMapLayerID = 0 AND Name IN ('Cancer Incidence','Cancer Mortality')


INSERT INTO lu_MapLayer ([ParentMapLayerID], [Name], [Summary],	[Description], [DataSource], [CreatedDate], [UpdatedDate], [DisplayedName], [Year])
SELECT DISTINCT p.MapLayerID AS ParentLayerID, i.LayerName, i.Summary, i.[Description], i.DataSource, getdate(), getdate(), i.layerFullName, 2018
FROM (SELECT MapLayerID, Name FROM lu_MapLayer WHERE ParentMapLayerID = 0 AND [Year]=2018) p
	JOIN #MapLayerLegend i ON p.Name = i.ParentName

commit
--rollback

UPDATE lu_maplayer SET Year = NULL WHERE Name IN ('Cancer Prevalence','World Bank Income Bands')
UPDATE lu_maplayer SET Summary = REPLACE(Summary, '2012', '2018'),  Description = REPLACE(Description, '2012', '2018'),  DataSource = REPLACE(DataSource, '2012', '2018') 
	WHERE Name IN ('Cancer Incidence', 'Cancer Mortality') AND Year = 2018

--	select * from [lu_MapLayer] where parentmaplayerid =0
	
--UPDATE [lu_MapLayer] SET Year = 2012 WHERE MapLayerID IN (25,26)
--UPDATE [lu_MapLayer] SET Year = 2018 WHERE MapLayerID IN (1,2)

--UPDATE lu_maplayer SET Summary = REPLACE(Summary, '2012', '2018'),  Description = REPLACE(Description, '2012', '2018'),  DataSource = REPLACE(DataSource, '2012', '2018') 
--	WHERE MapLayerID IN (1,2)

--UPDATE lu_maplayer SET Summary = REPLACE(Summary, '2018', '2012'),  Description = REPLACE(Description, '2018', '2012'),  DataSource = REPLACE(DataSource, '2018', '2012') 
--WHERE MapLayerID IN (25,26)

-----------------------------------------------------------------------------------------
--***** Insert MapLayer Legend Description
-----------------------------------------------------------------------------------------
select * from lu_MapLayer
select * from lu_MapLayerLegend 
select * from #MapLayerLegend

BEGIN TRANSACTION
INSERT lu_MapLayerLegend ([MapLayerID], [LegendName], [LegendColor],[DisplayOrder], [Year])
SELECT m.MapLayerID, LegendName =
	CASE
		WHEN l.Min IS NULL THEN l.Max
		WHEN l.Max IS NULL THEN l.Min
		ELSE CONCAT(l.min, ' - ', l.Max)
	END,
	l.legendcolor, l.displayorder, 2018
--SELECT *
FROM #MapLayerLegend l
	JOIN (SELECT * FROM lu_MapLayer WHERE Year=2018) m ON l.layerFullName = m.DisplayedName

COMMIT
--ROLLBACK

--UPDATE lu_MapLayerLegend SET LegendName =
--	CASE
--		WHEN i.Min IS NULL THEN i.Max
--		WHEN i.Max IS NULL THEN i.Min
--		ELSE CONCAT(i.min, ' - ', i.Max)
--	END
--FROM lu_MapLayerLegend l
--	JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID
--	JOIN lu_MapLayer p ON p.MapLayerID = m.ParentMapLayerID
--	JOIN #MapLayerLegend i ON m.Name = i.layerName AND p.Name = i.ParentName AND l.DisplayOrder = i.displayorder

-----------------------------------------------------------------------------------------
--***** Update CountryMapLayer data
-----------------------------------------------------------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'
--delete CountryMapLayer where Maplayerid > 4
-- DROP Table #CountryMapLayer
-- DROP Table #tmpLegend
--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CountryMapLayer (	
	[Country] [varchar](3) NULL,
	[Breast Cancer Incidence] [varchar](100) NULL,
	[Breast Cancer Mortality] [varchar](15) NULL,
	[Cervical Cancer Incidence] [varchar](15) NULL,
	[Cervical Cancer Mortality] [varchar](100) NULL,
	[Colorectal Cancer Incidence] [varchar](100) NULL,
	[Colorectal Cancer Mortality] [varchar](100) NULL,
	[Liver Cancer Incidence] [varchar](100) NULL,
	[Liver Cancer Mortality] [varchar](100) NULL,
	[Lung Cancer Incidence] [varchar](100) NULL,
	[Lung Cancer Mortality] [varchar](100) NULL,	
	[Esophageal Cancer Incidence] [varchar](100) NULL,
	[Esophageal Cancer Mortality] [varchar](100) NULL,
	[Prostate Cancer Incidence] [varchar](100) NULL,
	[Prostate Cancer Mortality] [varchar](100) NULL,
	[Stomach Cancer Incidence] [varchar](100) NULL,
	[Stomach Cancer Mortality] [varchar](100) NULL,
	[Bladder Cancer Incidence] [varchar](100) NULL,
	[Bladder Cancer Mortality] [varchar](100) NULL,
	[Non-Hodgkin Lymphoma Incidence] [varchar](100) NULL,
	[Non-Hodgkin Lymphoma Mortality] [varchar](100) NULL
)

GO

BULK INSERT #CountryMapLayer
FROM 'C:\icrp\database\DataImport\MapLayers\2018 Globocan Layers-Country.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

--select top 5 * from #MapLayerLegend
select   * from #CountryMapLayer
--select  top 5 * from #tmpLegend
select * from CountryMapLayer where  year is null
select * from lu_maplayer

update #CountryMapLayer set country = LTRIM(RTRIM(Country))

-----------------------------------------
-- Temp LegendName
----------------------------------------
select distinct  m.displayorder, l.DisplayedName, l.maplayerid, m.ParentName, l.Name, CONCAT(ISNULL(m.min, ''), ' - ', ISNULL(m.max, '')) AS legend into #tmpLegend 
from #MapLayerLegend m
	join lu_maplayer l ON m.layerFullName = l.DisplayedName

select * from #tmpLegend

update #tmpLegend set legend = replace(legend, ' - >', '>')
update #tmpLegend set legend = replace(legend, ' - ', '') WHERE RIGHT(legend, 3) = ' - '

select ParentName, Name as LayerName, displayorder, legend from #tmpLegend order by ParentName, Name, displayorder

-----------------------------------------
-- Update CountryMapLayer
----------------------------------------
select top 5 * from CountryMapLayer
select top 5 * from #CountryMapLayer

DECLARE @LayerFullname VARCHAR (50)
DECLARE @MapLayerID INT
DECLARE @cursor as CURSOR;
DECLARE @sql VARCHAR (2000)

DECLARE @legendcursor as CURSOR
DECLARE @legendsql VARCHAR (2000)
DECLARE @legendid INT
DECLARE @min VARCHAR (2000)
DECLARE @max VARCHAR (2000)

begin transaction

SET @cursor = CURSOR FOR

SELECT  DISTINCT layerfullname FROM #MapLayerLegend;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @LayerFullname;

WHILE @@FETCH_STATUS = 0
BEGIN 
	-- Get MapLayer ID
	SELECT DISTINCT @MapLayerID = m.MapLayerID
	from  #MapLayerLegend l
	join lu_maplayer m on l.layerFullName = m.DisplayedName
	WHERE l.layerfullname = @LayerFullname -- 'Bladder Cancer Incidence'

	print @LayerFullname
	print @MapLayerID

	/***** Get legendID Sql   ***/
	SET @legendsql = 'CASE '

	SET @legendcursor = CURSOR FOR 
	SELECT l.MapLayerLegendID, m.min, m.max 
		FROM #MapLayerLegend m
			JOIN #tmpLegend tl ON m.ParentName = tl.ParentName AND m.layerName = tl.Name AND m.displayorder = tl.displayorder
			JOIN lu_MapLayerLegend l ON tl.MapLayerID = l.MapLayerID AND tl.displayorder = l.DisplayOrder
		WHERE m.layerFullName = @LayerFullname

	OPEN @legendcursor;
	FETCH NEXT FROM @legendcursor INTO @legendid, @min, @max;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
	Print 'legend => legendID=' + CAST(@legendid AS Varchar(100)) + ' / min=' + @min + ' / max=' + @max
		IF @min IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST(t.[' + @LayerFullName + '] AS decimal(9,1))' + @max + ' THEN ' + CAST(@legendid AS VARCHAR(10))

		IF @max IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST(t.[' + @LayerFullName + '] AS decimal(9,1))' + @min + ' THEN ' + CAST(@legendid AS VARCHAR(10))
	
		IF @min IS NOT NULL AND @max IS NOT NULL 
			SET @legendsql = @legendsql + '  WHEN  (CAST(t.[' + @LayerFullName + '] AS decimal(9,1)) > ' + @min +  ') AND (CAST(t.[' + @LayerFullName + '] AS decimal(9,1)) <= ' + @max + ') THEN ' + CAST(@legendid AS VARCHAR(10)) 				  
		
	 FETCH NEXT FROM @legendcursor INTO  @legendid, @min, @max;

	END
 
	CLOSE @legendcursor;
	DEALLOCATE @legendcursor;

	SET @sql = 'INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value], Year, CreatedDate, UpdatedDate) 
		SELECT ' + CAST(@MapLayerID AS varchar(10)) + ', ' + @legendsql + ' ELSE 6 END, c.[Abbreviation], ' + 't.[' + @LayerFullname + 
		'], 2018, getdate(), getdate() FROM #CountryMapLayer t
		JOIN Country c ON c.[Abbreviation] = t.[Country]'

	--SET @sql = 'UPDATE CountryMapLayer SET MapLayerLegendID = ' +
	--	@legendsql + ' END 
	--	FROM CountryMapLayer cm
	--		JOIN #CountryMapLayer t ON cm.Country = t.Country
	--	WHERE cm.MapLayerID = @MapLayerID'

	PRINT '---------------@sql---------------'
	PRINT (@sql)
	PRINT '------------------------------'
	exec (@sql)

	IF @@ROWCOUNT = 0
		PRINT '===> ERROR - No such layerFullName'

 FETCH NEXT FROM @cursor INTO  @LayerFullname;

END
 
CLOSE @cursor;
DEALLOCATE @cursor;

commit
--rollback

select * from CountryMapLayer where year=2018

select * from #CountryMapLayer where [Non-Hodgkin lymphoma Incidence] is null
INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value], Year) 
		SELECT 34, 
		CASE   
		WHEN  CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1))<= 3.6 THEN 123  
		WHEN  CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1))<= 3.6 THEN 226  
		WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 3.6) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 5) THEN 103  
		WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 3.6) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 5) THEN 227  
		WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 5) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 6.7) THEN 83 
		 WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 5) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 6.7) THEN 228  
		 WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 6.7) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 9.8) THEN 63 
		  WHEN  (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) > 6.7) AND (CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1)) <= 9.8) THEN 229 
		   WHEN  CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1))>  9.8 THEN 43  WHEN  CAST(t.[Non-Hodgkin lymphoma Incidence] AS decimal(9,1))>  9.8 THEN 230 
		   ELSE 6 
		   END, c.[Abbreviation], t.[Non-Hodgkin lymphoma Incidence], 2018 
		   FROM #CountryMapLayer t
		JOIN Country c ON c.[Abbreviation] = t.[Country]
------------------------------
Msg 207, Level 16, State 1, Line 249
Invalid column name 'Non-Hodgkin lymphoma Incidence'.


/****** Set legend color  ******/
update lu_MapLayerLegend set LegendColor = '#0DDCFF' where DisplayOrder=5 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#0BC2E0' where DisplayOrder=4 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#0994AB' where DisplayOrder=3 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#066C7D' where DisplayOrder=2 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#03353D' where DisplayOrder=1 and  MapLayerID>4

select * from lu_MapLayer

select  m.MapLayerID, 
	CASE 
	WHEN m.ParentMapLayerID = 0 THEN m.Name 
	WHEN m.ParentMapLayerID = 1 THEN CONCAT (m.Name, ' ', 'Incidence') 
	WHEN m.ParentMapLayerID = 2 THEN CONCAT (m.Name, ' ', 'Mortality') 
	END AS DisplayedName
INTO #displayedname
FROM lu_MapLayer m
LEFT JOIN lu_MapLayer p ON m.ParentMapLayerID = p.MapLayerID


UPDATE lu_MapLayer set DisplayedName = t.DisplayedName
FROM lu_MapLayer m
JOIN #displayedname t ON m.MapLayerID = t.MapLayerID


update lu_MapLayer set DisplayedName = CONCAT ('All ', Name) Where MapLayerID < 4





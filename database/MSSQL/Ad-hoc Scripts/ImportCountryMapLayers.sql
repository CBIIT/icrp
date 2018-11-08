/********************************************************************************/
/*																				*/
/* Archive old dataset and create new tables									*/
/*																				*/
/********************************************************************************/
-----------------------------------------
-- Archive these old tables
--    lu_MapLayer  -> Archive-lu_MapLayer-2012
--    lu_MapLayerLegend
--    CountryMapLayer
----------------------------------------
-- rename keys
-----------------------------------------
-- Recreate 3 maplayer tables
----------------------------------------
DROP Table [lu_MapLayer]
GO
DROP Table [lu_MapLayerLegend]
GO
DROP Table [CountryMapLayer]
GO

CREATE TABLE [dbo].[lu_MapLayer](
	[MapLayerID] [int] NOT NULL,
	[ParentMapLayerID] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Summary] [varchar](500) NULL,
	[Description] [varchar](500) NULL,
	[DataSource] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[DisplayedName] [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[lu_MapLayer] ADD  CONSTRAINT [DF_lu_MayLayer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[lu_MapLayer] ADD  CONSTRAINT [DF_lu_MayLayer_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

CREATE TABLE [dbo].[lu_MapLayerLegend](
	[MapLayerLegendID] [int] IDENTITY(1,1) NOT NULL,
	[MapLayerID] [int] NOT NULL,
	[LegendName] [varchar](150) NULL,
	[LegendColor] [varchar](7) NULL,
	[DisplayOrder] [int] NOT NULL,
 CONSTRAINT [PK_lu_MapLayerLegend] PRIMARY KEY CLUSTERED 
(
	[MapLayerLegendID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CountryMapLayer](
	[MapLayerID] [int] NOT NULL,
	[MapLayerLegendID] [int] NOT NULL,
	[Country] [varchar](3) NOT NULL,
	[Value] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]
GO

/********************************************************************************/
/*																				*/
/* Copy base layers	Data     													*/
/*																				*/
/********************************************************************************/
--truncate table lu_MapLayer
--truncate table lu_MapLayerLegend
--truncate table CountryMapLayer
--------------------------------------------------------------------------------
-- Copy Parent layers from the old tables to new tables
-------------------------------------------------------------------------------

BEGIN TRANSACTION

INSERT INTO Lu_MapLayer SELECT * FROM [Archive-lu_MapLayer-2012] WHERE ParentMapLayerID = 0

SET IDENTITY_INSERT [Lu_MapLayerLegend] ON; 
INSERT INTO Lu_MapLayerLegend ([MapLayerLegendID],[MapLayerID],[LegendName],[LegendColor],[DisplayOrder]) SELECT * FROM [Archive-lu_MapLayerLegend-2012] WHERE MapLayerID < 5  -- Insert "No Data" and parent layers
SET IDENTITY_INSERT [Lu_MapLayerLegend] OFF; 

INSERT INTO CountryMapLayer SELECT *, getdate(), getdate() FROM [Archive-CountryMapLayer-2012] WHERE MapLayerID <= 4

UPDATE CountryMapLayer SET CreatedDate = '2017-12-20 17:16:05.010' 
UPDATE CountryMapLayer SET UpdatedDate = '2017-12-20 17:16:05.010' 

COMMIT
--ROLLBACK

select * from Lu_MapLayer
select * from [Lu_MapLayerLegend]
select * from CountryMapLayer order by maplayerid




/********************************************************************************/
/*																				*/
/* Buck load MapLayer data sources									 		    */
/*																				*/
/********************************************************************************/
--drop table #MapLayerLegend
--GO

CREATE TABLE #MapLayerLegend (	
	[displayorder] [int] NULL,
	[layerFullName] [varchar](100) NULL,
	[layerName] [varchar](100) NULL,
	[ParentName] [varchar](250) NULL,	
	[Summary] [varchar](1000) NULL,
	[Description] [varchar](1000) NULL,
	[Min] [varchar](100) NULL,
	[Max] [varchar](100) NULL,
	[DataSource] [varchar](1000) NULL
)

GO

BULK INSERT #MapLayerLegend
FROM 'C:\ICRP\database\DataImport\MapLayers\2018UpdatedBaseMapLayers-lookup.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- data check - parent name
IF EXISTS 
	(select * from #MapLayerLegend m
		LEFT join lu_MapLayer l on m.ParentName = l.Name
		WHERE m.ParentName IS NULL)
	PRINT 'Parent Name Not Found'
ELSE
	PRINT 'Pass'	

-- Fix data
--update #MapLayerLegend set layerfullname = REPLACE(layerfullname, ' - ', ' ')
--update #MapLayerLegend set Min = replace(Min, '<', '<= ')
--update #MapLayerLegend set Max = replace(Max, '>=', '> ')

update #MapLayerLegend set layerName = REPLACE(layerName, 'All ', '')

select * from #MapLayerLegend



/********************************************************************************/
/*																				*/
/* Buck load MapLayer Country data 									 		    */
/*																				*/
/********************************************************************************/
-- drop table #CountryMapLayer

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CountryMapLayer (	
	[CountryID] INT NULL,
	[Country] [varchar](255) NULL,
	[World Bank Income Bands] [varchar](100) NULL,	
	[All Cancer Incidence] [varchar](100) NULL,
	[All Cancer Mortality] [varchar](15) NULL,
	[All Cancer Prevalence] [varchar](15) NULL	
)

GO

BULK INSERT #CountryMapLayer
FROM 'C:\icrp\database\DataImport\MapLayers\UpdatedBaseMapLayers-Data.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #CountryMapLayer

/********************************************************************************/
/*																				*/
/* Update Base Map Layers														*/
/*																				*/
/********************************************************************************/
-----------------------------------------
-- Update Parent MapLayer - lookup
----------------------------------------
-- select * from lu_MapLayer
-- drop table #tmpMapLayer
-- drop table #tmpLegend

SELECT l.MapLayerID AS ParentMapLayierID, m.ParentName, m.layerName, m.LayerFullName AS DisplayedName, m.Summary, m.Description, m.DataSource INTO #tmpMapLayer 
FROM (select ParentName, layerName, LayerFullName, Summary, Description, DataSource from #MapLayerLegend group by ParentName, layerName, LayerFullName, Summary, Description, DataSource) m
	join lu_MapLayer l on m.ParentName = l.Name

begin transaction

UPDATE lu_MapLayer SET Summary=t.Summary, Description=t.Description, DataSource=t.DataSource, UpdatedDate=getdate()
FROM lu_MapLayer m
JOIN #tmpMapLayer t ON m.DisplayedName = t.DisplayedName

select 'lu_MapLayer', * from lu_MapLayer
commit
--rollback

-----------------------------------------
-- Update Parent MapLayer - Legend
----------------------------------------

select distinct  t.displayorder, l.maplayerid, t.ParentName, l.Name, CONCAT(ISNULL(t.min, ''), ' - ', ISNULL(t.max, '')) AS legend into #tmpLegend 
from #MapLayerLegend t
	join lu_maplayer l ON t.layerFullName = l.DisplayedName

update #tmpLegend set legend = replace(legend, '- >', '>')
update #tmpLegend set legend = replace(legend, '<', '<= ')
update #tmpLegend set legend = replace(legend, ' - ', '') WHERE RIGHT(legend, 3) = ' - '

begin transaction
	UPDATE lu_MapLayerLegend SET LegendName=t.legend
	FROM lu_MapLayerLegend l
	JOIN #tmpLegend t ON t.MapLayerID = l.MapLayerID and t.displayorder = l.DisplayOrder
commit
--rollback

select 'lu_MapLayerLegend', * from lu_MapLayerLegend order by MapLayerID, DisplayOrder

/********************************************************************************/
/*																				*/
/* Update MapLayer Country data 									 		    */
/*																				*/
/********************************************************************************/
--select top 5 * from #MapLayerLegend
--update #CountryMapLayer set [All Cancer Incidence] = NULL WHERE [All Cancer Incidence] = ''

--update #CountryMapLayer set country = c.Abbreviation
--from #CountryMapLayer t
--join Country c ON t.CountryID = c.CountryID

--- Import Country Data
DECLARE @LayerFullname VARCHAR (50)
DECLARE @MapLayerID INT
DECLARE @cursor as CURSOR;
DECLARE @sql VARCHAR (2000)

DECLARE @legendcursor as CURSOR
DECLARE @legendsql VARCHAR (2000)
DECLARE @legendid INT
DECLARE @min VARCHAR (2000)
DECLARE @max VARCHAR (2000)


select * from lu_maplayer
select * from CountryMapLayer

select * from #MapLayerLegend
select * from #tmpLegend
select * from lu_MapLayerLegend

begin transaction

SET @cursor = CURSOR FOR
SELECT  DISTINCT layerfullname FROM #MapLayerLegend;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @LayerFullname;

WHILE @@FETCH_STATUS = 0 AND @LayerFullname <> 'World Bank Income Bands'
BEGIN 		
	print @LayerFullname
	
	SELECT DISTINCT @MapLayerID = MapLayerID
	--FROM #MapLayerLegend t
	--join lu_maplayer l on t.layerFullName = l.DisplayedName
	FROM lu_maplayer
	WHERE DisplayedName=@LayerFullname	

	/***** Get legendID Sql   ***/
	SET @legendsql = 'CASE '

	SET @legendcursor = CURSOR FOR 
	SELECT l.MapLayerLegendID, t.min, t.max 
		FROM #MapLayerLegend t
			JOIN #tmpLegend tl ON t.ParentName = tl.ParentName AND t.layerName = tl.Name AND t.displayorder = tl.displayorder
			JOIN lu_MapLayerLegend l ON tl.MapLayerID = l.MapLayerID AND tl.displayorder = l.DisplayOrder
		WHERE t.layerFullName = @LayerFullname 

	OPEN @legendcursor;
	FETCH NEXT FROM @legendcursor INTO @legendid, @min, @max;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
	Print 'legendID => ' + CAST(@legendid AS Varchar(100)) + ' / ' + @min + ' / ' + @max

		IF @min IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST([' + @LayerFullName + '] AS decimal(9,1))' + @max + ' THEN ' + CAST(@legendid AS VARCHAR(10))

		IF @max IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST([' + @LayerFullName + '] AS decimal(9,1))' + @min + ' THEN ' + CAST(@legendid AS VARCHAR(10))
	
		IF @min IS NOT NULL AND @max IS NOT NULL 
			SET @legendsql = @legendsql + '  WHEN  (CAST([' + @LayerFullName + '] AS decimal(9,1)) > ' + @min +  ') AND (CAST([' + @LayerFullName + '] AS decimal(9,1)) <= ' + @max + ') THEN ' + CAST(@legendid AS VARCHAR(10)) 
				  
	 FETCH NEXT FROM @legendcursor INTO  @legendid, @min, @max;

	END
 
	CLOSE @legendcursor;
	DEALLOCATE @legendcursor;
		
	SET @sql = 'UPDATE CountryMapLayer SET MapLayerLegendID = ' + 	@legendsql + ' ELSE 6 END, ' + '[Value] = l.[' + @LayerFullname + 
		'], UpdatedDate=getdate() 
		 FROM CountryMapLayer cm
			JOIN #CountryMapLayer l ON cm.Country = l.Country
			WHERE cm.MapLayerID = ' + CAST(@MapLayerID AS VARCHAR(10))
		
	PRINT (@sql)
	exec (@sql)

	IF @@ROWCOUNT = 0
		PRINT '===> ERROR - No such layerFullName'

 FETCH NEXT FROM @cursor INTO  @LayerFullname;

END
 
CLOSE @cursor;
DEALLOCATE @cursor;

select 'CountryMapLayer', * from CountryMapLayer

commit
--rollback


/************************************************************************************************************************************************************************/
/*																																										*/
/* Import Children Map Layers																																			*/
/*																																										*/
/************************************************************************************************************************************************************************/
DROP TABLE #MapLayerLegend
GO
DROP TABLE #CountryMapLayer
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
-- data check - parent name
IF EXISTS 
	(select * from #MapLayerLegend m
		LEFT join lu_MapLayer l on m.ParentName = l.Name
		WHERE m.ParentName IS NULL)
	PRINT 'Parent Name Not Found'
ELSE
	PRINT 'Pass'	

-- Fix data
update #MapLayerLegend set layerfullname = REPLACE(layerfullname, ' - ', ' ')
update #MapLayerLegend set Min = replace(Min, '<', '<= ')
update #MapLayerLegend set Max = replace(Max, '>=', '> ')

select * from #MapLayerLegend


-----------------------------------------
-- Insert MapLayer - Country data
----------------------------------------
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

select * from #CountryMapLayer

update #CountryMapLayer set country = LTRIM(RTRIM(Country))

-----------------------------------------
-- Insert MapLayer - Children
----------------------------------------
DROP TABLE #tmpMapLayer
GO

-- select * from #tmpMapLayer
--select * from #MapLayerLegend

SELECT l.MapLayerID AS ParentMapLayierID, m.ParentName, m.layerName, m.LayerFullName AS DisplayedName, m.Summary, m.Description, m.DataSource INTO #tmpMapLayer 
FROM (select ParentName, layerName, LayerFullName, Summary, Description, DataSource from #MapLayerLegend group by ParentName, layerName, LayerFullName, Summary, Description, DataSource) m
	join lu_MapLayer l on m.ParentName = l.Name

DECLARE @childmaplayerid int = 5
DECLARE @parentmaplayerid int
DECLARE @layerName [varchar](100)
DECLARE @Summary [varchar](1000) 
DECLARE @Description [varchar](1000)
DECLARE @DataSource [varchar](1000)
DECLARE @DisplayedName [varchar](100)
DECLARE @childcursor as CURSOR;

begin transaction

SET @childcursor = CURSOR FOR
SELECT  ParentMapLayierID, layerName, DisplayedName, Summary, Description, DataSource FROM #tmpMapLayer;
 
OPEN @childcursor;
FETCH NEXT FROM @childcursor INTO @parentmaplayerid, @layerName, @DisplayedName, @Summary, @Description, @DataSource;

WHILE @@FETCH_STATUS = 0
BEGIN 

	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [DisplayedName], [Summary],[Description], [DataSource], [CreatedDate], [UpdatedDate]) 
	SELECT @childmaplayerid, @parentmaplayerid, @layerName, @DisplayedName, @Summary, @Description, @DataSource, getdate(), getdate()
	SET @childmaplayerid = @childmaplayerid + 1

 FETCH NEXT FROM @childcursor INTO  @parentmaplayerid, @layerName, @DisplayedName, @Summary, @Description, @DataSource;
END
 
CLOSE @childcursor;
DEALLOCATE @childcursor;

select 'lu_MapLayer', * from lu_MapLayer

commit
--rollback

-----------------------------------------
-- Insert MapLayerLegend - lookup
----------------------------------------
drop table #tmpLegend
go
-- DBCC  CHECKIDENT ('lu_maplayerlegend', reseed, 34)
--select * from #tmpLegend
--select * from #MapLayerLegend
--select * from lu_MapLayerLegend where maplayerid > 4

select distinct  m.displayorder, l.maplayerid, m.ParentName, l.Name, m.legendcolor, CONCAT(ISNULL(m.min, ''), ' - ', ISNULL(m.max, '')) AS legend into #tmpLegend 
from #MapLayerLegend m
	join (select distinct p.name as parent, l.* 
			from lu_maplayer l 	
			left join lu_maplayer p on p.MapLayerID = l.ParentMapLayerID) l ON m.layerName = l.Name and m.ParentName = l.parent

update #tmpLegend set legend = replace(legend, ' - >', '>')
update #tmpLegend set legend = replace(legend, ' - ', '') WHERE RIGHT(legend, 3) = ' - '

select ParentName, Name as LayerName, displayorder, legend from #tmpLegend order by ParentName, Name, displayorder

--delete lu_MapLayerLegend where legendcolor='#999999'
begin transaction
	INSERT INTO lu_MapLayerLegend SELECT maplayerid, legend, legendcolor, displayorder from #tmpLegend
commit
--rollback

select * from lu_MapLayerLegend order by MapLayerID, DisplayOrder

-----------------------------------------
-- Insert MapLayer - Country data
----------------------------------------


--select top 5 * from #MapLayerLegend
--select  top 5 * from #CountryMapLayer
--select  top 5 * from #tmpLegend

--- Import Country Data
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
	PRINT @LayerFullname
	SELECT DISTINCT @MapLayerID = p.MapLayerID
	from  #MapLayerLegend l
	join (select distinct p.name as parent, l.name, l.MapLayerID, l.ParentMapLayerID 
				from lu_maplayer l 	
				join lu_maplayer p on p.MapLayerID = l.ParentMapLayerID) p on l.ParentName = p.parent and l.layerName = p.name
	WHERE l.layerfullname = @LayerFullname

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
	Print 'legend => ' + CAST(@legendid AS Varchar(100)) + ' / ' + @min + ' / ' + @max
		IF @min IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST([' + @LayerFullName + '] AS decimal(9,1))' + @max + ' THEN ' + CAST(@legendid AS VARCHAR(10))

		IF @max IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST([' + @LayerFullName + '] AS decimal(9,1))' + @min + ' THEN ' + CAST(@legendid AS VARCHAR(10))
	
		IF @min IS NOT NULL AND @max IS NOT NULL 
			SET @legendsql = @legendsql + '  WHEN  (CAST([' + @LayerFullName + '] AS decimal(9,1)) > ' + @min +  ') AND (CAST([' + @LayerFullName + '] AS decimal(9,1)) <= ' + @max + ') THEN ' + CAST(@legendid AS VARCHAR(10)) 
				  
	 FETCH NEXT FROM @legendcursor INTO  @legendid, @min, @max;

	END
 
	CLOSE @legendcursor;
	DEALLOCATE @legendcursor;

	--PRINT (@legendsql)

	SET @sql = 'INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
		SELECT ' + CAST(@MapLayerID AS varchar(10)) + ', ' + @legendsql + ' ELSE 6 END, c.[Abbreviation], ' + 'l.[' + @LayerFullname + 
		'] FROM #CountryMapLayer l
		JOIN Country c ON c.[Abbreviation] = l.[Country]'
		
	PRINT (@sql)
	exec (@sql)

	IF @@ROWCOUNT = 0
		PRINT '===> ERROR - No such layerFullName'

 FETCH NEXT FROM @cursor INTO  @LayerFullname;

END
 
CLOSE @cursor;
DEALLOCATE @cursor;

select * from CountryMapLayer
select * from lu_MapLayerLegend

commit
--rollback

-----------------------------------------
/******  Set legend color  ******/
----------------------------------------

select * from lu_MapLayerLegend
select * from lu_MapLayer


update lu_MapLayerLegend set LegendColor = '#0DDCFF' where DisplayOrder=5 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#0BC2E0' where DisplayOrder=4 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#0994AB' where DisplayOrder=3 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#066C7D' where DisplayOrder=2 and  MapLayerID>4
update lu_MapLayerLegend set LegendColor = '#03353D' where DisplayOrder=1 and  MapLayerID>4

update lu_MapLayerLegend set LegendColor = '#785912' FROM lu_MapLayerLegend l
JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID where l.DisplayOrder=1 AND l.MapLayerID>4 AND m.ParentMapLayerID= 1 
update lu_MapLayerLegend set LegendColor = '#B1841B' FROM lu_MapLayerLegend l
JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID where l.DisplayOrder=2 AND l.MapLayerID>4 AND m.ParentMapLayerID= 1 
update lu_MapLayerLegend set LegendColor = '#E0AB30' FROM lu_MapLayerLegend l
JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID where l.DisplayOrder=3 AND l.MapLayerID>4 AND m.ParentMapLayerID= 1 
update lu_MapLayerLegend set LegendColor = '#EDCF89' FROM lu_MapLayerLegend l
JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID where l.DisplayOrder=4 AND l.MapLayerID>4 AND m.ParentMapLayerID= 1 
update lu_MapLayerLegend set LegendColor = '#F7E6C4' FROM lu_MapLayerLegend l
JOIN lu_MapLayer m ON l.MapLayerID = m.MapLayerID where l.DisplayOrder=5 AND l.MapLayerID>4 AND m.ParentMapLayerID= 1 



update lu_MapLayerLegend set legendname = replace(legendname, '>=', '>')

update lu_MapLayer 
set DataSource= 'Ferlay J, Ervik M, Lam F, Colombet M, Mery L, Piñeros M, Znaor A, Soerjomataram I, Bray F (2018). Global Cancer Observatory: Cancer Today. Lyon, France: International Agency for Research on Cancer. Available from: https://gco.iarc.fr/today'
where Name <> 'World Bank Income Bands'

update lu_MapLayer 
set Description = 'This layer displays the 2018 World Bank country classifications by income level, based on gross national income per capita for 2017',
	Summary= 'This layer displays the 2018 World Bank country classifications by income level, based on gross national income per capita for 2017'	
where Name = 'World Bank Income Bands'

Select * from lu_MapLayer where Name = 'World Bank Income Bands'

select * from lu_MapLayer




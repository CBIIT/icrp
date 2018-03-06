--drop table #CountryMapLayer
--GO
--drop table #MapLayerLegend
--GO

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
FROM 'C:\icrp\database\DataImport\CurrentRelease\MapLayer\MapLayers_legend_2.1.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #MapLayerLegend m
LEFT join lu_MapLayer l on m.ParentName = l.Name
WHERE m.ParentName IS NULL

update #MapLayerLegend set layerfullname = REPLACE(layerfullname, ' ', '')
update #MapLayerLegend set layerfullname = REPLACE(layerfullname, '-', '')

update #MapLayerLegend set Min = replace(Min, '<', '<= ')
update #MapLayerLegend set Max = replace(Max, '>=', '> ')

select * from #MapLayerLegend
-----------------------------------------
-- Insert MapLayer - lookup
----------------------------------------
-- select * from lu_MapLayer
-- drop table #tmpMapLayer
SELECT l.MapLayerID AS ParentMapLayierID, m.ParentName, m.layerName, m.Summary, m.Description, m.DataSource INTO #tmpMapLayer 
FROM (select ParentName, layerName, Summary, Description, DataSource from #MapLayerLegend group by ParentName, layerName, Summary, Description, DataSource) m
	join lu_MapLayer l on m.ParentName = l.Name

--select * from #tmpMapLayer

DECLARE @maplayerid int = 5
DECLARE @parentmaplayerid int
DECLARE @layerName [varchar](100)
DECLARE @Summary [varchar](1000) 
DECLARE @Description [varchar](1000)
DECLARE @DataSource [varchar](1000)
DECLARE @layerfullName [varchar](100)
DECLARE @cursor as CURSOR;

begin transaction

SET @cursor = CURSOR FOR
SELECT  ParentMapLayierID, layerName, Summary, Description, DataSource FROM #tmpMapLayer;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @parentmaplayerid, @layerName, @Summary, @Description, @DataSource;

WHILE @@FETCH_STATUS = 0
BEGIN 

	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [DisplayedName], [Summary],[Description], [DataSource], [CreatedDate], [UpdatedDate]) 
	SELECT @maplayerid, @parentmaplayerid, @layerName, @layerfullName, @Summary, @Description, @DataSource, getdate(), getdate()
	SET @maplayerid = @maplayerid + 1

 FETCH NEXT FROM @cursor INTO  @parentmaplayerid, @layerName, @Summary, @Description, @DataSource;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

commit
--rollback

-----------------------------------------
-- Insert MapLayerLegend - lookup
----------------------------------------
--drop table #tmpLegend
-- delete lu_maplayerlegend where maplayerid > 4
-- DBCC  CHECKIDENT ('lu_maplayerlegend', reseed, 34)
--select * from #MapLayerLegend

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

--select * from lu_MapLayerLegend order by MapLayerID, DisplayOrder

-----------------------------------------
-- Insert MapLayer - data
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'
--delete CountryMapLayer where Maplayerid > 4

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CountryMapLayer (	
	[Country] [varchar](3) NULL,
	[BreastCancerIncidence] [varchar](100) NULL,
	[BreastCancerMortality] [varchar](15) NULL,
	[CervicalCancerIncidence] [varchar](15) NULL,
	[CervicalCancerMortality] [varchar](100) NULL,
	[ColorectalCancerIncidence] [varchar](100) NULL,
	[ColorectalCancerMortality] [varchar](100) NULL,
	[LiverCancerIncidence] [varchar](100) NULL,
	[LiverCancerMortality] [varchar](100) NULL,
	[LungCancerIncidence] [varchar](100) NULL,
	[LungCancerMortality] [varchar](100) NULL,	
	[EsophagealCancerIncidence] [varchar](100) NULL,
	[EsophagealCancerMortality] [varchar](100) NULL,
	[ProstateCancerIncidence] [varchar](100) NULL,
	[ProstateCancerMortality] [varchar](100) NULL,
	[StomachCancerIncidence] [varchar](100) NULL,
	[StomachCancerMortality] [varchar](100) NULL,
	[BladderCancerIncidence] [varchar](100) NULL,
	[BladderCancerMortality] [varchar](100) NULL,
	[NonHodgkinLymphomaIncidence] [varchar](100) NULL,
	[NonHodgkinLymphomaMortality] [varchar](100) NULL
)

GO

BULK INSERT #CountryMapLayer
FROM 'C:\icrp\database\DataImport\CurrentRelease\MapLayer\MapLayers_data_2.1.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

--select top 5 * from #MapLayerLegend
--select  top 5 * from #CountryMapLayer
--select  top 5 * from #tmpLegend

update #CountryMapLayer set country = LTRIM(RTRIM(Country))

--select * from #tmpLegend where name= 'Cervical Cancer' and ParentName='Cancer Incidence'
--select * from #MapLayerLegend where layerFullName='CervicalCancerIncidence'
--select country,CervicalCancerIncidence from #CountryMapLayer where country='sd'
--select * from CountryMapLayer where country='sd'
--select * from #MapLayerLegend 
--select * from country
--select * from CountryMapLayer
--truncate table CountryMapLayer

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
			SET @legendsql = @legendsql + '  WHEN  CAST(' + @LayerFullName + ' AS decimal(9,1))' + @max + ' THEN ' + CAST(@legendid AS VARCHAR(10))

		IF @max IS NULL 
			SET @legendsql = @legendsql + '  WHEN  CAST(' + @LayerFullName + ' AS decimal(9,1))' + @min + ' THEN ' + CAST(@legendid AS VARCHAR(10))
	
		IF @min IS NOT NULL AND @max IS NOT NULL 
			SET @legendsql = @legendsql + '  WHEN  (CAST(' + @LayerFullName + ' AS decimal(9,1)) > ' + @min +  ') AND (CAST(' + @LayerFullName + ' AS decimal(9,1)) <= ' + @max + ') THEN ' + CAST(@legendid AS VARCHAR(10)) 
				  
	 FETCH NEXT FROM @legendcursor INTO  @legendid, @min, @max;

	END
 
	CLOSE @legendcursor;
	DEALLOCATE @legendcursor;

	PRINT (@legendsql)

	SET @sql = 'INSERT INTO CountryMapLayer (MapLayerID, MapLayerLegendID, Country, [Value]) 
		SELECT ' + CAST(@MapLayerID AS varchar(10)) + ', ' + @legendsql + ' ELSE 6 END, c.[Abbreviation], ' + 'l.' + @LayerFullname + 
		' FROM #CountryMapLayer l
		JOIN Country c ON c.[Abbreviation] = l.[Country]'
		
	PRINT (@sql)
	exec (@sql)

	IF @@ROWCOUNT = 0
		PRINT '===> ERROR - No such layerFullName'

 FETCH NEXT FROM @cursor INTO  @LayerFullname;

END
 
CLOSE @cursor;
DEALLOCATE @cursor;

commit
--rollback

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
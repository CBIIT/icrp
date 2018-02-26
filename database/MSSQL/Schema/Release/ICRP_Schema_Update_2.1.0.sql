/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Status')
	ALTER TABLE Partner ADD Status VARCHAR(25) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_MapLayer]') AND name = 'DisplayedName')
	ALTER TABLE lu_MapLayer ADD DisplayedName VARCHAR(50) NULL
GO


/*************************************************/
/******					Data				******/
/*************************************************/
-- MapLayer
UPDATE CountryMapLayer SET [MapLayerLegendID] = 0
WHERE [MapLayerLegendID] IN (select [MapLayerLegendID] from [lu_MapLayerLegend] WHERE [LegendName] = 'No data' AND [MapLayerLegendID] <> 0)

DELETE [lu_MapLayerLegend] WHERE [LegendName] = 'No data' AND [MapLayerLegendID] <> 0

-- select * from CountryMapLayer where [MapLayerLegendID] IN (6,16,26,35)
IF NOT EXISTS (SELECT 1 FROM [lu_MapLayerLegend] where [MapLayerLegendID] = 0)
BEGIN
	SET IDENTITY_INSERT [lu_MapLayerLegend] ON;  -- SET IDENTITY_INSERT to ON. 

	INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) 
	SELECT 0, 0, 'No data', '#D2D7D3', 99

	SET IDENTITY_INSERT [lu_MapLayerLegend] OFF;  -- SET IDENTITY_INSERT to OFF. 
END

-- Partner
UPDATE Partner SET Status = 'Current' WHERE Status IS NULL

/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/


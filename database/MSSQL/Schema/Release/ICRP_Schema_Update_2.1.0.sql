/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

/*************************************************/
/******					Data				******/
/*************************************************/

UPDATE CountryMapLayer SET [MapLayerLegendID] = 0
WHERE [MapLayerLegendID] IN (select [MapLayerLegendID] from CountryMapLayer WHERE [LegendName] = 'No data' AND [MapLayerLegendID] <> 0)

DELETE [lu_MapLayerLegend] WHERE [LegendName] = 'No data' AND [MapLayerLegendID] <> 0

-- select * from CountryMapLayer where [MapLayerLegendID] IN (6,16,26,35)
IF NOT EXISTS (SELECT 1 FROM [lu_MapLayerLegend] where [MapLayerLegendID] = 0)
BEGIN
	SET IDENTITY_INSERT [lu_MapLayerLegend] ON;  -- SET IDENTITY_INSERT to ON. 

	INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) 
	SELECT 0, 0, 'No data', '#D2D7D3', 99

	SET IDENTITY_INSERT [lu_MapLayerLegend] OFF;  -- SET IDENTITY_INSERT to OFF. 
END

/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/

select [MapLayerLegendID] from [lu_MapLayerLegend] WHERE [LegendName] = 'No data' AND [MapLayerLegendID] <> 0
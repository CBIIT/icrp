 select pl.Name AS Categoy, ml.DisplayedName, ml.Summary, ml.Description, ml.DataSource, cml.Country, cml.Value from [CountryMapLayer] cml
	join lu_MapLayer ml on cml.MapLayerID = ml.MapLayerID
	join lu_MapLayer pl on cml.MapLayerID = pl.MapLayerID
 order by ml.ParentMapLayerID, ml.MapLayerID, cml.Value DESC
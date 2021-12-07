
/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[PartnerApplication]') AND name = 'IncomeBand')
	ALTER TABLE PartnerApplication ADD IncomeBand VARCHAR(50) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'ApplicationIncomeBand')
	ALTER TABLE Partner ADD ApplicationIncomeBand VARCHAR(50) NULL
GO


/*************************************************/
/******				Update Data				******/
/*************************************************/
Update PartnerApplication set OrgCountry = 'BE' WHERE OrgCountry='Belgium'

Update PartnerApplication set IncomeBand = i.IncomeBand
From PartnerApplication p
join (select Country, Value as IncomeBand from CountryMapLayer) i on p.OrgCountry = i.Country

Update Partner set ApplicationIncomeBand = i.IncomeBand
From Partner p
join (select Country, Value as IncomeBand from CountryMapLayer) i on p.Country = i.Country


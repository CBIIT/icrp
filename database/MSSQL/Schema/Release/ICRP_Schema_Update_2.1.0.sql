/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 
IF object_id('[NonPartner]') is null  
BEGIN

	CREATE TABLE [dbo].[NonPartner] (
		[NonPartnerID] [int] IDENTITY(1,1) NOT NULL,			 
		[Name] [varchar](100) NOT NULL,
		[Description] [varchar](max) NULL,
		[Abbreviation] [varchar](50) NULL,
		[Email] [varchar](75) NULL,	
		[Country] [varchar](2) NULL,		
		[Longitude] [decimal](9, 6) NULL,
		[Latitude] [decimal](9, 6) NULL,
		[Website] [varchar](200) NULL,
		[LogoFile] [varchar](100) NULL,
		[Note] [varchar](8000) NULL,			
		[EstimatedInvest] [varchar](100) NULL,		
		[ContactPerson] [varchar](100) NULL,		
		[Position] [varchar](100) NULL,
		[DoNotContact] [bit] NULL,
		[CancerOnly] [bit] NULL,
		[ResearchFunder] [bit] NULL,
		[DoNotShow] [bit] NULL,		
		[CreatedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL
		CONSTRAINT [PK_NonParter] PRIMARY KEY CLUSTERED 
	(
		[NonPartnerID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

	
/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Status')
	ALTER TABLE Partner ADD Status VARCHAR(25) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_MapLayer]') AND name = 'DisplayedName')
	ALTER TABLE lu_MapLayer ADD DisplayedName VARCHAR(50) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[LibraryFolder]') AND name = 'Type')
	ALTER TABLE LibraryFolder ADD Type VARCHAR(50) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[NonPartner]') AND name = 'DoNotShow')
	ALTER TABLE NonPartner ADD [DoNotShow] [bit] NULL
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

-- Library
UPDATE LibraryFolder SET Type = 'General' WHERE Type IS NULL

/*************************************************/
/******					Keys				******/
/*************************************************/
IF (OBJECT_ID('FK_FundingOrg_Partner', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE dbo.FundingOrg DROP CONSTRAINT FK_FundingOrg_Partner
END

/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/


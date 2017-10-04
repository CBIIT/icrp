/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF (OBJECT_ID('FK_Country_lu_Region', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE dbo.[Country] DROP CONSTRAINT FK_Country_lu_Region
END

IF object_id('lu_Region') is NOT null
DROP Table lu_Region
GO

CREATE TABLE [dbo].[lu_Region](
	[RegionID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,		
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
	CONSTRAINT [PK_lu_Region] PRIMARY KEY CLUSTERED 
(
	[RegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF object_id('lu_City') is null
BEGIN

	CREATE TABLE [dbo].[lu_City](
		[CityID] [int] IDENTITY(1,1) NOT NULL,
		[Name] [varchar](100) NOT NULL,		
		[Country] [varchar](2) NOT NULL,		
		[Latitude] [decimal](9, 6) NULL,
		[Longitude] [decimal](9, 6) NULL
		CONSTRAINT [PK_lu_City] PRIMARY KEY CLUSTERED 
	(
		[CityID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO


IF object_id('[CountryMapLayer]') is null
BEGIN

	CREATE TABLE [dbo].[CountryMapLayer] (
		[MapLayerID] [int] NOT NULL,		
		[MapLayerLegendID] [int] NOT NULL,		
		[Country] [varchar] (3) NOT NULL,		
		[Value] [varchar] (50) NULL				
	) 

END
GO


IF object_id('lu_MapLayer') is NOT null
	DROP TABLE lu_MapLayer
ELSE
BEGIN

	CREATE TABLE [dbo].[lu_MapLayer] (
		[MapLayerID] [int] NOT NULL,
		[ParentMapLayerID] [int] NOT NULL,
		[Name] [varchar](50) NOT NULL,
		[Summary] [varchar](500) NULL,
		[Description] [varchar](500) NULL,
		[DataSource] [varchar](500) NULL,
		[CreatedDate] [datetime] not null,
		[UpdatedDate] [datetime] not null
	)

END


ALTER TABLE [dbo].[lu_MapLayer] ADD  CONSTRAINT [DF_lu_MayLayer_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[lu_MapLayer] ADD  CONSTRAINT [DF_lu_MayLayer_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO


IF object_id('lu_MapLayerLegend') is null
BEGIN

	CREATE TABLE [dbo].[lu_MapLayerLegend] (
		[MapLayerLegendID] [int] IDENTITY(1,1) NOT NULL,
		[MapLayerID] [int] NOT NULL,
		[LegendName] [varchar] (150) NULL,
		[DisplayOrder] [int] NOT NULL
	CONSTRAINT [PK_lu_MapLayerLegend] PRIMARY KEY CLUSTERED 
	(
		[MapLayerLegendID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END


/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'RegionID')
	ALTER TABLE Country ADD RegionID INT NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'Latitude')
	ALTER TABLE Country ADD [Latitude] [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'Longitude')
	ALTER TABLE Country ADD [Longitude] [decimal](9, 6) NULL
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFundingInvestigator]') AND name = 'LastName')
	ALTER TABLE ProjectFundingInvestigator ALTER COLUMN LastName VARCHAR(100) NULL

GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'RegionList')
	ALTER TABLE SearchCriteria ADD RegionList varchar(100) NULL
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFundingInvestigator]') AND name = 'IsPrivateInvestigator')
	EXEC sp_rename 'ProjectFundingInvestigator.IsPrivateInvestigator', 'ProjectFundingInvestigator.IsPrincipalInvestigator', 'COLUMN';  
GO  

--IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'MapCoords')
--	ALTER TABLE Partner DROP COLUMN MapCoords

--GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Longitude')
	ALTER TABLE Partner ADD Longitude [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Latitude')
	ALTER TABLE Partner ADD Latitude [decimal](9, 6) NULL
GO


--IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'MapCoords')
--	ALTER TABLE Partner DROP COLUMN MapCoords

--GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'Longitude')
	ALTER TABLE FundingOrg ADD Longitude [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'Latitude')
	ALTER TABLE FundingOrg ADD Latitude [decimal](9, 6) NULL
GO


/*************************************************/
/******					Data				******/
/*************************************************/
--  lu_Region
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 1)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 1, 'North America', 42.611695, -104.326171
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 2)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 2, 'Latin America & Caribbean', -17.902996, -58.974609 
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 3)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 3, 'Europe & Central Asia', 48.613534, 21.335449	

IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 4)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 4, 'South Asia', 19.532168, 77.585449
ELSE
	UPDATE lu_Region SET [Latitude] = 23.152948, [Longitude] = 77.299819

IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 5)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 5, 'East Asia & Pacific', 29.451519, 116.674819
ELSE
	UPDATE lu_Region SET [Latitude] = 29.451519, [Longitude] = 116.674819

IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 6)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 6, 'Middle East & North Africa', 26.187443, 29.619140
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 7)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 7, 'Sub-Saharan Africa', -17.232669, 25.751953

GO

IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 8)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 8, 'Australia & New Zealand', -31.353637, 149.414063
GO

-- SearchResult
IF NOT EXISTS (SELECT * FROM SearchCriteria WHERE SearchCriteriaID = 0)
BEGIN
	SET IDENTITY_INSERT SearchCriteria ON; 
	INSERT INTO SearchCriteria (SearchCriteriaID, [TermSearchType],[Terms],[Institution],[piLastName],[piFirstName],[piORCiD],[AwardCode],[YearList],[CityList],[StateList],[CountryList],[FundingOrgList],
		[CancerTypeList],[ProjectTypeList],	[CSOList],[SearchByUserName],[SearchDate],	[FundingOrgTypeList],[IsChildhood],	[RegionList]) 
		VALUES ( 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, getdate(), NULL, NULL, NULL)	
	SET IDENTITY_INSERT SearchCriteria OFF; 

	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( 0, NULL, NULL, NULL, NULL, NULL)	
END

-- lu_MapLayer
IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 1)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 1, 0, 'Cancer Incidence', 
		'This layer displays the estimated age-standardized rates (world population) of incident cases, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.', 
		'Estimated age-standardized rates (world population) of incident cases, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: http://globocan.iarc.fr.', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 2)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 2, 0, 'Cancer Mortality', 
		'This layer displays the estimated age-standardized rates (world population) of deaths, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Estimated age-standardized rates (world population) of deaths, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: http://globocan.iarc.fr.', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 3)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 3, 0, 'Cancer Prevalence', 
		'This layer displays the estimated number of prevalence cases (1-year), both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Estimated number of prevalence cases (1-year), both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: http://globocan.iarc.fr.', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 4)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 4, 0, 'World Bank Income Bands', 
		'This layer displays the 2016 World Bank country classifications by income level, based on estimates of gross national income per capita for 2015.',
		'This layer displays the 2016 World Bank country classifications by income level, based on estimates of gross national income per capita for 2015.',
		'https://data.worldbank.org/', getdate(), getdate()
	
GO

-- lu_MapLayerLegend
TRUNCATE TABLE [lu_MapLayerLegend]

INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, '> 244.2', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, '174.3 - 244.2', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, '137.6 - 174.3', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, '101.6 - 137.6', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, '< 101.6', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, 'No data', 6
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 1, 'Not applicable', 7

INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, '117.0', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, '99.9-117.0', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, '89.8-99.9', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, '74.0-89.8', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, '< 74.0', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, 'No data', 6
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 2, 'Not applicable', 7

INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, '> 328.7', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, '139.6-328.7', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, '85.7-139.6', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, '62.6-85.7', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, '< 62.6', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, 'No data', 6
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 3, 'Not applicable', 7

INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'High Income', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'Upper Middle Income', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'Lower Middle Income', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'Low Income', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'No data', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerID], [LegendName], [DisplayOrder]) SELECT 4, 'Not applicable', 6
		

/*************************************************/
/******					Keys				******/
/*************************************************/

ALTER TABLE [dbo].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Country_lu_Region] FOREIGN KEY([RegionID])
REFERENCES [dbo].[lu_Region] ([RegionID])
GO
ALTER TABLE [dbo].[Country] CHECK CONSTRAINT [FK_Country_lu_Region]
GO

-- [ProjectFundingInvestigator] - Delete the primary key constraint.  
IF (OBJECT_ID('PK_ProjectFundingInvestigator', 'PK') IS NOT NULL)
BEGIN
    ALTER TABLE dbo.[ProjectFundingInvestigator] DROP CONSTRAINT PK_ProjectFundingInvestigator
END


IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFundingInvestigator]') AND name = 'ProjectFundingInvestigatorID')
	ALTER TABLE ProjectFundingInvestigator ADD ProjectFundingInvestigatorID INT IDENTITY(1,1) NOT NULL 

IF (OBJECT_ID('PK_ProjectFundingInvestigator', 'PK') IS NULL)
ALTER TABLE [ProjectFundingInvestigator] 
   ADD CONSTRAINT [PK_ProjectFundingInvestigator] PRIMARY KEY CLUSTERED 
(
	[ProjectFundingInvestigatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO

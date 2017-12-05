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
		[State] [varchar](50) NULL,		
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
		[LegendColor] [varchar] (7) NULL,
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

	EXEC sp_rename 'ProjectFundingInvestigator.IsPrivateInvestigator', 'IsPrincipalInvestigator', 'COLUMN';  
GO  

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'MapCoords')
	ALTER TABLE Partner DROP COLUMN MapCoords

GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Longitude')
	ALTER TABLE Partner ADD Longitude [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Partner]') AND name = 'Latitude')
	ALTER TABLE Partner ADD Latitude [decimal](9, 6) NULL
GO


IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'MapCoords')
	ALTER TABLE FundingOrg DROP COLUMN MapCoords

GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'Longitude')
	ALTER TABLE FundingOrg ADD Longitude [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'Latitude')
	ALTER TABLE FundingOrg ADD Latitude [decimal](9, 6) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_DataUploadIntegrityCheckRules]') AND name = 'DisplayOrder')
	ALTER TABLE lu_DataUploadIntegrityCheckRules ADD DisplayOrder int NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[lu_DataUploadIntegrityCheckRules]') AND name = 'Type')
	ALTER TABLE lu_DataUploadIntegrityCheckRules ADD Type varchar(25) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'InvestigatorType')
	ALTER TABLE SearchCriteria ADD InvestigatorType varchar(25) NULL
GO

/*************************************************/
/******					Data				******/
/*************************************************/
-- lu_DataUploadIntegrityCheckRules
UPDATE lu_DataUploadIntegrityCheckRules SET Type = 'Both'

IF NOT EXISTS (SELECT * FROM lu_DataUploadIntegrityCheckRules WHERE lu_DataUploadIntegrityCheckRules_ID = 18)
	INSERT INTO lu_DataUploadIntegrityCheckRules (lu_DataUploadIntegrityCheckRules_ID, [Name],[Category],[IsRequired],[IsActive], Type, CreatedDate, UpdatedDate) SELECT 18, 'Missing AltAwardCodes', 'Award', 1, 1, 'Update', getdate(), getdate()
ELSE
	UPDATE lu_DataUploadIntegrityCheckRules SET Type='Update' WHERE lu_DataUploadIntegrityCheckRules_ID = 18
GO

IF EXISTS (SELECT * FROM lu_DataUploadIntegrityCheckRules WHERE lu_DataUploadIntegrityCheckRules_ID = 13)
	UPDATE lu_DataUploadIntegrityCheckRules SET Name = 'Multiple Parents' WHERE lu_DataUploadIntegrityCheckRules_ID = 13
GO

UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 1 WHERE lu_DataUploadIntegrityCheckRules_ID =1
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 1 WHERE lu_DataUploadIntegrityCheckRules_ID =18
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 2 WHERE lu_DataUploadIntegrityCheckRules_ID =11
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 3 WHERE lu_DataUploadIntegrityCheckRules_ID =12
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 4 WHERE lu_DataUploadIntegrityCheckRules_ID =13
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 5 WHERE lu_DataUploadIntegrityCheckRules_ID =14
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 6 WHERE lu_DataUploadIntegrityCheckRules_ID =15
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 7 WHERE lu_DataUploadIntegrityCheckRules_ID =16
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 8 WHERE lu_DataUploadIntegrityCheckRules_ID =17
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 1 WHERE lu_DataUploadIntegrityCheckRules_ID =21
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 2 WHERE lu_DataUploadIntegrityCheckRules_ID =22
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 3 WHERE lu_DataUploadIntegrityCheckRules_ID =23
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 4 WHERE lu_DataUploadIntegrityCheckRules_ID =24
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 5 WHERE lu_DataUploadIntegrityCheckRules_ID =25
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 6 WHERE lu_DataUploadIntegrityCheckRules_ID =26
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 1 WHERE lu_DataUploadIntegrityCheckRules_ID =31
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 2 WHERE lu_DataUploadIntegrityCheckRules_ID =32
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 3 WHERE lu_DataUploadIntegrityCheckRules_ID =33
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 4 WHERE lu_DataUploadIntegrityCheckRules_ID =34
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 5 WHERE lu_DataUploadIntegrityCheckRules_ID =35
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 1 WHERE lu_DataUploadIntegrityCheckRules_ID =41
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 2 WHERE lu_DataUploadIntegrityCheckRules_ID =42
UPDATE lu_DataUploadIntegrityCheckRules SET DisplayOrder = 3 WHERE lu_DataUploadIntegrityCheckRules_ID =43

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
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: <a href="http://globocan.iarc.fr" target="_blank">http://globocan.iarc.fr</a>', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 2)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 2, 0, 'Cancer Mortality', 
		'This layer displays the estimated age-standardized rates (world population) of deaths, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Estimated age-standardized rates (world population) of deaths, both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: <a href="http://globocan.iarc.fr" target="_blank">http://globocan.iarc.fr.</a>', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 3)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 3, 0, 'Cancer Prevalence', 
		'This layer displays the estimated number of prevalence cases (1-year), both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Estimated number of prevalence cases (1-year), both sexes, all cancers excluding non-melanoma skin cancer, worldwide in 2012.',
		'Ferlay J, Soerjomataram I, Ervik M, et al. GLOBOCAN 2012 v1.0, Cancer Incidence and Mortality Worldwide: IARC CancerBase No. 11 [Internet]. Available from: <a href="http://globocan.iarc.fr" target="_blank">http://globocan.iarc.fr.</a>', getdate(), getdate()

IF NOT EXISTS (SELECT * FROM lu_MapLayer WHERE MapLayerID = 4)
	INSERT INTO lu_MapLayer ([MapLayerID], [ParentMapLayerID], [Name], [Summary], [Description], [DataSource], [CreatedDate], [UpdatedDate])
	SELECT 4, 0, 'World Bank Income Bands', 
		'This layer displays the 2016 World Bank country classifications by income level, based on estimates of gross national income per capita for 2015.',
		'This layer displays the 2016 World Bank country classifications by income level, based on estimates of gross national income per capita for 2015.',
		'<a href="https://data.worldbank.org/" target="_blank">https://data.worldbank.org/</a>', getdate(), getdate()
	
GO

-- lu_MapLayerLegend
TRUNCATE TABLE [lu_MapLayerLegend]

SET IDENTITY_INSERT [lu_MapLayerLegend] ON;

INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 1, 1, '> 244.2', '#3d1b00', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 2, 1, '174.3 - 244.2', '#6d3e1a', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 3, 1, '137.6 - 174.3', '#91623e', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 4, 1, '101.6 - 137.6', '#cc9c78', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 5, 1, '< 101.6', '#f7d4b9', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 6, 1, 'No data', '#D2D7D3', 6


INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 11, 2, '117.0', '#330012', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 12, 2, '99.9-117.0', '#631c35', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 13, 2, '89.8-99.9', '#99526b', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 14, 2, '74.0-89.8', '#cc9faf', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 15, 2, '< 74.0', '#f9dee8', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 16, 2, 'No data', '#D2D7D3', 6

INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 21, 3, '> 328.7', '#065100', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 22, 3, '139.6-328.7', '#208c17', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 23, 3, '85.7-139.6', '#4dc643', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 24, 3, '62.6-85.7', '#8be884', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 25, 3, '< 62.6', '#cbf7c8', 5
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 26, 3, 'No data', '#D2D7D3', 6

INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 31, 4, 'High Income', '#414700', 1
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 32, 4, 'Upper Middle Income', '#79820e', 2
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 33, 4, 'Lower Middle Income', '#d0d86e', 3
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 34, 4, 'Low Income', '#f5f9c2', 4
INSERT INTO [lu_MapLayerLegend] ([MapLayerLegendID], [MapLayerID], [LegendName], [LegendColor], [DisplayOrder]) SELECT 35, 4, 'No data', '#D2D7D3', 5

SET IDENTITY_INSERT dbo.[lu_MapLayerLegend] OFF;

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


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddInstitutions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddInstitutions]
GO 

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_Import]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_Import]
GO 
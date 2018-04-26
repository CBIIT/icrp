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
		[ConvertedDate] [datetime] NULL,
		[CreatedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL
		CONSTRAINT [PK_NonParter] PRIMARY KEY CLUSTERED 
	(
		[NonPartnerID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO


IF object_id('[ImportCollaboratorLog]') is null  
BEGIN

	CREATE TABLE [dbo].[ImportCollaboratorLog] (
		[ImportCollaboratorLogID] [int] IDENTITY(1,1) NOT NULL,			
		[FileCount] [int] NULL,
		[ImportedCount] [int] NULL,
		[Status] VARCHAR (25) NULL,  -- Failed, Completed
		[CreatedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL
		CONSTRAINT [PK_ImportCollaboratorLogID] PRIMARY KEY CLUSTERED 
	(
		[ImportCollaboratorLogID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

IF object_id('[ImportCollaboratorStaging]') is null  
BEGIN

	CREATE TABLE [dbo].[ImportCollaboratorStaging] (
		[ImportCollaboratorLogID] [int] NOT NULL,			
		[AwardCode] [varchar](75) NULL,
		[AltAwardCode] [varchar](75) NULL,
		[LastName] [varchar](100) NULL,
		[FirstName] [varchar](100) NULL,
		[SubmittedInstitution] [varchar](250) NULL,
		[Institution] [varchar](250) NULL,
		[City] [varchar](50) NULL,
		[ORC_ID] [varchar](19) NULL,
		[OtherResearchID] [int] NULL,
		[OtherResearchType] [varchar](50) NULL
	) ON [PRIMARY]

END
GO


IF object_id('[ImportInstitutionLog]') is null  
BEGIN

	CREATE TABLE [dbo].[ImportInstitutionLog] (
		[ImportInstitutionLogID] [int] IDENTITY(1,1) NOT NULL,			
		[FileCount] [int] NULL,
		[ImportedCount] [int] NULL,
		[Status] VARCHAR (25) NULL,  -- Failed, Completed
		[CreatedDate] [datetime] NOT NULL,
		[UpdatedDate] [datetime] NOT NULL
		CONSTRAINT [PK_ImportInstitutionLogID] PRIMARY KEY CLUSTERED 
	(
		[ImportInstitutionLogID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END
GO

IF object_id('[ImportInstitutionStaging]') is null  
BEGIN

	CREATE TABLE [dbo].[ImportInstitutionStaging] (
		[ImportInstitutionLogID][int] NOT NULL,			
		[ID] [int] IDENTITY(1,1) NOT NULL,
		[Name] [varchar](250) NULL,
		[City] [varchar](50) NULL,
		[State] [varchar](50) NULL,
		[Country] [varchar](100) NULL,
		[Postal] [varchar](50) NULL,
		[Latitude] [decimal](9, 6) NULL,
		[Longitude] [decimal](9, 6) NULL,
		[GRID] [varchar](250) NULL
		) ON [PRIMARY]

END
GO

--IF object_id('[DataUploadStaging]') is null  
--BEGIN
--CREATE TABLE [dbo].[DataUploadStaging](
--	[InternalId] [int] IDENTITY(1,1) NOT NULL,
--	[DataUploadStatusID] [int] NOT NULL,
--	[AwardCode] [nvarchar](50) NULL,
--	[AwardStartDate] [date] NULL,
--	[AwardEndDate] [date] NULL,
--	[SourceId] [varchar](150) NULL,
--	[AltId] [varchar](50) NULL,
--	[NewAltId] [varchar](50) NULL,
--	[AwardTitle] [varchar](1000) NULL,
--	[Category] [varchar](25) NULL,
--	[AwardType] [varchar](50) NULL,
--	[Childhood] [varchar](5) NULL,
--	[BudgetStartDate] [date] NULL,
--	[BudgetEndDate] [date] NULL,
--	[CSOCodes] [varchar](500) NULL,
--	[CSORel] [varchar](500) NULL,
--	[SiteCodes] [varchar](500) NULL,
--	[SiteRel] [varchar](500) NULL,
--	[AwardFunding] [decimal](16, 2) NULL,
--	[IsAnnualized] [varchar](1) NULL,
--	[FundingMechanismCode] [varchar](30) NULL,
--	[FundingMechanism] [varchar](200) NULL,
--	[FundingOrgAbbr] [varchar](50) NULL,
--	[FundingDiv] [varchar](75) NULL,
--	[FundingDivAbbr] [varchar](50) NULL,
--	[FundingContact] [varchar](50) NULL,
--	[PILastName] [varchar](50) NULL,
--	[PIFirstName] [varchar](50) NULL,
--	[SubmittedInstitution] [varchar](250) NULL,
--	[City] [varchar](50) NULL,
--	[State] [varchar](50) NULL,
--	[Country] [varchar](3) NULL,
--	[PostalZipCode] [varchar](50) NULL,
--	[InstitutionICRP] [varchar](4000) NULL,
--	[Latitute] [decimal](9, 6) NULL,
--	[Longitute] [decimal](9, 6) NULL,
--	[GRID] [varchar](250) NULL,
--	[TechAbstract] [nvarchar](max) NULL,
--	[PublicAbstract] [nvarchar](max) NULL,
--	[RelatedAwardCode] [varchar](200) NULL,
--	[RelationshipType] [varchar](200) NULL,
--	[ORCID] [varchar](25) NULL,
--	[OtherResearcherID] [int] NULL,
--	[OtherResearcherIDType] [varchar](1000) NULL,
--	[InternalUseOnly] [nvarchar](max) NULL
--)
--END	
--GO

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

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[NonPartner]') AND name = 'ConvertedDate')
	ALTER TABLE NonPartner ADD [ConvertedDate] [datetime] NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ImportCollaboratorLog]') AND name = 'ImportedCount')
	ALTER TABLE ImportCollaboratorLog ADD [ImportedCount] INT NULL
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
UPDATE Library SET Title=NULL where Title='NULL'
UPDATE Library SET Description=NULL where Description='NULL'

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


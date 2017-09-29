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
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 3, 'Europe & Central Asia', 43.383062, 20.478515

IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 4)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 4, 'South Asia', 23.152948, 77.299819
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

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

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFundingInvestigator]') AND name = 'LastName')
	ALTER TABLE ProjectFundingInvestigator ALTER COLUMN LastName VARCHAR(100) NULL

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
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 4, 'South Asia', 8.138043, 102.392578
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 5)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 5, 'East Asia & Pacific', 36.095683, 113.291015
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 6)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 6, 'Middle East & North Africa', 26.187443, 29.619140
IF NOT EXISTS (SELECT * FROM lu_Region WHERE RegionID = 7)
	INSERT INTO lu_Region ([RegionID], [Name], [Latitude], [Longitude]) SELECT 7, 'Sub-Saharan Africa', -17.232669, 25.751953

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

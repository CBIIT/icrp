/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF object_id('PartnerApplication') is not null
DROP TABLE PartnerApplication
GO 

CREATE TABLE [dbo].[PartnerApplication](
	[PartnerApplicationID] [int] IDENTITY(1,1) NOT NULL,	
	[OrgName] [varchar](100) NULL,	
	[OrgCountry] [varchar](255) NULL,		
	[OrgEmail] [varchar](50) NULL,
	[MissionDesc] [varchar](max) NULL,	
	[Status] [varchar](100) NULL,    -- New, Done
	[CompletedDate] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PartnerApplication] PRIMARY KEY CLUSTERED 
(
	[PartnerApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[PartnerApplication] ADD  CONSTRAINT [DF_PartnerApplication_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PartnerApplication] ADD  CONSTRAINT [DF_PartnerApplication_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO



/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchResult]') AND name = 'TotalRelatedProjectCount')
	ALTER TABLE [SearchResult] ADD [TotalRelatedProjectCount] INT NULL

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchResult]') AND name = 'LastBudgetYear')
	ALTER TABLE [SearchResult] ADD [LastBudgetYear] INT NULL

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'Currency')
	ALTER TABLE [Country] ADD [Currency] [varchar](3) NULL


/*************************************************/
/******					Data				******/
/*************************************************/
UPDATE Country SET Currency = cur.Currency
FROM Country c
join (select distinct country, currency from fundingorg) cur ON c.Abbreviation = cur.country


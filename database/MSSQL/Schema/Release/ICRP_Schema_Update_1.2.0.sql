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



IF object_id('lu_DataUploadIntegrityCheckRules') is not null
DROP TABLE [lu_DataUploadIntegrityCheckRules]
GO 

CREATE TABLE [dbo].[lu_DataUploadIntegrityCheckRules] (
	[lu_DataUploadIntegrityCheckRules_ID] [int] NOT NULL,	
	[Name] [varchar](250) NOT NULL,	
	[Category] [varchar](50) NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,		
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)

GO

ALTER TABLE [dbo].[lu_DataUploadIntegrityCheckRules] ADD  CONSTRAINT [DF_lu_DataUploadIntegrityCheckRules_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[lu_DataUploadIntegrityCheckRules] ADD  CONSTRAINT [DF_lu_DataUploadIntegrityCheckRules_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO


------------------------------------------------------------------
-- Insert [lu_DataUploadIntegrityCheckRules] Data
------------------------------------------------------------------
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (1, 'Required Fields', 'General', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (2, 'Place Holder', 'General', 1, 0, getdate(), getdate())

INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (11, 'Duplicate AltAwardCodes', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (12, 'Missing Parents', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (13, 'Renewals imported as Parents', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (14, 'Invalid Award Dates', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (15, 'Invalid Funding Amounts', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (16, 'Invalid Annulized Values', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (17, 'Invalid Award Type', 'Award', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (18, 'Place Holder', 'Award', 1, 0, getdate(), getdate())

INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (21, 'Missing CSO Code/Relevance', 'CSO', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (22, 'Invalid CSO Codes', 'CSO', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (23, 'Relevances not 100% ', 'CSO', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (24, 'Mismatched Codes/Relevances', 'CSO', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (25, 'Using Historical CSO Codes', 'CSO', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (26, 'Place Holder', 'CSO', 1, 0, getdate(), getdate())

INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (31, 'Missing Cancer Type/Relevance', 'Cancer Type', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (32, 'Invalid Cancer Types', 'Cancer Type', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (33, 'Relevances not 100% ', 'Cancer Type', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (34, 'Mismatched Cancer Types/Relevances', 'Cancer Type', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (35, 'Place Holder', 'Cancer Type', 1, 0, getdate(), getdate())

INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (41, 'Missing Institution', 'Funding Org / Institution', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (42, 'Missing Funding Org', 'Funding Org / Institution', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (43, 'Missing Funding Org Div', 'Funding Org / Institution', 1, 1, getdate(), getdate())
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (44, 'Place Holder', 'Funding Org / Institution', 1, 0, getdate(), getdate())

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchResult]') AND name = 'TotalRelatedProjectCount')
	ALTER TABLE [SearchResult] ADD [TotalRelatedProjectCount] INT NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchResult]') AND name = 'LastBudgetYear')
	ALTER TABLE [SearchResult] ADD [LastBudgetYear] INT NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'Currency')
	ALTER TABLE [Country] ADD [Currency] [varchar](3) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CSO]') AND name = 'AltAwardCode1')
	ALTER TABLE [CSO] ADD [AltAwardCode1] [varchar](100) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CSO]') AND name = 'AltAwardCode2')
	ALTER TABLE [CSO] ADD [AltAwardCode2] [varchar](100) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'MapCoords')
	ALTER TABLE [FundingOrg] ADD [MapCoords] [varchar](50) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[FundingOrg]') AND name = 'Website')
	ALTER TABLE [FundingOrg] ADD [Website] [varchar](200) NULL
GO
	
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'DataUploadStatusID')
	ALTER TABLE [Project] ADD [DataUploadStatusID] INT NULL
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Institution]') AND name = 'State')
	ALTER TABLE [Institution] ALTER COLUMN [State] VARCHAR(50) NULL
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Institution]') AND name = 'Postal')
	ALTER TABLE [Institution] ALTER COLUMN Postal VARCHAR(50) NULL
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'Source_ID')
	ALTER TABLE [ProjectFunding] ALTER COLUMN Source_ID VARCHAR(150) NULL
GO

/*************************************************/
/******					Data				******/
/*************************************************/
UPDATE Country SET Currency = cur.Currency
FROM Country c
join (select distinct country, currency from fundingorg) cur ON c.Abbreviation = cur.country
GO

-----------------------------------------
-- Insert Currency in the Country table
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Currency (	
	[Currency] [varchar](3) NULL,
	[Country] [varchar](1000) NULL
)

GO

BULK INSERT #Currency
FROM 'C:\icrp\database\DataUpload\ISOCurrencyCodes.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

update country set Currency = cu.Currency
FROM country c
JOIN #Currency cu ON c.Name = cu.Country

GO

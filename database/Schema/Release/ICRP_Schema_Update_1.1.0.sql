/*************************************************/
/******		NEW TABLE        				******/
/*************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF object_id('lu_FundingOrgType') is null
BEGIN

	CREATE TABLE [dbo].[lu_FundingOrgType](
		[FundingOrgTypeID] [int] NOT NULL,
		[FundingOrgType] [varchar](50) NOT NULL	
	 CONSTRAINT [PK_FundingOrgType] PRIMARY KEY CLUSTERED 
	(
		[FundingOrgTypeID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

END

GO

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'FundingOrgTypeList')
	ALTER TABLE [SearchCriteria] ADD [FundingOrgTypeList] VARCHAR(250) NULL

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'IsChildhood')
	ALTER TABLE [SearchCriteria] ADD [IsChildhood] bit NULL

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[DataUploadStatus]') AND name = 'Type')
	ALTER TABLE [DataUploadStatus] ADD [Type] [varchar](50) NULL	
	
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Library]') AND name = 'DisplayName')
	ALTER TABLE [Library] ADD [DisplayName] [varchar](150) NULL

/*************************************************/
/******					Data				******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM [lu_FundingOrgType] WHERE FundingOrgType = 'Government')
	INSERT INTO [lu_FundingOrgType] VALUES (1, 'Government')

IF NOT EXISTS (SELECT * FROM [lu_FundingOrgType] WHERE FundingOrgType = 'Non-profit')
	INSERT INTO [lu_FundingOrgType] VALUES (2, 'Non-profit')

IF NOT EXISTS (SELECT * FROM [lu_FundingOrgType] WHERE FundingOrgType = 'Other')
	INSERT INTO [lu_FundingOrgType] VALUES (3, 'Other')

UPDATE Library SET [DisplayName] = Filename


/*******************************************************************************************/
/******  Project Active/Inactive status (epic NCIATWP-11791, technical story)          ******/
/******  Part 1 of 2: columns. Run on BOTH icrp_data and icrp_dataload.                  ******/
/******  Part 2 (ICRP_Schema_Update_ProjectStatus_Procedures.sql): icrp_data only.        ******/
/******  Undo: ICRP_Schema_Rollback_ProjectStatus.sql                                     ******/
/*******************************************************************************************/
-- Adds to Project (base/parent projects) and ProjectFunding (sub-projects):
--   IsActive           1 = Active (shown on the public site), 0 = Inactive. Every existing and new row is Active.
--   StatusUpdatedBy    Drupal user name of the ICRP Manager who last changed IsActive (NULL = never changed)
--   StatusUpdatedDate  when IsActive last changed (NULL = never changed)
--
-- Safe to re-run. Nothing changes on the site: all rows start Active, and no procedure reads the new columns yet.
-- Data uploads (DataUpload_ImportNew / ImportUpdate / SyncProd) list their columns explicitly, so new rows take the
-- default (Active) and re-uploads never change an existing row's status.
--
-- Note: on SQL Server Web and Standard Edition (all ICRP tiers) adding a NOT NULL column with a default writes every
-- row of the table, so run this in a quiet period. On Developer/Enterprise Edition it's a metadata-only change.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************/
/******	NEW Columns: Project               ******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'IsActive')
	ALTER TABLE [dbo].[Project] ADD [IsActive] BIT NOT NULL CONSTRAINT [DF_Project_IsActive] DEFAULT (1)
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'StatusUpdatedBy')
	ALTER TABLE [dbo].[Project] ADD [StatusUpdatedBy] NVARCHAR(100) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'StatusUpdatedDate')
	ALTER TABLE [dbo].[Project] ADD [StatusUpdatedDate] DATETIME NULL
GO

/*************************************************/
/******	NEW Columns: ProjectFunding        ******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'IsActive')
	ALTER TABLE [dbo].[ProjectFunding] ADD [IsActive] BIT NOT NULL CONSTRAINT [DF_ProjectFunding_IsActive] DEFAULT (1)
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'StatusUpdatedBy')
	ALTER TABLE [dbo].[ProjectFunding] ADD [StatusUpdatedBy] NVARCHAR(100) NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'StatusUpdatedDate')
	ALTER TABLE [dbo].[ProjectFunding] ADD [StatusUpdatedDate] DATETIME NULL
GO

/*************************************************/
/******	Check                              ******/
/*************************************************/
SELECT DB_NAME() AS [Database],
	(SELECT COUNT(*) FROM sys.columns WHERE object_id IN (OBJECT_ID(N'[dbo].[Project]'), OBJECT_ID(N'[dbo].[ProjectFunding]'))
		AND name IN ('IsActive', 'StatusUpdatedBy', 'StatusUpdatedDate')) AS [StatusColumns (expect 6)]
GO

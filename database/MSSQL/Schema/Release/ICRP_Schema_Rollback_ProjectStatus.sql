/*******************************************************************************************/
/******  Project Active/Inactive status (epic NCIATWP-11791, technical story): ROLLBACK ******/
/******  Run on BOTH icrp_data and icrp_dataload. Safe to re-run.                        ******/
/*******************************************************************************************/
-- Removes the procedures from ICRP_Schema_Update_ProjectStatus_Procedures.sql and the columns from
-- ICRP_Schema_Update_ProjectStatus.sql.
--
-- WARNING: dropping the columns discards every project's Active/Inactive status. Once Managers have started
-- inactivating projects, roll back the application code and procedures only, and leave the columns in place:
-- they're additive and harmless to code that doesn't use them.

/*************************************************/
/******	Procedures                         ******/
/*************************************************/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetProjectStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetProjectStatus]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetProjectFundingStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetProjectFundingStatus]
GO

/*************************************************/
/******	Columns: Project                   ******/
/*************************************************/
IF EXISTS (SELECT * FROM sys.default_constraints WHERE name = 'DF_Project_IsActive' AND parent_object_id = OBJECT_ID(N'[dbo].[Project]'))
	ALTER TABLE [dbo].[Project] DROP CONSTRAINT [DF_Project_IsActive]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'IsActive')
	ALTER TABLE [dbo].[Project] DROP COLUMN [IsActive]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'StatusUpdatedBy')
	ALTER TABLE [dbo].[Project] DROP COLUMN [StatusUpdatedBy]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'StatusUpdatedDate')
	ALTER TABLE [dbo].[Project] DROP COLUMN [StatusUpdatedDate]
GO

/*************************************************/
/******	Columns: ProjectFunding            ******/
/*************************************************/
IF EXISTS (SELECT * FROM sys.default_constraints WHERE name = 'DF_ProjectFunding_IsActive' AND parent_object_id = OBJECT_ID(N'[dbo].[ProjectFunding]'))
	ALTER TABLE [dbo].[ProjectFunding] DROP CONSTRAINT [DF_ProjectFunding_IsActive]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'IsActive')
	ALTER TABLE [dbo].[ProjectFunding] DROP COLUMN [IsActive]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'StatusUpdatedBy')
	ALTER TABLE [dbo].[ProjectFunding] DROP COLUMN [StatusUpdatedBy]
GO

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'StatusUpdatedDate')
	ALTER TABLE [dbo].[ProjectFunding] DROP COLUMN [StatusUpdatedDate]
GO

/*************************************************/
/******	Check                              ******/
/*************************************************/
SELECT DB_NAME() AS [Database],
	(SELECT COUNT(*) FROM sys.columns WHERE object_id IN (OBJECT_ID(N'[dbo].[Project]'), OBJECT_ID(N'[dbo].[ProjectFunding]'))
		AND name IN ('IsActive', 'StatusUpdatedBy', 'StatusUpdatedDate')) AS [StatusColumns (expect 0)],
	(SELECT COUNT(*) FROM sys.objects WHERE name IN ('SetProjectStatus', 'SetProjectFundingStatus')) AS [StatusProcedures (expect 0)]
GO

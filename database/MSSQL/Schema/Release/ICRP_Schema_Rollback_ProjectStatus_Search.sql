/*******************************************************************************************/
/******  NCIATWP-11792: ROLLBACK of ICRP_Schema_Update_ProjectStatus_Search.sql          ******/
/******  Run on icrp_data, AFTER restoring the previous procedure definitions (the       ******/
/******  procedures in the PR reference vwActiveProjects). Safe to re-run.               ******/
/*******************************************************************************************/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshSearchSummaryAllProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RefreshSearchSummaryAllProjects]
GO

IF OBJECT_ID(N'[dbo].[vwActiveProjects]', N'V') IS NOT NULL
	DROP VIEW [dbo].[vwActiveProjects]
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ProjectFunding_ProjectID_IsActive' AND object_id = OBJECT_ID(N'[dbo].[ProjectFunding]'))
	DROP INDEX [IX_ProjectFunding_ProjectID_IsActive] ON [dbo].[ProjectFunding]
GO

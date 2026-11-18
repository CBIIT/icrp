/*******************************************************************************************/
/******  NCIATWP-11796: Manager search for Active or Inactive projects                ******/
/******  Run on icrp_data only, BEFORE deploying the changed procedures (they read    ******/
/******  SearchCriteria.ProjectStatus). Undo: ICRP_Schema_Rollback_SearchProjectStatus.sql ****/
/*******************************************************************************************/
-- SearchCriteria.ProjectStatus stores the mode a search was built in:
--   NULL       = Active (every existing search, and every search by a non-manager)
--   'Inactive' = an ICRP Manager's search for inactive projects (NCIATWP-11796)
-- The Search procedures read it for a saved SearchID, so paging, statistics and exports of an Inactive search show
-- inactive projects, and every other search keeps showing active ones only.
--
-- Safe to re-run. Adding a NULLable column with no default is a metadata-only change (no table rewrite).

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'ProjectStatus')
	ALTER TABLE [dbo].[SearchCriteria] ADD [ProjectStatus] VARCHAR(10) NULL
GO

SELECT DB_NAME() AS [Database], COL_LENGTH('dbo.SearchCriteria', 'ProjectStatus') AS [ProjectStatus length (expect 10)]
GO

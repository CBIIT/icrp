/*******************************************************************************************/
/******  Rollback for NCIATWP-11796 (ICRP_Schema_Update_SearchProjectStatus.sql)       ******/
/******  icrp_data only.                                                              ******/
/*******************************************************************************************/
-- FIRST restore the previous versions of the procedures that read SearchCriteria.ProjectStatus (the NCIATWP-11792
-- versions of the Search procedures, GetProjectsByCriteria, AddNewSearchBySearchID and GetSearchCriteriaBySearchID);
-- otherwise they stop compiling once the column is gone. Saved Manager searches for inactive projects then behave as
-- ordinary (Active) searches.
--
-- Safe to re-run.

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'ProjectStatus')
	ALTER TABLE [dbo].[SearchCriteria] DROP COLUMN [ProjectStatus]
GO

SELECT DB_NAME() AS [Database], COL_LENGTH('dbo.SearchCriteria', 'ProjectStatus') AS [ProjectStatus length (expect NULL)]
GO

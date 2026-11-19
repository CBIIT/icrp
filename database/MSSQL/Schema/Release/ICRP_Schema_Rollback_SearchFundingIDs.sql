/*******************************************************************************************/
/******  Rollback for ICRP_Schema_Update_SearchFundingIDs.sql (NCIATWP-11892)          ******/
/******  icrp_data only.                                                              ******/
/*******************************************************************************************/
-- FIRST restore the previous versions of GetProjectsByCriteria, AddNewSearchBySearchID and GetSearchCriteriaBySearchID
-- (the NCIATWP-11796 versions); otherwise they stop compiling once the column is gone.
--
-- Safe to re-run.

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'ProjectFundingIDList')
	ALTER TABLE [dbo].[SearchCriteria] DROP COLUMN [ProjectFundingIDList]
GO

SELECT DB_NAME() AS [Database], COL_LENGTH('dbo.SearchCriteria', 'ProjectFundingIDList') AS [ProjectFundingIDList length (expect NULL)]
GO

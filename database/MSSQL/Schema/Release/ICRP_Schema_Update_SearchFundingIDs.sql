/*******************************************************************************************/
/******  NCIATWP-11892: ICRP Manager search by ProjectFundingID        ******/
/******  Run on icrp_data only, BEFORE deploying GetProjectsByCriteria,               ******/
/******  AddNewSearchBySearchID and GetSearchCriteriaBySearchID (they read the column).  ******/
/******  Undo: ICRP_Schema_Rollback_SearchFundingIDs.sql                               ******/
/*******************************************************************************************/
-- SearchCriteria.ProjectFundingIDList stores the comma-separated ProjectFundingIDs a Manager searched for, so the
-- saved search keeps showing them in the Search Criteria panel and in the search form.
--
-- Safe to re-run. Adding a NULLable column with no default is a metadata-only change (no table rewrite).

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'ProjectFundingIDList')
	ALTER TABLE [dbo].[SearchCriteria] ADD [ProjectFundingIDList] VARCHAR(4000) NULL
GO

SELECT DB_NAME() AS [Database], COL_LENGTH('dbo.SearchCriteria', 'ProjectFundingIDList') AS [ProjectFundingIDList length (expect 4000)]
GO

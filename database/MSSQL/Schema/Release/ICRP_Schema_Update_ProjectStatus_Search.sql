/*******************************************************************************************/
/******  NCIATWP-11792: hide Inactive projects from the public Search ICRP Data page     ******/
/******  Run on icrp_data only, after ICRP_Schema_Update_ProjectStatus.sql (columns).     ******/
/******  Then deploy the changed procedures (see the PR) and the Drupal code.             ******/
/******  Undo: ICRP_Schema_Rollback_ProjectStatus_Search.sql                              ******/
/*******************************************************************************************/
-- Visibility rule used by every search, statistics and export procedure:
--   * a sub-project (ProjectFunding row) is visible when IsActive = 1
--   * a project is visible when IsActive = 1 and it has at least one visible sub-project
--     (a project with no sub-projects at all stays visible, exactly as before)
-- An Inactive parent always has only Inactive sub-projects (SetProjectStatus cascades, and SetProjectFundingStatus won't
-- reactivate a sub-project of an Inactive parent), so filtering sub-projects on IsActive also hides Inactive parents.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*************************************************/
/******	Index: active sub-projects per project ******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ProjectFunding_ProjectID_IsActive' AND object_id = OBJECT_ID(N'[dbo].[ProjectFunding]'))
	CREATE NONCLUSTERED INDEX [IX_ProjectFunding_ProjectID_IsActive] ON [dbo].[ProjectFunding] ([ProjectID], [IsActive])
GO

/*************************************************/
/******	View: projects the public may see    ******/
/*************************************************/
IF OBJECT_ID(N'[dbo].[vwActiveProjects]', N'V') IS NOT NULL
	DROP VIEW [dbo].[vwActiveProjects]
GO

CREATE VIEW [dbo].[vwActiveProjects] AS
SELECT p.ProjectID
FROM dbo.Project p
WHERE p.IsActive = 1
	AND (EXISTS (SELECT 1 FROM dbo.ProjectFunding f WHERE f.ProjectID = p.ProjectID AND f.IsActive = 1)
		OR NOT EXISTS (SELECT 1 FROM dbo.ProjectFunding f WHERE f.ProjectID = p.ProjectID))
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[RefreshSearchSummaryAllProjects]                            ******/
----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RefreshSearchSummaryAllProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[RefreshSearchSummaryAllProjects]
GO

-- Recomputes the cached totals the Search page shows before any filter is applied (SearchResult row 0), the same way an
-- unfiltered GetProjectsByCriteria does. SetProjectStatus and SetProjectFundingStatus call it after every status change,
-- so the default page never shows numbers that still include Inactive projects. Returns no result set.
CREATE PROCEDURE [dbo].[RefreshSearchSummaryAllProjects]
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ResultCount INT, @TotalRelatedProjectCount INT, @LastBudgetYear INT;

	SELECT @ResultCount = COUNT(DISTINCT v.ProjectID),
		@TotalRelatedProjectCount = COUNT(DISTINCT v.ProjectFundingID),
		@LastBudgetYear = DATEPART(year, MAX(v.BudgetEndDate))
	FROM vwProjectFundings v
		JOIN Project ap ON ap.ProjectID = v.ProjectID AND ap.IsActive = 1
		JOIN ProjectFunding af ON af.ProjectFundingID = v.ProjectFundingID AND af.IsActive = 1;

	UPDATE SearchResult
	SET Results = NULL, ResultCount = @ResultCount, TotalRelatedProjectCount = @TotalRelatedProjectCount,
		LastBudgetYear = @LastBudgetYear, IsEmailSent = 0
	WHERE SearchCriteriaID = 0;
END
GO

/*************************************************/
/******	Check                              ******/
/*************************************************/
SELECT DB_NAME() AS [Database],
	(SELECT COUNT(*) FROM sys.objects WHERE name IN ('vwActiveProjects', 'RefreshSearchSummaryAllProjects')) AS [Objects (expect 2)],
	(SELECT COUNT(*) FROM dbo.vwActiveProjects) AS [VisibleProjects],
	(SELECT COUNT(*) FROM dbo.Project) AS [AllProjects]
GO

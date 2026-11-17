/*******************************************************************************************/
/******  Project Active/Inactive status (epic NCIATWP-11791, technical story)          ******/
/******  Part 2 of 2: procedures. Run on icrp_data only, after part 1                   ******/
/******  (ICRP_Schema_Update_ProjectStatus.sql). Undo: ICRP_Schema_Rollback_ProjectStatus.sql ******/
/*******************************************************************************************/
-- Status is only ever changed on the live data (icrp_data). Both procedures:
--   * take a comma-separated list of IDs, e.g. '101,102,103'; unknown IDs are ignored
--   * record who (@ChangedBy, the Manager's Drupal user name, supplied by the server, never by the browser) and when
--   * only touch rows whose status actually changes, so repeating a request keeps the original who/when
--   * return one row: ProjectsUpdated, SubProjectsUpdated
--
-- Cached search results (SearchResultProject) are deliberately left alone: the search, statistics, map and export
-- procedures read Project/ProjectFunding when they run, and NCIATWP-11792/11793 apply the IsActive filter there, so a
-- status change shows up without breaking searches that users already have open. Only the cached unfiltered totals
-- (SearchResult row 0) are recomputed, by RefreshSearchSummaryAllProjects once NCIATWP-11792 has added it.

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[SetProjectStatus]                                           ******/
----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetProjectStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetProjectStatus]
GO

-- Sets the status of base/parent projects AND all of their sub-projects, in both directions:
-- inactivating a parent inactivates every sub-project; reactivating a parent reactivates every sub-project,
-- including any a Manager had inactivated individually (the Manager adjusts those on the parent's page afterwards).
CREATE PROCEDURE [dbo].[SetProjectStatus]
	@ProjectIDs VARCHAR(MAX),     -- comma-separated base/parent ProjectIDs
	@IsActive BIT,                -- 1 = Active, 0 = Inactive
	@ChangedBy NVARCHAR(100)      -- Drupal user name of the ICRP Manager making the change
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF @IsActive IS NULL OR NULLIF(LTRIM(RTRIM(@ChangedBy)), N'') IS NULL
		THROW 50001, 'SetProjectStatus: @IsActive and @ChangedBy are required.', 1;

	DECLARE @ids TABLE (ProjectID INT PRIMARY KEY);
	INSERT INTO @ids (ProjectID)
		SELECT DISTINCT [Value] FROM dbo.ToIntTable(@ProjectIDs) WHERE [Value] > 0;

	DECLARE @now DATETIME = GETDATE(), @projects INT, @subProjects INT;

	BEGIN TRANSACTION;

	UPDATE p SET IsActive = @IsActive, StatusUpdatedBy = @ChangedBy, StatusUpdatedDate = @now
	FROM dbo.Project p
		JOIN @ids i ON i.ProjectID = p.ProjectID
	WHERE p.IsActive <> @IsActive;
	SET @projects = @@ROWCOUNT;

	UPDATE f SET IsActive = @IsActive, StatusUpdatedBy = @ChangedBy, StatusUpdatedDate = @now
	FROM dbo.ProjectFunding f
		JOIN @ids i ON i.ProjectID = f.ProjectID
	WHERE f.IsActive <> @IsActive;
	SET @subProjects = @@ROWCOUNT;

	COMMIT TRANSACTION;

	-- Keep the Search page's default totals current (procedure added by NCIATWP-11792; skipped until it exists)
	IF @projects + @subProjects > 0 AND OBJECT_ID(N'dbo.RefreshSearchSummaryAllProjects', N'P') IS NOT NULL
		EXEC dbo.RefreshSearchSummaryAllProjects;

	SELECT @projects AS ProjectsUpdated, @subProjects AS SubProjectsUpdated;
END
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[SetProjectFundingStatus]                                    ******/
----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SetProjectFundingStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SetProjectFundingStatus]
GO

-- Sets the status of individual sub-projects (ProjectFunding rows). The parent project's status never changes here:
-- a parent stays Active unless a Manager inactivates it. Sub-projects of an Inactive parent can't be reactivated
-- individually (reactivate the parent instead); such requests are skipped.
CREATE PROCEDURE [dbo].[SetProjectFundingStatus]
	@ProjectFundingIDs VARCHAR(MAX),  -- comma-separated ProjectFundingIDs
	@IsActive BIT,                    -- 1 = Active, 0 = Inactive
	@ChangedBy NVARCHAR(100)          -- Drupal user name of the ICRP Manager making the change
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF @IsActive IS NULL OR NULLIF(LTRIM(RTRIM(@ChangedBy)), N'') IS NULL
		THROW 50001, 'SetProjectFundingStatus: @IsActive and @ChangedBy are required.', 1;

	DECLARE @ids TABLE (ProjectFundingID INT PRIMARY KEY);
	INSERT INTO @ids (ProjectFundingID)
		SELECT DISTINCT [Value] FROM dbo.ToIntTable(@ProjectFundingIDs) WHERE [Value] > 0;

	DECLARE @subProjects INT;

	UPDATE f SET IsActive = @IsActive, StatusUpdatedBy = @ChangedBy, StatusUpdatedDate = GETDATE()
	FROM dbo.ProjectFunding f
		JOIN @ids i ON i.ProjectFundingID = f.ProjectFundingID
		JOIN dbo.Project p ON p.ProjectID = f.ProjectID
	WHERE f.IsActive <> @IsActive
		AND (@IsActive = 0 OR p.IsActive = 1);
	SET @subProjects = @@ROWCOUNT;

	-- Keep the Search page's default totals current (procedure added by NCIATWP-11792; skipped until it exists)
	IF @subProjects > 0 AND OBJECT_ID(N'dbo.RefreshSearchSummaryAllProjects', N'P') IS NOT NULL
		EXEC dbo.RefreshSearchSummaryAllProjects;

	SELECT 0 AS ProjectsUpdated, @subProjects AS SubProjectsUpdated;
END
GO

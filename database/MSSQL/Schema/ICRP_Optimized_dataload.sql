USE [icrp_dataload]
GO

-- Drop indexes if they exist
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SearchResultProject_CreatedDate' AND object_id = OBJECT_ID('SearchResultProject'))
    DROP INDEX IX_SearchResultProject_CreatedDate ON SearchResultProject;

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SearchResultProject_SearchCriteriaID_ProjectID' AND object_id = OBJECT_ID('SearchResultProject'))
    DROP INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID ON SearchResultProject;

-- Drop table if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchResultProject]') AND type in (N'U'))
    DROP TABLE [dbo].[SearchResultProject];

-- Create the table
CREATE TABLE SearchResultProject
(
   SearchCriteriaID INT,
    ProjectID INT,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

-- Create indexes
CREATE INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID
ON SearchResultProject (SearchCriteriaID, ProjectID);

CREATE INDEX IX_SearchResultProject_CreatedDate
ON SearchResultProject (CreatedDate);

/**************/

/****** Object:  StoredProcedure [dbo].[GetProjectsByDataUploadID]    Script Date: 8/14/2025 1:26:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByDataUploadID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectsByDataUploadID]
GO

CREATE PROCEDURE [dbo].[GetProjectsByDataUploadID]
    @PageSize int = NULL, -- return all by default
	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @DataUploadID INT,    
	@searchCriteriaID INT OUTPUT,  -- return the searchID	
	@ResultCount INT OUTPUT  -- return the searchID		
AS   

	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	SELECT ProjectID, ProjectFundingID, BudgetEndDate  INTO #import FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadID
	SELECT @TotalRelatedProjectCount = COUNT(*) FROM #import
	SELECT @LastBudgetYear = DATEPART(year, MAX(BudgetEndDate)) FROM #import
		
	------------------------------------------------------
	-- Get all imported projects/projectfunding by DataUploadStatusID
	------------------------------------------------------	
	SELECT ProjectID, MIN(ProjectFundingID) AS ProjectFundingID INTO #base FROM #import GROUP BY ProjectID 
	SELECT @ResultCount = COUNT(*) FROM #base	

	----------------------------------
	-- Save search criteria
	----------------------------------			
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	
	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #base	

	INSERT INTO SearchCriteria (SearchDate) VALUES (getdate())

										 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()	

	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	

	INSERT INTO SearchResultProject (SearchCriteriaID, ProjectID)
	SELECT @searchCriteriaID, ProjectID
	FROM #base

	--------------------------------------------------------------------	
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------
	SELECT r.ProjectID, p.AwardCode, r.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID		 
		 JOIN ProjectFunding f ON r.ProjectFundingID = f.projectFundingID
		 JOIN  (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID
		 JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		 JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN f.Title  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN p.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN f.Title  END DESC,
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN p.AwardCode  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.LastName  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.FirstName  END DESC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN i.Name END DESC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN i.City  END DESC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN i.State  END DESC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN i.Country  END DESC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN o.Abbreviation  END DESC
	OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
	FETCH NEXT 
		CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
		END ROWS ONLY		
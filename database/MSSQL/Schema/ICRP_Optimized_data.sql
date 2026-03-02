/***
   This stored procedure retrieves all projects associated with a specific DataUploadID.
GetProjectsByCriteria
GetProjectExportsBySearchID
GetProjectsBySearchID (for sorting, update country name)
GetProjectCSOsBySearchID
GetProjectCancerTypesBySearchID
GetProjectCollaboratorsBysearchID
AddNewSearchBySearchID

-- 7 pie charts for ICRP
-- GetProjectCancerTypeStatsBySearchID
-- GetProjectCountryStatsBySearchID
-- GetProjectTypeStatsBySearchID
-- GetProjectCSOStatsBySearchID
-- GetProjectChildhoodCancerStatsBySearchID
-- GetProjectFundingOrgStatsBySearchID
-- GetProjectInstitutionStatsBySearchID

 -- 7 pie charts for base 
-- GetProjectCancerTypeStatsBySearchIDBase
-- GetProjectCountryStatsBySearchIDBase
-- GetProjectTypeStatsBySearchIDBase
-- GetProjectCSOStatsBySearchIDBase
-- GetProjectChildhoodCancerStatsBySearchIDBase
-- GetProjectFundingOrgStatsBySearchIDBase
-- GetProjectInstitutionStatsBySearchIDBase

***/
USE [icrp_data]
GO					  
    											  
/*****************************/
-- Drop indexes if they exist
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SearchResultProject_CreatedDate' AND object_id = OBJECT_ID('SearchResultProject'))
    DROP INDEX IX_SearchResultProject_CreatedDate ON SearchResultProject;

IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SearchResultProject_SearchCriteriaID_ProjectID' AND object_id = OBJECT_ID('SearchResultProject'))
    DROP INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID ON SearchResultProject;

-- Drop table if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SearchResultProject]') AND type in (N'U'))
    DROP TABLE [dbo].[SearchResultProject];

CREATE TABLE SearchResultProject
(
   SearchCriteriaID INT,
    ProjectID INT,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
CREATE INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID
ON SearchResultProject (SearchCriteriaID, ProjectID);

CREATE INDEX IX_SearchResultProject_CreatedDate
ON SearchResultProject (CreatedDate);
/***********************/
/****** Object:  StoredProcedure [dbo].[GetProjectsByCriteria]    Script Date: 8/14/2025 1:28:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByCriteria]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectsByCriteria]
GO

CREATE PROCEDURE [dbo].[GetProjectsByCriteria]    
	@PageSize int = 50, -- return all by default
	@PageNumber int = 1, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO', city, state, country ....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @termSearchType varchar(25) = NULL,  -- No full text search by default; otherwise 'Any', 'None', 'All', 'Exact'
	@terms varchar(4000) = NULL,  -- No full text search by default;
	@InvestigatorType varchar(250) = NULL, -- No full text search by default; otherwise 'All', 'PI', 'Collab'
	@institution varchar(250) = NULL,
	@piLastName varchar(50) = NULL,
	@piFirstName varchar(50) = NULL,
	@piORCiD varchar(50) = NULL,
	@awardCode varchar(50) = NULL,
	@yearList varchar(1000) = NULL, 
	@cityList varchar(1000) = NULL, 
	@stateList varchar(1000) = NULL,
	@countryList varchar(1000) = NULL,
	@regionList varchar(100) = NULL,
	@incomeGroupList varchar(1000) = NULL,
	@FundingOrgTypeList varchar(50) = NULL,
	@fundingOrgList varchar(1000) = NULL, 
	@cancerTypeList varchar(1000) = NULL, 
	@projectTypeList varchar(1000) = NULL,
	@CSOList varchar(1000) = NULL,	
	@ChildhoodCancerList varchar(1000) = NULL,	  -- 0: no childhood, 1: childhood, 2: partially childhood
	@searchCriteriaID INT OUTPUT,  -- return the searchID	
	@ResultCount INT OUTPUT  -- return the searchID	
	
	
AS   
	DECLARE @IsFiltered bit = 0
	
	IF @InvestigatorType = 'All'
		SELECT @InvestigatorType = NULL

	----------------------------------
	-- Get all Projects 
	----------------------------------
	SELECT * INTO #projFunding  FROM vwProjectFundings   -- All project funding records including PI and collaborator
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding institutions and PI do NOT meet the criteria
	-------------------------------------------------------------------------
	IF (@InvestigatorType IS NOT NULL)
	BEGIN	
		SET @IsFiltered = 1	

		DELETE FROM #projFunding WHERE (@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND IsPrincipalInvestigator = 0) OR (@InvestigatorType = 'Collab' AND IsPrincipalInvestigator = 1)   -- Search only PI, Collaborators or all			   
		
	END
	

	SELECT * INTO #childhoodcancer FROM dbo.ToIntTable(@ChildhoodCancerList)

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@awardCode IS NOT NULL) OR (@ChildhoodCancerList IS NOT NULL)
	BEGIN	
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 
			(SELECT ProjectFundingID FROM #projFunding WHERE 
					((@institution IS NULL) OR (institution like '%'+ @institution +'%')) AND					
					((@piLastName IS NULL) OR (piLastName like '%'+ @piLastName +'%')) AND 
				   ((@piFirstName IS NULL) OR (piFirstName like '%'+ @piFirstName +'%')) AND
				   ((@piORCiD IS NULL) OR (piORCiD like '%'+ @piORCiD +'%')) AND
				   ((@awardCode IS NULL) OR (AwardCode like '%'+ @awardCode +'%')) AND				   
				   ((@ChildhoodCancerList IS NULL) OR (IsChildhood IN (SELECT value from #childhoodcancer)))			   
			)
	END
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI City do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @cityList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 
			(SELECT ProjectFundingID FROM #projFunding WHERE city IN (SELECT * FROM dbo.ToStrTable(@cityList)))		
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI State do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @stateList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE [State] IN (SELECT * FROM dbo.ToStrTable(@stateList)))				
	END	

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI Country do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @countryList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE [Country] IN (SELECT * FROM dbo.ToStrTable(@countryList)))				
	END
	
	-------------------------------------------------------------------------
	-- Exclude the projects which income groups do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @incomeGroupList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding pf JOIN 
			 CountryMapLayer cm ON pf.country = cm.Country WHERE cm.value IN (SELECT * FROM dbo.ToStrTable(@incomeGroupList)))				
	END
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI Region do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @regionList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE RegionID NOT IN 			
			(SELECT RegionID FROM #projFunding WHERE [RegionID] IN (SELECT * FROM dbo.ToIntTable(@regionList)))				
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org type do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE FundingOrgType IN (SELECT * FROM dbo.ToStrTable(@FundingOrgTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgList IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@fundingOrgList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @cancerTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT p.ProjectFundingID FROM #projFunding p
			JOIN ProjectCancerType ct ON p.ProjectFundingID = ct.ProjectFundingID WHERE CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))

	END

	-------------------------------------------------------------------------
	-- Exclude the projects which ProjectType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @projectTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
			JOIN Project_ProjectType pt WITH (NOLOCK) ON p.ProjectID = pt.ProjectID WHERE ProjectType IN (SELECT * FROM dbo.ToStrTable(@projectTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CSO do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @CSOList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT p.ProjectFundingID FROM #projFunding p
				JOIN ProjectCSO cso WITH (NOLOCK) ON p.ProjectFundingID = cso.ProjectFundingID WHERE CSOCode IN (SELECT * FROM dbo.ToStrTable(@CSOList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Years do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @yearList IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT DISTINCT f.ProjectFundingID FROM #projFunding f
				--JOIN ProjectFunding f ON p.projectID = f.ProjectID
				JOIN ProjectFundingExt ext WITH (NOLOCK) ON f.ProjectFundingID = ext.ProjectFundingID WHERE [CalendarYear] IN (SELECT * FROM dbo.ToIntTable(@yearList)))
	END	
	
	-------------------------------------------------------------------------
	-- Terms Search Filter
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF (@termSearchType IS NOT NULL) AND (@terms IS NOT NULL)
	BEGIN
		SET @IsFiltered = 1	

		DECLARE @searchWords VARCHAR(1000)

		SELECT @searchWords = 
		CASE @termSearchType
			WHEN 'Exact' THEN '"'+ @terms + '"'
			WHEN 'Any' THEN REPLACE(@terms,' ',' OR ')
			ELSE REPLACE(@terms,' ',' AND ') -- All or None	
		END 		

		IF (@termSearchType = 'None')  ---- do not contain any words specified		
		BEGIN
			DELETE FROM #projFunding WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
				JOIN ProjectSearch s ON p.projectID = s.ProjectID  			
			 WHERE NOT CONTAINS(s.content, @searchWords)
			)
		END

		ELSE 
		 ---- Contain Any, All or Exeact words
		BEGIN
			DELETE FROM #projFunding WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
				LEFT JOIN ProjectSearch s ON p.projectID = s.ProjectID  
			WHERE CONTAINS(s.content, @searchWords)
			)
		END		
				
	END	

	----------------------------------
	-- Retrieve Result counts
	----------------------------------	
	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	--SELECT DISTINCT ProjectID, AwardCode INTO #baseProj FROM #projFunding	
	
	-- Find out the base project: if Category = parent, otherwise the first projectfunding inserted
	SELECT DISTINCT ProjectID, AwardCode, 99999 AS ProjectFundingID		
	INTO #baseProj 
	FROM #projFunding
	
-- 	update #baseProj
-- 	SET ProjectFundingID =
-- 		CASE p.projectfundingID
-- 			WHEN NULL THEN f.ProjectFundingID
-- 			ELSE p.ProjectFundingID
-- 		END
-- 	from #baseProj b
-- 	JOIN  (SELECT projectid, projectfundingID FROM #projFunding WHERE Category='parent') p ON b.ProjectID = p.ProjectID
-- 	JOIN  (SELECT ProjectID, MIN(projectfundingID) AS projectfundingID FROM projectfunding GROUP BY ProjectID) f ON b.ProjectID = f.ProjectID

--  This update needs to be split into two steps, since there are funding organizations containing 0 parent projects (meaning the join will return 0 records)
    -- set the project funding id to the first funding id in the projects table
	update #baseProj
	SET ProjectFundingID = f.ProjectFundingID
	from #baseProj b
	JOIN  (SELECT ProjectID, MIN(projectfundingID) AS projectfundingID FROM projectfunding GROUP BY ProjectID) f ON b.ProjectID = f.ProjectID

    -- if a parent project exists, overwrite the project funding id
    update #baseProj
	SET ProjectFundingID = p.ProjectFundingID
	from #baseProj b
	JOIN  (SELECT projectid, projectfundingID FROM #projFunding WHERE Category='parent') p ON b.ProjectID = p.ProjectID

	SELECT @ResultCount=COUNT(*) FROM #baseProj	
	SELECT @TotalRelatedProjectCount=COUNT(*) FROM (SELECT DISTINCT ProjectFundingID FROM #projFunding) u	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #projFunding	

	----------------------------------
	-- Save search criteria
	----------------------------------	
	SET @searchCriteriaID = 0  -- no filters
	

	IF @IsFiltered = 1   -- Only record search criteria if filtered
	BEGIN		
		DECLARE @ProjectIDList VARCHAR(max) = '' 	

		SELECT @ProjectIDList = @ProjectIDList + 
			   ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
		FROM #baseProj	

		INSERT INTO SearchCriteria ([termSearchType],[terms],[institution],[piLastName],[piFirstName],[piORCiD],[awardCode],
			[yearList], [cityList],[stateList],[countryList],[incomeGroupList],[regionList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [ChildhoodCancerList], [InvestigatorType])
			VALUES ( @termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@yearList,@cityList,@stateList,@countryList,@incomeGroupList,@regionList,
				@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList, @FundingOrgTypeList,	@ChildhoodCancerList, @InvestigatorType)
									 
		SELECT @searchCriteriaID = SCOPE_IDENTITY()		

		INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
		INSERT INTO SearchResultProject (SearchCriteriaID, ProjectID) SELECT @searchCriteriaID AS SearchCriteriaID, ProjectID FROM #projFunding;
 
	END
	ELSE
	BEGIN
		UPDATE SearchResult SET Results = NULL,ResultCount=@ResultCount, TotalRelatedProjectCount=@TotalRelatedProjectCount, LastBudgetYear=@LastBudgetYear, IsEmailSent=0 WHERE SearchCriteriaID =0
	END
	
	
	--------------------------------------------------------------------
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------vvvv
	SELECT base.ProjectID, base.AwardCode, base.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName,
	 pi.ORC_ID AS piORCiD, i.Name AS institution, f.Amount, i.City, i.State, i.country,  c.name as CountryName, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort
	FROM #baseProj base
		JOIN (SELECT ProjectID, MIN(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding GROUP BY ProjectID) maxf ON base.ProjectID = maxf.ProjectID
		JOIN ProjectFunding f ON base.ProjectFundingID = f.ProjectFundingID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
		JOIN (SELECT * FROM ProjectFundingInvestigator  WHERE IsPrincipalInvestigator = 1) pi ON pi.ProjectFundingID = base.ProjectFundingID
		JOIN Institution i ON pi.InstitutionID = i.InstitutionID
           JOIN Country c on c.Abbreviation = i.Country
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) END ASC,
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN base.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,		
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) END DESC,
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN base.AwardCode  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.LastName  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.FirstName  END DESC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN i.Name END DESC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN i.City  END DESC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN i.State  END DESC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN i.Country  END DESC,		
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN o.Abbreviation END DESC
	OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
	FETCH NEXT 
		CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
		END ROWS ONLY


/************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectExportsBySearchID]    Script Date: 8/14/2025 1:29:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectExportsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectExportsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectExportsBySearchID]
    @SearchID INT,
    @IncludeAbstract INT = 0,
    @SiteURL VARCHAR(250) = 'https://www.icrpartnership.org/project/',
    @Year SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
    DECLARE @CountryList VARCHAR(1000) = NULL,
            @IncomeGroupList VARCHAR(1000) = NULL,
            @CityList VARCHAR(1000) = NULL,
            @StateList VARCHAR(1000) = NULL,
            @RegionList VARCHAR(100) = NULL,
            @YearList VARCHAR(1000) = NULL,
            @CSOList VARCHAR(1000) = NULL,
            @CancerTypeList VARCHAR(1000) = NULL,
            @InvestigatorType VARCHAR(250) = NULL,
            @Institution VARCHAR(250) = NULL,
            @PiLastName VARCHAR(50) = NULL,
            @PiFirstName VARCHAR(50) = NULL,
            @PiORCiD VARCHAR(50) = NULL,
            @FundingOrgTypeList VARCHAR(50) = NULL,
            @FundingOrgList VARCHAR(1000) = NULL,
            @ChildhoodCancerList VARCHAR(1000) = NULL;

    -- Set default year if not provided
    IF @Year IS NULL
        SELECT @Year = MAX(Year) FROM CurrencyRate;

    -- Retrieve search criteria
    SELECT @YearList = YearList,
           @CountryList = CountryList,
           @IncomeGroupList = IncomeGroupList,
           @CSOList = CSOList,
           @CancerTypeList = CancerTypeList,
           @InvestigatorType = InvestigatorType,
           @Institution = Institution,
           @PiLastName = PiLastName,
           @PiFirstName = PiFirstName,
           @PiORCiD = PiORCiD,
           @CityList = CityList,
           @StateList = StateList,
           @RegionList = RegionList,
           @FundingOrgTypeList = FundingOrgTypeList,
           @FundingOrgList = FundingOrgList,
           @ChildhoodCancerList = ChildhoodCancerList
    FROM SearchCriteria
    WHERE SearchCriteriaID = @SearchID;

    -- Filter projects based on SearchID
    CREATE TABLE #base (ProjectID INT);
    IF @SearchID = 0
    BEGIN
        INSERT INTO #base SELECT ProjectID FROM Project
    END
    ELSE
    BEGIN
        ;WITH FilteredSearchResult AS (
            SELECT DISTINCT srp.ProjectID
            FROM SearchResultProject srp
            WHERE srp.SearchCriteriaID = @SearchID
        )
        INSERT INTO #base
        SELECT ProjectID
        FROM FilteredSearchResult
    END

    -- Retrieve project funding details
    SELECT DISTINCT 
        p.ProjectID,
        f.ProjectFundingID,
        f.Title AS AwardTitle,
        CAST(NULL AS VARCHAR(100)) AS AwardType,
        p.AwardCode,
        f.Source_ID,
        f.AltAwardCode,
        f.Category AS FundingCategory,
        CASE f.IsChildhood 
            WHEN 1 THEN 'Yes' 
            WHEN 2 THEN 'Partially' 
            WHEN 0 THEN 'No' 
            ELSE '' 
        END AS IsChildhood,
        p.ProjectStartDate AS AwardStartDate,
        p.ProjectEndDate AS AwardEndDate,
        f.BudgetStartDate,
        f.BudgetEndDate,
        CAST(f.Amount AS DECIMAL(18, 2)) AS AwardAmount,
        CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator,
        o.Currency,
        f.MechanismTitle AS FundingMechanism,
        f.MechanismCode AS FundingMechanismCode,
        o.SponsorCode,
        o.Name AS FundingOrg,
        o.Type AS FundingOrgType,
        d.Name AS FundingDiv,
        d.Abbreviation AS FundingDivAbbr,
        f.FundingContact,
        pi.LastName AS PiLastName,
        pi.FirstName AS PiFirstName,
        pi.ORC_ID AS PiORCID,
        i.Name AS Institution,
        i.City,
        i.State,
        i.Country,
        l.Name AS Region,
        @SiteURL + CAST(p.ProjectID AS VARCHAR(10)) AS ICRPURL,
        CASE WHEN @IncludeAbstract = 1 THEN a.TechAbstract ELSE NULL END AS TechAbstract
    INTO #pf
    FROM #base r
    JOIN Project p ON r.ProjectID = p.ProjectID
    JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
    JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
    JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID AND pi.IsPrincipalInvestigator = 1
    JOIN Institution i ON i.InstitutionID = pi.InstitutionID
    JOIN CountryMapLayer cm ON i.Country = cm.Country
    JOIN Country c ON c.Abbreviation = i.Country
    JOIN lu_Region l ON c.RegionID = l.RegionID
    LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
    LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
    WHERE (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%')
      AND (@InvestigatorType IS NULL OR 
           (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR 
           (@InvestigatorType = 'Collab' AND pi.IsPrincipalInvestigator = 0))
      AND (@PiLastName IS NULL OR pi.LastName LIKE '%' + @PiLastName + '%')
      AND (@PiFirstName IS NULL OR pi.FirstName LIKE '%' + @PiFirstName + '%')
      AND (@PiORCiD IS NULL OR pi.ORC_ID LIKE '%' + @PiORCiD + '%')
      AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
      AND (@IncomeGroupList IS NULL OR cm.[VALUE] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
      AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
      AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
      AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
      AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    -- Apply Year, CSO, and CancerType filters
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT ext.ProjectFundingID
            FROM ProjectFundingExt ext
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    IF @CSOList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT pc.ProjectFundingID
            FROM ProjectCSO pc
            WHERE pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
        );
    END;

    IF @CancerTypeList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT pct.ProjectFundingID
            FROM ProjectCancerType pct
            WHERE pct.CancerTypeID IN (
                SELECT CancerTypeID
                FROM dbo.ToIntTable(@CancerTypeList)
            )
        );
    END;

    -- Update AwardType with concatenated ProjectTypes
UPDATE pf 
SET AwardType = pt.AwardTypes
FROM #pf pf
JOIN (
    SELECT ProjectID,
           STUFF((
               SELECT ', ' + CAST(pt2.ProjectType AS NVARCHAR(50))
               FROM Project_ProjectType pt2
               WHERE pt2.ProjectID = pt1.ProjectID
               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS AwardTypes
    FROM Project_ProjectType pt1
    GROUP BY ProjectID
) pt ON pf.ProjectID = pt.ProjectID;


    -- Generate dynamic pivot query
    DECLARE @SQLQuery NVARCHAR(MAX),
            @PivotColumns NVARCHAR(MAX);

    SELECT @PivotColumns = STRING_AGG(QUOTENAME(CalendarYear), ',')
    FROM (
        SELECT DISTINCT CalendarYear
        FROM ProjectFundingExt
        
        WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #pf)
    ) AS Years;

    SET @SQLQuery = '
    SELECT * FROM (
        SELECT
            pf.ProjectID as ICRPProjectID,
            pf.ProjectFundingID as ICRPProjectFundingID,
            pf.AwardTitle,
            pf.AwardType,
            pf.AwardCode,
            pf.Source_ID,
            pf.AltAwardCode,
            pf.FundingCategory,
            pf.IsChildhood,
            pf.AwardStartDate,
            pf.AwardEndDate,
            pf.BudgetStartDate,
            pf.BudgetEndDate,
            pf.AwardAmount,
            pf.Currency,
            pf.FundingIndicator,
            pf.FundingMechanism,
            pf.FundingMechanismCode,
            pf.SponsorCode,
            pf.FundingOrg,
            pf.FundingOrgType,
            pf.FundingDiv,
            pf.FundingDivAbbr,
            pf.FundingContact,
            pf.PiLastName,
            pf.PiFirstName,
            pf.PiORCID,
            pf.Institution,
            pf.City,
            pf.State,
            pf.Country,
            pf.Region,
            pf.ICRPURL' +
            CASE WHEN @IncludeAbstract = 1 THEN ', pf.TechAbstract' ELSE '' END + ' as icrpURL,
            ext.CalendarYear,
            ext.CalendarAmount
        FROM #pf pf
        JOIN ProjectFundingExt ext ON pf.ProjectFundingID = ext.ProjectFundingID
    ) AS SourceTable
    PIVOT (
        SUM(CalendarAmount)
        FOR CalendarYear IN (' + @PivotColumns + ')
    ) AS PivotTable;';

    EXEC sp_executesql @SQLQuery;

    -- Cleanup
    DROP TABLE IF EXISTS #base, #pf;
END;
/******************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectsBySearchID]    Script Date: 8/14/2025 1:30:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectsBySearchID]
    @PageSize int = 50, -- return all by default
	@PageNumber int = 1, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

    -- Insert distinct ProjectID values into the table variable
    INSERT INTO @Result (ProjectID)
    SELECT DISTINCT srp.ProjectID
    FROM SearchResultProject srp
    WHERE srp.SearchCriteriaID = @SearchID;

	DECLARE @ProjectIDs VARCHAR(max) 
	IF @SearchID = 0
	BEGIN
        INSERT INTO @Result SELECT DISTINCT ProjectID From Project
		SELECT @ResultCount = COUNT(*) FROM @Result
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
	END

	SELECT ProjectID INTO #base FROM @Result

	--------------------------------------------------------------------
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------
	SELECT r.ProjectID, p.AwardCode, minf.projectfundingID AS LastProjectFundingID,LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) AS Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, c.name as CountryName, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID
		JOIN (SELECT ProjectID, MIN(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding f GROUP BY ProjectID) minf ON r.ProjectID = minf.ProjectID
		JOIN ProjectFunding f ON minf.ProjectFundingID = f.projectFundingID
		JOIN  (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
		 JOIN Country c on c.Abbreviation = i.Country
	ORDER BY 
		CASE WHEN @SortCol = 'title' AND @SortDirection = 'ASC' THEN  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), '')))  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN p.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title' AND @SortDirection = 'DESC' THEN  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), '')))  END DESC,
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
    											  
/******************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCSOsBySearchID]    Script Date: 8/14/2025 1:31:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSOsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCSOsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCSOsBySearchID]
      @SearchID INT
AS   
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
      -- Filter projects based on SearchID
	  CREATE TABLE #base (ProjectID INT);
   IF @SearchID = 0
    BEGIN
        INSERT INTO #base SELECT ProjectID FROM Project
    END
    ELSE
    BEGIN
        ;WITH FilteredSearchResult AS (
            SELECT DISTINCT srp.ProjectID
            FROM SearchResultProject srp
            WHERE srp.SearchCriteriaID = @SearchID
        )
        INSERT INTO #base
        SELECT ProjectID
        FROM FilteredSearchResult
    END

	DECLARE @ProjectIDs VARCHAR(max) 

	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		

		SELECT 	@YearList = YearList,
			@CountryList = CountryList,
			@incomeGroupList = IncomeGroupList,
			@CSOlist = CSOlist,
			@CancerTypelist = CancerTypelist,
			@InvestigatorType = InvestigatorType,
			@institution = institution,
			@piLastName = piLastName,
			@piFirstName = piFirstName,
			@piORCiD = piORCiD,
			@cityList = cityList,
			@stateList = stateList,
			@regionList = regionList,
			@FundingOrgTypeList = FundingOrgTypeList,
			@fundingOrgList = fundingOrgList,
			@childhoodcancerList = childhoodcancerList
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
	WHERE (@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList)))	

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@incomeGroupList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@countryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList))))  AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))
			)	

	-----------------------------------------------------------		
	--  Get project CSOs
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, cso.CSOCode, cso.Relevance AS CSORelevance	
	FROM #pf pf		
		JOIN ProjectCSO cso ON pf.ProjectFundingID = cso.ProjectFundingID
	ORDER BY pf.ProjectID
	

/*************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypesBySearchID]    Script Date: 8/14/2025 1:32:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypesBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCancerTypesBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCancerTypesBySearchID]
     @SearchID INT	
	 
AS  
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	
	DECLARE @ProjectIDs VARCHAR(max) 

	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL 
      -- Filter projects based on SearchID
CREATE TABLE #base (ProjectID INT);
   IF @SearchID = 0
    BEGIN
        INSERT INTO #base SELECT ProjectID FROM Project
    END
    ELSE
    BEGIN
        ;WITH FilteredSearchResult AS (
            SELECT DISTINCT srp.ProjectID
            FROM SearchResultProject srp
            WHERE srp.SearchCriteriaID = @SearchID
        )
        INSERT INTO #base
        SELECT ProjectID
        FROM FilteredSearchResult
    END
	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

		SELECT 	@YearList = YearList,
			@CountryList = CountryList,
			@incomeGroupList = IncomeGroupList,
			@CSOlist = CSOlist,
			@CancerTypelist = CancerTypelist,
			@InvestigatorType = InvestigatorType,
			@institution = institution,
			@piLastName = piLastName,
			@piFirstName = piFirstName,
			@piORCiD = piORCiD,
			@cityList = cityList,
			@stateList = stateList,
			@regionList = regionList,
			@FundingOrgTypeList = FundingOrgTypeList,
			@fundingOrgList = fundingOrgList,
			@childhoodcancerList = childhoodcancerList
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
	WHERE (@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList)))
	
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@incomeGroupList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))
			)	
							 
	-----------------------------------------------------------		
	--  Get project CancerTypes
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, ct.ICRPCode, ct.Name AS CancerType, pct.Relevance AS Relevance
	FROM #pf pf		
		JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pct ON pf.ProjectFundingID = pct.ProjectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
	ORDER BY pf.ProjectID
	
/***************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCollaboratorsBysearchID]    Script Date: 8/14/2025 1:33:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCollaboratorsBysearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCollaboratorsBysearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCollaboratorsBysearchID]   
    @SearchID INT
AS   
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	


	DECLARE @ProjectIDs VARCHAR(max) 

	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL	
	
          -- Filter projects based on SearchID
CREATE TABLE #base (ProjectID INT);
   IF @SearchID = 0
    BEGIN
        INSERT INTO #base SELECT ProjectID FROM Project
    END
    ELSE
    BEGIN
        ;WITH FilteredSearchResult AS (
            SELECT DISTINCT srp.ProjectID
            FROM SearchResultProject srp
            WHERE srp.SearchCriteriaID = @SearchID
        )
        INSERT INTO #base
        SELECT ProjectID
        FROM FilteredSearchResult
    END
	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
	
		SELECT 	@YearList = YearList,
			@CountryList = CountryList,
			@CSOlist = CSOlist,
			@CancerTypelist = CancerTypelist,
			@InvestigatorType = InvestigatorType,
			@institution = institution,
			@piLastName = piLastName,
			@piFirstName = piFirstName,
			@piORCiD = piORCiD,
			@cityList = cityList,
			@stateList = stateList,
			@regionList = regionList,
			@FundingOrgTypeList = FundingOrgTypeList,
			@fundingOrgList = fundingOrgList,
			@childhoodcancerList = childhoodcancerList
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END
	


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode, f.isChildhood
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))	

	-----------------------------------------------------------		
	--  Get project Collaborators
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID AS ICRPProjectFundingID, f.AltAwardCode, pi.LastName, pi.FirstName, i.Name AS Institution, i.City, i.State, i.Country, l.Name AS Region	
	FROM #pf f	
		JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		JOIN Country c ON i.Country = c.Abbreviation
		JOIN lu_Region l ON c.RegionID = l.RegionID
	WHERE	(pi.IsPrincipalInvestigator = 0) AND
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList))))
	ORDER BY f.ProjectID, f.ProjectFundingID

/******************************/
 
GO
/****** Object:  StoredProcedure [dbo].[AddNewSearchBySearchID]    Script Date: 8/14/2025 1:34:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddNewSearchBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[AddNewSearchBySearchID]
GO

CREATE PROCEDURE [dbo].[AddNewSearchBySearchID]  
@SearchID INT,
@RegionID INT = NULL,
@Country VARCHAR(3) = NULL,
@City VARCHAR(50) = NULL,
@InstitutionID INT = NULL,
@searchCriteriaID INT OUTPUT,  -- return the searchID	
@ResultCount INT OUTPUT  -- return the searchID		
AS   
	DECLARE @project TABLE
	(ProjectID INT)
		
    IF @SearchID = 0
    BEGIN
        INSERT INTO @project SELECT ProjectID FROM Project
    END
    ELSE
    BEGIN
        ;WITH FilteredSearchResult AS (
            SELECT DISTINCT srp.ProjectID
            FROM SearchResultProject srp
            WHERE srp.SearchCriteriaID = @SearchID
        )
        INSERT INTO @project
        SELECT ProjectID
        FROM FilteredSearchResult
    END


	-- Further drill down - Filter on Region, Country or City
	SELECT p.ProjectID, pf.Projectfundingid, pf.BudgetEndDate INTO #Proj
		FROM @project p
			JOIN ProjectFunding pf ON pf.ProjectID = p.ProjectID
			JOIN ProjectFundingInvestigator pi ON pf.ProjectFundingID = pi.ProjectFundingID  -- only get pi			
			JOIN Institution i ON pi.InstitutionID = i.InstitutionID
			JOIN Country c ON i.Country = c.Abbreviation			
		WHERE (@RegionID IS NULL OR @RegionID = c.RegionID) AND (@Country IS NULL OR @Country = i.Country) AND (@City IS NULL OR @City = i.City) AND (@InstitutionID IS NULL OR @InstitutionID = i.InstitutionID)
		
	----------------------------------
	-- Save search criteria
	----------------------------------	
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	--SELECT @TotalRelatedProjectCount=COUNT(*) FROM (SELECT DISTINCT Projectfundingid FROM #Proj) pf
	SELECT @TotalRelatedProjectCount = TotalRelatedProjectCount FROM SearchResult WHERE SearchCriteriaID = @SearchID;

	SELECT DISTINCT ProjectID INTO #baseProj FROM #proj	
	SELECT @ResultCount=COUNT(*) FROM #baseProj	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #proj


	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #baseProj	

	DECLARE @InstitutionName VARCHAR(250)
	IF @InstitutionID IS NOT NULL
		SELECT @InstitutionName = Name FROM Institution WHERE InstitutionID = @InstitutionID

	IF @SearchID=0
	BEGIN
	INSERT INTO SearchCriteria ([cityList],[countryList],[RegionList], [institution])
		SELECT @City, @Country,@RegionID, @InstitutionName		
	END
	ELSE
	BEGIN	  

		INSERT INTO SearchCriteria ([termSearchType],[terms],[piLastName],[piFirstName],[piORCiD],[awardCode],
			[yearList], [stateList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [ChildhoodCancerList], [incomeGroupList],
			[institution], [cityList], [countryList], [RegionList])

			SELECT [termSearchType],[terms],[piLastName],[piFirstName],[piORCiD],[awardCode],
				[yearList], [stateList], [fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [ChildhoodCancerList], [incomeGroupList],

				CASE
				WHEN @InstitutionName IS NULL THEN [institution]
				ELSE @InstitutionName END,				
				
				CASE
				WHEN @City IS NULL THEN [cityList]
				ELSE @City END,
				
				CASE
				WHEN @Country IS NULL THEN [countryList]
				ELSE @Country END,

				CASE
				WHEN @RegionID IS NULL THEN [RegionList]
				ELSE @RegionID END		
				
			FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END									 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()		
		
	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
		-- Insert one row per ProjectID into SearchResultProject
    INSERT INTO SearchResultProject (SearchCriteriaID, ProjectID) SELECT @searchCriteriaID, [VALUE] FROM dbo.ToIntTable(@ProjectIDList);

/*************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypeStatsBySearchID]    Script Date: 8/14/2025 1:37:30 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypeStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,	
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the total relevances	
	@ResultAmount float OUTPUT  -- return the total amounts

AS   

    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project
	
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
			
			SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	--SELECT ProjectID INTO #proj FROM @Result

	-- CancerType Rollups - include all related cancertype IDs if search by roll-up cancer type 
	SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
		FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
		LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

	SELECT DISTINCT cancertypeid INTO #ctlist FROM
	(
		SELECT cancertypeid FROM #ct
		UNION
		SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
	) ct	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ct.Name AS CancerType, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID	
	 WHERE	((@CancerTypelist IS NULL) OR (ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	----------------------------------		
	--   Get CancerType Stats
	----------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT CancerType, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #pf GROUP BY CancerType 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT CancerType, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT CancerType, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #pf f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY CancerType	

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		

/*********************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCountryStatsBySearchID]    Script Date: 8/14/2025 1:39:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCountryStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
  ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
			-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END
		
	SELECT ProjectID INTO #proj FROM #Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, f.Amount, pii.Country, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID	
		JOIN CountryMapLayer cm ON i.country = cm.Country AND cm.MapLayerID = 4
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY country 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.country, CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS Decimal(18,2)) AS USDAmount 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t		
		GROUP BY country 
		
		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

/*************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectTypeStatsBySearchID]    Script Date: 8/14/2025 1:40:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectTypeStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
  ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
				@YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END		

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, pt.ProjectType, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE (@ProjectTypeList IS NULL) OR (pt.ProjectType IN (SELECT VALUE AS ProjectTypeID FROM dbo.ToStrTable(@ProjectTypeList))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT ProjectType, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY ProjectType 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT ProjectType, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats  FROM
		(SELECT f.ProjectType, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY ProjectType 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
/***************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCSOStatsBySearchID]    Script Date: 8/14/2025 1:40:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSOStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]
    @SearchID INT,		
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  

AS  
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max)	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		
		
			SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID	

	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CSO c ON c.code = pc.csocode	
	 WHERE	((@CSOlist IS NULL) OR (c.Code IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOlist)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
	BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	----------------------------------		
	--   Get CSO Stats
	----------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #pf GROUP BY categoryName 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT categoryName, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT categoryName, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #pf f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY categoryName		

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		
	
/****************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectChildhoodCancerStatsBySearchID]    Script Date: 8/14/2025 1:41:13 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectChildhoodCancerStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
		      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
				@YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END	
	
	-------------------------------------------------------------------		
	--   Find all related projects (project funding records)
	-------------------------------------------------------------------		
	SELECT f.ProjectID, f.IsChildhood, f.ProjectFundingID, f.Amount, o.Currency INTO #pf 
	FROM #Result r
		JOIN Project p ON r.ProjectID = p.ProjectID	
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID			
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE 	((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT 
			CASE IsChildhood 
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 
			COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats 
		FROM #pf 
		GROUP BY IsChildhood 

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 
		SELECT CASE IsChildhood
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats	FROM 
		(SELECT f.IsChildhood, (f.amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			FROM #pf f		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t					
		GROUP BY IsChildhood

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
/*************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectFundingOrgStatsBySearchID]    Script Date: 8/14/2025 1:41:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectFundingOrgStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;
    
	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@incomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgAbbrv, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID
		JOIN CountryMapLayer cm ON i.country = cm.Country		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT FundingOrg, FundingOrgAbbrv, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY FundingOrg, FundingOrgAbbrv

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT f.FundingOrg, f.FundingOrgAbbrv, 0 AS [Count], CAST((SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS Decimal(18,2)) AS USDAmount INTO #AmountStats 
		FROM #pf f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY f.FundingOrg, f.FundingOrgAbbrv

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

/***************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectInstitutionStatsBySearchID]    Script Date: 8/14/2025 1:42:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectInstitutionStatsBySearchID]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   
	
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;
    
	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, pii.InstitutionID, pii.Name AS Institution, pii.City, pii.state, pii.Country, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN CountryMapLayer cm ON i.country = cm.Country
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
	 		((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT Institution, City, State, Country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY InstitutionID, Institution, City, State, Country

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT InstitutionID, Institution, City, State, Country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.InstitutionID, f.Institution, f.City, f.State, f.Country, CAST(f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS Decimal(18,2)) AS USDAmount 
		FROM #pf f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY InstitutionID, Institution, City, State, Country


		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

/************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypeStatsBySearchIDBase]    Script Date: 8/14/2025 1:43:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypeStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchIDBase]
    @SearchID INT,	
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the total relevances	
	@ResultAmount float OUTPUT  -- return the total amounts

AS   

    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project
	
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
			
			SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	--SELECT ProjectID INTO #proj FROM @Result

	-- CancerType Rollups - include all related cancertype IDs if search by roll-up cancer type 
	SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
		FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
		LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

	SELECT DISTINCT cancertypeid INTO #ctlist FROM
	(
		SELECT cancertypeid FROM #ct
		UNION
		SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
	) ct	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ct.Name AS CancerType, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID	
	 WHERE	((@CancerTypelist IS NULL) OR (ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	----------------------------------		
	--   Get CancerType Stats
	----------------------------------

--- GET the baseproject

SELECT ProjectID, ProjectFundingID
INTO #baseProject
FROM #pf
GROUP BY ProjectID, ProjectFundingID;

SELECT ProjectID, ProjectFundingID
into #baseProjects
FROM (
  SELECT ProjectID, ProjectFundingID,
         ROW_NUMBER() OVER (PARTITION BY ProjectID ORDER BY ProjectFundingID) AS rn
  FROM #baseproject
) t
WHERE rn = 1;

-- Step 2: Join #baseProject with #pf to get the required columns
SELECT
    pf.ProjectID,
    pf.ProjectFundingID,
    pf.CancerType,
    pf.amount,
    pf.currency,
    pf.Relevance
Into #baseprojectsCancerType
FROM #pf pf
JOIN #baseprojects bp
  ON pf.ProjectID = bp.ProjectID
 AND pf.ProjectFundingID = bp.ProjectFundingID

 -------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT CancerType, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #baseprojectsCancerType GROUP BY CancerType 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT CancerType, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT CancerType, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #baseprojectsCancerType f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY CancerType	

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		


/*******************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCountryStatsBySearchIDBase]    Script Date: 8/14/2025 1:43:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCountryStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCountryStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectCountryStatsBySearchIDBase]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
  ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
			-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END
		
	SELECT ProjectID INTO #proj FROM #Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, f.Amount, pii.Country, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID	
		JOIN CountryMapLayer cm ON i.country = cm.Country AND cm.MapLayerID = 4
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END


    SELECT DISTINCT projectid
    INTO #baseProjectIDs
    FROM (
        SELECT DISTINCT ProjectFundingID, projectid
        FROM #pf
    ) AS SubQuery;

WITH RankedProjects AS (
    SELECT 
        b.projectid,
        f.Country,
        f.amount,
        f.currency,
        ROW_NUMBER() OVER (
            PARTITION BY b.projectid 
            ORDER BY f.Country, f.ProjectFundingID
        ) AS rn
    FROM #baseProjectIDs b
    JOIN #pf f
        ON b.projectid = f.projectid
)
SELECT 
    projectid,
    Country,
    amount,
    currency
INTO #ProjectWithCountry
FROM RankedProjects
WHERE rn = 1;
	------------------------------------------------------------------------------
	--   Get Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #ProjectWithCountry GROUP BY country 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.country, CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS Decimal(18,2)) AS USDAmount 
		FROM #ProjectWithCountry f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t		
		GROUP BY country 
		
		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

/*****************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectTypeStatsBySearchIDBase]    Script Date: 8/14/2025 1:44:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectTypeStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectTypeStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectTypeStatsBySearchIDBase]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
  ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
				@YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END		

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, pt.ProjectType, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE (@ProjectTypeList IS NULL) OR (pt.ProjectType IN (SELECT VALUE AS ProjectTypeID FROM dbo.ToStrTable(@ProjectTypeList))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
    SELECT DISTINCT projectid
    INTO #baseProjectIDs
    FROM (
        SELECT DISTINCT ProjectFundingID, projectid
        FROM #pf
    ) AS SubQuery;


WITH RankedProjects AS (
    SELECT 
        b.projectid,
        f.ProjectType,
        f.amount,
        f.currency,
        ROW_NUMBER() OVER (
            PARTITION BY b.projectid 
            ORDER BY f.ProjectType, f.ProjectFundingID
        ) AS rn
    FROM #baseProjectIDs b
    JOIN #pf f
        ON b.projectid = f.projectid
)
SELECT 
    projectid,
    ProjectType,
    amount,
    currency
INTO #ProjectWithType
FROM RankedProjects
WHERE rn = 1;

	IF @Type = 'Count'
	BEGIN	
		
		SELECT ProjectType, COUNT(distinct projectID) AS [Count], 0  AS USDAmount INTO #CountStats FROM #ProjectWithType GROUP BY ProjectType 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT ProjectType, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats  FROM
		(SELECT f.ProjectType, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
		FROM #ProjectWithType f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY ProjectType 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
/******************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCSOStatsBySearchIDBase]    Script Date: 8/14/2025 1:45:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSOStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectCSOStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectCSOStatsBySearchIDBase]
    @SearchID INT,		
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  

AS  
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max)	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		
		
			SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID	

	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CSO c ON c.code = pc.csocode	
	 WHERE	((@CSOlist IS NULL) OR (c.Code IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOlist)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
	BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	----------------------------------		
	--   Get CSO Stats
	----------------------------------

SELECT ProjectID, ProjectFundingID
INTO #baseProject
FROM #pf
GROUP BY ProjectID, ProjectFundingID;

SELECT ProjectID, ProjectFundingID
into #baseProjects
FROM (
  SELECT ProjectID, ProjectFundingID,
         ROW_NUMBER() OVER (PARTITION BY ProjectID ORDER BY ProjectFundingID) AS rn
  FROM #baseproject
) t
WHERE rn = 1;

-- Step 2: Join #baseProject with #pf to get the required columns
SELECT
    pf.ProjectID,
    pf.ProjectFundingID,
    pf.CategoryName AS categoryName,
    pf.amount,
    pf.currency,
    pf.Relevance
Into #baseprojectsCSO
FROM #pf pf
JOIN #baseprojects bp
  ON pf.ProjectID = bp.ProjectID
 AND pf.ProjectFundingID = bp.ProjectFundingID


	IF @Type = 'Count'
	BEGIN	
		
		SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,3)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #baseprojectsCSO GROUP BY categoryName 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT categoryName, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT categoryName, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #baseprojectsCSO f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY categoryName		

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		
	

    -------------------------------------------------------
  SET ANSI_NULLS ON
/**************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectChildhoodCancerStatsBySearchIDBase]    Script Date: 8/14/2025 1:45:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectChildhoodCancerStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchIDBase]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
		      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
				@YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END	
	
	-------------------------------------------------------------------		
	--   Find all related projects (project funding records)
	-------------------------------------------------------------------		
	SELECT f.ProjectID, f.IsChildhood, f.ProjectFundingID, f.Amount, o.Currency INTO #pf 
	FROM #Result r
		JOIN Project p ON r.ProjectID = p.ProjectID	
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID			
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE 	((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------


    SELECT DISTINCT projectid
    INTO #baseProjectIDs
    FROM (
        SELECT DISTINCT ProjectFundingID, projectid
        FROM #pf
    ) AS SubQuery;

WITH RankedProjects AS (
    SELECT 
        b.projectid,
        f.IsChildhood,
        f.amount,
        f.currency,
        ROW_NUMBER() OVER (
            PARTITION BY b.projectid 
            ORDER BY f.IsChildhood, f.ProjectFundingID
        ) AS rn
    FROM #baseProjectIDs b
    JOIN #pf f
        ON b.projectid = f.projectid
)
SELECT 
    projectid,
    IsChildhood,
    amount,
    currency
INTO #ProjectWithChildhood
FROM RankedProjects
WHERE rn = 1;

	IF @Type = 'Count'
	BEGIN	
		
		SELECT 
			CASE IsChildhood 
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 
			COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats 
		FROM #ProjectWithChildhood 
		GROUP BY IsChildhood 

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 
		SELECT CASE IsChildhood
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats	FROM 
		(SELECT f.IsChildhood, (f.amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			FROM #ProjectWithChildhood f		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t					
		GROUP BY IsChildhood

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
/*************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectFundingOrgStatsBySearchIDBase]    Script Date: 8/14/2025 1:45:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectFundingOrgStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchIDBase]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@incomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgAbbrv, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID
		JOIN CountryMapLayer cm ON i.country = cm.Country		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------

    SELECT DISTINCT projectid
    INTO #baseProjectIDs
    FROM (
        SELECT DISTINCT ProjectFundingID, projectid
        FROM #pf
    ) AS SubQuery;

WITH RankedProjects AS (
    SELECT 
        b.projectid,
        f.FundingOrgAbbrv,
        f.FundingOrg,
        f.amount,
        f.currency,
        ROW_NUMBER() OVER (
            PARTITION BY b.projectid 
            ORDER BY f.FundingOrg, f.ProjectFundingID
        ) AS rn
    FROM #baseProjectIDs b
    JOIN #pf f
        ON b.projectid = f.projectid
)
SELECT 
    projectid,
    FundingOrgAbbrv,
    FundingOrg,
    amount,
    currency
INTO #ProjectWithFunding
FROM RankedProjects
WHERE rn = 1;


	IF @Type = 'Count'
	BEGIN		
		
		SELECT FundingOrg, FundingOrgAbbrv, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #ProjectWithFunding GROUP BY FundingOrg, FundingOrgAbbrv

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT f.FundingOrg, f.FundingOrgAbbrv, 0 AS [Count], CAST((SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS Decimal(18,2)) AS USDAmount INTO #AmountStats 
		FROM #ProjectWithFunding f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY f.FundingOrg, f.FundingOrgAbbrv

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	


/****************************/
 
GO
/****** Object:  StoredProcedure [dbo].[GetProjectInstitutionStatsBySearchIDBase]    Script Date: 8/14/2025 1:49:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectInstitutionStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchIDBase]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   
	
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@IncomeGroupList = IncomeGroupList,
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,
				@regionList = regionList,
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList,
				@childhoodcancerList = childhoodcancerList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, pii.InstitutionID, pii.Name AS Institution, pii.City, pii.state, pii.Country, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN CountryMapLayer cm ON i.country = cm.Country
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
	 		((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

	IF @CancerTypelist IS NOT NULL
	BEGIN
		-- include all related cancertype IDs if search by roll-up cancer type 
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------

    SELECT DISTINCT projectid
    INTO #baseProjectIDs
    FROM (
        SELECT DISTINCT ProjectFundingID, projectid
        FROM #pf
    ) AS SubQuery;

WITH RankedProjects AS (
    SELECT 
        b.projectid,
        f.InstitutionID,
        f.Institution,
        f.City,
        f.State,
        f.Country,
        f.amount,
        f.currency,
        ROW_NUMBER() OVER (
            PARTITION BY b.projectid 
            ORDER BY f.Institution, f.ProjectFundingID
        ) AS rn
    FROM #baseProjectIDs b
    JOIN #pf f
        ON b.projectid = f.projectid
)
SELECT 
    projectid,
    InstitutionID,
    Institution,
    City,
    State,
    Country,
    amount,
    currency
INTO #ProjectWithInstitution
FROM RankedProjects
WHERE rn = 1;


	IF @Type = 'Count'
	BEGIN		
		
		SELECT Institution, City, State, Country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #ProjectWithInstitution GROUP BY InstitutionID, Institution, City, State, Country

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT InstitutionID, Institution, City, State, Country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.InstitutionID, f.Institution, f.City, f.State, f.Country, CAST(f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS Decimal(18,2)) AS USDAmount 
		FROM #ProjectWithInstitution f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY InstitutionID, Institution, City, State, Country


		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	






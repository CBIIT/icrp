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

---------------------------
CREATE TRIGGER trg_DeleteOldSearchResults
ON SearchResultProject
AFTER INSERT
AS
BEGIN
    -- Delete rows older than 10 days
    DELETE FROM SearchResultProject
    WHERE CreatedDate < DATEADD(DAY, -2, GETDATE());
END;

---------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetProjectsByCriteria]    
    @PageSize INT = 50, 
    @PageNumber INT = 1, 
    @SortCol VARCHAR(50) = 'title', 
    @SortDirection VARCHAR(4) = 'ASC',  
    @termSearchType VARCHAR(25) = NULL,  
    @terms VARCHAR(4000) = NULL,  
    @InvestigatorType VARCHAR(250) = NULL, 
    @institution VARCHAR(250) = NULL,
    @piLastName VARCHAR(50) = NULL,
    @piFirstName VARCHAR(50) = NULL,
    @piORCiD VARCHAR(50) = NULL,
    @awardCode VARCHAR(50) = NULL,
    @yearList VARCHAR(1000) = NULL, 
    @cityList VARCHAR(1000) = NULL, 
    @stateList VARCHAR(1000) = NULL,
    @countryList VARCHAR(1000) = NULL,
    @regionList VARCHAR(100) = NULL,
    @incomeGroupList VARCHAR(1000) = NULL,
    @FundingOrgTypeList VARCHAR(50) = NULL,
    @fundingOrgList VARCHAR(1000) = NULL, 
    @cancerTypeList VARCHAR(1000) = NULL, 
    @projectTypeList VARCHAR(1000) = NULL,
    @CSOList VARCHAR(1000) = NULL,	
    @ChildhoodCancerList VARCHAR(1000) = NULL,	  
    @searchCriteriaID INT OUTPUT,  
    @ResultCount INT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
    DECLARE @IsFiltered BIT = 0;
    DECLARE @TotalRelatedProjectCount INT;
	DECLARE @LastBudgetYear INT;
    DECLARE @searchWords VARCHAR(4000);

    -- Always create #ctlist
    IF OBJECT_ID('tempdb..#ctlist') IS NOT NULL DROP TABLE #ctlist;
    CREATE TABLE #ctlist (CancerTypeID INT);

 IF @cancerTypeList IS NOT NULL
BEGIN
    -- include all related cancertype IDs if search by roll-up cancer type 
    SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
        FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
        LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID;

    INSERT INTO #ctlist (CancerTypeID)
    SELECT DISTINCT cancertypeid FROM
    (
        SELECT cancertypeid FROM #ct
        UNION
        SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
    ) ct;

    DROP TABLE #ct;
END
-- Check if any filtering criteria are applied
IF @yearList IS NOT NULL OR
   @institution IS NOT NULL OR
   @piLastName IS NOT NULL OR
   @piFirstName IS NOT NULL OR
   @piORCiD IS NOT NULL OR
   @awardCode IS NOT NULL OR
   @cityList IS NOT NULL OR
   @stateList IS NOT NULL OR
   @countryList IS NOT NULL OR
   @incomeGroupList IS NOT NULL OR
   @regionList IS NOT NULL OR
   @FundingOrgTypeList IS NOT NULL OR
   @fundingOrgList IS NOT NULL OR
   @cancerTypeList IS NOT NULL OR
   @projectTypeList IS NOT NULL OR
   @CSOList IS NOT NULL OR
   @ChildhoodCancerList IS NOT NULL OR
   @termSearchType IS NOT NULL OR
   @terms IS NOT NULL
BEGIN
    SET @IsFiltered = 1;
END;

    -- Prepare search terms
    IF @terms IS NOT NULL
    BEGIN
        SELECT @searchWords = 
        CASE @termSearchType
            WHEN 'Exact' THEN '"' + @terms + '"'
            WHEN 'Any' THEN REPLACE(@terms, ' ', ' OR ')
            ELSE REPLACE(@terms, ' ', ' AND ') -- All or None	
        END;
    END;

    -- Handle 'All' InvestigatorType
    IF @InvestigatorType = 'All'
        SET @InvestigatorType = NULL;

    -- Common Table Expression (CTE) for filtering
    WITH FilteredProjects AS (
       SELECT f.*, 
               pi.InstitutionID AS piInstitutionID,
               i.Country AS piInstitutionCountry,
               cm.Value AS piIncomeGroup
        FROM vwProjectFundings f
        JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID 
        JOIN Institution i ON pi.InstitutionID = i.InstitutionID
        JOIN CountryMapLayer cm ON i.Country = cm.Country AND cm.MapLayerID = 4

   
        WHERE 1 = 1
            -- Investigator Type Filter
            AND (@InvestigatorType IS NULL 
                 OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1)
                 OR (@InvestigatorType = 'Collab' AND pi.IsPrincipalInvestigator = 0))
            -- Institution Filter
            AND (@institution IS NULL OR institution LIKE '%' + @institution + '%')
            -- PI Filters
            AND (@piLastName IS NULL OR piLastName LIKE '%' + @piLastName + '%')
            AND (@piFirstName IS NULL OR piFirstName LIKE '%' + @piFirstName + '%')
            AND (@piORCiD IS NULL OR piORCiD LIKE '%' + @piORCiD + '%')
            -- Award Code Filter
            AND (@awardCode IS NULL OR AwardCode LIKE '%' + @awardCode + '%')
            -- Childhood Cancer Filter
            AND (@ChildhoodCancerList IS NULL OR IsChildhood IN (SELECT value FROM dbo.ToIntTable(@ChildhoodCancerList)))
            -- City Filter
            AND (@cityList IS NULL OR i.city IN (SELECT value FROM dbo.ToStrTable(@cityList)))
            -- State Filter
            AND (@stateList IS NULL OR i.[State] IN (SELECT value FROM dbo.ToStrTable(@stateList)))
            -- Country Filter
            AND (@countryList IS NULL OR i.[Country] IN (SELECT value FROM dbo.ToStrTable(@countryList)))
             -- Income Group Filter (applied here)
            AND (@incomeGroupList IS NULL OR cm.Value IN (SELECT VALUE FROM dbo.ToStrTable(@incomeGroupList)))
         
            -- Region Filter
            AND (@regionList IS NULL OR RegionID IN (SELECT value FROM dbo.ToIntTable(@regionList)))
            -- Funding Org Type Filter
            AND (@FundingOrgTypeList IS NULL OR FundingOrgType IN (SELECT value FROM dbo.ToStrTable(@FundingOrgTypeList)))
            -- Funding Org Filter
            AND (@fundingOrgList IS NULL OR FundingOrgID IN (SELECT value FROM dbo.ToIntTable(@fundingOrgList)))
            -- Cancer Type Filter (with roll-up logic)
            AND (
                @cancerTypeList IS NULL OR f.ProjectFundingID IN (
                    SELECT DISTINCT ProjectFundingID
                    FROM ProjectCancerType
                    WHERE CancerTypeID IN (SELECT CancerTypeID FROM #ctlist)
                )
            )
            -- Project Type Filter
            AND (@projectTypeList IS NULL OR ProjectID IN (
                SELECT ProjectID 
                FROM Project_ProjectType 
                WHERE ProjectType IN (SELECT value FROM dbo.ToStrTable(@projectTypeList))
            ))
            -- CSO Filter
            AND (@CSOList IS NULL OR f.ProjectFundingID IN (
                SELECT ProjectFundingID 
                FROM ProjectCSO 
                WHERE CSOCode IN (SELECT value FROM dbo.ToStrTable(@CSOList))
            ))
            -- Year Filter
            AND (@yearList IS NULL OR f.ProjectID IN (
                SELECT ProjectFundingID 
                FROM ProjectFundingExt 
                WHERE CalendarYear IN (SELECT value FROM dbo.ToIntTable(@yearList))
            ))
            -- Terms Search Filter
            AND (
                (@terms IS NULL) OR
                (@termSearchType = 'None' AND f.ProjectID NOT IN (
                    SELECT ProjectID FROM ProjectSearch s WHERE CONTAINS(s.content, @searchWords)
                )) OR
                (@termSearchType <> 'None' AND f.ProjectID IN (
                    SELECT ProjectID FROM ProjectSearch s WHERE CONTAINS(s.content, @searchWords)
                ))
            )
    )
    SELECT * INTO #FilteredProjects FROM FilteredProjects;

    -- Count Results
    SELECT @ResultCount = COUNT(DISTINCT ProjectID) FROM #FilteredProjects;
    SELECT @TotalRelatedProjectCount=COUNT(*) FROM (SELECT DISTINCT ProjectFundingID FROM #FilteredProjects) u	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #FilteredProjects	
  


    SET @searchCriteriaID = 0  -- no filters
    -- Save Search Criteria if filtered
    IF @IsFiltered = 1
    BEGIN
        DECLARE @ProjectIDList VARCHAR(max) = '' 	

    SELECT @ProjectIDList = STRING_AGG(CONVERT(VARCHAR(MAX), ProjectID), ',')
    FROM #FilteredProjects;

        INSERT INTO SearchCriteria (
            termSearchType, terms, institution, piLastName, piFirstName, piORCiD, awardCode,
            yearList, cityList, stateList, countryList, incomeGroupList, regionList,
            fundingOrgList, cancerTypeList, projectTypeList, CSOList, FundingOrgTypeList, ChildhoodCancerList, InvestigatorType
        )
        VALUES (
            @termSearchType, @terms, @institution, @piLastName, @piFirstName, @piORCiD, @awardCode,
            @yearList, @cityList, @stateList, @countryList, @incomeGroupList, @regionList,
            @fundingOrgList, @cancerTypeList, @projectTypeList, @CSOList, @FundingOrgTypeList, @ChildhoodCancerList, @InvestigatorType
        );

        SELECT @searchCriteriaID = SCOPE_IDENTITY();

        INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
        INSERT INTO SearchResultProject (SearchCriteriaID, ProjectID) SELECT @searchCriteriaID AS SearchCriteriaID, ProjectID FROM #FilteredProjects;
    END
    ELSE
	BEGIN
		UPDATE SearchResult SET Results = NULL,ResultCount=@ResultCount, TotalRelatedProjectCount=@TotalRelatedProjectCount, LastBudgetYear=@LastBudgetYear, IsEmailSent=0 WHERE SearchCriteriaID =0
           -- Insert ProjectIDs into SearchResultProject for SearchCriteriaID = 0
      
    END

    -- Pagination and Sorting
    SELECT 
        p.ProjectID, 
        p.AwardCode, 
        p.ProjectFundingID AS LastProjectFundingID,
        LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) as CleanTitle,
        pi.LastName AS piLastName, 
        pi.FirstName AS piFirstName,
        pi.ORC_ID AS piORCiD, 
        i.Name AS institution, 
        f.Amount, 
        i.City, 
        i.State, 
        i.Country, 
        c.name as CountryName,
        o.FundingOrgID, 
        o.Name AS FundingOrg, 
        o.Abbreviation AS FundingOrgShort
    INTO #finalresult 
    FROM #FilteredProjects p
    JOIN ProjectFunding f ON p.ProjectFundingID = f.ProjectFundingID
    JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = p.ProjectFundingID AND pi.IsPrincipalInvestigator = 1
    JOIN Institution i ON pi.InstitutionID = i.InstitutionID
    JOIN Country c on c.Abbreviation = i.Country
ORDER BY 
    CASE 
        WHEN @SortCol = 'title' AND @SortDirection = 'ASC' THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), '')))
        WHEN @SortCol = 'code' AND @SortDirection = 'ASC' THEN p.AwardCode
        WHEN @SortCol = 'pi' AND @SortDirection = 'ASC' THEN pi.LastName
        WHEN @SortCol = 'inst' AND @SortDirection = 'ASC' THEN i.Name
        WHEN @SortCol = 'city' AND @SortDirection = 'ASC' THEN i.City
        WHEN @SortCol = 'state' AND @SortDirection = 'ASC' THEN i.State
        WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country
        WHEN @SortCol = 'FO' AND @SortDirection = 'ASC' THEN o.Abbreviation
    END ASC,
    CASE 
        WHEN @SortCol = 'title' AND @SortDirection = 'DESC' THEN LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), '')))
        WHEN @SortCol = 'code' AND @SortDirection = 'DESC' THEN p.AwardCode
        WHEN @SortCol = 'pi' AND @SortDirection = 'DESC' THEN pi.LastName
        WHEN @SortCol = 'inst' AND @SortDirection = 'DESC' THEN i.Name
        WHEN @SortCol = 'city' AND @SortDirection = 'DESC' THEN i.City
        WHEN @SortCol = 'state' AND @SortDirection = 'DESC' THEN i.State
        WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN i.Country
        WHEN @SortCol = 'FO' AND @SortDirection = 'DESC' THEN o.Abbreviation
    END DESC
OFFSET (@PageNumber - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY;

-- Select distinct rows from the temporary table

;WITH RankedProjects AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ProjectID 
               ORDER BY CleanTitle ASC 
        ) AS rn
    FROM #finalresult
)
SELECT 
    ProjectID, 
    AwardCode, 
    LastProjectFundingID,
 CleanTitle as Title,
    piLastName, 
    piFirstName, 
    piORCiD, 
    institution, 
    Amount, 
    City, 
    State, 
    Country as country,
    CountryName,
    FundingOrgID, 
    FundingOrg, 
    FundingOrgShort
FROM RankedProjects
WHERE rn = 1
ORDER BY CleanTitle ASC

  DROP TABLE #FilteredProjects;
    DROP TABLE #finalresult;
    IF OBJECT_ID('tempdb..#ct') IS NOT NULL DROP TABLE #ct;
    IF OBJECT_ID('tempdb..#ctlist') IS NOT NULL DROP TABLE #ctlist;
END;
GO

----------------------------
----------------------------
USE [icrp_data]
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
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN f.Title  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN base.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,		
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN f.Title  END DESC,
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


GO




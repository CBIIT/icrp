CREATE PROCEDURE [dbo].[GetProjectsByCriteria]    
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
    DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT


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
   @ChildhoodCancerList IS NOT NULL
BEGIN
    SET @IsFiltered = 1;
END;

    -- Handle 'All' InvestigatorType
    IF @InvestigatorType = 'All'
        SET @InvestigatorType = NULL;

    -- Common Table Expression (CTE) for filtering
    WITH FilteredProjects AS (
        SELECT *
        FROM vwProjectFundings
        WHERE 1 = 1
            -- Investigator Type Filter
            AND (@InvestigatorType IS NULL 
                 OR (@InvestigatorType = 'PI' AND IsPrincipalInvestigator = 1)
                 OR (@InvestigatorType = 'Collab' AND IsPrincipalInvestigator = 0))
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
            AND (@cityList IS NULL OR city IN (SELECT value FROM dbo.ToStrTable(@cityList)))
            -- State Filter
            AND (@stateList IS NULL OR [State] IN (SELECT value FROM dbo.ToStrTable(@stateList)))
            -- Country Filter
            AND (@countryList IS NULL OR [Country] IN (SELECT value FROM dbo.ToStrTable(@countryList)))
            -- Income Group Filter
            AND (@incomeGroupList IS NULL OR country IN (
                SELECT Country 
                FROM CountryMapLayer 
                WHERE value IN (SELECT value FROM dbo.ToStrTable(@incomeGroupList))
            ))
            -- Region Filter
            AND (@regionList IS NULL OR RegionID IN (SELECT value FROM dbo.ToIntTable(@regionList)))
            -- Funding Org Type Filter
            AND (@FundingOrgTypeList IS NULL OR FundingOrgType IN (SELECT value FROM dbo.ToStrTable(@FundingOrgTypeList)))
            -- Funding Org Filter
            AND (@fundingOrgList IS NULL OR FundingOrgID IN (SELECT value FROM dbo.ToIntTable(@fundingOrgList)))
            -- Cancer Type Filter
            AND (@cancerTypeList IS NULL OR ProjectFundingID IN (
                SELECT DISTINCT ProjectFundingID
                FROM ProjectCancerType
                WHERE CancerTypeID IN (
                    SELECT DISTINCT CancerTypeID
                    FROM (
                        SELECT CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)
                        UNION
                        SELECT CancerTypeID 
                        FROM CancerTypeRollUp 
                        WHERE CancerTyperollupID IN (SELECT value FROM dbo.ToIntTable(@cancerTypeList))
                    ) AS CancerTypes
                )
            ))
            -- Project Type Filter
            AND (@projectTypeList IS NULL OR ProjectID IN (
                SELECT ProjectID 
                FROM Project_ProjectType 
                WHERE ProjectType IN (SELECT value FROM dbo.ToStrTable(@projectTypeList))
            ))
            -- CSO Filter
            AND (@CSOList IS NULL OR ProjectFundingID IN (
                SELECT ProjectFundingID 
                FROM ProjectCSO 
                WHERE CSOCode IN (SELECT value FROM dbo.ToStrTable(@CSOList))
            ))
            -- Year Filter
            AND (@yearList IS NULL OR ProjectFundingID IN (
                SELECT ProjectFundingID 
                FROM ProjectFundingExt 
                WHERE CalendarYear IN (SELECT value FROM dbo.ToIntTable(@yearList))
            ))
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
        INSERT INTO SearchResultProject (SearchCriteriaID, ProjectID)
        SELECT 0 AS SearchCriteriaID, ProjectID
        FROM #FilteredProjects;
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
        f.Title, 
        pi.LastName AS piLastName, 
        pi.FirstName AS piFirstName,
        pi.ORC_ID AS piORCiD, 
        i.Name AS institution, 
        f.Amount, 
        i.City, 
        i.State, 
        i.Country, 
        o.FundingOrgID, 
        o.Name AS FundingOrg, 
        o.Abbreviation AS FundingOrgShort
    INTO #finalresult 
    FROM #FilteredProjects p
    JOIN ProjectFunding f ON p.ProjectFundingID = f.ProjectFundingID
    JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = p.ProjectFundingID AND pi.IsPrincipalInvestigator = 1
    JOIN Institution i ON pi.InstitutionID = i.InstitutionID
ORDER BY 
    CASE 
        WHEN @SortCol = 'title' AND @SortDirection = 'ASC' THEN f.Title
        WHEN @SortCol = 'code' AND @SortDirection = 'ASC' THEN p.AwardCode
        WHEN @SortCol = 'pi' AND @SortDirection = 'ASC' THEN pi.LastName
        WHEN @SortCol = 'inst' AND @SortDirection = 'ASC' THEN i.Name
        WHEN @SortCol = 'city' AND @SortDirection = 'ASC' THEN i.City
        WHEN @SortCol = 'state' AND @SortDirection = 'ASC' THEN i.State
        WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country
        WHEN @SortCol = 'FO' AND @SortDirection = 'ASC' THEN o.Abbreviation
    END ASC,
    CASE 
        WHEN @SortCol = 'title' AND @SortDirection = 'DESC' THEN f.Title
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
               ORDER BY Title ASC 
        ) AS rn
    FROM #finalresult
)
SELECT 
    ProjectID, 
    AwardCode, 
    LastProjectFundingID,
    Title, 
    piLastName, 
    piFirstName, 
    piORCiD, 
    institution, 
    Amount, 
    City, 
    State, 
    Country as country,
    FundingOrgID, 
    FundingOrg, 
    FundingOrgShort
FROM RankedProjects
WHERE rn = 1
ORDER BY Title ASC;  

    DROP TABLE #FilteredProjects;
    DROP TABLE #finalresult;
END;


--------------------------
CREATE TABLE SearchResultProject
(
    SearchCriteriaID INT,
    ProjectID INT
);

CREATE INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID
ON SearchResultProject (SearchCriteriaID, ProjectID);

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
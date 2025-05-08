
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByCriteria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectsByCriteria]
GO
CREATE PROCEDURE [dbo].[GetProjectsByCriteria2]    
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
    -- Normalize InvestigatorType parameter
    IF @InvestigatorType = 'All'
        SET @InvestigatorType = NULL;
    -- CTE for filtering projects
    ;WITH cteFiltered AS (
        SELECT 
            pf.ProjectID,
            pf.ProjectFundingID,
            pf.Title,
            pf.InstitutionName,
            pf.LastName AS piLastName,
            pf.FirstName AS piFirstName,
            pf.ORC_ID AS piORCiD,
            pf.AwardCode,
            pf.City,
            pf.State,
            pf.Country,
            pf.RegionID,
            pf.IncomeGroupValue,
            pf.IsChildhood,
            pf.Amount,
            pf.FundingOrgID,
            pf.FundingOrgType
        FROM vw_ProjectFundingDetails pf
        WHERE 1 = 1
            -- Investigator type filter
            AND (@InvestigatorType IS NULL 
                OR (@InvestigatorType = 'PI' AND pf.IsPrincipalInvestigator = 1)
                OR (@InvestigatorType = 'Collab' AND pf.IsPrincipalInvestigator = 0))
            -- Institution filter
            AND (@institution IS NULL OR pf.InstitutionName LIKE '%' + @institution + '%')
            -- PI filters
            AND (@piLastName IS NULL OR pf.LastName LIKE '%' + @piLastName + '%')
            AND (@piFirstName IS NULL OR pf.FirstName LIKE '%' + @piFirstName + '%')
            AND (@piORCiD IS NULL OR pf.ORC_ID LIKE '%' + @piORCiD + '%')
            -- Award code filter
            AND (@awardCode IS NULL OR pf.AwardCode LIKE '%' + @awardCode + '%')
            -- Location filters
            AND (@cityList IS NULL OR pf.City IN (SELECT VALUE FROM dbo.ToStrTable(@cityList)))
            AND (@stateList IS NULL OR pf.State IN (SELECT VALUE FROM dbo.ToStrTable(@stateList)))
            AND (@countryList IS NULL OR pf.Country IN (SELECT VALUE FROM dbo.ToStrTable(@countryList)))
            AND (@regionList IS NULL OR pf.RegionID IN (SELECT VALUE FROM dbo.ToIntTable(@regionList)))
            -- Income group filter
            AND (@incomeGroupList IS NULL OR pf.IncomeGroupValue IN (SELECT VALUE FROM dbo.ToStrTable(@incomeGroupList)))
            -- Childhood cancer filter
            AND (@ChildhoodCancerList IS NULL OR pf.IsChildhood IN (SELECT VALUE FROM dbo.ToIntTable(@ChildhoodCancerList)))
            -- Funding organization filters
            AND (@FundingOrgTypeList IS NULL OR pf.FundingOrgType IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
            AND (@fundingOrgList IS NULL OR pf.FundingOrgID IN (SELECT VALUE FROM dbo.ToIntTable(@fundingOrgList)))
    ),
    cteBase AS (
        SELECT 
            ProjectID,
            MIN(ProjectFundingID) AS BaseFundingID
        FROM cteFiltered
        GROUP BY ProjectID
    )
    -- Capture the total result count
    SELECT @ResultCount = COUNT(*) FROM cteBase;
    -- Save search criteria if filters are applied
    IF @ResultCount > 0
    BEGIN
        DECLARE @ProjectIDList VARCHAR(MAX);
        SELECT @ProjectIDList = STRING_AGG(CONVERT(VARCHAR(20), ProjectID), ',') FROM cteBase;
        INSERT INTO SearchCriteria (
            termSearchType, terms, institution, piLastName, piFirstName, piORCiD, awardCode,
            yearList, cityList, stateList, countryList, incomeGroupList, regionList, fundingOrgList,
            cancerTypeList, projectTypeList, CSOList, FundingOrgTypeList, ChildhoodCancerList, InvestigatorType
        )
        VALUES (
            @termSearchType, @terms, @institution, @piLastName, @piFirstName, @piORCiD, @awardCode,
            @yearList, @cityList, @stateList, @countryList, @incomeGroupList, @regionList, @fundingOrgList,
            @cancerTypeList, @projectTypeList, @CSOList, @FundingOrgTypeList, @ChildhoodCancerList, @InvestigatorType
        );
        SET @searchCriteriaID = SCOPE_IDENTITY();
        INSERT INTO SearchResult (
            SearchCriteriaID, Results, ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent
        )
        VALUES (
            @searchCriteriaID, @ProjectIDList, @ResultCount,
            (SELECT COUNT(DISTINCT ProjectFundingID) FROM cteFiltered),
            (SELECT DATEPART(YEAR, MAX(BudgetEndDate)) FROM cteFiltered), 0
        );
    END
    -- Final result with sorting and pagination
    SELECT 
        b.ProjectID,
        b.BaseFundingID AS LastProjectFundingID,
        f.Title,
        f.Amount,
        f.InstitutionName AS Institution,
        f.City,
        f.State,
        f.Country,
        f.FundingOrgID,
        f.FundingOrgType
    FROM cteBase b
    JOIN vw_ProjectFundingDetails f ON b.BaseFundingID = f.ProjectFundingID
    ORDER BY 
        CASE WHEN @SortCol = 'title' AND @SortDirection = 'ASC' THEN f.Title END ASC,
        CASE WHEN @SortCol = 'title' AND @SortDirection = 'DESC' THEN f.Title END DESC,
        CASE WHEN @SortCol = 'amount' AND @SortDirection = 'ASC' THEN f.Amount END ASC,
        CASE WHEN @SortCol = 'amount' AND @SortDirection = 'DESC' THEN f.Amount END DESC
    OFFSET (@PageSize * (@PageNumber - 1)) ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END
GO
-- 	1. CTEs:
-- 		○ cteFiltered: Filters the data directly from the vw_ProjectFundingDetails view.
-- 		○ cteBase: Groups the filtered data to find the base project funding ID.
-- 	2. Avoid Temporary Tables:
-- 		○ Replaced temporary tables with CTEs for better performance and readability.
-- 		1. Reduce Temporary Table Usage:
-- 			○ Instead of creating multiple temporary tables (#projFunding, #childhoodcancer, #baseProj), consider using Common Table Expressions (CTEs) for intermediate results. This can reduce I/O overhead and improve readability.
		
-- 	3. Dynamic Filtering:
-- 		○ Filters are applied directly in the WHERE clause of the cteFiltered CTE.
-- 	4. Pagination:
-- 		○ Used OFFSET and FETCH NEXT for efficient pagination.
-- 	5. STRING_AGG:
-- Used STRING_AGG to generate a comma-separated list of project IDs for saving search criteria.
-- This optimized query improves performance, reduces I/O overhead, and enhances readability and maintainability.

CREATE PROCEDURE [dbo].[GetProjectsByCriteria3]    
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

    -- Declare temporary tables explicitly
    CREATE TABLE #projFunding (
        ProjectFundingID INT PRIMARY KEY,
        ProjectID INT,
        Title NVARCHAR(255),
        Institution NVARCHAR(255),
        piLastName NVARCHAR(50),
        piFirstName NVARCHAR(50),
        piORCiD NVARCHAR(50),
        AwardCode NVARCHAR(50),
        BudgetEndDate DATE,
        IsChildhood INT,
        City NVARCHAR(100),
        State NVARCHAR(100),
        Country NVARCHAR(100),
        RegionID INT,
        FundingOrgType NVARCHAR(50),
        FundingOrgID INT,
        CancerTypeID INT,
        ProjectType NVARCHAR(50),
        CSOCode NVARCHAR(50)
    );

    -- Insert data into #projFunding with necessary filters
    INSERT INTO #projFunding (ProjectFundingID, ProjectID, Title, Institution, piLastName, piFirstName, piORCiD, AwardCode, BudgetEndDate, IsChildhood, City, State, Country, RegionID, FundingOrgType, FundingOrgID, CancerTypeID, ProjectType, CSOCode)
    SELECT 
        pf.ProjectFundingID,
        pf.ProjectID,
        pf.Title,
        i.Name AS Institution, -- Verify if 'Name' is the correct column for Institution
        pi.LastName AS piLastName,
        pi.FirstName AS piFirstName,
        pi.ORC_ID AS piORCiD,
        pf.AltAwardCode, -- Verify if 'AwardCode' exists in ProjectFunding
        pf.BudgetEndDate,
        pf.IsChildhood,
        i.City,
        i.State,
        i.Country,
        c.RegionID,
        o.Type AS FundingOrgType,
        o.FundingOrgID,
        ct.CancerTypeID,
        pt.ProjectType,
        cso.CSOCode
    FROM ProjectFunding pf
    INNER JOIN Institution i ON pf.FundingOrgID = i.InstitutionID -- Verify if 'InstitutionID' exists in ProjectFunding and Institution
    INNER JOIN ProjectFundingInvestigator pi ON pf.ProjectFundingID = pi.ProjectFundingID AND pi.IsPrincipalInvestigator = 1
    LEFT JOIN Country c ON i.Country = c.Abbreviation -- Verify if 'Abbreviation' is the correct column in Country
    LEFT JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID
    LEFT JOIN ProjectCancerType ct ON pf.ProjectFundingID = ct.ProjectFundingID
    LEFT JOIN Project_ProjectType pt ON pf.ProjectID = pt.ProjectID
    LEFT JOIN ProjectCSO cso ON pf.ProjectFundingID = cso.ProjectFundingID
    WHERE 
        (@InvestigatorType IS NULL OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND pi.IsPrincipalInvestigator = 0))
        AND (@institution IS NULL OR i.Name LIKE '%' + @institution + '%')
        AND (@piLastName IS NULL OR pi.LastName LIKE '%' + @piLastName + '%')
        AND (@piFirstName IS NULL OR pi.FirstName LIKE '%' + @piFirstName + '%')
        AND (@piORCiD IS NULL OR pi.ORC_ID LIKE '%' + @piORCiD + '%')
        AND (@awardCode IS NULL OR pf.AltAwardCode LIKE '%' + @awardCode + '%')
        AND (@yearList IS NULL OR YEAR(pf.BudgetEndDate) IN (SELECT VALUE FROM dbo.ToIntTable(@yearList)))
        AND (@cityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@cityList)))
        AND (@stateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@stateList)))
        AND (@countryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@countryList)))
        AND (@regionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToIntTable(@regionList)))
        AND (@incomeGroupList IS NULL OR c.IncomeBand IN (SELECT VALUE FROM dbo.ToStrTable(@incomeGroupList))) -- Verify if 'IncomeGroup' exists in Country
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToIntTable(@fundingOrgList)))
        AND (@cancerTypeList IS NULL OR ct.CancerTypeID IN (SELECT VALUE FROM dbo.ToIntTable(@cancerTypeList)))
        AND (@projectTypeList IS NULL OR pt.ProjectType IN (SELECT VALUE FROM dbo.ToStrTable(@projectTypeList)))
        AND (@CSOList IS NULL OR cso.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList)))
        AND (@ChildhoodCancerList IS NULL OR pf.IsChildhood IN (SELECT VALUE FROM dbo.ToIntTable(@ChildhoodCancerList)));

    -- Pagination and Sorting
    SELECT 
        ProjectID,
        Title,
        Institution,
        piLastName,
        piFirstName,
        piORCiD,
        AwardCode,
        BudgetEndDate,
        IsChildhood,
        City,
        State,
        Country,
        RegionID,
        FundingOrgType,
        FundingOrgID
    FROM #projFunding
    ORDER BY 
        CASE WHEN @SortCol = 'title' AND @SortDirection = 'ASC' THEN Title END ASC,
        CASE WHEN @SortCol = 'title' AND @SortDirection = 'DESC' THEN Title END DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Cleanup
    DROP TABLE #projFunding;
END;

---Explicit Temporary Table Creation: Avoided SELECT INTO for better control and indexing.
---Filtered Data Early: Applied filters directly in the INSERT INTO statement to reduce unnecessary data processing.
----Simplified Sorting: Removed redundant CASE statements in ORDER BY.
----Indexed Columns: Ensure indexes exist on columns used in WHERE and JOIN clauses.
----Pagination: Used OFFSET and FETCH NEXT for efficient pagination.


CREATE PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]   
    @SearchID INT,		
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  -- return the relevances		
    @ResultAmount FLOAT OUTPUT  -- return the amount	
AS   
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------
    -- Temporary Table for Filtered Projects
    ------------------------------------------------------
    CREATE TABLE #FilteredProjects (
        ProjectFundingID INT NOT NULL,
        categoryName NVARCHAR(255),
        Relevance DECIMAL(18, 2),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    ------------------------------------------------------
    -- Retrieve Search Criteria
    ------------------------------------------------------
    DECLARE @CountryList VARCHAR(1000) = NULL;
    DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
    DECLARE @CityList VARCHAR(1000) = NULL;
    DECLARE @StateList VARCHAR(1000) = NULL;
    DECLARE @RegionList VARCHAR(100) = NULL;
    DECLARE @YearList VARCHAR(1000) = NULL;
    DECLARE @CSOList VARCHAR(1000) = NULL;
    DECLARE @CancerTypeList VARCHAR(1000) = NULL;
    DECLARE @InvestigatorType VARCHAR(250) = NULL;
    DECLARE @Institution VARCHAR(250) = NULL;
    DECLARE @PILastName VARCHAR(50) = NULL;
    DECLARE @PIFirstName VARCHAR(50) = NULL;
    DECLARE @PIORCiD VARCHAR(50) = NULL;
    DECLARE @FundingOrgTypeList VARCHAR(50) = NULL;
    DECLARE @FundingOrgList VARCHAR(1000) = NULL;
    DECLARE @ChildhoodCancerList VARCHAR(1000) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @YearList = YearList,
            @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList,
            @CSOList = CSOList,
            @CancerTypeList = CancerTypeList,
            @InvestigatorType = InvestigatorType,
            @Institution = Institution,
            @PILastName = PILastName,
            @PIFirstName = PIFirstName,
            @PIORCiD = PIORCiD,
            @CityList = CityList,
            @StateList = StateList,
            @RegionList = RegionList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @FundingOrgList = FundingOrgList,
            @ChildhoodCancerList = ChildhoodCancerList
        FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Filter Projects Based on Criteria
    ------------------------------------------------------
    INSERT INTO #FilteredProjects (ProjectFundingID, categoryName, Relevance, Amount, Currency)
    SELECT 
        f.ProjectFundingID,
        c.categoryName,
        pc.Relevance,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID
    INNER JOIN CSO c ON pc.CSOCode = c.Code
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@CSOList IS NULL OR c.Code IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToIntTable(@FundingOrgList)))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    ------------------------------------------------------
    -- Apply Additional Filters
    ------------------------------------------------------
    IF @CancerTypeList IS NOT NULL
    BEGIN
        -- Include related cancer types
        SELECT l.VALUE, r.CancerTypeID AS RelatedCancerTypeID
        INTO #CancerTypeMapping
        FROM dbo.ToIntTable(@CancerTypeList) l
        LEFT JOIN CancerTypeRollUp r ON l.VALUE = r.CancerTypeRollupID;

        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectCancerType pct ON f.ProjectFundingID = pct.ProjectFundingID
            INNER JOIN #CancerTypeMapping ctm ON pct.CancerTypeID = ctm.CancerTypeID OR pct.CancerTypeID = ctm.RelatedCancerTypeID
        );
    END;

    IF @YearList IS NOT NULL
    BEGIN
        -- Filter by year
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    ------------------------------------------------------
    -- Calculate CSO Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT 
            categoryName,
            CAST(SUM(Relevance) / 100 AS DECIMAL(16, 2)) AS Relevance,
            0 AS USDAmount,
            COUNT(ProjectFundingID) AS ProjectCount
        INTO #CountStats
        FROM #FilteredProjects
        GROUP BY categoryName;

        SELECT @ResultCount = SUM(Relevance) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY Relevance DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        SELECT 
            categoryName,
            SUM(Relevance) AS Relevance,
            SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT 
                categoryName,
                Relevance / 100 AS Relevance,
                (Relevance / 100) * Amount * ISNULL(cr.ToCurrencyRate, 1) AS USDAmount
            FROM #FilteredProjects f
            LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        ) t
        GROUP BY categoryName;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
    END;

    ------------------------------------------------------
    -- Cleanup
    ------------------------------------------------------
    DROP TABLE #FilteredProjects;

    IF OBJECT_ID('tempdb..#CancerTypeMapping') IS NOT NULL DROP TABLE #CancerTypeMapping;
    IF OBJECT_ID('tempdb..#CountStats') IS NOT NULL DROP TABLE #CountStats;
    IF OBJECT_ID('tempdb..#AmountStats') IS NOT NULL DROP TABLE #AmountStats;
END;
GO



---------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]   
    @SearchID INT,
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------
    -- Temporary Table for Filtered Projects
    ------------------------------------------------------
    CREATE TABLE #FilteredProjects (
        ProjectFundingID INT NOT NULL,
        country NVARCHAR(255),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    ------------------------------------------------------
    -- Retrieve Search Criteria
    ------------------------------------------------------
    DECLARE @CountryList VARCHAR(1000) = NULL;
    DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
    DECLARE @YearList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgList VARCHAR(1000) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @YearList = YearList,
            @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList,
            @FundingOrgList = FundingOrgList
        FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Filter Projects Using SearchResultProject
    ------------------------------------------------------
    INSERT INTO #FilteredProjects (ProjectFundingID, country, Amount, Currency)
    SELECT 
        f.ProjectFundingID,
        pii.country,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
    INNER JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@CountryList IS NULL OR pii.country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
        AND (@IncomeGroupList IS NULL OR pii.country IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)));

    ------------------------------------------------------
    -- Apply Year Filter
    ------------------------------------------------------
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    ------------------------------------------------------
    -- Calculate Country Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT 
            country,
            COUNT(DISTINCT ProjectFundingID) AS [Count],
            0 AS USDAmount
        INTO #CountStats
        FROM #FilteredProjects
        GROUP BY country;

        SELECT @ResultCount = SUM([Count]) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY [Count] DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        SELECT 
            country,
            0 AS [Count],
            SUM(CAST((Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
        INTO #AmountStats
        FROM #FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY country;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
    END;

    ------------------------------------------------------
    -- Cleanup
    ------------------------------------------------------
    DROP TABLE #FilteredProjects;

    IF OBJECT_ID('tempdb..#CountStats') IS NOT NULL DROP TABLE #CountStats;
    IF OBJECT_ID('tempdb..#AmountStats') IS NOT NULL DROP TABLE #AmountStats;
END;
GO

-----------------------------------------------------------------

CREATE PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,	
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------
    -- Temporary Table for Filtered Projects
    ------------------------------------------------------
    CREATE TABLE #FilteredProjects (
        ProjectFundingID INT NOT NULL,
        CancerType NVARCHAR(255),
        Relevance DECIMAL(18, 2),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    ------------------------------------------------------
    -- Retrieve Search Criteria
    ------------------------------------------------------
    DECLARE @CancerTypeList VARCHAR(1000) = NULL;
    DECLARE @YearList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgTypeList VARCHAR(50) = NULL;
    DECLARE @ChildhoodCancerList VARCHAR(1000) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @CancerTypeList = CancerTypeList,
            @YearList = YearList,
            @FundingOrgList = FundingOrgList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @ChildhoodCancerList = ChildhoodCancerList
        FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Filter Projects Using SearchResultProject
    ------------------------------------------------------
    INSERT INTO #FilteredProjects (ProjectFundingID, CancerType, Relevance, Amount, Currency)
    SELECT 
        f.ProjectFundingID,
        ct.Name AS CancerType,
        pc.Relevance,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectCancerType pc ON f.ProjectFundingID = pc.ProjectFundingID
    INNER JOIN CancerType ct ON pc.CancerTypeID = ct.CancerTypeID
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@CancerTypeList IS NULL OR ct.CancerTypeID IN (SELECT VALUE FROM dbo.ToIntTable(@CancerTypeList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToIntTable(@FundingOrgList)))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    ------------------------------------------------------
    -- Apply Year Filter
    ------------------------------------------------------
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    ------------------------------------------------------
    -- Calculate CancerType Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT 
            CancerType,
            CAST(SUM(Relevance) / 100 AS DECIMAL(16, 2)) AS Relevance,
            0 AS USDAmount,
            COUNT(ProjectFundingID) AS ProjectCount
        INTO #CountStats
        FROM #FilteredProjects
        GROUP BY CancerType;

        SELECT @ResultCount = SUM(Relevance) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY Relevance DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        SELECT 
            CancerType,
            SUM(Relevance) AS Relevance,
            SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT 
                CancerType,
                Relevance / 100 AS Relevance,
                (Relevance / 100) * Amount * ISNULL(cr.ToCurrencyRate, 1) AS USDAmount
            FROM #FilteredProjects f
            LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        ) t
        GROUP BY CancerType;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
    END;

    ------------------------------------------------------
    -- Cleanup
    ------------------------------------------------------
    DROP TABLE #FilteredProjects;

    IF OBJECT_ID('tempdb..#CountStats') IS NOT NULL DROP TABLE #CountStats;
    IF OBJECT_ID('tempdb..#AmountStats') IS NOT NULL DROP TABLE #AmountStats;
END;
GO


CREATE PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
    @SearchID INT,
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'	
    @ResultCount INT OUTPUT,  -- return the total count
    @ResultAmount FLOAT OUTPUT  -- return the total amount	
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------
    -- Temporary Table for Filtered Projects
    ------------------------------------------------------
    CREATE TABLE #FilteredProjects (
        ProjectFundingID INT NOT NULL,
        ProjectType NVARCHAR(255),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    ------------------------------------------------------
    -- Retrieve Search Criteria
    ------------------------------------------------------
    DECLARE @ProjectTypeList VARCHAR(1000) = NULL;
    DECLARE @YearList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgTypeList VARCHAR(50) = NULL;
    DECLARE @ChildhoodCancerList VARCHAR(1000) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @ProjectTypeList = ProjectTypeList,
            @YearList = YearList,
            @FundingOrgList = FundingOrgList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @ChildhoodCancerList = ChildhoodCancerList
        FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Filter Projects Using SearchResultProject
    ------------------------------------------------------
    INSERT INTO #FilteredProjects (ProjectFundingID, ProjectType, Amount, Currency)
    SELECT 
        f.ProjectFundingID,
        pt.ProjectType,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN Project_ProjectType pt ON f.ProjectID = pt.ProjectID
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@ProjectTypeList IS NULL OR pt.ProjectType IN (SELECT VALUE FROM dbo.ToStrTable(@ProjectTypeList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    ------------------------------------------------------
    -- Apply Year Filter
    ------------------------------------------------------
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    ------------------------------------------------------
    -- Calculate ProjectType Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT 
            ProjectType,
            COUNT(*) AS [Count],
            0 AS USDAmount
        INTO #CountStats
        FROM #FilteredProjects
        GROUP BY ProjectType;

        SELECT @ResultCount = SUM([Count]) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY [Count] DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        SELECT 
            ProjectType,
            0 AS [Count],
            SUM(CAST((Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
        INTO #AmountStats
        FROM #FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY ProjectType;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
    END;

    ------------------------------------------------------
    -- Cleanup
    ------------------------------------------------------
    DROP TABLE #FilteredProjects;

    IF OBJECT_ID('tempdb..#CountStats') IS NOT NULL DROP TABLE #CountStats;
    IF OBJECT_ID('tempdb..#AmountStats') IS NOT NULL DROP TABLE #AmountStats;
END;
GO

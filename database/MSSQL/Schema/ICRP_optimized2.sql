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
   INNER JOIN (SELECT * FROM ProjectCSO WHERE ISNULL(Relevance, 0) <> 0) pc ON f.ProjectFundingID = pc.ProjectFundingID
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
-- Add after Year filter section
IF @YearList IS NOT NULL
BEGIN
    CREATE TABLE #YearlyAmounts (
        ProjectFundingID INT,
        CalendarAmount DECIMAL(18,2)
    );

    INSERT INTO #YearlyAmounts (ProjectFundingID, CalendarAmount)
    SELECT 
        ext.ProjectFundingID,
        SUM(ext.CalendarAmount)
    FROM 
        ProjectFundingExt ext
    WHERE 
        ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        AND ext.ProjectFundingID IN (SELECT ProjectFundingID FROM #FilteredProjects)
    GROUP BY ext.ProjectFundingID;

    -- Update the Amount in #FilteredProjects to reflect calendar-based filtered amount
    UPDATE f
    SET f.Amount = y.CalendarAmount
    FROM #FilteredProjects f
    INNER JOIN #YearlyAmounts y ON f.ProjectFundingID = y.ProjectFundingID;

    DROP TABLE #YearlyAmounts;
END;

       -- Add missing investigator and institution filters
    IF (@Institution IS NOT NULL) OR (@PILastName IS NOT NULL) OR (@PIFirstName IS NOT NULL) OR (@PIORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@CityList IS NOT NULL) OR (@StateList IS NOT NULL) OR (@RegionList IS NOT NULL)
    BEGIN
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
            INNER JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            INNER JOIN CountryMapLayer cm ON i.Country = cm.Country
            INNER JOIN Country c ON i.Country = c.Abbreviation
            WHERE 
                ((@Institution IS NULL) OR (i.Name LIKE '%' + @Institution + '%')) AND
                ((@InvestigatorType IS NULL) OR 
                    (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR 
                    (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND
                ((@PILastName IS NULL) OR (pi.LastName LIKE '%' + @PILastName + '%')) AND
                ((@PIFirstName IS NULL) OR (pi.FirstName LIKE '%' + @PIFirstName + '%')) AND
                ((@PIORCiD IS NULL) OR (pi.ORC_ID LIKE '%' + @PIORCiD + '%')) AND
                ((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))) AND
                ((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))) AND
                ((@CityList IS NULL) OR (i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))) AND
                ((@StateList IS NULL) OR (i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))) AND
                ((@RegionList IS NULL) OR (c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList))))
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
    -- Declare Variables for Search Criteria
    ------------------------------------------------------
    DECLARE @CountryList VARCHAR(1000) = NULL;
    DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
    DECLARE @YearList VARCHAR(1000) = NULL;
    DECLARE @FundingOrgList VARCHAR(1000) = NULL;
    DECLARE @cityList VARCHAR(1000) = NULL;
    DECLARE @stateList VARCHAR(1000) = NULL;
    DECLARE @regionList VARCHAR(100) = NULL;
    DECLARE @CSOlist VARCHAR(1000) = NULL;
    DECLARE @CancerTypelist VARCHAR(1000) = NULL;
    DECLARE @InvestigatorType VARCHAR(250) = NULL;
    DECLARE @institution VARCHAR(250) = NULL;
    DECLARE @piLastName VARCHAR(50) = NULL;
    DECLARE @piFirstName VARCHAR(50) = NULL;
    DECLARE @piORCiD VARCHAR(50) = NULL;
    DECLARE @FundingOrgTypeList VARCHAR(50) = NULL;
    DECLARE @childhoodcancerList VARCHAR(1000) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @YearList = YearList,
            @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList,
            @FundingOrgList = FundingOrgList,
            @cityList = cityList,
            @stateList = stateList,
            @regionList = regionList,
            @CSOlist = CSOlist,
            @CancerTypelist = CancerTypelist,
            @InvestigatorType = InvestigatorType,
            @institution = institution,
            @piLastName = piLastName,
            @piFirstName = piFirstName,
            @piORCiD = piORCiD,
            @FundingOrgTypeList = FundingOrgTypeList,
            @childhoodcancerList = childhoodcancerList
        FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Table Variable for Filtered Projects
    ------------------------------------------------------
    DECLARE @FilteredProjects TABLE (
        ProjectFundingID INT NOT NULL,
        Country NVARCHAR(255),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    -- Filter Projects Based on Criteria
-- Filter Projects Based on Criteria
INSERT INTO @FilteredProjects (ProjectFundingID, Country, Amount, Currency)
SELECT DISTINCT 
    f.ProjectFundingID,
    pii.Country,
    f.Amount,
    o.Currency
    FROM SearchResultProject srp
INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
INNER JOIN ProjectFundingInvestigator people ON f.ProjectFundingID = people.ProjectFundingID -- Find PI and collaborators
INNER JOIN Institution i ON i.InstitutionID = people.InstitutionID
INNER JOIN CountryMapLayer cm ON i.Country = cm.Country
INNER JOIN (
    SELECT InstitutionID, ProjectFundingID 
    FROM ProjectFundingInvestigator 
    WHERE IsPrincipalInvestigator = 1
) pi ON f.ProjectFundingID = pi.ProjectFundingID -- Find PI country
INNER JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID -- Get PI country
INNER JOIN Country c ON c.Abbreviation = i.Country
WHERE 
srp.SearchCriteriaID = @SearchID and 
    (@CountryList IS NULL OR i.Country IN (SELECT [Value] FROM dbo.ToStrTable(@CountryList)))
    AND (@IncomeGroupList IS NULL OR cm.[Value] IN (SELECT [Value] FROM dbo.ToStrTable(@IncomeGroupList)))
    AND (@InvestigatorType IS NULL OR 
        (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR 
        (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) -- Search only PI, collaborators, or all
    AND (@institution IS NULL OR i.Name LIKE '%' + @institution + '%')
    AND (@piLastName IS NULL OR people.LastName LIKE '%' + @piLastName + '%')
    AND (@piFirstName IS NULL OR people.FirstName LIKE '%' + @piFirstName + '%')
    AND (@piORCiD IS NULL OR people.ORC_ID LIKE '%' + @piORCiD + '%')
    AND (@cityList IS NULL OR i.City IN (SELECT [Value] FROM dbo.ToStrTable(@cityList)))
    AND (@stateList IS NULL OR i.State IN (SELECT [Value] FROM dbo.ToStrTable(@stateList)))
    AND (@regionList IS NULL OR c.RegionID IN (SELECT [Value] FROM dbo.ToStrTable(@regionList)))
    AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT [Value] FROM dbo.ToStrTable(@fundingOrgList)))
    AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT [Value] FROM dbo.ToStrTable(@FundingOrgTypeList)))
    AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT [Value] FROM dbo.ToStrTable(@childhoodcancerList)))
    AND (@YearList IS NULL OR EXISTS (
        SELECT 1
        FROM ProjectFundingExt ext
        WHERE f.ProjectFundingID = ext.ProjectFundingID
          AND ext.CalendarYear IN (SELECT [Value] FROM dbo.ToStrTable(@YearList))
    ));

    ------------------------------------------------------
    -- Calculate Country Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        DECLARE @CountStats TABLE (
            country NVARCHAR(255),
            Count INT,
            USDAmount DECIMAL(18, 2)
        );

        INSERT INTO @CountStats (Country, Count, USDAmount)
        SELECT 
            Country,
            COUNT(DISTINCT CONCAT(ProjectFundingID, Country, Amount, Currency)) AS [Count],
            0 AS USDAmount
        FROM @FilteredProjects
        GROUP BY Country;

        SELECT @ResultCount = SUM([Count]) FROM @CountStats;
        SELECT * FROM @CountStats ORDER BY [Count] DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        DECLARE @AmountStats TABLE (
            country NVARCHAR(255),
            Count INT,
            USDAmount DECIMAL(18, 2)
        );

        INSERT INTO @AmountStats (Country, Count, USDAmount)
        SELECT 
            Country,
            0 AS [Count],
            SUM(CAST((Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
        FROM @FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY Country;

        SELECT @ResultAmount = SUM(USDAmount) FROM @AmountStats;
        SELECT * FROM @AmountStats ORDER BY USDAmount DESC;
    END;

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

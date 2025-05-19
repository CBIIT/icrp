
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE dbo.GetProjectCountryStatsBySearchID
    @SearchID INT,
    @Year INT,
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,
    @ResultAmount FLOAT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare Variables for Search Criteria
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
    -- Materialize Filtered Projects into Table Variable
    ------------------------------------------------------
    DECLARE @FilteredProjects TABLE (
        ProjectFundingID INT,
        Country NVARCHAR(255),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    INSERT INTO @FilteredProjects (ProjectFundingID, Country, Amount, Currency)
    SELECT DISTINCT
        f.ProjectFundingID,
        pii.Country,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectFundingInvestigator people ON f.ProjectFundingID = people.ProjectFundingID
    INNER JOIN Institution i ON i.InstitutionID = people.InstitutionID
    INNER JOIN CountryMapLayer cm ON i.Country = cm.Country
    INNER JOIN (
        SELECT InstitutionID, ProjectFundingID 
        FROM ProjectFundingInvestigator 
        WHERE IsPrincipalInvestigator = 1
    ) pi ON f.ProjectFundingID = pi.ProjectFundingID
    INNER JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID
    INNER JOIN Country c ON c.Abbreviation = i.Country
    WHERE
        srp.SearchCriteriaID = @SearchID
        AND (@CountryList IS NULL OR i.Country IN (SELECT [Value] FROM dbo.ToStrTable(@CountryList)))
        AND (@IncomeGroupList IS NULL OR cm.[Value] IN (SELECT [Value] FROM dbo.ToStrTable(@IncomeGroupList)))
        AND (@InvestigatorType IS NULL OR 
            (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR 
            (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0))
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

    -- Adjust Amount by Year if needed
    IF @YearList IS NOT NULL AND @Type != 'Count'
    BEGIN
        ;WITH FilteredProjectFundingExt AS (
            SELECT ProjectFundingID, SUM(CalendarAmount) AS Amount
            FROM ProjectFundingExt
            WHERE CalendarYear IN (SELECT [Value] FROM dbo.ToStrTable(@YearList))
            GROUP BY ProjectFundingID
        )
        UPDATE fp
        SET fp.Amount = ext.Amount
        FROM @FilteredProjects fp
        JOIN FilteredProjectFundingExt ext ON fp.ProjectFundingID = ext.ProjectFundingID;
    END;

    ------------------------------------------------------
    -- Calculate Results
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT 
            Country,
            COUNT(*) AS [Count],
            0.0 AS USDAmount
        INTO #CountStats
        FROM @FilteredProjects
        GROUP BY Country;

        SELECT @ResultCount = SUM([Count]) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY [Count] DESC;
        DROP TABLE #CountStats;
    END
    ELSE
    BEGIN
        SELECT 
            f.Country,
            0 AS [Count],
            SUM(CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
        INTO #AmountStats
        FROM @FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY f.Country;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
        DROP TABLE #AmountStats;
    END
END;
GO

-------------------------------------------------------

ALTER   PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]   
    @SearchID INT,		
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,   -- Return the relevance
    @ResultAmount FLOAT OUTPUT  -- Return the amount
AS   
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------
    -- Temp table for filtered project funding records
    ------------------------------------------------------
    CREATE TABLE #FilteredProjects (
        ProjectFundingID INT NOT NULL,
        categoryName NVARCHAR(255),
        Relevance DECIMAL(18, 2),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    ------------------------------------------------------
    -- Declare criteria variables
    ------------------------------------------------------
    DECLARE 
        @CountryList VARCHAR(1000) = NULL,
        @IncomeGroupList VARCHAR(1000) = NULL,
        @CityList VARCHAR(1000) = NULL,
        @StateList VARCHAR(1000) = NULL,
        @RegionList VARCHAR(100) = NULL,
        @YearList VARCHAR(1000) = NULL,
        @CSOList VARCHAR(1000) = NULL,
        @CancerTypeList VARCHAR(1000) = NULL,
        @InvestigatorType VARCHAR(250) = NULL,
        @Institution VARCHAR(250) = NULL,
        @PILastName VARCHAR(50) = NULL,
        @PIFirstName VARCHAR(50) = NULL,
        @PIORCiD VARCHAR(50) = NULL,
        @FundingOrgTypeList VARCHAR(50) = NULL,
        @FundingOrgList VARCHAR(1000) = NULL,
        @ChildhoodCancerList VARCHAR(1000) = NULL;

    ------------------------------------------------------
    -- Load Search Criteria
    ------------------------------------------------------
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
        FROM SearchCriteria 
        WHERE SearchCriteriaID = @SearchID;
    END;

    ------------------------------------------------------
    -- Filter project fundings with CSO mappings
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
    INNER JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID AND ISNULL(pc.Relevance, 0) <> 0
    INNER JOIN CSO c ON pc.CSOCode = c.Code
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@CSOList IS NULL OR c.Code IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToIntTable(@FundingOrgList)))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    ------------------------------------------------------
    -- Filter by Cancer Type (with roll-up)
    ------------------------------------------------------
    IF @CancerTypeList IS NOT NULL
    BEGIN
        SELECT l.VALUE, r.CancerTypeID AS RelatedCancerTypeID
        INTO #CancerTypeMapping
        FROM dbo.ToIntTable(@CancerTypeList) l
        LEFT JOIN CancerTypeRollUp r ON l.VALUE = r.CancerTypeRollupID;

        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT f.ProjectFundingID
            FROM #FilteredProjects f
            INNER JOIN ProjectCancerType pct ON f.ProjectFundingID = pct.ProjectFundingID
            INNER JOIN #CancerTypeMapping ctm 
                ON pct.CancerTypeID = ctm.VALUE 
                OR pct.CancerTypeID = ctm.RelatedCancerTypeID
        );
    END;

    ------------------------------------------------------
    -- Filter by Year and Update Amount with CalendarYear data
    ------------------------------------------------------
    IF @YearList IS NOT NULL  AND @Type != 'Count'
    BEGIN
        CREATE TABLE #YearlyAmounts (
            ProjectFundingID INT,
            CalendarAmount DECIMAL(18,2)
        );

        INSERT INTO #YearlyAmounts (ProjectFundingID, CalendarAmount)
        SELECT 
            ext.ProjectFundingID,
            SUM(ext.CalendarAmount)
        FROM ProjectFundingExt ext
        WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
            AND ext.ProjectFundingID IN (SELECT ProjectFundingID FROM #FilteredProjects)
        GROUP BY ext.ProjectFundingID;

        -- Keep only matching projects
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM #YearlyAmounts);

        -- Update filtered project amounts
        UPDATE f
        SET f.Amount = y.CalendarAmount
        FROM #FilteredProjects f
        INNER JOIN #YearlyAmounts y ON f.ProjectFundingID = y.ProjectFundingID;

        DROP TABLE #YearlyAmounts;
    END;

    ------------------------------------------------------
    -- Filter by Investigator/Institution/Country
    ------------------------------------------------------
    IF (@Institution IS NOT NULL) OR (@PILastName IS NOT NULL) OR (@PIFirstName IS NOT NULL) OR 
       (@PIORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR 
       (@CityList IS NOT NULL) OR (@StateList IS NOT NULL) OR (@RegionList IS NOT NULL)
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
                (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%') AND
                (@InvestigatorType IS NULL OR 
                    (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR 
                    (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND
                (@PILastName IS NULL OR pi.LastName LIKE '%' + @PILastName + '%') AND
                (@PIFirstName IS NULL OR pi.FirstName LIKE '%' + @PIFirstName + '%') AND
                (@PIORCiD IS NULL OR pi.ORC_ID LIKE '%' + @PIORCiD + '%') AND
                (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList))) AND
                (@IncomeGroupList IS NULL OR cm.[VALUE] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList))) AND
                (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList))) AND
                (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList))) AND
                (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
        );
    END;

    ------------------------------------------------------
    -- Generate Output
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

-------------------------------------------------------


ALTER PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
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
    DECLARE @CountryList VARCHAR(1000) = NULL;
    DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
    DECLARE @CityList VARCHAR(1000) = NULL;
    DECLARE @StateList VARCHAR(1000) = NULL;
    DECLARE @RegionList VARCHAR(100) = NULL;
    DECLARE @InvestigatorType VARCHAR(250) = NULL;
    DECLARE @Institution VARCHAR(250) = NULL;
    DECLARE @PILastName VARCHAR(50) = NULL;
    DECLARE @PIFirstName VARCHAR(50) = NULL;
    DECLARE @PIORCiD VARCHAR(50) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @CancerTypeList = CancerTypeList,
            @YearList = YearList,
            @FundingOrgList = FundingOrgList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @ChildhoodCancerList = ChildhoodCancerList,
            @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList,
            @CityList = CityList,
            @StateList = StateList,
            @RegionList = RegionList,
            @InvestigatorType = InvestigatorType,
            @Institution = Institution,
            @PILastName = PILastName,
            @PIFirstName = PIFirstName,
            @PIORCiD = PIORCiD
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
    -- Apply Year Filter and Recalculate Amounts Based on CalendarAmount
    ------------------------------------------------------
    IF @YearList IS NOT NULL  AND @Type != 'Count'
    BEGIN
        -- Create temporary table for year-based amounts
        CREATE TABLE #YearlyAmounts (
            ProjectFundingID INT,
            CalendarAmount DECIMAL(18, 2)
        );

        -- Get the CalendarAmount for filtered projects in the specified year
        INSERT INTO #YearlyAmounts (ProjectFundingID, CalendarAmount)
        SELECT 
            ext.ProjectFundingID,
            SUM(ext.CalendarAmount) AS CalendarAmount
        FROM ProjectFundingExt ext
        WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
              AND ext.ProjectFundingID IN (SELECT ProjectFundingID FROM #FilteredProjects)
        GROUP BY ext.ProjectFundingID;

        -- Remove projects that don't have matching CalendarAmount for the specified year
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM #YearlyAmounts);

        -- Update the Amount based on CalendarAmount
        UPDATE f
        SET f.Amount = y.CalendarAmount
        FROM #FilteredProjects f
        INNER JOIN #YearlyAmounts y ON f.ProjectFundingID = y.ProjectFundingID;

        DROP TABLE #YearlyAmounts;
    END;

    ------------------------------------------------------
    -- Apply Investigator and Institution Filters (if provided)
    ------------------------------------------------------
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
    -- Calculate Stats Based on Type
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
            LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency 
                                      AND cr.ToCurrency = 'USD' 
                                      AND cr.Year = @Year
        ) t
        GROUP BY CancerType;
        -- Update ResultCount for Amount calculation

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

-------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
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
    DECLARE @CountryList VARCHAR(1000) = NULL;
    DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
    DECLARE @CityList VARCHAR(1000) = NULL;
    DECLARE @StateList VARCHAR(1000) = NULL;
    DECLARE @RegionList VARCHAR(100) = NULL;
    DECLARE @InvestigatorType VARCHAR(250) = NULL;
    DECLARE @Institution VARCHAR(250) = NULL;
    DECLARE @PILastName VARCHAR(50) = NULL;
    DECLARE @PIFirstName VARCHAR(50) = NULL;
    DECLARE @PIORCiD VARCHAR(50) = NULL;

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @ProjectTypeList = ProjectTypeList,
            @YearList = YearList,
            @FundingOrgList = FundingOrgList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @ChildhoodCancerList = ChildhoodCancerList,
            @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList,
            @CityList = CityList,
            @StateList = StateList,
            @RegionList = RegionList,
            @InvestigatorType = InvestigatorType,
            @Institution = Institution,
            @PILastName = PILastName,
            @PIFirstName = PIFirstName,
            @PIORCiD = PIORCiD
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
    IF @YearList IS NOT NULL  AND @Type != 'Count'
    BEGIN
        -- Create temporary table for year-based amounts
        CREATE TABLE #YearlyAmounts (
            ProjectFundingID INT,
            CalendarAmount DECIMAL(18, 2)
        );

        -- Get the CalendarAmount for filtered projects in the specified year
        INSERT INTO #YearlyAmounts (ProjectFundingID, CalendarAmount)
        SELECT 
            ext.ProjectFundingID,
            SUM(ext.CalendarAmount) AS CalendarAmount
        FROM ProjectFundingExt ext
        WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
              AND ext.ProjectFundingID IN (SELECT ProjectFundingID FROM #FilteredProjects)
        GROUP BY ext.ProjectFundingID;

        -- Remove projects that don't have matching CalendarAmount for the specified year
        DELETE FROM #FilteredProjects
        WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM #YearlyAmounts);

        -- Update the Amount based on CalendarAmount
        UPDATE f
        SET f.Amount = y.CalendarAmount
        FROM #FilteredProjects f
        INNER JOIN #YearlyAmounts y ON f.ProjectFundingID = y.ProjectFundingID;

        DROP TABLE #YearlyAmounts;
    END;

    ------------------------------------------------------
    -- Apply Investigator and Institution Filters
    ------------------------------------------------------
    IF (@Institution IS NOT NULL) OR (@PILastName IS NOT NULL) OR (@PIFirstName IS NOT NULL) OR (@PIORCiD IS NOT NULL) OR 
       (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@CityList IS NOT NULL) OR 
       (@StateList IS NOT NULL) OR (@RegionList IS NOT NULL)
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


-------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
GO
ALTER PROCEDURE [dbo].[GetProjectExportsBySearchIDOpt]
    @SearchID INT,
    @IncludeAbstract INT = 0,
    @SiteURL VARCHAR(250) = 'https://www.icrpartnership.org/project/',
    @Year SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Table variable to hold project funding
    DECLARE @ProjectFunding TABLE (
        ProjectID INT,
        ProjectFundingID INT,
        AwardTitle VARCHAR(255),
        AwardType VARCHAR(255),
        AwardCode VARCHAR(50),
        Source_ID VARCHAR(50),
        AltAwardCode VARCHAR(50),
        FundingCategory VARCHAR(100),
        IsChildhood VARCHAR(50),
        AwardStartDate DATE,
        AwardEndDate DATE,
        BudgetStartDate DATE,
        BudgetEndDate DATE,
        AwardAmount DECIMAL(18, 2),
        FundingIndicator CHAR(1),
        Currency VARCHAR(10),
        FundingMechanism VARCHAR(255),
        FundingMechanismCode VARCHAR(50),
        SponsorCode VARCHAR(50),
        FundingOrg VARCHAR(255),
        FundingOrgType VARCHAR(50),
        FundingDiv VARCHAR(255),
        FundingDivAbbr VARCHAR(50),
        FundingContact VARCHAR(255),
        PiLastName VARCHAR(255),
        PiFirstName VARCHAR(255),
        PiORCID VARCHAR(50),
        Institution VARCHAR(255),
        City VARCHAR(255),
        State VARCHAR(255),
        Country VARCHAR(255),
        Region VARCHAR(255),
        ICRPURL VARCHAR(255),
        TechAbstract TEXT
    );

    -- Declare variables
    DECLARE @PivotColumns NVARCHAR(MAX);
    DECLARE @SQLQuery NVARCHAR(MAX);

    DECLARE 
        @CountryList VARCHAR(1000) = NULL,
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
        @PiORCID VARCHAR(50) = NULL,
        @FundingOrgTypeList VARCHAR(50) = NULL,
        @FundingOrgList VARCHAR(1000) = NULL,
        @ChildhoodCancerList VARCHAR(1000) = NULL;

    -- Load base data
    INSERT INTO @ProjectFunding
    SELECT DISTINCT
        p.ProjectID,
        f.ProjectFundingID,
        LEFT(f.Title, 255),
        NULL,
        LEFT(p.AwardCode, 50),
        LEFT(f.Source_ID, 50),
        LEFT(f.AltAwardCode, 50),
        LEFT(f.Category, 100),
        CASE f.IsChildhood
            WHEN 1 THEN 'Yes'
            WHEN 2 THEN 'Partially'
            WHEN 0 THEN 'No'
            ELSE ''
        END,
        p.ProjectStartDate,
        p.ProjectEndDate,
        f.BudgetStartDate,
        f.BudgetEndDate,
        CAST(f.Amount AS DECIMAL(18, 2)),
        CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END,
        LEFT(o.Currency, 10),
        LEFT(f.MechanismTitle, 255),
        LEFT(f.MechanismCode, 50),
        LEFT(o.SponsorCode, 50),
        LEFT(o.Name, 255),
        LEFT(o.Type, 50),
        LEFT(d.Name, 255),
        LEFT(d.Abbreviation, 50),
        LEFT(f.FundingContact, 255),
        LEFT(pi.LastName, 255),
        LEFT(pi.FirstName, 255),
        LEFT(pi.ORC_ID, 50),
        LEFT(i.Name, 255),
        LEFT(i.City, 255),
        LEFT(i.State, 255),
        LEFT(i.Country, 255),
        LEFT(l.Name, 255),
        LEFT(@SiteURL + CAST(p.ProjectID AS VARCHAR(10)), 255),
        LEFT(a.TechAbstract, 8000)
    FROM SearchResultProject srp
    JOIN Project p ON srp.ProjectID = p.ProjectID
    JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
    JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
    JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID
    JOIN Institution i ON i.InstitutionID = pi.InstitutionID
    JOIN CountryMapLayer cm ON i.Country = cm.Country
    JOIN Country c ON c.Abbreviation = i.Country
    JOIN lu_Region l ON c.RegionID = l.RegionID
    LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
    LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
        AND (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%')
        AND (@InvestigatorType IS NULL OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND pi.IsPrincipalInvestigator = 0))
        AND (@PiLastName IS NULL OR pi.LastName LIKE '%' + @PiLastName + '%')
        AND (@PiFirstName IS NULL OR pi.FirstName LIKE '%' + @PiFirstName + '%')
        AND (@PiORCID IS NULL OR pi.ORC_ID LIKE '%' + @PiORCID + '%')
        AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
        AND (@IncomeGroupList IS NULL OR cm.VALUE IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
        AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
        AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
        AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
        AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    -- Filter by Year
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM @ProjectFunding
        WHERE ProjectFundingID NOT IN (
            SELECT f.ProjectFundingID
            FROM @ProjectFunding f
            JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END

    -- Filter by CSO
    IF @CSOList IS NOT NULL
    BEGIN
        DELETE FROM @ProjectFunding
        WHERE ProjectFundingID NOT IN (
            SELECT f.ProjectFundingID
            FROM @ProjectFunding f
            JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID
            WHERE pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
        );
    END

    -- Filter by Cancer Type
    IF @CancerTypeList IS NOT NULL
    BEGIN
        DELETE FROM @ProjectFunding
        WHERE ProjectFundingID NOT IN (
            SELECT f.ProjectFundingID
            FROM @ProjectFunding f
            JOIN ProjectCancerType pc ON f.ProjectFundingID = pc.ProjectFundingID
            WHERE pc.CancerTypeID IN (
                SELECT CancerTypeID FROM dbo.ToIntTable(@CancerTypeList)
            )
        );
    END

    -- Move data to temp table so dynamic SQL can use it
    SELECT * INTO #TempFunding FROM @ProjectFunding;

        -- Update AwardType after loading into temp table
    UPDATE #TempFunding
    SET AwardType = aw.AwardTypes
    FROM #TempFunding t
    JOIN (
        SELECT DISTINCT ProjectID,
            STUFF((
                SELECT ', ' + ProjectType
                FROM Project_ProjectType pt2
                WHERE pt2.ProjectID = pt.ProjectID
                FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
            , 1, 1, '') AS AwardTypes
        FROM Project_ProjectType pt
    ) aw ON t.ProjectID = aw.ProjectID;


    -- Get dynamic pivot column list
    SELECT @PivotColumns = STRING_AGG(QUOTENAME(CalendarYear), ',')
    FROM (
        SELECT DISTINCT ext.CalendarYear
        FROM ProjectFundingExt ext
        JOIN #TempFunding pf ON pf.ProjectFundingID = ext.ProjectFundingID
    ) AS Years;

    -- Build dynamic pivot query
    SET @SQLQuery = '
    SELECT * FROM (
        SELECT 
            pf.ProjectID,
            pf.ProjectFundingID,
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
            pf.FundingIndicator,
            pf.Currency,
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
            CASE WHEN @IncludeAbstract = 1 THEN ', pf.TechAbstract' ELSE '' END + ',
            ext.CalendarYear,
            CAST(ext.CalendarAmount * ISNULL(cr.ToCurrencyRate, 1) AS DECIMAL(18,2)) AS CalendarAmount
        FROM #TempFunding pf
        JOIN ProjectFundingExt ext ON pf.ProjectFundingID = ext.ProjectFundingID
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = pf.Currency 
            AND cr.ToCurrency = ''USD'' 
            AND cr.Year = ' + CAST(@Year AS VARCHAR(4)) + '
    ) AS SourceTable
    PIVOT (
        SUM(CalendarAmount)
        FOR CalendarYear IN (' + @PivotColumns + ')
    ) AS PivotTable;
    ';

    -- Execute the final pivoted query
    EXEC sp_executesql @SQLQuery;

    -- Clean up
    DROP TABLE #TempFunding;
END;
GO

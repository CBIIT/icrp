SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]   
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
    -- Recalculate Amount Based on CalendarAmount (Only When @Type != 'Count')
    ------------------------------------------------------
IF @YearList IS NOT NULL AND @Type != 'Count'
BEGIN
    -- Convert @YearList to a usable CTE
    WITH YearList AS (
        SELECT [Value] AS Year
        FROM dbo.ToStrTable(@YearList)
    ),
    
    -- Filter ProjectFundingExt by year
    FilteredProjectFundingExt AS (
        SELECT ProjectFundingID, CalendarAmount
        FROM ProjectFundingExt
        WHERE CalendarYear IN (SELECT Year FROM YearList)
    ),

    -- Aggregate CalendarAmount for each ProjectFundingID
    TmpCalAmt AS (
        SELECT 
            f.ProjectFundingID,
            SUM(ext.CalendarAmount) AS Amount
        FROM @FilteredProjects f
        INNER JOIN FilteredProjectFundingExt ext 
            ON f.ProjectFundingID = ext.ProjectFundingID
        GROUP BY f.ProjectFundingID
    )

    -- Update the Amount in @FilteredProjects
    UPDATE fp
    SET fp.Amount = ISNULL(tca.Amount, 0)
    FROM @FilteredProjects fp
    INNER JOIN TmpCalAmt tca 
        ON fp.ProjectFundingID = tca.ProjectFundingID;
END;


    ------------------------------------------------------
    -- Calculate Country Stats
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        DECLARE @CountStats TABLE (
            country NVARCHAR(255),
            Count INT
        );

        INSERT INTO @CountStats (country, Count)
        SELECT 
            Country,
            COUNT(DISTINCT CONCAT(ProjectFundingID, Country, Amount, Currency)) AS [Count]
        FROM @FilteredProjects
        GROUP BY country;

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

        INSERT INTO @AmountStats (country, Count, USDAmount)
        SELECT 
            Country,
            0 AS [Count],
            SUM(CAST((Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
        FROM @FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY country;

        SELECT @ResultAmount = SUM(USDAmount) FROM @AmountStats;
        SELECT * FROM @AmountStats ORDER BY USDAmount DESC;
    END;

END;
GO


----------  -- This stored procedure retrieves project statistics based on various search criteria.
ALTER  PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,
    @Year INT,
    @Type VARCHAR(25) = 'Count', -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,
    @ResultAmount FLOAT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

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
    -- Load search filters
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
            @PILastName = piLastName,
            @PIFirstName = piFirstName,
            @PIORCiD = piORCiD,
            @CityList = CityList,
            @StateList = StateList,
            @RegionList = RegionList,
            @FundingOrgTypeList = FundingOrgTypeList,
            @FundingOrgList = FundingOrgList,
            @ChildhoodCancerList = ChildhoodCancerList
        FROM SearchCriteria
        WHERE SearchCriteriaID = @SearchID;
    END

    ------------------------------------------------------
    -- Expand Cancer Type Rollups
    ------------------------------------------------------
    ;WITH CancerTypes AS (
        SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@CancerTypeList)
    ),
    ExpandedCancerTypes AS (
        SELECT CancerTypeID FROM CancerTypes
        UNION
        SELECT cru.CancerTypeID FROM CancerTypeRollUp cru
        JOIN CancerTypes ct ON cru.CancerTypeRollupID = ct.CancerTypeID
        WHERE cru.CancerTypeID IS NOT NULL
    )
    SELECT DISTINCT CancerTypeID
    INTO #CTList
    FROM ExpandedCancerTypes;

    ------------------------------------------------------
    -- Initial Project Funding Selection
    ------------------------------------------------------
    CREATE TABLE #PF (
        ProjectID INT,
        ProjectFundingID INT,
        CancerType NVARCHAR(250),
        Relevance FLOAT,
        Amount FLOAT,
        Currency VARCHAR(10)
    );

    INSERT INTO #PF
    SELECT
        f.ProjectID,
        f.ProjectFundingID,
        ct.Name AS CancerType,
        pc.Relevance,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    JOIN ProjectCancerType pc ON f.ProjectFundingID = pc.ProjectFundingID AND ISNULL(pc.Relevance, 0) <> 0
    JOIN CancerType ct ON pc.CancerTypeID = ct.CancerTypeID
    WHERE srp.SearchCriteriaID = @SearchID
      AND (@CancerTypeList IS NULL OR ct.CancerTypeID IN (SELECT CancerTypeID FROM #CTList))
      AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    ------------------------------------------------------
    -- Filter by CSO if provided
    ------------------------------------------------------
    IF @CSOList IS NOT NULL
    BEGIN
        DELETE FROM #PF
        WHERE ProjectFundingID NOT IN (
            SELECT pc.ProjectFundingID
            FROM ProjectCSO pc
            JOIN CSO c ON c.Code = pc.CSOCode
            WHERE ISNULL(pc.Relevance, 0) <> 0
              AND pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
        );
    END

    ------------------------------------------------------
    -- Filter by YearList and update Amounts if needed
    ------------------------------------------------------
    IF @YearList IS NOT NULL
    BEGIN
        CREATE TABLE #TmpCalAmt (
            ProjectFundingID INT,
            Amount FLOAT
        );

        INSERT INTO #TmpCalAmt
        SELECT f.ProjectFundingID, SUM(ext.CalendarAmount)
        FROM (SELECT DISTINCT ProjectFundingID FROM #PF) f
        JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID
        WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        GROUP BY f.ProjectFundingID;

        DELETE FROM #PF
        WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM #TmpCalAmt);

        UPDATE f
        SET f.Amount = ISNULL(ca.Amount, 0)
        FROM #PF f
        JOIN #TmpCalAmt ca ON f.ProjectFundingID = ca.ProjectFundingID;
    END

    ------------------------------------------------------
    -- Filter by Investigator or Institution Info
    ------------------------------------------------------
    IF (@Institution IS NOT NULL OR @PILastName IS NOT NULL OR @PIFirstName IS NOT NULL OR 
        @PIORCiD IS NOT NULL OR @InvestigatorType IS NOT NULL OR @CountryList IS NOT NULL OR 
        @CityList IS NOT NULL OR @StateList IS NOT NULL OR @RegionList IS NOT NULL OR 
        @IncomeGroupList IS NOT NULL)
    BEGIN
        DELETE FROM #PF
        WHERE ProjectFundingID NOT IN (
            SELECT DISTINCT pi.ProjectFundingID
            FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            JOIN CountryMapLayer cm ON i.Country = cm.Country
            JOIN Country c ON i.Country = c.Abbreviation
            WHERE (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%')
              AND (@InvestigatorType IS NULL OR 
                    (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR
                    (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0))
              AND (@PILastName IS NULL OR pi.LastName LIKE '%' + @PILastName + '%')
              AND (@PIFirstName IS NULL OR pi.FirstName LIKE '%' + @PIFirstName + '%')
              AND (@PIORCiD IS NULL OR pi.ORC_ID LIKE '%' + @PIORCiD + '%')
              AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
              AND (@IncomeGroupList IS NULL OR cm.Value IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
              AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
              AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
              AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
        );
    END

    ------------------------------------------------------
    -- Cancer Type Stats Output
    ------------------------------------------------------
    IF @Type = 'Count'
    BEGIN
        SELECT
            CancerType,
            CAST(SUM(Relevance) / 100 AS DECIMAL(16,2)) AS Relevance,
            0 AS USDAmount,
            COUNT(*) AS ProjectCount
        INTO #CountStats
        FROM #PF
        GROUP BY CancerType;

        SELECT @ResultCount = SUM(Relevance) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY Relevance DESC;
    END
    ELSE -- Amount
    BEGIN
        SELECT
            CancerType,
            SUM(Relevance) AS Relevance,
            SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT
                f.CancerType,
                f.Relevance / 100 AS Relevance,
                (f.Relevance / 100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS USDAmount
            FROM #PF f
            LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        ) AS sub
        GROUP BY CancerType;

        SELECT @ResultCount = SUM(Relevance) FROM #AmountStats;
        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
    END
END;
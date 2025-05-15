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
    SELECT 
        f.ProjectFundingID,
        pii.Country,
        f.Amount,
        o.Currency
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
    INNER JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID
    WHERE 
        srp.SearchCriteriaID = @SearchID
        AND (@CountryList IS NULL OR pii.Country IN (SELECT [Value] FROM dbo.ToStrTable(@CountryList)))
        AND (@IncomeGroupList IS NULL OR pii.Country IN (SELECT [Value] FROM dbo.ToStrTable(@IncomeGroupList)))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT [Value] FROM dbo.ToStrTable(@FundingOrgList)))
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
            Country NVARCHAR(255),
            Count INT,
            USDAmount DECIMAL(18, 2)
        );

        INSERT INTO @CountStats (Country, Count, USDAmount)
        SELECT 
            Country,
            COUNT(DISTINCT ProjectFundingID) AS [Count],
            0 AS USDAmount
        FROM @FilteredProjects
        GROUP BY Country;

        SELECT @ResultCount = SUM([Count]) FROM @CountStats;
        SELECT * FROM @CountStats ORDER BY [Count] DESC;
    END
    ELSE -- 'Amount'
    BEGIN
        DECLARE @AmountStats TABLE (
            Country NVARCHAR(255),
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

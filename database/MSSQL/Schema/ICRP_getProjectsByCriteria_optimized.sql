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
    DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

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
            -- Cancer Type Filter (with roll-up logic)
            AND (
                @cancerTypeList IS NULL OR ProjectFundingID IN (
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
    FROM (SELECT DISTINCT ProjectID FROM #FilteredProjects) AS DistinctProjects;

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
            SELECT @searchCriteriaID AS SearchCriteriaID, ProjectID 
            FROM (SELECT DISTINCT ProjectID FROM #FilteredProjects) AS DistinctProjects;

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
    IF OBJECT_ID('tempdb..#ct') IS NOT NULL DROP TABLE #ct;
    IF OBJECT_ID('tempdb..#ctlist') IS NOT NULL DROP TABLE #ctlist;
END;
GO





ALTER PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
    @SearchID INT,
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'	
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare filter variables
    DECLARE @ProjectTypeList VARCHAR(1000), @CountryList VARCHAR(1000), @IncomeGroupList VARCHAR(1000),
            @cityList VARCHAR(1000), @stateList VARCHAR(1000), @regionList VARCHAR(100),
            @YearList VARCHAR(1000), @CSOlist VARCHAR(1000), @CancerTypelist VARCHAR(1000),
            @InvestigatorType VARCHAR(250), @institution VARCHAR(250), @piLastName VARCHAR(50),
            @piFirstName VARCHAR(50), @piORCiD VARCHAR(50), @FundingOrgTypeList VARCHAR(50),
            @fundingOrgList VARCHAR(1000), @childhoodcancerList VARCHAR(1000);

    -- Load search criteria
    SELECT 
        @ProjectTypeList = ProjectTypeList,
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
    FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;

    -- CancerType rollup
    DECLARE @ctlist TABLE (CancerTypeID INT PRIMARY KEY);
    IF @CancerTypelist IS NOT NULL
    BEGIN
        INSERT INTO @ctlist(CancerTypeID)
        SELECT DISTINCT CancerTypeID FROM (
            SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@CancerTypelist)
            UNION
            SELECT r.CancerTypeID FROM dbo.ToIntTable(@CancerTypelist) l
            LEFT JOIN CancerTypeRollUp r ON l.VALUE = r.CancerTyperollupID
            WHERE r.CancerTypeID IS NOT NULL
        ) x
    END

    -- Main filtered projects with all filters applied up front
    SELECT 
        f.ProjectID, f.ProjectFundingID, pt.ProjectType, f.Amount, o.Currency
    INTO #pf
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN Project_ProjectType pt ON f.ProjectID = pt.ProjectID
    WHERE srp.SearchCriteriaID = @SearchID
      AND (@ProjectTypeList IS NULL OR pt.ProjectType IN (SELECT VALUE FROM dbo.ToStrTable(@ProjectTypeList)))
      AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@fundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@childhoodcancerList)))
      AND (
        @CSOlist IS NULL OR EXISTS (
            SELECT 1 FROM ProjectCSO pc
            WHERE pc.ProjectFundingID = f.ProjectFundingID
              AND ISNULL(pc.Relevance,0) <> 0
              AND pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOlist))
        )
      )
      AND (
        @CancerTypelist IS NULL OR EXISTS (
            SELECT 1 FROM ProjectCancerType pct
            WHERE pct.ProjectFundingID = f.ProjectFundingID
              AND pct.CancerTypeID IN (SELECT CancerTypeID FROM @ctlist)
              AND ISNULL(pct.Relevance,0) <> 0
        )
      )
      AND (
        @YearList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingExt ext
            WHERE ext.ProjectFundingID = f.ProjectFundingID
              AND ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        )
      )
      AND (
        @institution IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND i.Name LIKE '%' + @institution + '%'
        )
      )
      AND (
        @InvestigatorType IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND (
                (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1)
                OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator,0) = 0)
              )
        )
      )
      AND (
        @piLastName IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND pi.LastName LIKE '%' + @piLastName + '%'
        )
      )
      AND (
        @piFirstName IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND pi.FirstName LIKE '%' + @piFirstName + '%'
        )
      )
      AND (
        @piORCiD IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND pi.ORC_ID LIKE '%' + @piORCiD + '%'
        )
      )
      AND (
        @CountryList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList))
        )
      )
      AND (
        @IncomeGroupList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            JOIN CountryMapLayer cm ON i.Country = cm.Country
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND cm.[VALUE] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList))
        )
      )
      AND (
        @cityList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND i.City IN (SELECT VALUE FROM dbo.ToStrTable(@cityList))
        )
      )
      AND (
        @stateList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND i.State IN (SELECT VALUE FROM dbo.ToStrTable(@stateList))
        )
      )
      AND (
        @regionList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingInvestigator pi
            JOIN Institution i ON pi.InstitutionID = i.InstitutionID
            JOIN Country c ON i.Country = c.Abbreviation
            WHERE pi.ProjectFundingID = f.ProjectFundingID
              AND c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@regionList))
        )
      );

    -- Adjust Amount by Year if needed
    IF @YearList IS NOT NULL AND @Type != 'Count'
    BEGIN
        -- Replace Amount with sum of CalendarAmount for the selected years
        UPDATE f
        SET f.Amount = ISNULL(ext.Amount,0)
        FROM #pf f
        JOIN (
            SELECT ProjectFundingID, SUM(CalendarAmount) AS Amount
            FROM ProjectFundingExt
            WHERE CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
            GROUP BY ProjectFundingID
        ) ext ON f.ProjectFundingID = ext.ProjectFundingID;
    END

    -- Output
    IF @Type = 'Count'
    BEGIN
        SELECT ProjectType, COUNT(*) AS [Count], 0 AS USDAmount
        INTO #CountStats
        FROM #pf
        GROUP BY ProjectType;

        SELECT @ResultCount = SUM([Count]) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY [Count] DESC;
        DROP TABLE #CountStats;
    END
    ELSE
    BEGIN
        SELECT ProjectType, 0 AS [Count], SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT ProjectType, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
            FROM #pf f
            LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency
        ) t
        GROUP BY ProjectType;

        SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
        DROP TABLE #AmountStats;
    END

    DROP TABLE #pf;
END
GO
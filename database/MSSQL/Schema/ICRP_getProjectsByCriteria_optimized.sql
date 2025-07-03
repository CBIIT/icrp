SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]
    @SearchID INT,		
    @Year INT,	
    @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
    @ResultCount INT OUTPUT,  
    @ResultAmount FLOAT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare filter variables
    DECLARE @CountryList VARCHAR(1000), @IncomeGroupList VARCHAR(1000), @cityList VARCHAR(1000), @stateList VARCHAR(1000),
            @regionList VARCHAR(100), @YearList VARCHAR(1000), @CSOlist VARCHAR(1000), @CancerTypelist VARCHAR(1000),
            @InvestigatorType VARCHAR(250), @institution VARCHAR(250), @piLastName VARCHAR(50), @piFirstName VARCHAR(50),
            @piORCiD VARCHAR(50), @FundingOrgTypeList VARCHAR(50), @fundingOrgList VARCHAR(1000), @childhoodcancerList VARCHAR(1000);

	CREATE TABLE #Result (ProjectID INT NOT NULL)
	DECLARE @ProjectIDs VARCHAR(max)

    -- Load search criteria
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		-- Load search criteria
		SELECT 
			@ProjectIDs = Results,
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
		FROM SearchCriteria sc
		JOIN SearchResult sr on sc.SearchCriteriaID = sr.SearchCriteriaID
		WHERE sc.SearchCriteriaID = @SearchID;

		INSERT INTO #Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
	END

    -- Main filtered projects
    SELECT 
        f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency
    INTO #pf
    FROM #Result r
    INNER JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID AND ISNULL(pc.Relevance,0) <> 0
    INNER JOIN CSO c ON pc.CSOCode = c.Code
    WHERE (@CSOlist IS NULL OR c.Code IN (SELECT VALUE FROM dbo.ToStrTable(@CSOlist)))
      AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@fundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@childhoodcancerList)));

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

		DELETE FROM #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
		
		DROP TABLE #ct
		DROP TABLE #ctlist
	END

	IF @YearList IS NOT NULL
	BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE FROM #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		IF @Type != 'Count'
		BEGIN
			UPDATE pf SET Amount = ISNULL(cal.amount,0)
			FROM #pf pf
			JOIN #tmpCalAmt cal ON pf.ProjectFundingID = cal.ProjectFundingID
		END

		DROP TABLE #tmpCalAmt
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@IncomeGroupList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE FROM #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				LEFT JOIN CountryMapLayer cm ON i.country = cm.Country
				LEFT JOIN Country c ON i.Country = c.Abbreviation							
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

    -- Output
    IF @Type = 'Count'
    BEGIN
        SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0 AS USDAmount, COUNT(*) AS ProjectCount
        INTO #CountStats
        FROM #pf
        GROUP BY categoryName;

        SELECT @ResultCount = SUM(Relevance) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY Relevance DESC;
        DROP TABLE #CountStats;
    END
    ELSE
    BEGIN
        SELECT categoryName, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT categoryName, Relevance/100 AS Relevance,
                   (Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS USDAmount
            FROM #pf f
            LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency
        ) t
        GROUP BY categoryName;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
        DROP TABLE #AmountStats;
    END

    DROP TABLE #pf;
	DROP TABLE #Result;
END
GO

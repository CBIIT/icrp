/****** Object:  StoredProcedure [dbo].[GetProjectAwardStatsBySearchIDBase]    Script Date: 8/14/2025 1:45:00 PM ******/
USE [icrp_data]
GO	
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectAwardStatsBySearchIDBase]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[GetProjectAwardStatsBySearchIDBase]
GO

CREATE PROCEDURE [dbo].[GetProjectAwardStatsBySearchIDBase]
    @SearchID INT,
	@Year INT,
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,
	@ResultAmount float OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------
	;WITH FilteredSearchResult AS (
		SELECT DISTINCT srp.ProjectID
		FROM SearchResultProject srp
		WHERE srp.SearchCriteriaID = @SearchID
	)
	SELECT ProjectID INTO #Result
	FROM FilteredSearchResult;

	DECLARE @ProjectIDs VARCHAR(max);
	DECLARE @CountryList VARCHAR(1000) = NULL;
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
	DECLARE @cityList varchar(1000) = NULL;
	DECLARE @stateList varchar(1000) = NULL;
	DECLARE @regionList varchar(100) = NULL;
	DECLARE @Yearlist VARCHAR(1000) = NULL;
	DECLARE @CSOlist VARCHAR(1000) = NULL;
	DECLARE @CancerTypelist VARCHAR(1000) = NULL;
	DECLARE @InvestigatorType varchar(250) = NULL;
	DECLARE @institution varchar(250) = NULL;
	DECLARE @piLastName varchar(50) = NULL;
	DECLARE @piFirstName varchar(50) = NULL;
	DECLARE @piORCiD varchar(50) = NULL;
	DECLARE @FundingOrgTypeList varchar(50) = NULL;
	DECLARE @fundingOrgList varchar(1000) = NULL;
	DECLARE @childhoodcancerList varchar(1000) = NULL;

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID FROM Project;
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID;

		SELECT @YearList = YearList,
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
		FROM SearchCriteria
		WHERE SearchCriteriaID = @SearchID;
	END

	SELECT ProjectID INTO #proj FROM #Result;

	----------------------------------
	-- Find all related project funding years
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ext.CalendarYear, ext.CalendarAmount, o.Currency
	INTO #pf
	FROM #proj r
	JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
	JOIN ProjectFundingExt ext ON ext.ProjectFundingID = f.ProjectFundingID
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	WHERE ((@YearList IS NULL) OR (ext.CalendarYear IN (SELECT VALUE AS [CalendarYear] FROM dbo.ToStrTable(@YearList))))
		AND ((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList))))
		AND ((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))
		AND ((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))));

	------------------------------------------------------------------------------
	-- Exclude project funding records outside of search criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)));

	IF @CancerTypelist IS NOT NULL
	BEGIN
		SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct
			FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
			LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID;

		SELECT DISTINCT cancertypeid INTO #ctlist FROM
		(
			SELECT cancertypeid FROM #ct
			UNION
			SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
		) ct;

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist));
	END

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation
			WHERE ((@institution IS NULL) OR (i.Name like '%' + @institution + '%'))
				AND ((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0))
				AND ((@piLastName IS NULL) OR (pi.LastName like '%' + @piLastName + '%'))
				AND ((@piFirstName IS NULL) OR (pi.FirstName like '%' + @piFirstName + '%'))
				AND ((@piORCiD IS NULL) OR (pi.ORC_ID like '%' + @piORCiD + '%'))
				AND ((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList))))
				AND ((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList))))
				AND ((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList))))
				AND ((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))
				AND ((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))));

	SELECT DISTINCT projectid, CalendarYear
	INTO #baseProjectYear
	FROM #pf;

	WITH RankedProjectYear AS (
		SELECT
			b.projectid,
			b.CalendarYear,
			f.CalendarAmount,
			f.Currency,
			ROW_NUMBER() OVER (
				PARTITION BY b.projectid, b.CalendarYear
				ORDER BY f.ProjectFundingID
			) AS rn
		FROM #baseProjectYear b
		JOIN #pf f
			ON b.projectid = f.projectid
			AND b.CalendarYear = f.CalendarYear
	)
	SELECT
		projectid,
		CalendarYear,
		CalendarAmount,
		Currency
	INTO #ProjectByYear
	FROM RankedProjectYear
	WHERE rn = 1;

	------------------------------------------------------------------------------
	-- Get award year stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN
		SELECT CalendarYear AS [Year], COUNT(distinct projectID) AS [Count], 0 AS USDAmount
		INTO #CountStats
		FROM #ProjectByYear
		GROUP BY CalendarYear;

		SELECT @ResultCount = SUM([Count]) FROM #CountStats;
		SELECT * FROM #CountStats ORDER BY [Count] Desc;
	END
	ELSE
	BEGIN
		SELECT CalendarYear AS [Year], 0 AS [Count], SUM(USDAmount) AS USDAmount
		INTO #AmountStats
		FROM (
			SELECT f.CalendarYear,
				(f.CalendarAmount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
			FROM #ProjectByYear f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year = @Year) cr
				ON cr.FromCurrency = f.Currency
		) t
		GROUP BY CalendarYear;

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats;
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc;
	END
END

/******************/

GO
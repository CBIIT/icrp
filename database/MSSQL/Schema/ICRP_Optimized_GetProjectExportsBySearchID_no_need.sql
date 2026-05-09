SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
  SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectExportsBySearchID]')
    AND type IN (N'P', N'PC')
)
DROP PROCEDURE [dbo].[GetProjectExportsBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectExportsBySearchID]
  @SearchID INT,
  @IncludeAbstract INT = 0,
  @SiteURL VARCHAR(250) = 'https://www.icrpartnership.org/project/',
  @Year SMALLINT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @CountryList VARCHAR(1000) = NULL,
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
          @PiORCiD VARCHAR(50) = NULL,
          @FundingOrgTypeList VARCHAR(50) = NULL,
          @FundingOrgList VARCHAR(1000) = NULL,
          @ChildhoodCancerList VARCHAR(1000) = NULL,
          @SQLQuery NVARCHAR(MAX),
          @PivotColumns NVARCHAR(MAX);

  IF @Year IS NULL
    SELECT @Year = MAX([Year]) FROM CurrencyRate;

  SELECT @YearList = YearList,
         @CountryList = CountryList,
         @IncomeGroupList = IncomeGroupList,
         @CSOList = CSOList,
         @CancerTypeList = CancerTypeList,
         @InvestigatorType = InvestigatorType,
         @Institution = Institution,
         @PiLastName = PiLastName,
         @PiFirstName = PiFirstName,
         @PiORCiD = PiORCiD,
         @CityList = CityList,
         @StateList = StateList,
         @RegionList = RegionList,
         @FundingOrgTypeList = FundingOrgTypeList,
         @FundingOrgList = FundingOrgList,
         @ChildhoodCancerList = ChildhoodCancerList
  FROM SearchCriteria
  WHERE SearchCriteriaID = @SearchID;

  CREATE TABLE #base (ProjectID INT NOT NULL PRIMARY KEY);

  IF @SearchID = 0
  BEGIN
    INSERT INTO #base (ProjectID)
    SELECT DISTINCT ProjectID
    FROM Project;
  END
  ELSE
  BEGIN
    INSERT INTO #base (ProjectID)
    SELECT DISTINCT srp.ProjectID
    FROM SearchResultProject srp
    WHERE srp.SearchCriteriaID = @SearchID;
  END

  SELECT DISTINCT
    p.ProjectID,
    f.ProjectFundingID,
    f.Title AS AwardTitle,
    CAST(NULL AS VARCHAR(100)) AS AwardType,
    p.AwardCode,
    f.Source_ID,
    f.AltAwardCode,
    f.Category AS FundingCategory,
    CASE f.IsChildhood
      WHEN 1 THEN 'Yes'
      WHEN 2 THEN 'Partially'
      WHEN 0 THEN 'No'
      ELSE ''
    END AS IsChildhood,
    p.ProjectStartDate AS AwardStartDate,
    p.ProjectEndDate AS AwardEndDate,
    f.BudgetStartDate,
    f.BudgetEndDate,
    CAST(f.Amount AS DECIMAL(18,2)) AS AwardAmount,
    CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator,
    o.Currency,
    f.MechanismTitle AS FundingMechanism,
    f.MechanismCode AS FundingMechanismCode,
    o.SponsorCode,
    o.Name AS FundingOrg,
    o.Type AS FundingOrgType,
    d.Name AS FundingDiv,
    d.Abbreviation AS FundingDivAbbr,
    f.FundingContact,
    pi.LastName AS PiLastName,
    pi.FirstName AS PiFirstName,
    pi.ORC_ID AS PiORCID,
    i.Name AS Institution,
    i.City,
    i.State,
    i.Country,
    l.Name AS Region,
    @SiteURL + CAST(p.ProjectID AS VARCHAR(10)) AS ICRPURL,
    CASE WHEN @IncludeAbstract = 1 THEN a.TechAbstract ELSE NULL END AS TechAbstract
  INTO #pf
  FROM #base r
  JOIN Project p ON r.ProjectID = p.ProjectID
  JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
  JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
  JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID AND pi.IsPrincipalInvestigator = 1
  JOIN Institution i ON i.InstitutionID = pi.InstitutionID
  JOIN CountryMapLayer cm ON i.Country = cm.Country
  JOIN Country c ON c.Abbreviation = i.Country
  JOIN lu_Region l ON c.RegionID = l.RegionID
  LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
  LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
  WHERE (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
    AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
    AND (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%')
    AND (@InvestigatorType IS NULL OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1))
    AND (@PiLastName IS NULL OR pi.LastName LIKE '%' + @PiLastName + '%')
    AND (@PiFirstName IS NULL OR pi.FirstName LIKE '%' + @PiFirstName + '%')
    AND (@PiORCiD IS NULL OR pi.ORC_ID LIKE '%' + @PiORCiD + '%')
    AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
    AND (@IncomeGroupList IS NULL OR cm.[Value] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
    AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
    AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
    AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
    AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

  CREATE CLUSTERED INDEX IX_pf_ProjectFundingID ON #pf (ProjectFundingID);
  CREATE NONCLUSTERED INDEX IX_pf_ProjectID ON #pf (ProjectID);

  IF @YearList IS NOT NULL
  BEGIN
    DELETE pf
    FROM #pf pf
    WHERE NOT EXISTS (
      SELECT 1
      FROM ProjectFundingExt ext
      WHERE ext.ProjectFundingID = pf.ProjectFundingID
        AND ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
    );
  END

  IF @CSOList IS NOT NULL
  BEGIN
    DELETE pf
    FROM #pf pf
    WHERE NOT EXISTS (
      SELECT 1
      FROM ProjectCSO pc
      WHERE pc.ProjectFundingID = pf.ProjectFundingID
        AND pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
    );
  END

  IF @CancerTypeList IS NOT NULL
  BEGIN
    DELETE pf
    FROM #pf pf
    WHERE NOT EXISTS (
      SELECT 1
      FROM ProjectCancerType pct
      WHERE pct.ProjectFundingID = pf.ProjectFundingID
        AND pct.CancerTypeID IN (SELECT CancerTypeID FROM dbo.ToIntTable(@CancerTypeList))
    );
  END

  UPDATE pf
  SET AwardType = pt.AwardTypes
  FROM #pf pf
  JOIN (
    SELECT pt1.ProjectID,
      STUFF((
        SELECT ', ' + CAST(pt2.ProjectType AS NVARCHAR(50))
        FROM Project_ProjectType pt2
        WHERE pt2.ProjectID = pt1.ProjectID
        FOR XML PATH(''), TYPE
      ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS AwardTypes
    FROM Project_ProjectType pt1
    GROUP BY pt1.ProjectID
  ) pt ON pf.ProjectID = pt.ProjectID;

  SELECT ext.ProjectFundingID,
         ext.CalendarYear,
         CAST((ext.CalendarAmount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18,2)) AS CalendarAmountUSD
  INTO #pf_ext
  FROM ProjectFundingExt ext
  JOIN #pf pf ON ext.ProjectFundingID = pf.ProjectFundingID
  LEFT JOIN (
    SELECT FromCurrency, ToCurrencyRate
    FROM CurrencyRate
    WHERE ToCurrency = 'USD' AND [Year] = @Year
  ) cr ON cr.FromCurrency = pf.Currency;

  CREATE CLUSTERED INDEX IX_pf_ext_ProjectFundingYear ON #pf_ext (ProjectFundingID, CalendarYear);

  SELECT @PivotColumns = STRING_AGG(QUOTENAME(CalendarYear), ',')
  FROM (
    SELECT DISTINCT ext.CalendarYear
    FROM #pf_ext ext
  ) y;

  IF @PivotColumns IS NULL
  BEGIN
    SET @SQLQuery = N'
      SELECT
        pf.ProjectID AS ICRPProjectID,
        pf.ProjectFundingID AS ICRPProjectFundingID,
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
        CAST((pf.AwardAmount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18,2)) AS [AwardAmount (USD)],
        pf.AwardAmount AS [AwardAmount (Original)],
        pf.Currency,
        pf.FundingIndicator,
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
        CASE WHEN @IncludeAbstract = 1 THEN N', pf.TechAbstract' ELSE N'' END + N'
      FROM #pf pf
      LEFT JOIN (
        SELECT FromCurrency, ToCurrencyRate
        FROM CurrencyRate
        WHERE ToCurrency = ''USD'' AND [Year] = @year
      ) cr ON cr.FromCurrency = pf.Currency';

    EXEC sp_executesql @SQLQuery, N'@year SMALLINT', @year = @Year;
  END
  ELSE
  BEGIN
    SET @SQLQuery = N'
      SELECT *
      FROM (
        SELECT
          pf.ProjectID AS ICRPProjectID,
          pf.ProjectFundingID AS ICRPProjectFundingID,
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
          CAST((pf.AwardAmount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18,2)) AS [AwardAmount (USD)],
          pf.AwardAmount AS [AwardAmount (Original)],
          pf.Currency,
          pf.FundingIndicator,
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
          CASE WHEN @IncludeAbstract = 1 THEN N', pf.TechAbstract' ELSE N'' END + N',
          ext.CalendarYear,
          ext.CalendarAmountUSD AS CalendarAmount
        FROM #pf pf
        JOIN #pf_ext ext ON pf.ProjectFundingID = ext.ProjectFundingID
        LEFT JOIN (
          SELECT FromCurrency, ToCurrencyRate
          FROM CurrencyRate
          WHERE ToCurrency = ''USD'' AND [Year] = @year
        ) cr ON cr.FromCurrency = pf.Currency
      ) s
      PIVOT (
        SUM(CalendarAmount)
        FOR CalendarYear IN (' + @PivotColumns + N')
      ) p;';

    EXEC sp_executesql @SQLQuery, N'@year SMALLINT', @year = @Year;
  END

  DROP TABLE IF EXISTS #base;
  DROP TABLE IF EXISTS #pf;
  DROP TABLE IF EXISTS #pf_ext;
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (
  SELECT *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectExportsSingleBySearchID]')
    AND type IN (N'P', N'PC')
)
DROP PROCEDURE [dbo].[GetProjectExportsSingleBySearchID]
GO

CREATE PROCEDURE [dbo].[GetProjectExportsSingleBySearchID]
  @SearchID INT,
  @IncludeAbstract BIT = 0,
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
          @PivotColumns_Years NVARCHAR(MAX),
          @PivotColumns_CSOs NVARCHAR(MAX),
          @PivotColumns_CancerTypes NVARCHAR(MAX);

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
    FROM vwProjectFundings;
  END
  ELSE
  BEGIN
    ;WITH FilteredSearchResult AS (
      SELECT DISTINCT srp.ProjectID
      FROM SearchResultProject srp
      WHERE srp.SearchCriteriaID = @SearchID
    )
    INSERT INTO #base (ProjectID)
    SELECT ProjectID
    FROM FilteredSearchResult;
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
    f.Amount AS AwardAmount,
    CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator,
    o.Currency,
    f.MechanismTitle AS FundingMechanism,
    f.MechanismCode AS FundingMechanismCode,
    o.SponsorCode,
    o.Name AS FundingOrg,
    o.Type AS FundingOrgType,
    d.Name AS FundingDiv,
    d.Abbreviation AS FundingDivAbbr,
    '' AS FundingContact,
    pi.LastName AS PiLastName,
    pi.FirstName AS PiFirstName,
    pi.ORC_ID AS PiORCID,
    pii.Name AS Institution,
    pii.City,
    pii.State,
    pii.Country,
    pir.Name AS Region,
    @SiteURL + CAST(p.ProjectID AS VARCHAR(10)) AS ICRPURL,
    f.ProjectAbstractID,
    CAST('' AS NVARCHAR(MAX)) AS TechAbstract
  INTO #pf
  FROM #base b
  JOIN Project p ON b.ProjectID = p.ProjectID
  JOIN ProjectFunding f ON b.ProjectID = f.ProjectID
  JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
  JOIN ProjectFundingInvestigator people ON f.ProjectFundingID = people.ProjectFundingID
  JOIN Institution i ON people.InstitutionID = i.InstitutionID
  JOIN CountryMapLayer cm ON i.Country = cm.Country
  JOIN Country c ON c.Abbreviation = i.Country
  JOIN (
    SELECT *
    FROM ProjectFundingInvestigator
    WHERE IsPrincipalInvestigator = 1
  ) pi ON pi.ProjectFundingID = f.ProjectFundingID
  JOIN Institution pii ON pii.InstitutionID = pi.InstitutionID
  JOIN Country pic ON pic.Abbreviation = pii.Country
  JOIN lu_Region pir ON pic.RegionID = pir.RegionID
  LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
  WHERE (@Institution IS NULL OR i.Name LIKE '%' + @Institution + '%')
    AND (
      @InvestigatorType IS NULL
      OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1)
      OR (@InvestigatorType = 'Collab' AND people.IsPrincipalInvestigator = 0)
    )
    AND (@PiLastName IS NULL OR people.LastName LIKE '%' + @PiLastName + '%')
    AND (@PiFirstName IS NULL OR people.FirstName LIKE '%' + @PiFirstName + '%')
    AND (@PiORCiD IS NULL OR people.ORC_ID LIKE '%' + @PiORCiD + '%')
    AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
    AND (@IncomeGroupList IS NULL OR cm.[Value] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
    AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
    AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
    AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
    AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgList)))
    AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
    AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

  IF @YearList IS NOT NULL
  BEGIN
    DELETE #pf
    WHERE ProjectFundingID NOT IN (
      SELECT ext.ProjectFundingID
      FROM ProjectFundingExt ext
      WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
    );
  END

  IF @CSOList IS NOT NULL
  BEGIN
    DELETE #pf
    WHERE ProjectFundingID NOT IN (
      SELECT pc.ProjectFundingID
      FROM ProjectCSO pc
      WHERE ISNULL(pc.Relevance, 0) <> 0
        AND pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
    );
  END

  IF @CancerTypeList IS NOT NULL
  BEGIN
    SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID
    INTO #ct
    FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@CancerTypeList)) l
    LEFT JOIN CancerTypeRollUp r ON l.CancerTypeID = r.CancerTypeRollupID;

    SELECT DISTINCT CancerTypeID
    INTO #ctlist
    FROM (
      SELECT CancerTypeID FROM #ct
      UNION
      SELECT RelatedCancerTypeID AS CancerTypeID FROM #ct WHERE RelatedCancerTypeID IS NOT NULL
    ) ct;

    DELETE #pf
    WHERE ProjectFundingID NOT IN (
      SELECT f.ProjectFundingID
      FROM #pf f
      JOIN ProjectCancerType pc ON f.ProjectFundingID = pc.ProjectFundingID
      JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID
      WHERE ISNULL(pc.Relevance, 0) <> 0
        AND ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist)
    );
  END

  IF @IncludeAbstract = 1
  BEGIN
    UPDATE f
    SET TechAbstract = a.TechAbstract
    FROM #pf f
    JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID;
  END

  UPDATE pf
  SET AwardType = pt.AwardTypes
  FROM #pf pf
  JOIN (
    SELECT ProjectID,
      STUFF((
        SELECT ', ' + CAST(pt2.ProjectType AS NVARCHAR(50))
        FROM Project_ProjectType pt2
        WHERE pt2.ProjectID = pt1.ProjectID
        FOR XML PATH(''), TYPE
      ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS AwardTypes
    FROM Project_ProjectType pt1
    GROUP BY ProjectID
  ) pt ON pf.ProjectID = pt.ProjectID;

  SELECT @PivotColumns_Years = STRING_AGG(QUOTENAME(CalendarYear), ',')
  FROM (
    SELECT DISTINCT ext.CalendarYear
    FROM ProjectFundingExt ext
    JOIN #pf t ON ext.ProjectFundingID = t.ProjectFundingID
  ) p;

  SELECT @PivotColumns_CSOs = STRING_AGG(QUOTENAME(CSO), ',')
  FROM (
    SELECT DISTINCT c.Code + ' ' + c.Name AS CSO
    FROM ProjectCSO pc
    JOIN CSO c ON pc.CSOCode = c.Code
    JOIN #pf t ON pc.ProjectFundingID = t.ProjectFundingID
  ) p;

  SELECT @PivotColumns_CancerTypes = STRING_AGG(QUOTENAME(CancerType), ',')
  FROM (
    SELECT DISTINCT c.Name AS CancerType
    FROM ProjectCancerType pc
    JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID
    JOIN #pf t ON pc.ProjectFundingID = t.ProjectFundingID
    WHERE ISNULL(pc.RelSource, '') = 'S'
  ) p;

  SET @SQLQuery = N'SELECT * FROM (
      SELECT
        t.ProjectID AS ICRPProjectID,
        t.ProjectFundingID AS ICRPProjectFundingID,
        t.AwardCode,
        t.AwardTitle,
        t.AwardType,
        t.Source_ID,
        t.AltAwardCode,
        t.FundingCategory,
        t.IsChildhood,
        t.AwardStartDate,
        t.AwardEndDate,
        t.BudgetStartDate,
        t.BudgetEndDate,
        CAST((t.AwardAmount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18,2)) AS [AwardAmount (USD)],
        t.AwardAmount AS [AwardAmount (Original)],
        t.Currency,
        t.FundingIndicator,
        t.FundingMechanism,
        t.FundingMechanismCode,
        t.SponsorCode,
        t.FundingOrg,
        t.FundingOrgType,
        t.FundingDiv,
        t.FundingDivAbbr,
        t.FundingContact,
        t.PiLastName,
        t.PiFirstName,
        t.PiORCID,
        t.Institution AS PiInstitution,
        t.City AS PiCity,
        t.State AS PiState,
        t.Country AS PiCountry,
        t.Region AS PiRegion,
        t.ICRPURL';

  IF @IncludeAbstract = 1
    SET @SQLQuery = @SQLQuery + N', t.TechAbstract';

  IF @PivotColumns_Years IS NOT NULL
    SET @SQLQuery = @SQLQuery + N', ext.CalendarYear, CAST((ext.CalendarAmount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18,2)) AS CalendarAmount';

  IF @PivotColumns_CSOs IS NOT NULL
    SET @SQLQuery = @SQLQuery + N', cso.Code + '' '' + cso.Name AS CSO, pcso.Relevance AS CSORel';

  IF @PivotColumns_CancerTypes IS NOT NULL
    SET @SQLQuery = @SQLQuery + N', c.Name AS CancerType, pc.Relevance AS CancerTypeRel';

  SET @SQLQuery = @SQLQuery + N'
      FROM #pf t
      LEFT JOIN (
        SELECT FromCurrency, ToCurrencyRate
        FROM CurrencyRate
        WHERE ToCurrency = ''USD'' AND [Year] = ' + CAST(@Year AS VARCHAR(4)) + N'
      ) cr ON cr.FromCurrency = t.Currency';

  IF @PivotColumns_CSOs IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
      JOIN ProjectCSO pcso ON t.ProjectFundingID = pcso.ProjectFundingID
      JOIN CSO cso ON pcso.CSOCode = cso.Code';

  IF @PivotColumns_CancerTypes IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
      JOIN ProjectCancerType pc ON t.ProjectFundingID = pc.ProjectFundingID
      JOIN CancerType c ON pc.CancerTypeID = c.CancerTypeID';

  IF @PivotColumns_Years IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
      JOIN ProjectFundingExt ext ON ext.ProjectFundingID = t.ProjectFundingID';

  SET @SQLQuery = @SQLQuery + N'
    ) exp';

  IF @PivotColumns_Years IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
    PIVOT (
      SUM(CalendarAmount)
      FOR CalendarYear IN (' + @PivotColumns_Years + N')
    ) AS amount';

  IF @PivotColumns_CSOs IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
    PIVOT (
      MAX(CSORel)
      FOR CSO IN (' + @PivotColumns_CSOs + N')
    ) AS c';

  IF @PivotColumns_CancerTypes IS NOT NULL
    SET @SQLQuery = @SQLQuery + N'
    PIVOT (
      MAX(CancerTypeRel)
      FOR CancerType IN (' + @PivotColumns_CancerTypes + N')
    ) AS cancer';

  EXEC sp_executesql @SQLQuery;
END
GO

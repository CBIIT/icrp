-------------------------------
-- 7 pie charts for ICRP
-- GetProjectCancerTypeStatsBySearchID
-- GetProjectCountryStatsBySearchID
-- GetProjectTypeStatsBySearchID
-- GetProjectCSOStatsBySearchID
-- GetProjectChildhoodCancerStatsBySearchID
-- GetProjectFundingOrgStatsBySearchID
-- GetProjectInvestigatorStatsBySearchID

--------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypeStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID] 
GO 

CREATE PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,	
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the total relevances	
	@ResultAmount float OUTPUT  -- return the total amounts

AS   

    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project
	
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
			
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	--SELECT ProjectID INTO #proj FROM @Result

	-- CancerType Rollups - include all related cancertype IDs if search by roll-up cancer type 
	SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
		FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
		LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

	SELECT DISTINCT cancertypeid INTO #ctlist FROM
	(
		SELECT cancertypeid FROM #ct
		UNION
		SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
	) ct	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ct.Name AS CancerType, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID	
	 WHERE	((@CancerTypelist IS NULL) OR (ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
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

	----------------------------------		
	--   Get CancerType Stats
	----------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT CancerType, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #pf GROUP BY CancerType 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT CancerType, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT CancerType, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #pf f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY CancerType	

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		

GO
------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCountryStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

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

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
			-- get search criteria to filter project funding records
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END
		
	SELECT ProjectID INTO #proj FROM #Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, f.Amount, pii.Country, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID	
		JOIN CountryMapLayer cm ON i.country = cm.Country AND cm.MapLayerID = 4
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY country 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.country, CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS Decimal(18,2)) AS USDAmount 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t		
		GROUP BY country 
		
		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectTypeStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]  
GO 

CREATE PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

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

	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END		

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, pt.ProjectType, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE (@ProjectTypeList IS NULL) OR (pt.ProjectType IN (SELECT VALUE AS ProjectTypeID FROM dbo.ToStrTable(@ProjectTypeList))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
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

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT ProjectType, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY ProjectType 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT ProjectType, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats  FROM
		(SELECT f.ProjectType, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY ProjectType 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
GO


USE [icrp_data]
GO
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypeStatsBySearchID]    Script Date: 7/2/2025 5:40:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,	
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the total relevances	
	@ResultAmount float OUTPUT  -- return the total amounts

AS   

    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project
	
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
			
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	--SELECT ProjectID INTO #proj FROM @Result

	-- CancerType Rollups - include all related cancertype IDs if search by roll-up cancer type 
	SELECT l.CancerTypeID, r.CancerTypeID AS RelatedCancerTypeID INTO #ct 
		FROM (SELECT VALUE AS CancerTypeID FROM dbo.ToIntTable(@cancerTypeList)) l
		LEFT JOIN CancerTypeRollUp r ON l.cancertypeid = r.CancerTyperollupID

	SELECT DISTINCT cancertypeid INTO #ctlist FROM
	(
		SELECT cancertypeid FROM #ct
		UNION
		SELECT Relatedcancertypeid AS cancertypeid FROM #ct WHERE Relatedcancertypeid IS NOT NULL
	) ct	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ct.Name AS CancerType, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID	
	 WHERE	((@CancerTypelist IS NULL) OR (ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
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

	----------------------------------		
	--   Get CancerType Stats
	----------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT CancerType, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #pf GROUP BY CancerType 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT CancerType, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT CancerType, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #pf f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY CancerType	

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		


GO
/****** Object:  StoredProcedure [dbo].[GetProjectCSOStatsBySearchID]    Script Date: 7/2/2025 5:43:05 PM ******/
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
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max)	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		
		
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID	

	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CSO c ON c.code = pc.csocode	
	 WHERE	((@CSOlist IS NULL) OR (c.Code IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOlist)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
	BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation							
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

	----------------------------------		
	--   Get CSO Stats
	----------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0  AS USDAmount, Count(*) AS ProjectCount INTO #CountStats FROM #pf GROUP BY categoryName 
		SELECT @ResultCount = SUM(Relevance) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY Relevance Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT categoryName, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount INTO #AmountStats 
			FROM (SELECT categoryName, Relevance/100 AS Relevance, 
				     ((Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			  FROM #pf f
			  LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t
		GROUP BY categoryName		

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END		
	

    -------------------------------------------------------
    SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectChildhoodCancerStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchID]  
GO 

CREATE PROCEDURE [dbo].[GetProjectChildhoodCancerStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
		      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #Result
    FROM FilteredSearchResult;


	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
				
		SELECT @ProjectTypeList = ProjectTypeList,
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END	
	
	-------------------------------------------------------------------		
	--   Find all related projects (project funding records)
	-------------------------------------------------------------------		
	SELECT f.ProjectID, f.IsChildhood, f.ProjectFundingID, f.Amount, o.Currency INTO #pf 
	FROM #Result r
		JOIN Project p ON r.ProjectID = p.ProjectID	
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID			
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE 	((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))
	 
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END


	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country	
				JOIN Country c ON i.Country = c.Abbreviation							
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

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT 
			CASE IsChildhood 
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 
			COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats 
		FROM #pf 
		GROUP BY IsChildhood 

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 
		SELECT CASE IsChildhood
				WHEN 1 THEN 'Childhood Cancer: Yes' 
				WHEN 2 THEN 'Childhood Cancer: Partially' 
				ELSE 'Childhood Cancer: No'   -- value = 0
			END AS IsChildhood, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats	FROM 
		(SELECT f.IsChildhood, (f.amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
			FROM #pf f		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=2020) cr ON cr.FromCurrency = f.Currency) t					
		GROUP BY IsChildhood

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
GO

--------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectInstitutionStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectInstitutionStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   
	
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

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

		-- get search criteria to filter project funding records
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, pii.InstitutionID, pii.Name AS Institution, pii.City, pii.state, pii.Country, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN CountryMapLayer cm ON i.country = cm.Country
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
	 		((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT Institution, City, State, Country, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY InstitutionID, Institution, City, State, Country

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT InstitutionID, Institution, City, State, Country, 0 AS [Count], SUM(USDAmount) AS USDAmount INTO #AmountStats FROM
		(SELECT f.InstitutionID, f.Institution, f.City, f.State, f.Country, CAST(f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS Decimal(18,2)) AS USDAmount 
		FROM #pf f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency) t			
		GROUP BY InstitutionID, Institution, City, State, Country


		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectFundingOrgStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectFundingOrgStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectFundingOrgStatsBySearchID]   
    @SearchID INT,
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   

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

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @IncomeGroupList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL	
	DECLARE @regionList varchar(100) = NULL	
	DECLARE @Yearlist VARCHAR(1000) = NULL
	DECLARE @CSOlist VARCHAR(1000) = NULL
	DECLARE @CancerTypelist VARCHAR(1000) = NULL
	DECLARE @InvestigatorType varchar(250) = NULL
	DECLARE @institution varchar(250) = NULL
	DECLARE @piLastName varchar(50) = NULL
	DECLARE @piFirstName varchar(50) = NULL
	DECLARE @piORCiD varchar(50) = NULL
	DECLARE @FundingOrgTypeList varchar(50) = NULL
	DECLARE @fundingOrgList varchar(1000) = NULL
	DECLARE @childhoodcancerList varchar(1000) = NULL

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO #Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
				@CountryList = CountryList,
				@incomeGroupList = IncomeGroupList,
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
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END	

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgAbbrv, f.Amount, o.Currency INTO #pf 
	FROM #Result r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID
		JOIN CountryMapLayer cm ON i.country = cm.Country		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@childhoodcancerList IS NULL) OR (f.IsChildhood IN (SELECT VALUE AS type FROM dbo.ToStrTable(@childhoodcancerList))))

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		BEGIN
		-- Find total calendar amount 
		SELECT f.ProjectFundingID, sum(ext.CalendarAmount) as amount into #tmpCalAmt
		FROM (SELECT DISTINCT ProjectFundingID FROM #pf) f
			JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID	
		WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@Yearlist))
		group by f.ProjectFundingID		

		DELETE #pf 
		WHERE ProjectFundingID NOT IN (SELECT ProjectFundingID FROM  #tmpCalAmt)

		UPDATE #pf SET Amount = ISNULL(cal.amount,0)
		FROM #pf f
		JOIN #tmpCalAmt cal ON f.ProjectFundingID = cal.ProjectFundingID
	END

		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))		

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

		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get Institution Stats (PIs only)
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN		
		
		SELECT FundingOrg, FundingOrgAbbrv, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY FundingOrg, FundingOrgAbbrv

		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT f.FundingOrg, f.FundingOrgAbbrv, 0 AS [Count], CAST((SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS Decimal(18,2)) AS USDAmount INTO #AmountStats 
		FROM #pf f			
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY f.FundingOrg, f.FundingOrgAbbrv

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

GO









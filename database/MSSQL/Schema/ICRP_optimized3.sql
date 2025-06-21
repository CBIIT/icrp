--GetProjectExportsBySearchID
--GetProjectsBySearchID (for sorting)
--GetProjectCSOsBySearchID
--GetProjectCancerTypesBySearchID
--GetProjectCollaboratorsBysearchID


--GetProjectTypeStatsBySearchID
--GetProjectCSOStatsBySearchID
--GetProjectCountryStatsBySearchID
--GetProjectCancerTypeStatsBySearchID

--AddNewSearchBySearchID

---------------------------------------------------------
USE [icrp_data]
GO
/****** Object:  StoredProcedure [dbo].[GetProjectExportsBySearchID]    Script Date: 6/20/2025 6:08:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetProjectExportsBySearchID]
    @SearchID INT,
    @IncludeAbstract INT = 0,
    @SiteURL VARCHAR(250) = 'https://www.icrpartnership.org/project/',
    @Year SMALLINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
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
            @ChildhoodCancerList VARCHAR(1000) = NULL;

    -- Set default year if not provided
    IF @Year IS NULL
        SELECT @Year = MAX(Year) FROM CurrencyRate;

    -- Retrieve search criteria
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

    -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #base
    FROM FilteredSearchResult;

    -- Retrieve project funding details
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
        CAST(f.Amount AS DECIMAL(18, 2)) AS AwardAmount,
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
      AND (@InvestigatorType IS NULL OR 
           (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR 
           (@InvestigatorType = 'Collab' AND pi.IsPrincipalInvestigator = 0))
      AND (@PiLastName IS NULL OR pi.LastName LIKE '%' + @PiLastName + '%')
      AND (@PiFirstName IS NULL OR pi.FirstName LIKE '%' + @PiFirstName + '%')
      AND (@PiORCiD IS NULL OR pi.ORC_ID LIKE '%' + @PiORCiD + '%')
      AND (@CountryList IS NULL OR i.Country IN (SELECT VALUE FROM dbo.ToStrTable(@CountryList)))
      AND (@IncomeGroupList IS NULL OR cm.[VALUE] IN (SELECT VALUE FROM dbo.ToStrTable(@IncomeGroupList)))
      AND (@CityList IS NULL OR i.City IN (SELECT VALUE FROM dbo.ToStrTable(@CityList)))
      AND (@StateList IS NULL OR i.State IN (SELECT VALUE FROM dbo.ToStrTable(@StateList)))
      AND (@RegionList IS NULL OR c.RegionID IN (SELECT VALUE FROM dbo.ToStrTable(@RegionList)))
      AND (@ChildhoodCancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@ChildhoodCancerList)));

    -- Apply Year, CSO, and CancerType filters
    IF @YearList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT ext.ProjectFundingID
            FROM ProjectFundingExt ext
            WHERE ext.CalendarYear IN (SELECT VALUE FROM dbo.ToStrTable(@YearList))
        );
    END;

    IF @CSOList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT pc.ProjectFundingID
            FROM ProjectCSO pc
            WHERE pc.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOList))
        );
    END;

    IF @CancerTypeList IS NOT NULL
    BEGIN
        DELETE FROM #pf
        WHERE ProjectFundingID NOT IN (
            SELECT pct.ProjectFundingID
            FROM ProjectCancerType pct
            WHERE pct.CancerTypeID IN (
                SELECT CancerTypeID
                FROM dbo.ToIntTable(@CancerTypeList)
            )
        );
    END;

    -- Update AwardType with concatenated ProjectTypes
UPDATE pf 
SET AwardType = pt.AwardTypes
FROM #pf pf
JOIN (
    SELECT ProjectID,
           STUFF((
               SELECT ', ' + CAST(pt2.ProjectType AS NVARCHAR(50))
               FROM Project_ProjectType pt2
               WHERE pt2.ProjectID = pt1.ProjectID
               FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS AwardTypes
    FROM Project_ProjectType pt1
    GROUP BY ProjectID
) pt ON pf.ProjectID = pt.ProjectID;


    -- Generate dynamic pivot query
    DECLARE @SQLQuery NVARCHAR(MAX),
            @PivotColumns NVARCHAR(MAX);

    SELECT @PivotColumns = STRING_AGG(QUOTENAME(CalendarYear), ',')
    FROM (
        SELECT DISTINCT CalendarYear
        FROM ProjectFundingExt
        
        WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #pf)
    ) AS Years;

    SET @SQLQuery = '
    SELECT * FROM (
        SELECT
            pf.ProjectID as ICRPProjectID,
            pf.ProjectFundingID as ICRPProjectFundingID,
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
            CASE WHEN @IncludeAbstract = 1 THEN ', pf.TechAbstract' ELSE '' END + ',
            ext.CalendarYear,
            ext.CalendarAmount
        FROM #pf pf
        JOIN ProjectFundingExt ext ON pf.ProjectFundingID = ext.ProjectFundingID
    ) AS SourceTable
    PIVOT (
        SUM(CalendarAmount)
        FOR CalendarYear IN (' + @PivotColumns + ')
    ) AS PivotTable;';

    EXEC sp_executesql @SQLQuery;

    -- Cleanup
    DROP TABLE IF EXISTS #base, #pf;
END;

----------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetProjectsBySearchID]
    @PageSize int = 50, -- return all by default
	@PageNumber int = 1, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

    -- Insert distinct ProjectID values into the table variable
    INSERT INTO @Result (ProjectID)
    SELECT DISTINCT srp.ProjectID
    FROM SearchResultProject srp
    WHERE srp.SearchCriteriaID = @SearchID;

	DECLARE @ProjectIDs VARCHAR(max) 
	IF @SearchID = 0
	BEGIN
		SELECT @ResultCount = COUNT(*) FROM @Result
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
	END

	SELECT ProjectID INTO #base FROM @Result

	--------------------------------------------------------------------
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------
	SELECT r.ProjectID, p.AwardCode, minf.projectfundingID AS LastProjectFundingID, 
    	LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) AS Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID
		JOIN (SELECT ProjectID, MIN(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding f GROUP BY ProjectID) minf ON r.ProjectID = minf.ProjectID
		JOIN ProjectFunding f ON minf.ProjectFundingID = f.projectFundingID
		JOIN  (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), ''))) END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN p.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN  LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(f.Title, CHAR(9), ''), CHAR(13), ''), CHAR(10), '')))  END DESC,
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN p.AwardCode  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.LastName  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.FirstName  END DESC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN i.Name END DESC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN i.City  END DESC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN i.State  END DESC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN i.Country  END DESC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN o.Abbreviation  END DESC
	OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
	FETCH NEXT 
		CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
		END ROWS ONLY
    											  
GO

----------------------------------------------------------

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetProjectCSOsBySearchID]
      @SearchID INT
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
    SELECT ProjectID INTO #base
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

	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		

		SELECT 	@YearList = YearList,
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


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
	WHERE (@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList)))	

	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@incomeGroupList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@countryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList))))  AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))
			)	

	-----------------------------------------------------------		
	--  Get project CSOs
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, cso.CSOCode, cso.Relevance AS CSORelevance	
	FROM #pf pf		
		JOIN ProjectCSO cso ON pf.ProjectFundingID = cso.ProjectFundingID
	ORDER BY pf.ProjectID
	
GO
----------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetProjectCancerTypesBySearchID]
     @SearchID INT	
	 
AS  
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
      -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #base
    FROM FilteredSearchResult;
	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

		SELECT 	@YearList = YearList,
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


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
	WHERE (@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList)))
	
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@incomeGroupList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN CountryMapLayer cm ON i.country = cm.Country
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@IncomeGroupList IS NULL) OR (cm.[VALUE] IN (SELECT VALUE AS IncomeBand FROM dbo.ToStrTable(@IncomeGroupList)))) AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))
			)	
							 
	-----------------------------------------------------------		
	--  Get project CancerTypes
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, ct.ICRPCode, ct.Name AS CancerType, pct.Relevance AS Relevance
	FROM #pf pf		
		JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pct ON pf.ProjectFundingID = pct.ProjectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
	ORDER BY pf.ProjectID
	
GO
----------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetProjectCollaboratorsBysearchID]   
    @SearchID INT
AS   
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	


	DECLARE @ProjectIDs VARCHAR(max) 

	DECLARE @CountryList VARCHAR(1000) = NULL
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
	
          -- Filter projects based on SearchID
    ;WITH FilteredSearchResult AS (
        SELECT DISTINCT srp.ProjectID
        FROM SearchResultProject srp
        WHERE srp.SearchCriteriaID = @SearchID
    )
    SELECT ProjectID INTO #base
    FROM FilteredSearchResult;
	
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
	
		SELECT 	@YearList = YearList,
			@CountryList = CountryList,
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
	


	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode, f.isChildhood
	INTO #pf 
	FROM #base r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		
	------------------------------------------------------------------------------
	--   Exclude the project funding records outside of seach criteria
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode	
				WHERE pc.CSOCode IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOList)))
		
	IF @CancerTypelist IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.ProjectFundingID = pc.projectFundingID
				JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID		
			WHERE ct.CancerTypeID IN (SELECT VALUE AS CancerTypeID FROM dbo.ToStrTable(@CancerTypelist)))	

	-----------------------------------------------------------		
	--  Get project Collaborators
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID AS ICRPProjectFundingID, f.AltAwardCode, pi.LastName, pi.FirstName, i.Name AS Institution, i.City, i.State, i.Country, l.Name AS Region	
	FROM #pf f	
		JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		JOIN Country c ON i.Country = c.Abbreviation
		JOIN lu_Region l ON c.RegionID = l.RegionID
	WHERE	(pi.IsPrincipalInvestigator = 0) AND
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@childhoodcancerList IS NULL) OR (f.isChildhood IN (SELECT VALUE AS isChildhood FROM dbo.ToIntTable(@childhoodcancerList))))
	ORDER BY f.ProjectID, f.ProjectFundingID

GO
----------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
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
        SELECT srp.ProjectID
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
----------------------------------------------------------
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

    -- Load search criteria
    SELECT 
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

    -- Main filtered projects
    SELECT 
        f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency
    INTO #pf
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID AND ISNULL(pc.Relevance,0) <> 0
    INNER JOIN CSO c ON pc.CSOCode = c.Code
    WHERE srp.SearchCriteriaID = @SearchID
      AND (@CSOlist IS NULL OR c.Code IN (SELECT VALUE FROM dbo.ToStrTable(@CSOlist)))
      AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@fundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@childhoodcancerList)))
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
END
GO
----------------------------------------------------------
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

    -- Declare Variables for Search Criteria
    DECLARE @CountryList VARCHAR(1000), @IncomeGroupList VARCHAR(1000), @YearList VARCHAR(1000),
            @FundingOrgList VARCHAR(1000), @cityList VARCHAR(1000), @stateList VARCHAR(1000),
            @regionList VARCHAR(100), @CSOlist VARCHAR(1000), @CancerTypelist VARCHAR(1000),
            @InvestigatorType VARCHAR(250), @institution VARCHAR(250),
            @piLastName VARCHAR(50), @piFirstName VARCHAR(50), @piORCiD VARCHAR(50),
            @FundingOrgTypeList VARCHAR(50), @childhoodcancerList VARCHAR(1000);

    IF @SearchID <> 0
    BEGIN
        SELECT 
            @YearList = YearList, @CountryList = CountryList,
            @IncomeGroupList = IncomeGroupList, @FundingOrgList = FundingOrgList,
            @cityList = cityList, @stateList = stateList, @regionList = regionList,
            @CSOlist = CSOlist, @CancerTypelist = CancerTypelist,
            @InvestigatorType = InvestigatorType, @institution = institution,
            @piLastName = piLastName, @piFirstName = piFirstName, @piORCiD = piORCiD,
            @FundingOrgTypeList = FundingOrgTypeList, @childhoodcancerList = childhoodcancerList
        FROM SearchCriteria
        WHERE SearchCriteriaID = @SearchID;
    END;

    -- Prepare list variables to avoid multiple function calls
    DECLARE @tblCountry TABLE ([Value] VARCHAR(100));
    DECLARE @tblIncomeGroup TABLE ([Value] VARCHAR(100));
    DECLARE @tblYear TABLE ([Value] VARCHAR(100));
    DECLARE @tblFundingOrg TABLE ([Value] VARCHAR(100));
    DECLARE @tblCity TABLE ([Value] VARCHAR(100));
    DECLARE @tblState TABLE ([Value] VARCHAR(100));
    DECLARE @tblRegion TABLE ([Value] VARCHAR(100));
    DECLARE @tblFundingOrgType TABLE ([Value] VARCHAR(100));
    DECLARE @tblChildhoodCancer TABLE ([Value] VARCHAR(100));

    INSERT INTO @tblCountry SELECT [Value] FROM dbo.ToStrTable(@CountryList);
    INSERT INTO @tblIncomeGroup SELECT [Value] FROM dbo.ToStrTable(@IncomeGroupList);
    INSERT INTO @tblYear SELECT [Value] FROM dbo.ToStrTable(@YearList);
    INSERT INTO @tblFundingOrg SELECT [Value] FROM dbo.ToStrTable(@FundingOrgList);
    INSERT INTO @tblCity SELECT [Value] FROM dbo.ToStrTable(@cityList);
    INSERT INTO @tblState SELECT [Value] FROM dbo.ToStrTable(@stateList);
    INSERT INTO @tblRegion SELECT [Value] FROM dbo.ToStrTable(@regionList);
    INSERT INTO @tblFundingOrgType SELECT [Value] FROM dbo.ToStrTable(@FundingOrgTypeList);
    INSERT INTO @tblChildhoodCancer SELECT [Value] FROM dbo.ToStrTable(@childhoodcancerList);

    -- Prepare filtered project result
    DECLARE @FilteredProjects TABLE (
        ProjectFundingID INT,
        Country NVARCHAR(255),
        Amount DECIMAL(18, 2),
        Currency NVARCHAR(10)
    );

    -- Step 1: Filter by ProjectFundingID only (avoid early joins that expand rows)
    WITH FilteredProjectIDs AS (
        SELECT DISTINCT f.ProjectFundingID
        FROM SearchResultProject srp
        INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
        WHERE srp.SearchCriteriaID = @SearchID
    )
    -- Step 2: Join necessary data without row multiplication
    INSERT INTO @FilteredProjects (ProjectFundingID, Country, Amount, Currency)
    SELECT 
        f.ProjectFundingID,
        pii.Country,
        f.Amount,
        o.Currency
    FROM FilteredProjectIDs fp
    JOIN ProjectFunding f ON f.ProjectFundingID = fp.ProjectFundingID
    JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    JOIN (
        SELECT ProjectFundingID, MIN(InstitutionID) AS InstitutionID
        FROM ProjectFundingInvestigator
        WHERE IsPrincipalInvestigator = 1
        GROUP BY ProjectFundingID
    ) pi ON pi.ProjectFundingID = f.ProjectFundingID
    JOIN Institution pii ON pii.InstitutionID = pi.InstitutionID
    JOIN CountryMapLayer cm ON pii.Country = cm.Country
    JOIN Country c ON c.Abbreviation = pii.Country
    WHERE 
        (@CountryList IS NULL OR pii.Country IN (SELECT [Value] FROM @tblCountry))
        AND (@IncomeGroupList IS NULL OR cm.Value IN (SELECT [Value] FROM @tblIncomeGroup))
        AND (@FundingOrgList IS NULL OR o.FundingOrgID IN (SELECT [Value] FROM @tblFundingOrg))
        AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT [Value] FROM @tblFundingOrgType))
        AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT [Value] FROM @tblChildhoodCancer))
        AND (@YearList IS NULL OR EXISTS (
            SELECT 1 FROM ProjectFundingExt ext
            WHERE ext.ProjectFundingID = f.ProjectFundingID
              AND ext.CalendarYear IN (SELECT [Value] FROM @tblYear)
        ));

    -- Step 3: Update Amounts by Year if Type is not 'Count'
    IF @Type != 'Count' AND @YearList IS NOT NULL
    BEGIN
        ;WITH YearlySums AS (
            SELECT ProjectFundingID, SUM(CalendarAmount) AS TotalAmount
            FROM ProjectFundingExt
            WHERE CalendarYear IN (SELECT [Value] FROM @tblYear)
            GROUP BY ProjectFundingID
        )
        UPDATE fp
        SET fp.Amount = ys.TotalAmount
        FROM @FilteredProjects fp
        JOIN YearlySums ys ON fp.ProjectFundingID = ys.ProjectFundingID;
    END;

    -- Step 4: Output results
    IF @Type = 'Count'
    BEGIN
        SELECT 
            Country  as country,
            COUNT(DISTINCT ProjectFundingID) AS [Count],
            0.0 AS USDAmount
        INTO #Stats
        FROM @FilteredProjects
        GROUP BY Country;

        SELECT @ResultCount = SUM([Count]) FROM #Stats;
        SELECT * FROM #Stats ORDER BY [Count] DESC;
        DROP TABLE #Stats;
    END
    ELSE
    BEGIN
        SELECT 
            f.Country as country,
            0 AS [Count],
            SUM(CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1.0)) AS DECIMAL(18, 2))) AS USDAmount
        INTO #Stats2
        FROM @FilteredProjects f
        LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
        GROUP BY f.Country;

        SELECT @ResultAmount = SUM(USDAmount) FROM #Stats2;
        SELECT * FROM #Stats2 ORDER BY USDAmount DESC;
        DROP TABLE #Stats2;
    END
END
GO

-- ALTER PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]
--     @SearchID INT,
--     @Year INT,
--     @Type VARCHAR(25) = 'Count',  -- 'Count' or 'Amount'
--     @ResultCount INT OUTPUT,
--     @ResultAmount FLOAT OUTPUT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     -- Declare Variables for Search Criteria
--     DECLARE @CountryList VARCHAR(1000) = NULL;
--     DECLARE @IncomeGroupList VARCHAR(1000) = NULL;
--     DECLARE @YearList VARCHAR(1000) = NULL;
--     DECLARE @FundingOrgList VARCHAR(1000) = NULL;
--     DECLARE @cityList VARCHAR(1000) = NULL;
--     DECLARE @stateList VARCHAR(1000) = NULL;
--     DECLARE @regionList VARCHAR(100) = NULL;
--     DECLARE @CSOlist VARCHAR(1000) = NULL;
--     DECLARE @CancerTypelist VARCHAR(1000) = NULL;
--     DECLARE @InvestigatorType VARCHAR(250) = NULL;
--     DECLARE @institution VARCHAR(250) = NULL;
--     DECLARE @piLastName VARCHAR(50) = NULL;
--     DECLARE @piFirstName VARCHAR(50) = NULL;
--     DECLARE @piORCiD VARCHAR(50) = NULL;
--     DECLARE @FundingOrgTypeList VARCHAR(50) = NULL;
--     DECLARE @childhoodcancerList VARCHAR(1000) = NULL;

--     IF @SearchID <> 0
--     BEGIN
--         SELECT 
--             @YearList = YearList,
--             @CountryList = CountryList,
--             @IncomeGroupList = IncomeGroupList,
--             @FundingOrgList = FundingOrgList,
--             @cityList = cityList,
--             @stateList = stateList,
--             @regionList = regionList,
--             @CSOlist = CSOlist,
--             @CancerTypelist = CancerTypelist,
--             @InvestigatorType = InvestigatorType,
--             @institution = institution,
--             @piLastName = piLastName,
--             @piFirstName = piFirstName,
--             @piORCiD = piORCiD,
--             @FundingOrgTypeList = FundingOrgTypeList,
--             @childhoodcancerList = childhoodcancerList
--         FROM SearchCriteria WHERE SearchCriteriaID = @SearchID;
--     END;

--     ------------------------------------------------------
--     -- Materialize Filtered Projects into Table Variable
--     ------------------------------------------------------
--     DECLARE @FilteredProjects TABLE (
--         ProjectFundingID INT,
--         Country NVARCHAR(255),
--         Amount DECIMAL(18, 2),
--         Currency NVARCHAR(10)
--     );

--           -- Filter projects based on SearchID
--     ;WITH FilteredSearchResult AS (
--         SELECT srp.ProjectID
--         FROM SearchResultProject srp
--         WHERE srp.SearchCriteriaID = @SearchID
--     )

--     INSERT INTO @FilteredProjects (ProjectFundingID, Country, Amount, Currency)
--     SELECT 
--         f.ProjectFundingID,
--         pii.Country,
--         f.Amount,
--         o.Currency
--     FROM FilteredSearchResult srp
--     INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
--     INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
--     INNER JOIN ProjectFundingInvestigator people ON f.ProjectFundingID = people.ProjectFundingID
--     INNER JOIN Institution i ON i.InstitutionID = people.InstitutionID
--     INNER JOIN CountryMapLayer cm ON i.Country = cm.Country
--     INNER JOIN (
--         SELECT InstitutionID, ProjectFundingID 
--         FROM ProjectFundingInvestigator 
--         WHERE IsPrincipalInvestigator = 1
--     ) pi ON f.ProjectFundingID = pi.ProjectFundingID
--     INNER JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID
--     INNER JOIN Country c ON c.Abbreviation = i.Country
--     WHERE
--         (@CountryList IS NULL OR i.Country IN (SELECT [Value] FROM dbo.ToStrTable(@CountryList)))
--         AND (@IncomeGroupList IS NULL OR cm.[Value] IN (SELECT [Value] FROM dbo.ToStrTable(@IncomeGroupList)))
--         AND (@InvestigatorType IS NULL OR 
--             (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR 
--             (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0))
--         AND (@institution IS NULL OR i.Name LIKE '%' + @institution + '%')
--         AND (@piLastName IS NULL OR people.LastName LIKE '%' + @piLastName + '%')
--         AND (@piFirstName IS NULL OR people.FirstName LIKE '%' + @piFirstName + '%')
--         AND (@piORCiD IS NULL OR people.ORC_ID LIKE '%' + @piORCiD + '%')
--         AND (@cityList IS NULL OR i.City IN (SELECT [Value] FROM dbo.ToStrTable(@cityList)))
--         AND (@stateList IS NULL OR i.State IN (SELECT [Value] FROM dbo.ToStrTable(@stateList)))
--         AND (@regionList IS NULL OR c.RegionID IN (SELECT [Value] FROM dbo.ToStrTable(@regionList)))
--         AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT [Value] FROM dbo.ToStrTable(@fundingOrgList)))
--         AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT [Value] FROM dbo.ToStrTable(@FundingOrgTypeList)))
--         AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT [Value] FROM dbo.ToStrTable(@childhoodcancerList)))
--         AND (@YearList IS NULL OR EXISTS (
--             SELECT 1
--             FROM ProjectFundingExt ext
--             WHERE f.ProjectFundingID = ext.ProjectFundingID
--               AND ext.CalendarYear IN (SELECT [Value] FROM dbo.ToStrTable(@YearList))
--         ));

--     -- Adjust Amount by Year if needed
--     IF @YearList IS NOT NULL AND @Type != 'Count'
--     BEGIN
--         ;WITH FilteredProjectFundingExt AS (
--             SELECT ProjectFundingID, SUM(CalendarAmount) AS Amount
--             FROM ProjectFundingExt
--             WHERE CalendarYear IN (SELECT [Value] FROM dbo.ToStrTable(@YearList))
--             GROUP BY ProjectFundingID
--         )
--         UPDATE fp
--         SET fp.Amount = ext.Amount
--         FROM @FilteredProjects fp
--         JOIN FilteredProjectFundingExt ext ON fp.ProjectFundingID = ext.ProjectFundingID;
--     END;

--     ------------------------------------------------------
--     -- Calculate Results
--     ------------------------------------------------------
--     IF @Type = 'Count'
--     BEGIN
--         SELECT 
--             Country as country,
--             COUNT(*) AS [Count],
--             0.0 AS USDAmount
--         INTO #CountStats
--         FROM @FilteredProjects
--         GROUP BY Country;

--         SELECT @ResultCount = SUM([Count]) FROM #CountStats;
--         SELECT * FROM #CountStats ORDER BY [Count] DESC;
--         DROP TABLE #CountStats;
--     END
--     ELSE
--     BEGIN
--         SELECT 
--             f.Country as country,
--             0 AS [Count],
--             SUM(CAST((f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS DECIMAL(18, 2))) AS USDAmount
--         INTO #AmountStats
--         FROM @FilteredProjects f
--         LEFT JOIN CurrencyRate cr ON cr.FromCurrency = f.Currency AND cr.ToCurrency = 'USD' AND cr.Year = @Year
--         GROUP BY f.Country;

--         SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
--         SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
--         DROP TABLE #AmountStats;
--     END
-- END;
-- GO
----------------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
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

    -- Load search criteria
    SELECT 
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

    -- Main filtered projects
    SELECT 
        f.ProjectID, f.ProjectFundingID, ct.Name AS CancerType, pc.Relevance, f.Amount, o.Currency
    INTO #pf
    FROM SearchResultProject srp
    INNER JOIN ProjectFunding f ON srp.ProjectID = f.ProjectID
    INNER JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
    INNER JOIN ProjectCancerType pc ON f.ProjectFundingID = pc.ProjectFundingID AND ISNULL(pc.Relevance,0) <> 0
    INNER JOIN CancerType ct ON pc.CancerTypeID = ct.CancerTypeID
    WHERE srp.SearchCriteriaID = @SearchID
      AND (@CancerTypelist IS NULL OR ct.CancerTypeID IN (SELECT CancerTypeID FROM @ctlist))
      AND (@fundingOrgList IS NULL OR o.FundingOrgID IN (SELECT VALUE FROM dbo.ToStrTable(@fundingOrgList)))
      AND (@FundingOrgTypeList IS NULL OR o.Type IN (SELECT VALUE FROM dbo.ToStrTable(@FundingOrgTypeList)))
      AND (@childhoodcancerList IS NULL OR f.IsChildhood IN (SELECT VALUE FROM dbo.ToStrTable(@childhoodcancerList)))
      AND (
        @CSOlist IS NULL OR EXISTS (
            SELECT 1 FROM ProjectCSO pcso
            WHERE pcso.ProjectFundingID = f.ProjectFundingID
              AND ISNULL(pcso.Relevance,0) <> 0
              AND pcso.CSOCode IN (SELECT VALUE FROM dbo.ToStrTable(@CSOlist))
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
        SELECT CancerType, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, 0 AS USDAmount, COUNT(*) AS ProjectCount
        INTO #CountStats
        FROM #pf
        GROUP BY CancerType;

        SELECT @ResultCount = SUM(Relevance) FROM #CountStats;
        SELECT * FROM #CountStats ORDER BY Relevance DESC;
        DROP TABLE #CountStats;
    END
    ELSE
    BEGIN
        SELECT CancerType, SUM(Relevance) AS Relevance, SUM(USDAmount) AS USDAmount
        INTO #AmountStats
        FROM (
            SELECT CancerType, Relevance/100 AS Relevance,
                   (Relevance/100) * f.Amount * ISNULL(cr.ToCurrencyRate, 1) AS USDAmount
            FROM #pf f
            LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency
        ) t
        GROUP BY CancerType;

        SELECT @ResultAmount = SUM(USDAmount) FROM #AmountStats;
        SELECT * FROM #AmountStats ORDER BY USDAmount DESC;
        DROP TABLE #AmountStats;
    END

    DROP TABLE #pf;
END
GO
----------------------------------------------------------
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

------------------------------------------------------
------------------------------------------------------

-----------------------------------------------------------------------

CREATE TABLE SearchResultProject
(
    SearchCriteriaID INT,
    ProjectID INT,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE INDEX IX_SearchResultProject_SearchCriteriaID_ProjectID
ON SearchResultProject (SearchCriteriaID, ProjectID);

CREATE INDEX IX_SearchResultProject_CreatedDate
ON SearchResultProject (CreatedDate);
---------------------------
CREATE TRIGGER trg_DeleteOldSearchResults
ON SearchResultProject
AFTER INSERT
AS
BEGIN
    -- Delete rows older than 10 days
    DELETE FROM SearchResultProject
    WHERE CreatedDate < DATEADD(DAY, -2, GETDATE());
END;
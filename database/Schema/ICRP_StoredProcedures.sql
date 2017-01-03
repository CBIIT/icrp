----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjects]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjects]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjects]
GO 
CREATE PROCEDURE [dbo].[GetProjects]
    @PageSize int = NULL, -- return all by default
	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO', city, state, country ....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @termSearchType varchar(25) = NULL,  -- No full text search by default; otherwise 'Any', 'None', 'All', 'Exact'
	@terms varchar(4000) = NULL,  -- No full text search by default;
	@institution varchar(250) = NULL,
	@piLastName varchar(50) = NULL,
	@piFirstName varchar(50) = NULL,
	@piORCiD varchar(50) = NULL,
	@awardCode varchar(50) = NULL,
	@yearList varchar(1000) = NULL, 
	@cityList varchar(1000) = NULL, 
	@stateList varchar(1000) = NULL,
	@countryList varchar(1000) = NULL,
	@fundingOrgList varchar(1000) = NULL, 
	@cancerTypeList varchar(1000) = NULL, 
	@projectTypeList varchar(1000) = NULL,
	@CSOList varchar(1000) = NULL,
	@OnlyBaseProjects bit = 1  -- returns only the base projects

AS   
----------------------------------
	-- Criteria search 
	----------------------------------
	SELECT * INTO #results FROM vwProjects p
	WHERE (@institution IS NULL OR institution like '%'+ @institution +'%') AND
		(@piLastName IS NULL OR piLastName like '%'+ @piLastName +'%') AND
		(@piFirstName IS NULL OR piFirstName like '%'+ @piFirstName +'%') AND
		(@piORCiD IS NULL OR piORCiD like '%'+ @piORCiD +'%') AND
		(@awardCode IS NULL OR AwardCode like '%'+ @awardCode +'%') AND
		(@yearList IS NULL OR [CalendarYear] IN (SELECT * FROM dbo.ToIntTable(@yearList))) AND
		(@cityList IS NULL OR city IN (SELECT * FROM dbo.ToStrTable(@cityList))) AND
		(@stateList IS NULL OR state IN (SELECT * FROM dbo.ToStrTable(@stateList))) AND
		(@countryList IS NULL OR country IN (SELECT * FROM dbo.ToStrTable(@countryList))) AND
		(@fundingOrgList IS NULL OR FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@fundingOrgList))) AND
		(@cancerTypeList IS NULL OR CancerTypeID IN (SELECT * FROM dbo.ToIntTable(@cancerTypeList))) AND
		(@projectTypeList IS NULL OR ProjectType IN (SELECT * FROM dbo.ToStrTable(@projectTypeList))) AND
		(@CSOList IS NULL OR CSOCode IN (SELECT * FROM dbo.ToStrTable(@CSOList)))

	----------------------------------
	-- Return only base projects?
	----------------------------------
	DECLARE @final TABLE
	(
		ProjectID INT,		
		AwardCode NVARCHAR (50),
		ProjectFundingID INT,		
		Title nvarchar (1000),
		piLastName VARCHAR (50), 
		piFirstName VARCHAR (50), 
		piORCiD NVARCHAR (50),
		institution NVARCHAR (250), 
		Amount float,
		City VARCHAR (50), 
		State VARCHAR (3), 
		Country VARCHAR (3), 
		FundingOrgID INT, 
		FundingOrg	VARCHAR (100),
		ProjectType VARCHAR (50),
		CancerTypeID INT,
		CancerType VARCHAR (100),
		CSOCode VARCHAR (10),
		CalendarYear INT
	)	

	IF @OnlyBaseProjects = 1
	BEGIN
		INSERT INTO @final
		SELECT DISTINCT r.ProjectID, r.AwardCode, r.ProjectFundingID, r.Title, r.piLastName, r.piFirstName, r.piORCiD, r.institution, 
				r.Amount, r.City, r.State, r.country, r.FundingOrgID, r.FundingOrg, NULL, NULL, NULL, NULL, NULL
		FROM #results r
			JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM #results GROUP BY ProjectID) u ON r.ProjectFundingID = u.ProjectFundingID
	END
	ELSE
	BEGIN
		INSERT INTO @final SELECT DISTINCT * FROM #results r		
	END    

	----------------------------------
	-- Sort and Pagination
	----------------------------------
	-- Skip Full Text Search
	IF @termSearchType IS NULL OR @terms IS NULL  
	BEGIN
		SELECT * FROM @final
		ORDER BY 
			CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC' THEN Title  END ASC, --title ASC
			CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN AwardCode  END ASC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piLastName  END ASC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piFirstName  END ASC,
			CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN Institution  END ASC,
			CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN City  END ASC,
			CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN State  END ASC,
			CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN Country  END ASC,
			CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN FundingOrg  END ASC,
			CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN Title  END DESC,
			CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN AwardCode  END DESC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piLastName  END DESC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piFirstName  END DESC,
			CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN Institution  END DESC,
			CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN City  END DESC,
			CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN State  END DESC,
			CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN Country  END DESC,
			CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN FundingOrg  END DESC
		OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
		FETCH NEXT 
			CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
			END ROWS ONLY
	END
	ELSE
	BEGIN	
		----------------------------------
		-- Full text search the terms
		----------------------------------
		DECLARE @searchWords VARCHAR(1000)

		SELECT @searchWords = 
		CASE @termSearchType
			WHEN 'Exact' THEN '"'+ @terms + '"'
			WHEN 'Any' THEN REPLACE(@terms,' ',' OR ')
			ELSE REPLACE(@terms,' ',' AND ') -- All or None	
		END 

		-- do the full text search only if terms are specified 	
		SELECT r.* FROM @final r
			LEFT JOIN ProjectDocument d ON r.projectID = d.ProjectID  
			LEFT JOIN ProjectDocument_JP jd ON r.projectID = jd.ProjectID  
		WHERE
			-- do not contain any words specified
			(@termSearchType = 'None' AND (NOT CONTAINS(d.content, @searchWords)) OR (NOT CONTAINS(jd.content, @searchWords))) OR
			-- COntain Any, All or Exeact words
			((CONTAINS(d.content, @searchWords)) OR (CONTAINS(jd.content, @searchWords)))  
		ORDER BY 
			CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC' THEN Title  END ASC, --title ASC
			CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN AwardCode  END ASC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piLastName  END ASC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piFirstName  END ASC,
			CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN Institution  END ASC,
			CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN City  END ASC,
			CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN State  END ASC,
			CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN Country  END ASC,
			CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN FundingOrg  END ASC,
			CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN Title  END DESC,
			CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN AwardCode  END DESC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piLastName  END DESC,
			CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piFirstName  END DESC,
			CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN Institution  END DESC,			
			CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN City  END DESC,
			CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN State  END DESC,
			CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN Country  END DESC,
			CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN FundingOrg  END DESC
		OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
		FETCH NEXT 
			CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
			END ROWS ONLY 		  
	END	
  
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectsByCriteria]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByCriteria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectsByCriteria]
GO 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByCriteria]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectsByCriteria]
GO 

CREATE PROCEDURE [dbo].[GetProjectsByCriteria]
    @searchID INT OUTPUT,  -- return the searchID
	@PageSize int = NULL, -- return all by default
	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @termSearchType varchar(25) = NULL,  -- No full text search by default; otherwise 'Any', 'None', 'All', 'Exact'
	@terms varchar(4000) = NULL,  -- No full text search by default;
	@institution varchar(250) = NULL,
	@piLastName varchar(50) = NULL,
	@piFirstName varchar(50) = NULL,
	@piORCiD varchar(50) = NULL,
	@awardCode varchar(50) = NULL,
	@cityList varchar(4000) = NULL,  -- 'NYC', 'bbb','ccc'
	@stateList varchar(4000) = NULL,
	@countryList varchar(4000) = NULL,
	@fundingOrgList varchar(4000) = NULL,  -- INT
	@cancerTypeList varchar(4000) = NULL, -- INT
	@projectTypeList varchar(4000) = NULL,  -- string
	@CSOList varchar(4000) = NULL, -- string
	@isSaveCriteria bit = 1, -- save the criteria by default unless specified
	@OnlyBaseProjects bit = 1  -- returns only the base projects	
	
AS   
	----------------------------------
	-- Save search criteria
	----------------------------------	
	IF @isSaveCriteria = 1
	BEGIN
		INSERT INTO SearchCriteria ([termSearchType],[terms],[institution],[piLastName],[piFirstName],[piORCiD],[awardCode],
		[cityList],[stateList],[countryList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList])
		VALUES ( @termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@cityList,@stateList,@countryList,
			@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList)
									 
		SELECT @searchID = SCOPE_IDENTITY()	
		
	END	
	
	----------------------------------
	-- Return result results
	----------------------------------
	EXEC [GetProjects]	@PageSize, @PageNumber,@SortCol,@SortDirection, @termSearchType,@terms,@institution,
						@piLastName,@piFirstName,@piORCiD,@awardCode,@cityList,
						@stateList,	@countryList,@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList, @OnlyBaseProjects
	
	RETURN @@ROWCOUNT
 
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectsBySearchID]
GO 
CREATE PROCEDURE [dbo].[GetProjectsBySearchID]
    @PageSize int = NULL, -- return all by default
	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @searchCriteriaID INT 	
AS   

------------------------------------------------------
-- Get search criteria from saved searchCriteria
------------------------------------------------------
	DECLARE @termSearchType varchar(25)
	DECLARE @terms varchar(4000)
	DECLARE @institution varchar(250)
	DECLARE @piLastName varchar(50)
	DECLARE @piFirstName varchar(50)
	DECLARE @piORCiD varchar(50)
	DECLARE @awardCode varchar(50)
	DECLARE @cityList varchar(4000)
	DECLARE @stateList varchar(4000)
	DECLARE @countryList varchar(4000)
	DECLARE @fundingOrgList varchar(4000)
	DECLARE @cancerTypeList varchar(4000)
	DECLARE @projectTypeList varchar(4000)
	DECLARE @CSOList varchar(4000)
	DECLARE @OnlyBaseProjects bit  -- returns only the base projects

	SELECT @termSearchType = [termSearchType],
			@terms = [terms],
			@institution = [institution],
			@piLastName =[piLastName],
			@piFirstName =[piFirstName],
			@piORCiD =[piORCiD],
			@awardCode =[awardCode],
			@cityList =[cityList],
			@stateList =[stateList],
			@countryList =[countryList],
			@fundingOrgList =[fundingOrgList],
			@cancerTypeList =[cancerTypeList],
			@projectTypeList =[projectTypeList],
			@CSOList =[CSOList],
			@OnlyBaseProjects = [OnlyBaseProjects]
	FROM SearchCriteria
	WHERE SearchCriteriaID = @searchCriteriaID

	----------------------------------
	-- Return search results
	----------------------------------
	EXEC [GetProjects] @PageSize, @PageNumber,@SortCol,@SortDirection,
						@termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@cityList,
						@stateList,	@countryList,@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList, @OnlyBaseProjects
						
	RETURN @@ROWCOUNT														  
  
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectDetail]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectDetail]
GO 

CREATE PROCEDURE [dbo].[GetProjectDetail]
    @ProjectID INT    
AS   

SELECT f.Title, p.ProjectStartDate, p.ProjectEndDate,  a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract, m.Title AS FundingMechanism 
FROM project p	
	JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
	LEFT JOIN FundingMechanism m ON p.FundingMechanismID = m.FundingMechanismID
	LEFT JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE p.ProjectID = @ProjectID

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectFunding]    Script Date: 12/14/2016 4:21:42 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectFunding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectFunding]
GO 

CREATE PROCEDURE [dbo].[GetProjectFunding]
    @ProjectID INT    
AS   

SELECT pi.LastName AS piLastName, pi.FirstName AS piFirstName, i.Name AS Institution, l.City, l.State, l.Country, pf.AwardCode AS AltAwardCode, o.Name AS FundingOrganization,
		pf.BudgetStartDate, pf.BudgetEndDate
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID
	JOIN ProjectFunding_Investigator fi ON pf.ProjectFundingID = fi.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID
	JOIN Investigator pi ON pi.InvestigatorID = fi.InvestigatorID
	JOIN Location l ON l.LocationID = i.LocationID		
	JOIN FundingOrg o ON o.FundingOrgID = pf.FundingOrgID
WHERE p.ProjectID = @ProjectID
ORDER BY pf.BudgetStartDate DESC


GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCancerType]    Script Date: 12/14/2016 4:21:24 PM ******/
---------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCancerType]
GO 

CREATE PROCEDURE [dbo].[GetProjectCancerType]
    @ProjectID INT    
AS   

SELECT t.Name AS CancerType, t.SiteURL
FROM Project p
	JOIN ProjectCancerType ct ON p.ProjectID = ct.ProjectID	
	JOIN CancerType t ON ct.CancerTypeID = t.CancerTypeID
WHERE p.ProjectID = @ProjectID
ORDER BY t.Name


GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCSO]    Script Date: 12/14/2016 4:21:33 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSO]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCSO]
GO 

CREATE PROCEDURE [dbo].[GetProjectCSO]
    @ProjectID INT    
AS   

SELECT ct.CSOCode, c.CategoryName, c.Name AS CSOName, c.ShortName 
FROM Project p
	JOIN ProjectCSO ct ON p.ProjectID = ct.ProjectID	
	JOIN CSO c ON ct.CSOCode = c.Code
WHERE p.ProjectID = @ProjectID
ORDER BY c.Name


GO
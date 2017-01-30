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

CREATE PROCEDURE [dbo].[GetProjectsByCriteria]    
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
	@searchCriteriaID INT OUTPUT,  -- return the searchID	
	@ResultCount INT OUTPUT  -- return the searchID	
AS   
	----------------------------------
	-- Get all Projects 
	----------------------------------
	SELECT * INTO #proj  FROM vwProjectFundings   -- 76777
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding institutions and PI do NOT meet the criteria
	-------------------------------------------------------------------------
	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@awardCode IS NOT NULL)
	BEGIN		
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 
			(SELECT ProjectID FROM #Proj WHERE 
					((@institution IS NULL) OR (institution like '%'+ @institution +'%')) AND
					((@piLastName IS NULL) OR (piLastName like '%'+ @piLastName +'%')) AND 
				   ((@piFirstName IS NULL) OR (piFirstName like '%'+ @piFirstName +'%')) AND
				   ((@piORCiD IS NULL) OR (piORCiD like '%'+ @piORCiD +'%')) AND
				   ((@awardCode IS NULL) OR (AwardCode like '%'+ @awardCode +'%'))
			)
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI City do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @cityList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 
			(SELECT ProjectID FROM #Proj WHERE city IN (SELECT * FROM dbo.ToStrTable(@cityList)))		
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI State do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @stateList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT ProjectID FROM #Proj WHERE [State] IN (SELECT * FROM dbo.ToStrTable(@stateList)))				
	END	

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI Country do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @countryList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT ProjectID FROM #Proj WHERE [Country] IN (SELECT * FROM dbo.ToStrTable(@countryList)))				
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT ProjectID FROM #Proj WHERE FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@fundingOrgList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @cancerTypeList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
			JOIN (SELECT * FROM ProjectCancerType WHERE isnull(RelSource,'') = 'S') ct ON p.ProjectFundingID = ct.ProjectFundingID WHERE CancerTypeID IN (SELECT * FROM dbo.ToIntTable(@cancerTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which ProjectType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @projectTypeList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
			JOIN Project_ProjectType pt WITH (NOLOCK) ON p.ProjectID = pt.ProjectID WHERE ProjectType IN (SELECT * FROM dbo.ToStrTable(@projectTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @CSOList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
				JOIN ProjectCSO cso WITH (NOLOCK) ON p.ProjectFundingID = cso.ProjectFundingID WHERE CSOCode IN (SELECT * FROM dbo.ToStrTable(@CSOList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @yearList IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
				JOIN ProjectFundingExt ext WITH (NOLOCK) ON p.ProjectID = ext.ProjectID WHERE [CalendarYear] IN (SELECT * FROM dbo.ToIntTable(@yearList)))
	END	
	
	-------------------------------------------------------------------------
	-- Terms Search Filter
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF (@termSearchType IS NOT NULL) AND (@terms IS NOT NULL)
	BEGIN
		DECLARE @searchWords VARCHAR(1000)

		SELECT @searchWords = 
		CASE @termSearchType
			WHEN 'Exact' THEN '"'+ @terms + '"'
			WHEN 'Any' THEN REPLACE(@terms,' ',' OR ')
			ELSE REPLACE(@terms,' ',' AND ') -- All or None	
		END 

		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
				LEFT JOIN ProjectDocument d ON p.projectID = d.ProjectID  
				LEFT JOIN ProjectDocument_JP jd ON p.projectID = jd.ProjectID  
			 WHERE 	
				---- do not contain any words specified
				(@termSearchType = 'None' AND (NOT CONTAINS(d.content, @searchWords)) OR (NOT CONTAINS(jd.content, @searchWords))) OR
				---- COntain Any, All or Exeact words
				((CONTAINS(d.content, @searchWords)) OR (CONTAINS(jd.content, @searchWords)))  
			)
	END	

	----------------------------------
	-- Save search criteria
	----------------------------------	
	SELECT DISTINCT ProjectID INTO #baseProj FROM #proj
	
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	SELECT @ResultCount=COUNT(*) FROM #baseProj

	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #baseProj	

	INSERT INTO SearchCriteria ([termSearchType],[terms],[institution],[piLastName],[piFirstName],[piORCiD],[awardCode],
		[yearList], [cityList],[stateList],[countryList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList])
		VALUES ( @termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@yearList,@cityList,@stateList,@countryList,
			@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList)
									 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()	

	INSERT INTO SearchResult VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount)
	
	----------------------------------	
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	----------------------------------
	SELECT p.*, maxf.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort FROM
		(SELECT DISTINCT ProjectID, AwardCode FROM #proj) p
		 JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding f GROUP BY ProjectID) maxf ON p.ProjectID = maxf.ProjectID
		 JOIN ProjectFunding f ON maxf.ProjectFundingID = f.projectFundingID
		 JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
		 JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		 JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN f.Title  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN p.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN f.Title  END DESC,
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

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsBySearchID]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[GetProjectsBySearchID]
--GO 

-- CREATE PROCEDURE [dbo].[GetProjectsBySearchID]
--    @PageSize int = NULL, -- return all by default
--	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
--	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
--	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
--    @SearchID INT 	
--AS   

--	------------------------------------------------------
--	-- Get search criteria from saved searchCriteria
--	------------------------------------------------------
--	DECLARE @termSearchType varchar(25)
--	DECLARE @terms varchar(4000)
--	DECLARE @institution varchar(250)
--	DECLARE @piLastName varchar(50)
--	DECLARE @piFirstName varchar(50)
--	DECLARE @piORCiD varchar(50)
--	DECLARE @awardCode varchar(50)
--	DECLARE @yearList varchar(4000)
--	DECLARE @cityList varchar(4000)
--	DECLARE @stateList varchar(4000)
--	DECLARE @countryList varchar(4000)
--	DECLARE @fundingOrgList varchar(4000)
--	DECLARE @cancerTypeList varchar(4000)
--	DECLARE @projectTypeList varchar(4000)
--	DECLARE @CSOList varchar(4000)	

--	SELECT @termSearchType = [termSearchType],
--			@terms = [terms],
--			@institution = [institution],
--			@piLastName =[piLastName],
--			@piFirstName =[piFirstName],
--			@piORCiD =[piORCiD],
--			@awardCode =[awardCode],
--			@cityList =[cityList],
--			@yearList =[yearList],
--			@stateList =[stateList],
--			@countryList =[countryList],
--			@fundingOrgList =[fundingOrgList],
--			@cancerTypeList =[cancerTypeList],
--			@projectTypeList =[projectTypeList],
--			@CSOList =[CSOList]			
--	FROM SearchCriteria
--	WHERE SearchCriteriaID = @searchID

--	----------------------------------
--	-- Return search results
--	----------------------------------
--	declare @count INT;	
--	declare @searchCriteriaID INT;	
		
--	EXEC @count = [GetProjectsByCriteria] @searchCriteriaID OUTPUT, @PageSize, @PageNumber,@SortCol,@SortDirection,
--						@termSearchType, @terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode, @yearList,
--						@cityList, @stateList,	@countryList,@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList

--	RETURN ISNULL(@count, 0)
--GO

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
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		

	----------------------------------	
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	----------------------------------
	SELECT r.ProjectID, p.AwardCode, maxf.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		JOIN Project p ON r.ProjectID = p.ProjectID
		 JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding f GROUP BY ProjectID) maxf ON r.ProjectID = maxf.ProjectID
		 JOIN ProjectFunding f ON maxf.ProjectFundingID = f.projectFundingID
		 JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
		 JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		 JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN f.Title  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN p.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN f.Title  END DESC,
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



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCountryStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCountryStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCountryStatsBySearchID]   
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT i.country, Count(*) AS [Count] INTO #stats
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
		JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
	GROUP BY i.country				

	SELECT @ResultCount = SUM([Count]) FROM #stats	

	SELECT * FROM #stats ORDER BY [Count] Desc
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCSOStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSOStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCSOStatsBySearchID]   
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID			

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT c.categoryName, Count(*) AS [Count] INTO #stats
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
		JOIN ProjectCSO pc ON f.projectFundingID = pc.projectFundingID
		JOIN CSO c ON c.code = pc.csocode
	GROUP BY c.categoryName

	SELECT @ResultCount = SUM([Count]) FROM #stats	

	SELECT * FROM #stats ORDER BY [Count] DESC
	
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypeStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypeStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCancerTypeStatsBySearchID]
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT c.Name AS CancerType, Count(*) AS [Count] INTO #stats
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(RelSource,'') = 'S') pc ON f.projectFundingID = pc.projectFundingID		
		JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID		
	GROUP BY c.Name

	SELECT @ResultCount = SUM([Count]) FROM #stats	

	SELECT * FROM #stats ORDER BY [Count] DESC
GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectTypeStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectTypeStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectTypeStatsBySearchID]   
    @SearchID INT,
	@ResultCount INT OUTPUT  -- return the searchID		

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT pt.ProjectType, Count(*) AS [Count] INTO #stats
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r				
		JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID				
	GROUP BY pt.ProjectType
	
	SELECT @ResultCount = SUM([Count]) FROM #stats	

	SELECT * FROM #stats ORDER BY [Count] DESC
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectAwardStatsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectAwardStatsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectAwardStatsBySearchID]
GO 


CREATE PROCEDURE [dbo].[GetProjectAwardStatsBySearchID]   
    @SearchID INT,
	@isPartner bit = 0,
	@Total float OUTPUT  -- return the searchID		

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @Total=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	IF @isPartner = 0
	BEGIN
		SELECT ext.CalendarYear AS Year, Count(*) AS Count INTO #stats
		FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFundingExt ext ON ext.ProjectID = r.ProjectID
		GROUP BY ext.CalendarYear		

<<<<<<< HEAD
		SELECT @Total = SUM([Count]) FROM #stats	

		SELECT * FROM #stats ORDER BY Year
=======
		SELECT @ResultCount = SUM([Count]) FROM #stats	

		SELECT * FROM #stats ORDER BY [Count] DESC
>>>>>>> 2b9113b7dbd61a5b3b421285f837cd06713a09d2

	END
	ELSE  -- Partner Site
	BEGIN
		SELECT ext.CalendarYear AS Year, SUM(ISNULL(ext.CalendarAmount,0)) AS Amount INTO #statsPart
		FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFundingExt ext ON ext.ProjectID = r.ProjectID
		GROUP BY ext.CalendarYear	
	
<<<<<<< HEAD
		SELECT @Total = SUM(Amount) FROM #statsPart	

		SELECT * FROM #statsPart ORDER BY Year	
=======
		SELECT @ResultCount = SUM([Count]) FROM #statsPart	

		SELECT * FROM #statsPart ORDER BY [Count] DESC	
>>>>>>> 2b9113b7dbd61a5b3b421285f837cd06713a09d2
	END
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
 -- Get the project's most recent funding - max ProjectID
SELECT f.Title, mf.ProjectFundingID AS LastProjectFundingID, p.AwardCode, p.ProjectStartDate, p.ProjectEndDate,  a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract, f.MechanismCode + ' - ' + f.MechanismTitle AS FundingMechanism 
FROM Project p	
	JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding GROUP BY ProjectID) mf ON p.ProjectID = mf.ProjectID
	JOIN ProjectFunding f ON f.ProjectFundingID = mf.ProjectFundingID	
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

SELECT pf.ProjectFundingID, pf.title, fi.LastName AS piLastName, fi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.State, i.Country, pf.Category,
		pf.ALtAwardCode AS AltAwardCode, o.Abbreviation AS FundingOrganization,	pf.BudgetStartDate, pf.BudgetEndDate
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID
	JOIN ProjectFundingInvestigator fi ON pf.ProjectFundingID = fi.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg o ON o.FundingOrgID = pf.FundingOrgID
WHERE p.ProjectID = @ProjectID
ORDER BY pf.BudgetStartDate DESC, p.ProjectID DESC

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
    @ProjectFundingID INT    
AS   

SELECT t.Name AS CancerType, t.SiteURL
FROM ProjectFunding f
	JOIN ProjectCancerType ct ON f.ProjectFundingID = ct.ProjectFundingID	
	JOIN CancerType t ON ct.CancerTypeID = t.CancerTypeID
WHERE f.ProjectFundingID = @ProjectFundingID AND isnull(ct.RelSource,'') = 'S'
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
    @ProjectFundingID INT    
AS   

SELECT pc.CSOCode, c.CategoryName, c.Name AS CSOName, c.ShortName 
FROM ProjectFunding f
	JOIN ProjectCSO pc ON f.ProjectFundingID = pc.ProjectFundingID	
	JOIN CSO c ON pc.CSOCode = c.Code
WHERE f.ProjectFundingID = @ProjectFundingID
ORDER BY c.Name


GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectFundingDetail]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectFundingDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectFundingDetail]
GO 

CREATE PROCEDURE [dbo].[GetProjectFundingDetail]
    @ProjectFundingID INT    
AS   
 
SELECT f.Title, f.AltAwardCode, f.BudgetStartDate,  f.BudgetEndDate, o.Name AS FundingOrg, pi.LastName + ', ' + pi.FirstName AS piName, 
	i.Name AS Institution, i.City, i.State, i.Country, a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract
FROM ProjectFunding f	
	JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = pi.InstitutionID
	JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE f.ProjectFundingID = @ProjectFundingID

GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectExportsBySearchID]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectExportsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectExportsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectExportsBySearchID]
     @SearchID INT,
	 @SiteURL varchar(50) = 'https://www.icrpartnership.org/project/'
	 
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
		
	-----------------------------------------------------------		
	--  Get all related projects with dolloar amounts
	-----------------------------------------------------------			 
	SELECT p.ProjectID, p.AwardCode, f.Title AS AwardTitle, pt.ProjectType AS AwardType, f.Source_ID, f.AltAwardCode, p.ProjectStartDate AS AwardStartDate, p.ProjectEndDate AS AwardEndDate, 
		f.BudgetStartDate,  f.BudgetEndDate, f.Amount AS AwardAmount, 
		CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator, o.Currency, NULL AS ToCurrency, NULL AS ToCurrencyRate,		
<<<<<<< HEAD
		f.MechanismTitle AS FundingMechanism, f.MechanismCode AS FundingMechanismCode, o.Name AS FundingOrg, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, '' AS FundingContact, 
=======
		p.MechanismTitle AS FundingMechanism, p.MechanismCode AS FundingMechanismCode, o.Name AS FundingOrg, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, '' AS FundingContact, 
>>>>>>> 2b9113b7dbd61a5b3b421285f837cd06713a09d2
		pi.LastName  AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCID,i.Name AS Institution, i.City, i.State, i.Country, @Siteurl+CAST(p.Projectid AS varchar(10)) AS icrpURL, a.TechAbstract
	INTO #temp
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		LEFT JOIN Project p ON r.ProjectID = p.ProjectID
		LEFT JOIN Project_ProjectType pt ON p.ProjectID = pt.ProjectID
		LEFT JOIN ProjectFunding f ON p.ProjectID = f.PROJECTID
		LEFT JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
		LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
		LEFT JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID		
		LEFT JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	

	-----------------------------------------------------------		
	--  Get all calendar amounts and convert them to columns
	-----------------------------------------------------------		 	 
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
	DECLARE   @PivotColumns AS NVARCHAR(MAX)  	

	--Get unique values of pivot column  
	SELECT   @PivotColumns= COALESCE(@PivotColumns + ',','') + QUOTENAME(calendaryear)
	FROM (SELECT DISTINCT calendaryear FROM [dbo].[projectfundingext]) AS p	 
 
	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = 
		N'SELECT * '+
		'FROM (SELECT t.*, calendaryear, calendaramount FROM projectfundingext ext
				JOIN #temp t ON ext.ProjectID = t.ProjectID    
				) cal			
		PIVOT( SUM(calendaramount) 
			  FOR calendaryear IN (' + @PivotColumns + ')) AS P'

	----Execute dynamic query	
	EXEC sp_executesql @SQLQuery
    											  
GO

 

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCSOsBySearchID]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCSOsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCSOsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCSOsBySearchID]
      @SearchID INT
AS   
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	

	-----------------------------------------------------------		
	--  Get project CSOs
	-----------------------------------------------------------			 
	SELECT r.ProjectID, cso.CSOCode, cso.Relevance AS CSORelevance
	INTO #temp 
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		JOIN ProjectCSO cso ON f.ProjectFundingID = cso.ProjectFundingID
	
	SELECT * FROM #temp ORDER BY ProjectID
		
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCancerTypesBySearchID]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCancerTypesBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCancerTypesBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectCancerTypesBySearchID]
     @SearchID INT	
	 
AS  
	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	

	-----------------------------------------------------------		
	--  Get project CancerTypes
	-----------------------------------------------------------			 
	SELECT r.ProjectID, ct.Name AS CancerType, pct.Relevance AS Relevance
	INTO #temp 
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		JOIN ProjectCancerType pct ON f.ProjectFundingID = pct.ProjectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
	
	SELECT * FROM #temp ORDER BY ProjectID

GO
<<<<<<< HEAD


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetPartners]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPartners]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPartners]
GO 

CREATE  PROCEDURE [dbo].[GetPartners]
    
AS   

SELECT [Name]
      , '' AS SponsorCode
	  ,[Description]	  
      ,[Country]
      ,[Website]      
      ,CAST([CreatedDate] AS DATE)AS JoinDate      
  FROM [Partner]

  GO


    
----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetLibraryFolders]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLibraryFolders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetLibraryFolders]
GO 

CREATE  PROCEDURE [dbo].[GetLibraryFolders]
    
AS   

SELECT f.Name AS Folder, p.Name AS ParentFolder,  f.isPublic,
	CASE ISNULL(f.ArchivedDate, '') WHEN '' THEN 0 ELSE 1 END AS IsFolderArchived	
FROM LibraryFolder f 
JOIN LibraryFolder p ON f.ParentFolderID= p.LibraryFolderID

  GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetLibraries]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLibraries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetLibraries]
GO 

CREATE  PROCEDURE [dbo].[GetLibraries]
    
AS   

SELECT l.FileName,ThumbnailFilename AS ThumbnailFilename, l.Title, l.Description, p.Name AS ParentFolder, f.Name AS Folder, l.isPublic,
	CASE ISNULL(l.ArchivedDate, '') WHEN '' THEN 0 ELSE 1 END AS IsFileArchived	
FROM [Library] l
JOIN LibraryFolder f ON l.LibraryFolderID = f.LibraryFolderID
JOIN LibraryFolder p ON f.ParentFolderID= p.LibraryFolderID

  GO
=======
>>>>>>> 2b9113b7dbd61a5b3b421285f837cd06713a09d2


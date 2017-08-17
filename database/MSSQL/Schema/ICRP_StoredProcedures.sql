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
	@FundingOrgTypeList varchar(50) = NULL,
	@fundingOrgList varchar(1000) = NULL, 
	@cancerTypeList varchar(1000) = NULL, 
	@projectTypeList varchar(1000) = NULL,
	@CSOList varchar(1000) = NULL,	
	@IsChildhood bit = NULL,	
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
	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@awardCode IS NOT NULL) OR (@IsChildhood IS NOT NULL)
	BEGIN		
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 
			(SELECT ProjectID FROM #Proj WHERE 
					((@institution IS NULL) OR (institution like '%'+ @institution +'%')) AND
					((@piLastName IS NULL) OR (piLastName like '%'+ @piLastName +'%')) AND 
				   ((@piFirstName IS NULL) OR (piFirstName like '%'+ @piFirstName +'%')) AND
				   ((@piORCiD IS NULL) OR (piORCiD like '%'+ @piORCiD +'%')) AND
				   ((@awardCode IS NULL) OR (AwardCode like '%'+ @awardCode +'%')) AND				   
				   ((@IsChildhood IS NULL) OR (IsChildhood = @IsChildhood))
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
	-- Exclude the projects which funding Org type do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgTypeList  IS NOT NULL
	BEGIN
		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT ProjectID FROM #Proj WHERE FundingOrgType IN (SELECT * FROM dbo.ToStrTable(@FundingOrgTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgList IS NOT NULL
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

		DELETE FROM #proj 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
			JOIN ProjectCancerType ct ON p.ProjectFundingID = ct.ProjectFundingID WHERE CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))

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
			(SELECT DISTINCT p.ProjectID FROM #Proj p
				JOIN ProjectFunding f ON p.projectID = f.ProjectID
				JOIN ProjectFundingExt ext WITH (NOLOCK) ON f.ProjectFundingID = ext.ProjectFundingID WHERE [CalendarYear] IN (SELECT * FROM dbo.ToIntTable(@yearList)))
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

		IF (@termSearchType = 'None')  ---- do not contain any words specified		
		BEGIN
			DELETE FROM #proj WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
				JOIN ProjectSearch s ON p.projectID = s.ProjectID  			
			 WHERE NOT CONTAINS(s.content, @searchWords)
			)
		END

		ELSE 
		 ---- Contain Any, All or Exeact words
		BEGIN
			DELETE FROM #proj WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #Proj p
				LEFT JOIN ProjectSearch s ON p.projectID = s.ProjectID  
			WHERE CONTAINS(s.content, @searchWords)
			)
		END		
				
	END	

	----------------------------------
	-- Save search criteria
	----------------------------------	
	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	SELECT @TotalRelatedProjectCount=COUNT(*) FROM #Proj

	SELECT DISTINCT ProjectID INTO #baseProj FROM #proj
	
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	SELECT @ResultCount=COUNT(*) FROM #baseProj	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #proj

	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #baseProj	

	INSERT INTO SearchCriteria ([termSearchType],[terms],[institution],[piLastName],[piFirstName],[piORCiD],[awardCode],
		[yearList], [cityList],[stateList],[countryList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [IsChildhood])
		VALUES ( @termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@yearList,@cityList,@stateList,@countryList,
			@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList, @FundingOrgTypeList,	@IsChildhood)
									 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()	
		
	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
	
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
/****** Object:  StoredProcedure [dbo].[GetProjectsByDataUploadID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectsByDataUploadID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectsByDataUploadID]
GO 

CREATE PROCEDURE [dbo].[GetProjectsByDataUploadID]
    @PageSize int = NULL, -- return all by default
	@PageNumber int = NULL, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO',....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @DataUploadID INT,    
	@searchCriteriaID INT OUTPUT,  -- return the searchID	
	@ResultCount INT OUTPUT  -- return the searchID		
AS   

	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	SELECT ProjectID, ProjectFundingID, BudgetEndDate  INTO #import FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadID
	SELECT @TotalRelatedProjectCount = COUNT(*) FROM #import
	SELECT @LastBudgetYear = DATEPART(year, MAX(BudgetEndDate)) FROM #import
		
	------------------------------------------------------
	-- Get all imported projects/projectfunding by DataUploadStatusID
	------------------------------------------------------	
	SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID INTO #base FROM #import GROUP BY ProjectID 
	SELECT @ResultCount = COUNT(*) FROM #base	

	----------------------------------
	-- Save search criteria
	----------------------------------			
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	
	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #base	

	INSERT INTO SearchCriteria (SearchDate) VALUES (getdate())

										 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()	

	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	

	----------------------------------	
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	----------------------------------
	SELECT r.ProjectID, p.AwardCode, r.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID		 
		 JOIN ProjectFunding f ON r.ProjectFundingID = f.projectFundingID
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
/****** Object:  StoredProcedure [dbo].[GetDataUploadSummary]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDataUploadSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDataUploadSummary] 
GO 

CREATE PROCEDURE [dbo].[GetDataUploadSummary]
    @DataUploadID INT	
AS   

	------------------------------------------------------
	-- Get all imported projects/projectfunding by DataUploadStatusID
	------------------------------------------------------	
	select * from DataUploadLog where DataUploadStatusID=@DataUploadID

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectSearchSummary]    */
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectSearchSummaryBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectSearchSummaryBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetProjectSearchSummaryBySearchID]  
    @SearchID INT
AS   
  SELECT ResultCount AS TotalProjectCount, TotalRelatedProjectCount, LastBudgetYear FROM SearchResult  WHERE SearchCriteriaID = @SearchID

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
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the searchID		
	@ResultAmount float OUTPUT  -- return the searchID	

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT country, COUNT(*) AS Count, SUM(USDAmount) AS USDAmount INTO #stats FROM 
		(SELECT i.country, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
		 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
			JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
			JOIN Institution i ON i.InstitutionID = pi.InstitutionID
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency
		) r
	GROUP BY country				

	SELECT @ResultCount = SUM(Count) FROM #stats	
	SELECT @ResultAmount = SUM([USDAmount]) FROM #stats	

	IF @Type = 'Amount'
		SELECT * FROM #stats ORDER BY [USDAmount] Desc
	ELSE
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
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the relevances		
	@ResultAmount float OUTPUT  -- return the amount	

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	IF @Type = 'Count'
	BEGIN
		SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, SUM(USDAmount) AS USDAmount, count(*) AS ProjectCount INTO #counts FROM
			(SELECT c.categoryName, Relevance, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
			 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
				JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
				JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
				JOIN CSO c ON c.code = pc.csocode
				JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
				LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
		GROUP BY categoryName

		SELECT @ResultCount = SUM(Relevance) FROM #counts			
		SELECT * FROM #counts ORDER BY Relevance DESC	
	END

	ELSE 
	
	BEGIN --  'Amount'
		SELECT categoryName, SUM(Relevance)/100 AS Relevance, SUM(USDRelAmount)/100 AS USDAmount, Count(*) AS ProjectCount INTO #amounts FROM
		(SELECT c.CategoryName, pc.Relevance, (f.Amount*ISNULL(cr.ToCurrencyRate,1)*pc.Relevance) AS USDRelAmount  
		 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
			JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
			JOIN CSO c ON c.code = pc.csocode
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
		GROUP BY categoryName
				
		SELECT @ResultAmount = SUM([USDAmount]) FROM #amounts
			
		SELECT * FROM #amounts ORDER BY [USDAmount] Desc
	
	END		
	
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
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'
	@ResultCount INT OUTPUT,  -- return the total relevances	
	@ResultAmount float OUTPUT  -- return the total amounts

AS   
    	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	IF @Type = 'Count'
	BEGIN
		SELECT CancerType, ISNULL(CAST(SUM(Relevance)/100 AS decimal(16,2)),0) AS Relevance,  SUM(USDAmount) AS USDAmount, Count(*) AS ProjectCount INTO #counts	FROM 
			(SELECT c.Name AS CancerType, Relevance, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
			 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r			
				JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
				JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pc ON f.projectFundingID = pc.projectFundingID	
				JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID
				JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
				LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
		GROUP BY CancerType	
				
		SELECT @ResultCount = SUM(Relevance) FROM #counts			
		SELECT * FROM #counts ORDER BY Relevance DESC	
	END

	ELSE 
	
	BEGIN --  'Amount'
		SELECT CancerType, ISNULL(CAST(SUM(Relevance)/100 AS decimal(16,2)),0) AS Relevance,  SUM(USDRelAmount)/100 AS USDAmount, Count(*) AS ProjectCount INTO #amounts	FROM 
			(SELECT c.Name AS CancerType, Relevance, (f.Amount*ISNULL(cr.ToCurrencyRate,1)*pc.Relevance) AS USDRelAmount
			 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r			
				JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
				JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pc ON f.projectFundingID = pc.projectFundingID	
				JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID
				JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
				LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
		GROUP BY CancerType		
				
		SELECT @ResultAmount = SUM([USDAmount]) FROM #amounts			
		SELECT * FROM #amounts ORDER BY [USDAmount] Desc
			
	END
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
	@Year INT,	
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the searchID
	@ResultAmount float OUTPUT  -- return the searchID	

AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT ProjectType, COUNT(*) AS Count, SUM(USDAmount) AS USDAmount INTO #stats FROM 
		(SELECT pt.ProjectType, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount 
		 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFunding f ON f.ProjectID = r.ProjectID			
			JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID				
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
	GROUP BY ProjectType
	
	SELECT @ResultCount = SUM([Count]) FROM #stats	
	SELECT @ResultAmount = SUM([USDAmount]) FROM #stats	

	IF @Type = 'Amount'
		SELECT * FROM #stats ORDER BY [USDAmount] Desc
	ELSE
		SELECT * FROM #stats ORDER BY [Count] Desc
	
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
	@Year INT,	
	@ResultCount INT OUTPUT,  -- return the total project count		
	@ResultAmount float OUTPUT  -- return the total project funding amount	
AS   
  	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
	
--------------------------------------------------------------------		
	--   Find all related projects and convert to USD dollars
	--------------------------------------------------------------------
	SELECT r.ProjectID, ext.CalendarYear AS Year, ext.CalendarAmount, (ext.CalendarAmount*ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount, 
		ISNULL(cr.ToCurrencyRate, 1) AS ToCurrencyRate INTO #statsPart
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		JOIN ProjectFundingExt ext ON ext.ProjectFundingID = f.ProjectFundingID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
		LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency		
	
	SELECT @ResultCount = COUNT(*) FROM #statsPart
	SELECT @ResultAmount = SUM(USDAmount) FROM #statsPart
	
	SELECT Year AS Year, COUNT(*) AS Count, SUM(USDAmount) AS amount FROM #statsPart GROUP BY Year ORDER BY Year 
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
SELECT f.Title, mf.ProjectFundingID AS LastProjectFundingID, p.AwardCode, p.ProjectStartDate, p.ProjectEndDate, p.IsChildhood, a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract, f.MechanismCode + ' - ' + f.MechanismTitle AS FundingMechanism 
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

SELECT pf.ProjectFundingID, pf.title, fi.LastName AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID,
		i.Name AS Institution, i.City, i.State, i.Country, pf.Category,
		pf.ALtAwardCode AS AltAwardCode, o.Abbreviation AS FundingOrganization,	pf.BudgetStartDate, pf.BudgetEndDate
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID
	JOIN ProjectFundingInvestigator fi ON pf.ProjectFundingID = fi.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg o ON o.FundingOrgID = pf.FundingOrgID
WHERE p.ProjectID = @ProjectID
ORDER BY pf.BudgetStartDate DESC, pf.AltAwardCode DESC

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

SELECT t.Name AS CancerType, t.Description, t.ICRPCode, t.ICD10CodeInfo
FROM ProjectFunding f
	JOIN ProjectCancerType ct ON f.ProjectFundingID = ct.ProjectFundingID	
	JOIN CancerType t ON ct.CancerTypeID = t.CancerTypeID
WHERE f.ProjectFundingID = @ProjectFundingID AND isnull(ct.RelSource,'') = 'S'  -- only return 'S' relSource
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
 
SELECT f.Title, f.AltAwardCode, f.Source_ID,  f.BudgetStartDate,  f.BudgetEndDate, o.Name AS FundingOrg, f.Amount, o.currency, 
	f.MechanismCode, f.MechanismTitle, ISNULL(f.MechanismCode, '') + ' - ' + ISNULL(f.MechanismTitle, '') AS FundingMechanism, 
	f.FundingContact, pi.LastName + ', ' + pi.FirstName AS piName, pi.ORC_ID, i.Name AS Institution, i.City, i.State, i.Country, a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract
FROM ProjectFunding f	
	JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = pi.InstitutionID
	JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE f.ProjectFundingID = @ProjectFundingID

GO

-----------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetSearchCriteriaBySearchID]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetSearchCriteriaBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetSearchCriteriaBySearchID] 
GO 


CREATE PROCEDURE [dbo].[GetSearchCriteriaBySearchID]
    @SearchID INT
AS  

DECLARE @filterList varchar(2000)

SELECT * INTO #criteria FROM SearchCriteria WHERE SearchCriteriaID =@SearchID

DECLARE @SearchCriteria TABLE
(
	[Name] varchar(50),
	[Value] varchar(250)
)


IF EXISTS (SELECT * FROM #criteria WHERE TermSearchType IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'TermSearchType:', TermSearchType FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE Terms IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'Terms:', Terms FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE ProjectTypeList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'ProjectType:', ProjectTypeList FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE AwardCode IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'AwardCode:', AwardCode FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE Institution IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'Institution:', Institution FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE piLastName IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'piLastName:', piLastName FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE piFirstName IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'piFirstName:', piFirstName FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE piORCiD IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'piORCiD', piORCiD FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE YearList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'Year:', YearList FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE CityList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'City:', CityList FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE StateList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'State:', StateList FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE CountryList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'Country:', CountryList FROM #criteria

IF EXISTS (SELECT * FROM #criteria WHERE FundingOrgTypeList IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'FundingOrgType:', FundingOrgTypeList FROM #criteria	

--select * from #criteria
SELECT @filterList= FundingOrgList FROM #criteria
IF @filterList IS NOT NULL
BEGIN
	INSERT INTO @SearchCriteria VALUES ('FundingOrg:', '')
	INSERT INTO @SearchCriteria SELECT '', SponsorCode + ' - ' + Name FROM FundingOrg WHERE FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@filterList))
END

IF EXISTS (SELECT * FROM #criteria WHERE IsChildhood IS NOT NULL)
	INSERT INTO @SearchCriteria SELECT 'Childhood Cancer:', CASE IsChildhood WHEN 1 THEN 'Yes' ELSE 'No' END FROM #criteria

SELECT @filterList= CancerTypeList FROM #criteria
IF @filterList IS NOT NULL
BEGIN
	INSERT INTO @SearchCriteria VALUES ('CancerType:', '')
	INSERT INTO @SearchCriteria SELECT '', Name FROM CancerType WHERE CancerTypeID IN (SELECT * FROM dbo.ToIntTable(@filterList))
END

SELECT @filterList= CSOList FROM #criteria
IF @filterList IS NOT NULL
BEGIN
	INSERT INTO @SearchCriteria VALUES ('CSO:', '')
	INSERT INTO @SearchCriteria SELECT '', Name FROM CSO WHERE Code IN (SELECT * FROM dbo.ToStrTable(@filterList))
END

	select * from @SearchCriteria

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
	 @IncludeAbstract INT = 0,
	 @SiteURL varchar(250) = 'https://www.icrpartnership.org/project/'
	 
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
		
	-----------------------------------------------------------		
	--  Get all related projects with dolloar amounts
	-----------------------------------------------------------			 
		SELECT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, CAST(NULL AS VARCHAR(100)) AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
		CASE p.IsChildhood 
		   WHEN 1 THEN 'Yes' 
		   WHEN 0 THEN 'No' ELSE '' 
		END AS IsChildhood,  
		p.ProjectStartDate AS AwardStartDate, p.ProjectEndDate AS AwardEndDate, f.BudgetStartDate,  f.BudgetEndDate, f.Amount AS AwardAmount, 
		CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator, o.Currency,
		f.MechanismTitle AS FundingMechanism, f.MechanismCode AS FundingMechanismCode, o.SponsorCode, o.Name AS FundingOrg, o.Type AS FundingOrgType, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, 
		f.FundingContact, pi.LastName  AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCID,i.Name AS Institution, i.City, i.State, i.Country, @Siteurl+CAST(p.Projectid AS varchar(10)) AS icrpURL, a.TechAbstract
	INTO #temp
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		LEFT JOIN Project p ON r.ProjectID = p.ProjectID		
		LEFT JOIN ProjectFunding f ON p.ProjectID = f.PROJECTID
		LEFT JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
		LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
		LEFT JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID		
		LEFT JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	
	
	-- Special handling for AwardType	 - convert multiple AwardType to a comma delimited string
	UPDATE #temp SET AwardType = AWardTypes
	FROM #temp t
	JOIN (SELECT DISTINCT ProjectID,
		  STUFF(
		  (
				SELECT ', ' + ProjectType
				FROM Project_ProjectType AS pt2
				WHERE pt2.ProjectID = pt.ProjectID
				FOR XML PATH('')
		  ), 1, 1, '') AS AWardTypes
		 FROM Project_ProjectType AS pt) aw ON t.ProjectID = aw.ProjectID	

	-----------------------------------------------------------		
	--  Get all calendar amounts and convert them to columns
	-----------------------------------------------------------		 	 
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
	DECLARE   @PivotColumns AS NVARCHAR(MAX)  	

	--Get unique values of pivot column  
	SELECT   @PivotColumns= COALESCE(@PivotColumns + ',','') + QUOTENAME(calendaryear) FROM 
	(
		SELECT DISTINCT calendaryear FROM [dbo].[projectfundingext] e
		JOIN #temp t ON  e.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CalendarYear	 

	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = N'SELECT * FROM (SELECT t.ProjectID AS ICRPProjectID, t.ProjectFundingID AS ICRPProjectFundingID, t.AwardTitle, t.AwardType, 
		t.AwardCode, t.Source_ID, t.AltAwardCode, t.FundingCategory,
		t.IsChildhood, t.AwardStartDate, t.AwardEndDate, t.BudgetStartDate,  t.BudgetEndDate, t.AwardAmount, t.FundingIndicator, t.Currency, 
		t.FundingMechanism, t.FundingMechanismCode, t.SponsorCode, t.FundingOrg, t.FundingOrgType, t.FundingDiv, t.FundingDivAbbr, t.FundingContact, 
		t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.icrpURL'

	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ', t.TechAbstract'

	IF @PivotColumns IS NOT NULL  
	BEGIN
		SET @SQLQuery = @SQLQuery + ', calendaryear, calendaramount FROM projectfundingext ext
				JOIN #temp t ON ext.ProjectFundingID = t.ProjectFundingID    
				) cal			
		PIVOT( SUM(calendaramount) 
				FOR calendaryear IN (' + @PivotColumns + ')) AS P'		
	END

	ELSE
	
	BEGIN
		SET @SQLQuery = @SQLQuery + ' FROM #temp t) AS P'		
	END

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
	SELECT f.ProjectID, f.ProjectFundingID AS ICRPProjectFundindID, f.AltAwardCode, cso.CSOCode, cso.Relevance AS CSORelevance
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
	SELECT f.ProjectID, f.ProjectFundingID AS ICRPProjectFundingID, f.AltAwardCode, ct.ICRPCode, ct.Name AS CancerType, pct.Relevance AS Relevance
	INTO #temp 
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		JOIN ProjectFunding f ON f.ProjectID = r.ProjectID
		JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pct ON f.ProjectFundingID = pct.ProjectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
	
	SELECT * FROM #temp ORDER BY ProjectID
GO


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
      ,SponsorCode
	  ,[Description]	  
      ,[Country]
      ,[Website]      
      ,CAST([JoinedDate] AS DATE)AS JoinDate      
  FROM [Partner]
  ORDER BY [Country], [Name]

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

SELECT f.Name AS Folder, p.Name AS ParentFolder,  f.isPublic	
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

SELECT l.FileName,ThumbnailFilename AS ThumbnailFilename, l.Title, l.Description, f.Name AS Folder, l.isPublic,
	CASE ISNULL(l.ArchivedDate, '') WHEN '' THEN 0 ELSE 1 END AS IsFileArchived	
FROM [Library] l
JOIN LibraryFolder f ON l.LibraryFolderID = f.LibraryFolderID
JOIN LibraryFolder p ON f.ParentFolderID= p.LibraryFolderID

  GO

    
----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetLatestNewsletter]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetLatestNewsletter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetLatestNewsletter]
GO 

CREATE  PROCEDURE [dbo].[GetLatestNewsletter]
    
AS 
  
SELECT TOP 1 l.Filename, l.ThumbnailFilename, Title, Description from Library l
join LibraryFolder f ON l.LibraryFolderID = f.LibraryFolderID where f.Name = 'Newsletters'
ORDER BY l.CreatedDate DESC

  GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectExportsSingleBySearchID]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectExportsSingleBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectExportsSingleBySearchID]
GO 

CREATE  PROCEDURE [dbo].[GetProjectExportsSingleBySearchID]
  @SearchID INT,
  @IncludeAbstract bit  = 0,
  @SiteURL varchar(250) = 'https://www.icrpartnership.org/project/'
	 
AS   

------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @ProjectIDs VARCHAR(max) 
	SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID	
		
	-----------------------------------------------------------		
	--  Get all related projects with dolloar amounts
	-----------------------------------------------------------
	SELECT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, CAST(NULL AS VARCHAR(100)) AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
		CASE p.IsChildhood 
		   WHEN 1 THEN 'Yes' 
		   WHEN 0 THEN 'No' ELSE '' 
		END AS IsChildhood, 
		p.ProjectStartDate AS AwardStartDate, p.ProjectEndDate AS AwardEndDate, f.BudgetStartDate,  f.BudgetEndDate, f.Amount AS AwardAmount, 
		CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator, o.Currency, 
		f.MechanismTitle AS FundingMechanism, f.MechanismCode AS FundingMechanismCode, o.SponsorCode, o.Name AS FundingOrg, o.Type AS FundingOrgType, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, '' AS FundingContact, 
		pi.LastName  AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCID,i.Name AS Institution, i.City, i.State, i.Country, @Siteurl+CAST(p.Projectid AS varchar(10)) AS icrpURL, a.TechAbstract
	INTO #temp
	FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r
		LEFT JOIN Project p ON r.ProjectID = p.ProjectID		
		LEFT JOIN ProjectFunding f ON p.ProjectID = f.PROJECTID
		LEFT JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
		LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
		LEFT JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID		
		LEFT JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		LEFT JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	

	---------------------------------------------------------------------------------------------------		
	-- Special handling for AwardType: convert multiple AwardType to a comma delimited string
	---------------------------------------------------------------------------------------------------				
	UPDATE #temp SET AwardType = AWardTypes
	FROM #temp t
	JOIN (SELECT DISTINCT ProjectID,
		  STUFF(
		  (
				SELECT ', ' + ProjectType
				FROM Project_ProjectType AS pt2
				WHERE pt2.ProjectID = pt.ProjectID
				FOR XML PATH('')
		  ), 1, 1, '') AS AWardTypes
		 FROM Project_ProjectType AS pt) aw ON t.ProjectID = aw.ProjectID	
 
-----------------------------------------------------------		
	--  Get all calendar amounts and convert them to columns
	-----------------------------------------------------------		 	 
	DECLARE   @SQLQuery AS NVARCHAR(MAX)
	DECLARE   @PivotColumns_Years AS NVARCHAR(MAX)  
	DECLARE   @PivotColumns_CSOs AS NVARCHAR(MAX)  
	DECLARE   @PivotColumns_CancerTypes AS NVARCHAR(MAX) 

	--Get unique values of pivot column  
	SELECT   @PivotColumns_Years= COALESCE(@PivotColumns_Years + ',','') + QUOTENAME(calendaryear) FROM 
	(
		SELECT DISTINCT calendaryear FROM [dbo].[projectfundingext] e
		JOIN #temp t ON  e.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CalendarYear	 

	-----------------------------------------------------------		
	--  Get all Project CSOs and convert them to columns
	-----------------------------------------------------------	
	SELECT @PivotColumns_CSOs= COALESCE(@PivotColumns_CSOs + ',','') + QUOTENAME(cso) FROM 
	(
		SELECT DISTINCT c.Code + ' ' + c.Name AS cso FROM [dbo].[projectCSO] pc
		JOIN CSO c ON pc.CSOCode = c.code
		JOIN #temp t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.cso

	-----------------------------------------------------------		
	--  Get all project CancerTypes and convert them to columns
	-----------------------------------------------------------	
	SELECT   @PivotColumns_CancerTypes= COALESCE(@PivotColumns_CancerTypes + ',','') + QUOTENAME(CancerType) FROM 
	(
		SELECT DISTINCT c.Name AS CancerType FROM (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pc
		JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID	
		JOIN #temp t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CancerType

	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = N'SELECT * '+
		'FROM (SELECT t.ProjectID AS ICRPProjectID, t.ProjectFundingID AS ICRPProjectFundingID, t.AwardCode, t.AwardTitle, t.AwardType, t.Source_ID, t.AltAwardCode, FundingCategory, IsChildhood,
				t.AwardStartDate, t.AwardEndDate, t.BudgetStartDate, t.BudgetEndDate, t.AwardAmount, t.FundingIndicator, t.Currency, t.FundingMechanism, t.FundingMechanismCode, SponsorCode, t.FundingOrg, FundingOrgType,
				t.FundingDiv, t.FundingDivAbbr, t.FundingContact, t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.icrpURL'
	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ', t.TechAbstract'

	IF (@PivotColumns_Years IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', calendaryear, calendaramount'
		
	IF (@PivotColumns_CSOs IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', cso.code + '' '' + cso.Name AS cso, pcso.Relevance AS csoRel'

	IF (@PivotColumns_CancerTypes IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', c.Name AS CancerType, pc.Relevance AS CancerTypeRel'
		
	SET @SQLQuery = @SQLQuery +  N' FROM #temp t'

	IF (@PivotColumns_Years IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' JOIN projectfundingext ext ON ext.ProjectFundingID = t.ProjectFundingID'
	
	IF (@PivotColumns_CSOs IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' JOIN ProjectCSO pcso ON t.projectFundingID = pcso.projectFundingID
										JOIN CSO cso ON pcso.CSOCode = cso.Code'

	IF (@PivotColumns_CancerTypes IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' JOIN ProjectCancerType pc ON t.projectFundingID = pc.projectFundingID
										JOIN CancerType c ON pc.CancerTypeID = c.CancerTypeID'
	SET @SQLQuery = @SQLQuery +  N' ) exp'
	
	IF (@PivotColumns_Years IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' PIVOT
										( 
											SUM(calendaramount) 
											  FOR calendaryear IN (' + @PivotColumns_Years + ')
										) AS amount'

	IF (@PivotColumns_CSOs IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' PIVOT
										( 
											MAX(csoRel)
											  FOR cso IN  (' + @PivotColumns_CSOs + ')
										) AS c'

	IF (@PivotColumns_CancerTypes IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N' PIVOT
										( 
											MAX(CancerTypeRel)
											  FOR CancerType IN (' + @PivotColumns_CancerTypes + ')
										) AS cancer'
		
	----Execute dynamic query	
	--PRINT @SQLQuery  
	EXEC sp_executesql @SQLQuery  
    											  
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetDataUploadStatus]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDataUploadStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDataUploadStatus]
GO 

CREATE  PROCEDURE [dbo].[GetDataUploadStatus]
    
AS   

SELECT [PartnerCode] AS Partner,[FundingYear],[Status],[ReceivedDate],[ValidationDate],[UploadToDevDate],
	[UploadToStageDate],[UploadToProdDate],[Type],l.ProjectFundingCount AS Count,
	[Note]
FROM datauploadstatus u
LEFT JOIN DataUploadLog l ON u.DataUploadStatusID = l.DataUploadStatusID
ORDER BY [ReceivedDate] DESC

GO




----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetFundingOrgs]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetFundingOrgs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetFundingOrgs]
GO 

CREATE  PROCEDURE [dbo].[GetFundingOrgs]
     @type varchar(15) = 'funding'	-- 'funding': return all funding organizations; 'Search': return all funding organizations with data uploaded; 	
AS   

	SELECT FundingOrgID, Name, Abbreviation, SponsorCode + ' - ' + Name AS DisplayName, Type, MemberType, MemberStatus, Country, Currency, 
	SponsorCode, IsAnnualized, Note, LastImportDate, LastImportDesc
	FROM FundingOrg
	WHERE (MemberStatus='Current') AND ((@type = 'funding') OR (@type = 'Search' AND LastImportDate IS NOT NULL))
	ORDER BY SponsorCode, Name

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetPartnerOrgs]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetPartnerOrgs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetPartnerOrgs]
GO 

CREATE  PROCEDURE [dbo].[GetPartnerOrgs]    
AS   
	SELECT PartnerOrgID AS ID, SponsorCode + ' - ' + Name AS Name , IsActive FROM PartnerOrg ORDER BY SponsorCode, Name
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetCancerTypeLookUp]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCancerTypeLookUp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCancerTypeLookUp]
GO 

CREATE  PROCEDURE [dbo].[GetCancerTypeLookUp]
    
AS   

SELECT CancerTypeid, Name, ICRPCode, ICD10CodeInfo
FROM CancerType
ORDER BY Name

GO
  
----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetCSOLookup]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCSOLookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCSOLookup]
GO 

CREATE  PROCEDURE [dbo].[GetCSOLookup]
    
AS   

SELECT DISTINCT CategoryName, Code, Name, Code + '  ' + Name AS DisplayName, CAST(f1.ProjectFundingID AS VARCHAR(50))+','+ CAST(f2.ProjectFundingID AS VARCHAR(50))AS ProjectFundingIDs
FROM CSO c
LEFT JOIN ProjectFunding f1 ON c.AltAwardCode1 = f1.AltAwardCode
LEFT JOIN ProjectFunding f2 ON c.AltAwardCode2 = f2.AltAwardCode
WHERE c.IsActive = 1
ORDER BY Code

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetCountryCodeLookup]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCountryCodeLookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCountryCodeLookup]
GO 

CREATE  PROCEDURE [dbo].[GetCountryCodeLookup]
    
AS   

SELECT Abbreviation AS Code, Name AS Country
FROM Country
ORDER BY Code

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetCurrencyRateLookup]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrencyRateLookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCurrencyRateLookup]
GO 

CREATE  PROCEDURE [dbo].[GetCurrencyRateLookup]
    
AS   

SELECT Year, FromCurrency, FromCurrencyRate, ToCurrency, ToCurrencyRate
FROM CurrencyRate
ORDER BY Year DESC, FromCurrency, ToCurrency

GO

  
----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetInstitutionLookup]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetInstitutionLookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetInstitutionLookup]
GO 

CREATE  PROCEDURE [dbo].[GetInstitutionLookup]
    
AS   

SELECT Name, City, State, Country, Postal, Longitude, Latitude, GRID
FROM Institution
WHERE Name <> 'Missing'
ORDER BY Name

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdateSearchResultMarkEmailSent]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateSearchResultMarkEmailSent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateSearchResultMarkEmailSent]
GO 

CREATE  PROCEDURE [dbo].[UpdateSearchResultMarkEmailSent]
@SearchID INT    
AS   

UPDATE SearchResult SET IsEmailSent = 1
WHERE SearchCriteriaID =  @SearchID

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetDataUploadInStaging]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetDataUploadInStaging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetDataUploadInStaging]
GO 

CREATE  PROCEDURE [dbo].[GetDataUploadInStaging]

AS   

SELECT DataUploadStatusID AS DataUploadID, [Type], [PartnerCode] AS SponsorCode, [FundingYear], [ReceivedDate], Note
FROM DataUploadStatus
WHERE Status = 'Staging' 
ORDER BY [ReceivedDate] DESC

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[DeleteOldSearchResults]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DeleteOldSearchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DeleteOldSearchResults]
GO 

CREATE  PROCEDURE [dbo].[DeleteOldSearchResults]

AS

SELECT c.SearchCriteriaID INTO #old 
FROM searchresult r
	join searchCriteria c ON r.SearchCriteriaID = c.SearchCriteriaID
WHERE  ISNULL(IsEmailSent, 0) = 0 OR DATEDIFF(DAY, c.SearchDate, getdate()) > 30  -- only keep results for 30 days

DELETE searchresult
WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM #old)

DELETE searchCriteria
WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM #old)

GO




/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[AddInstitutions]    Script Date: 12/14/2016 4:21:37 PM ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddInstitutions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddInstitutions]
GO 

CREATE PROCEDURE [dbo].[AddInstitutions] 
  
AS

BEGIN TRANSACTION;

BEGIN TRY     	


	IF object_id('tmp_LoadIInstitutions') is null
	BEGIN
		   RAISERROR ('Table tmp_LoadIInstitutions not found', 16, 1)
	END

	SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] INTO #exist 
	FROM tmp_LoadIInstitutions u JOIN Institution i ON u.Name = i.Name AND u.City = i.City	

	-- DO NOT insert the institutions which already exist in the Institutions lookup 
	INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
	SELECT i.[Name], i.[City], i.[State], i.[Country], i.[Postal], i.[Longitude], i.[Latitude], i.[GRID] FROM tmp_LoadIInstitutions i
		LEFT JOIN #exist e ON i.Name = e.Name AND i.City = e.City
	WHERE (e.Name IS NULL)
	
	SELECT * FROM #exist

	IF object_id('tmp_LoadIInstitutions') is not null
		DROP TABLE tmp_LoadIInstitutions

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[DataUpload_IntegrityCheck]    Script Date: 12/14/2016 4:21:37 PM ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_IntegrityCheck]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_IntegrityCheck]
GO 

CREATE PROCEDURE [dbo].[DataUpload_IntegrityCheck] 
 @PartnerCode VARCHAR (25),
 @Type VARCHAR (10)  = 'New' -- 'New' or 'Update' 

AS

/***********************************************************************************************/
-- Data Integrigy Check Rules - NEW Upload
--
-- 1	Rule	Check Required Fields 
--
-- 11	Rule	Check Award - Duplicate AltAwardCodes
-- 12	Rule	Check Award - Missing Parent 
-- 13	Rule	Check Award - Renewals imported as Parents
-- 14	Rule	Check Budget - Invalid Award or Budget Duration
---15	Rule	Check Budget - Incorrect Funding Amounts
-- 16	Rule	Check Budget - Annulized Value
-- 17	Rule	Check Budget - Invalid Award Type
--
-- 21	Rule	Check CSO - Missing Codes/Relevance
-- 22	Rule	Check CSO - Invalid Codes
-- 23	Rule	Check CSO - Not 100% Relevance
-- 24	Rule	Check CSO - Mismatched Codes/Relevances
-- 25	Rule	Check CSO - Historical Codes
-- 26	Rule	Check CSO - Duplicate CSO Codes
--
-- 31	Rule	Check CancerType - Missing Codes/Relevance
-- 32	Rule	Check CancerType - Invalid Codes
-- 33	Rule	Check CancerType - Not 100% Relevance
-- 34	Rule	Check CancerType - Number of codes <> Number of Rel
-- 35	Rule	Check CancerType - Duplicate CancerType Codes
-- 36	Rule	Check CancerType - Duplicate CancerType codes
--
-- 41	Rule	Check FundingOrg Existance
-- 42	Rule	Check FundingOrgDiv Existance
-- 43	Rule	Check Institution - not-mapped 
--

/***********************************************************************************************/

DECLARE @DataUploadReport TABLE
(
	[ID] INT,
	[Type] varchar(25),
	[Description] varchar(250),
	[Count] INT
)
-------------------------------------------------------------------
-- Workbook Summary
-------------------------------------------------------------------
-- Get all AwardCodes
SELECT Distinct CAST('New' AS VARCHAR(25)) AS Type, CAST(NULL AS INT) AS ProjectID, CAST(NULL AS INT) AS FundingOrgID, AwardCode, 0 AS IsParent 
INTO #awardCodes FROM UploadWorkBook

UPDATE #awardCodes SET Type='Existing', ProjectID=pp.ProjectID, FundingOrgID = pp.FundingOrgID
FROM #awardCodes a 
JOIN (SELECT o.FundingOrgID, p.* FROM Project p 
		JOIN ProjectFunding f ON p.ProjectID = f.ProjectID 
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID 
	  WHERE o.SponsorCode = @PartnerCode) pp ON a.AwardCode = pp.AwardCode	

-- Get Project Funding record with parent category
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'

DECLARE @TotalAwardCodes INT
DECLARE @TotalNewParentProjects INT
DECLARE @ExistingParentProjects INT

SELECT @TotalAwardCodes = COUNT(*) FROM #awardCodes
SELECT @TotalNewParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='New'
SELECT @ExistingParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='Existing'

INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Total Base Projects (Unique AwardCodes)',  @TotalAwardCodes)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', '------- New Base Projects',  @TotalNewParentProjects)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', '------- Existing Base Projects',  @ExistingParentProjects)

DECLARE @TotalProjectFunding INT
DECLARE @ProjectFundingForNew INT
DECLARE @ProjectFundingForExisting INT
DECLARE @TotalProjectsWithParentCategory INT

SELECT @TotalProjectFunding = COUNT(*) FROM UploadWorkBook
SELECT @ProjectFundingForNew = COUNT(*) FROM UploadWorkBook u JOIN #AwardCodes b ON u.AwardCode = b.AwardCode WHERE b.Type='New'
SELECT @ProjectFundingForExisting = COUNT(*) FROM UploadWorkBook u JOIN #AwardCodes b ON u.AwardCode = b.AwardCode WHERE b.Type='Existing'
SELECT @TotalProjectsWithParentCategory = COUNT(*) FROM #parentProjects

INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Total Project Funding Records',  @TotalProjectFunding)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', '------- Funding Records for new Projects',  @ProjectFundingForNew)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', '------- Funding Records for existing projects',  @ProjectFundingForExisting)
--INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'New AwardCodes with Parent Category',  @TotalProjectsWithParentCategory)

------------------------------------------------------------------
-- Check General rules
-------------------------------------------------------------------
DECLARE @RuleName VARCHAR(100)
DECLARE @RuleID INT

SET @RuleID= 1
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

------------------------------------------------------------------
-- Check if AltAwardCodes not unique (check both workbook and existing ProjectFunding)
-------------------------------------------------------------------
SET @RuleID= 11
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

DECLARE @DupAltID TABLE
(
	[Source] varchar(25),
	[AltAwardCode] varchar(50),	
	[Count] INT
)

INSERT INTO @DupAltID SELECT 'Workbook' AS Source, Altid AS AltAwardCode, Count(*) FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1
INSERT INTO @DupAltID SELECT 'ICRP' AS Source, AltAwardCode, 1 FROM ProjectFunding f
JOIN UploadWorkBook u ON f.AltAwardCode = u.AltID

IF EXISTS (SELECT * FROM @DupAltID)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM @DupAltID
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check New AwardCodes without Parent project 
-------------------------------------------------------------------
SET @RuleID= 12
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT n.AwardCode INTO #newNoParent FROM 
(SELECT * FROM #awardcodes where Type='New') n
LEFT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
WHERE p.AwardCode IS NULL

IF EXISTS (SELECT * FROM #newNoParent)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #newNoParent
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check renewals imported as Parent 
-------------------------------------------------------------------
SET @RuleID= 13
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT 'Issue AwardCode Should NOT be Parent' AS Issue, p.* INTO #RenewalWithParent FROM 
(SELECT * FROM #awardcodes where Type='Existing') n
JOIN #parentProjects p ON n.AwardCode = p.AwardCode

IF EXISTS (SELECT * FROM #RenewalWithParent)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #RenewalWithParent
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
SET @RuleID= 14
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT AwardCode, AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, AwardStartDate, AwardEndDate) AS AwardDuration, 
		DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS BudgetDuration INTO #budgetDates FROM UploadWorkBook 		

IF EXISTS (SELECT * FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0
	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
SET @RuleID= 15
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT AwardCode, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook WHERE ISNULL(AwardFunding,0) < 0

IF EXISTS (SELECT * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0)
  INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Rule -Check Annulized Value
-------------------------------------------------------------------
SET @RuleID= 16
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT IsAnnualized INTO #annu from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('Y','N')

IF EXISTS (select * FROM #annu)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #annu
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Rule -Check AwardType Value
-------------------------------------------------------------------
SET @RuleID= 17
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

IF object_id('tmp_awardtype') is NOT null
	drop table tmp_awardtype

SELECT ALtID AS AltAwardCode, AwardType INTO #atlist
FROM UploadWorkBook

CREATE TABLE tmp_awardtype
(	
	AltAwardCode VARCHAR(50),
	AwardType VARCHAR(2000)	
)


DECLARE @AltAwardCode as VARCHAR(50)
DECLARE @AwardTypes as NVARCHAR(2000)
 
DECLARE @atcursor as CURSOR;

SET @atcursor = CURSOR FOR
SELECT AltAwardCode, AwardType FROM #atlist;
 
OPEN @atcursor;
FETCH NEXT FROM @atcursor INTO @AltAwardCode, @AwardTypes;

WHILE @@FETCH_STATUS = 0
BEGIN 
 INSERT INTO tmp_awardtype SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@AwardTypes)
 FETCH NEXT FROM @atcursor INTO @AltAwardCode, @AwardTypes;
END
 
CLOSE @atcursor;
DEALLOCATE @atcursor;

UPDATE tmp_awardtype SET AwardType = LTRIM(RTRIM(AwardType))

-- Rule - Check AwardType
SELECT * INTO #invalidAwardType FROM tmp_awardtype	
WHERE AwardType NOT IN ('R', 'C', 'T')

IF EXISTS (select * FROM #invalidAwardType)
BEGIN
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #invalidAwardType	
END
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Rule 21 - Check CSO - Missing Codes/Relevance
-- Rule 22 - Check CSO - Invalid Codes
-- Rule 23 - Check CSO - Not 100% Relevance
-- Rule 24 - Check CSO - # of codes <> # of Rel
-- Rule 25 - Check CSO - Historical Codes
-- Rule 26 - Check CSO - Historical Codes
-------------------------------------------------------------------
SET @RuleID= 21
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT csocodes, csorel INTO #cso from UploadWorkBook where ISNULL(csocodes,'')='' or ISNULL(csorel,'')=''

IF EXISTS (select * from #cso)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #cso
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------
-- Prepare CSO temp tables
-----------------------------------------------------------------
IF object_id('tmp_pcso') is NOT null
	drop table tmp_pcso
IF object_id('tmp_pcsoRel') is NOT null
	drop table tmp_pcsoRel

SELECT ALtID AS AltAwardCode, CSOCodes, CSORel, SiteCodes, SiteRel, AwardType INTO #list
FROM UploadWorkBook

CREATE TABLE tmp_pcso
(
	Seq INT NOT NULL IDENTITY (1,1),
	AltAwardCode VARCHAR(50),
	CSO VARCHAR(2000)	
)

CREATE TABLE tmp_pcsorel 
(
	Seq INT NOT NULL IDENTITY (1,1),
	AltAwardCode VARCHAR(50),
	Rel decimal(18,2)
)

DECLARE @csoList as NVARCHAR(2000)
DECLARE @csoRelList as NVARCHAR(2000)
 
DECLARE @csocursor as CURSOR;

SET @csocursor = CURSOR FOR
SELECT AltAwardCode, CSOCodes , CSORel FROM #list;
 
OPEN @csocursor;
FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN 
 INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
 INSERT INTO tmp_pcsorel SELECT @AltAwardCode, 
 CASE LTRIM(RTRIM(value))
	 WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
 FROM  dbo.ToStrTable(@csoRelList) 

 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0)
 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0)

 FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
END
 
CLOSE @csocursor;
DEALLOCATE @csocursor;

UPDATE tmp_pcso SET cso = LTRIM(RTRIM(cso))

-----------------------------------------------------------------
-- Rule 22 - Check CSO - Invalid Codes
-----------------------------------------------------------------
SET @RuleID= 22
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT * INTO #invalidCSO FROM tmp_pcso c 
	LEFT JOIN CSO cso ON c.cso = cso.Code
WHERE cso.Code IS NULL

IF EXISTS (select * FROM #invalidCSO)
BEGIN
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #invalidCSO	
END
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------
-- Rule 23 - Check CSO - Not 100% Relevance
-----------------------------------------------------------------
SET @RuleID= 23
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT * INTO #Not100CSORel 
FROM (SELECT AltAwardCode, SUM(Rel) AS TotalRel FROM tmp_pcsorel GROUP BY AltAwardCode) t 
WHERE (TotalRel < 99.00) OR (TotalRel > 100.00)

IF EXISTS (select * FROM #Not100CSORel)
BEGIN
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #Not100CSORel	
END
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------
-- Rule 24 - Check CSO - # of codes <> # of Rel		
-----------------------------------------------------------------
SET @RuleID= 24
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT c.*, r.Rel, r.Seq AS RelSeq INTO #csoNotMatch FROM tmp_pcso c
FULL OUTER JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
WHERE c.AltAwardCode IS NULL OR r.AltAwardCode IS NULL

IF EXISTS (select * FROM #csoNotMatch)
BEGIN
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #csoNotMatch	
END
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0
	
-----------------------------------------------------------------	
-- 25 Check Historical CSO Codes
-----------------------------------------------------------------
SET @RuleID= 25
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT t.* INTO #oldCSO FROM tmp_pcso t
	JOIN CSO c ON t.CSO = c.Code 	
WHERE c.IsActive <> 1

IF EXISTS (select * FROM #oldCSO)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #oldCSO
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------	
-- 26 Check Duplicate CSO Codes
-----------------------------------------------------------------
SET @RuleID= 26
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT AltAwardCode, CSO INTO #dupCSO FROM tmp_pcso GROUP BY AltAwardCode, CSO Having Count(*) > 1

IF EXISTS (select * FROM #dupCSO)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #dupCSO
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- 	Rule 31 - 	Check CancerType - Missing Codes/Relevance
-- 	Rule 32 - 	Check CancerType - Invalid Codes
-- 	Rule 33 - 	Check CancerType - Not 100% Relevance
-- 	Rule 34 -	Check CancerType - # of codes <> # of Rel
-- 	Rule 35 -	Check CancerType - Duplicate CancerType Codes
-------------------------------------------------------------------
SET @RuleID= 31
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT sitecodes, siterel INTO #site from UploadWorkBook where ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''

IF EXISTS (select * FROM #site)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #site
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------
-- Prepare CSO temp tables
-----------------------------------------------------------------
IF object_id('tmp_psite') is NOT null
	drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
	drop table tmp_psiterel

CREATE TABLE tmp_psite
(
	Seq INT NOT NULL IDENTITY (1,1),
	AltAwardCode VARCHAR(50),
	Code VARCHAR(2000)	
)

CREATE TABLE tmp_psiterel
(
	Seq INT NOT NULL IDENTITY (1,1),
	AltAwardCode VARCHAR(50),	
	Rel decimal(18,2)
)

DECLARE @siteList as NVARCHAR(2000)
DECLARE @siteRelList as NVARCHAR(2000)
 
DECLARE @ctcursor as CURSOR;

SET @ctcursor = CURSOR FOR
SELECT AltAwardCode, SiteCodes , SiteRel FROM #list;
 
OPEN @ctcursor;
FETCH NEXT FROM @ctcursor INTO @AltAwardCode, @siteList, @siteRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO tmp_psite SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@siteList)
 INSERT INTO tmp_psiterel SELECT @AltAwardCode, 
	CASE LTRIM(RTRIM(value))
	 WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
 FROM  dbo.ToStrTable(@siteRelList) 
 
 DBCC CHECKIDENT ('tmp_psite', RESEED, 0)
 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0)

 FETCH NEXT FROM @ctcursor INTO @AltAwardCode, @siteList, @siteRelList;
END
 
CLOSE @ctcursor;
DEALLOCATE @ctcursor;

UPDATE tmp_psite SET code = LTRIM(RTRIM(code))

-----------------------------------------------------------------	
-- 	Rule 32 - 	Check CancerType - Invalid Codes
-----------------------------------------------------------------	
SET @RuleID= 32
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT * INTO #invalidSite FROM tmp_psite s 
	LEFT JOIN CancerType ct ON s.Code = ct.ICRPCode
WHERE ct.ICRPCode IS NULL

IF EXISTS (select * FROM #invalidSite)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #invalidSite
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------	
-- 	Rule 33 - 	Check CancerType - Not 100% Relevance
-----------------------------------------------------------------	
SET @RuleID= 33
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT * INTO #Not100SiteRel
 FROM (SELECT AltAwardCode, SUM(Rel) AS TotalRel FROM tmp_psiterel GROUP BY AltAwardCode) t
 WHERE (TotalRel < 99.00) OR (TotalRel > 100.00)

IF EXISTS (select * FROM #Not100SiteRel)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #Not100SiteRel
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------	
-- 	Rule 34 -	Check CancerType - # of codes <> # of Rel	
-----------------------------------------------------------------	
SET @RuleID= 34
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT s.*, r.Rel, r.Seq AS RelSeq INTO #siteNotMatch FROM tmp_psite s
	FULL OUTER JOIN tmp_psiterel r ON s.AltAwardCode = r.AltAwardCode AND s.Seq = r.Seq
WHERE s.AltAwardCode IS NULL OR r.AltAwardCode IS NULL

IF EXISTS (select * FROM #siteNotMatch)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #siteNotMatch
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-----------------------------------------------------------------	
-- 35 Check Duplicate CancerType Codes
-----------------------------------------------------------------
SET @RuleID= 35
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT AltAwardCode, Code INTO #dupSite FROM tmp_psite GROUP BY AltAwardCode, Code Having Count(*) > 1

IF EXISTS (select * FROM #dupSite)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #dupSite
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check AwardType/ProjectTye Codes - TBD
-------------------------------------------------------------------
--IF EXISTS (select AwardType from UploadWorkBook where ISNULL(AwardType,'') NOT IN ('R','C','T'))
--BEGIN
--  PRINT 'ERROR ==> Incorrect AwardType'
--  SELECT DISTINCT 'Incorrect AwardType' AS Issue, AwardCode, AltId, AwardType from UploadWorkBook 
--	WHERE ISNULL(AwardType,'') NOT IN ('R','C','T')
--END
--ELSE
--	PRINT 'Checking Incorrect AwardType ==> Pass'	

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
SET @RuleID= 41
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT FundingOrgAbbr INTO #org from UploadWorkBook 
where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)

IF EXISTS (SELECT * FROM #org)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #org
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
SET @RuleID= 42
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
IF EXISTS (SELECT * FROM #orgDiv)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #org
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

	
-------------------------------------------------------------------
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
SET @RuleID= 43
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT u.InstitutionICRP, u.City INTO #missingInst FROM UploadWorkBook u
	LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
	LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)

IF EXISTS (select * FROM #missingInst)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #missingInst
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0
		
-------------------------------------------------------------------
-- Return Data IntegrityCheck Report
-------------------------------------------------------------------
SELECT * FROM @DataUploadReport

GO

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_IntegrityCheckDetails]    Script Date: 12/14/2016 4:21:37 PM																		*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_IntegrityCheckDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_IntegrityCheckDetails]
GO 

CREATE PROCEDURE [dbo].[DataUpload_IntegrityCheckDetails] 
 @PartnerCode VARCHAR (25),
 @RuleId INT
  
AS


/***********************************************************************************************/
-- Data Integrigy Check Rules - New Upload
--
--
-- 1	Rule	Check Required Fields 
--
-- 11	Rule	Check Award - Duplicate AltAwardCodes
-- 12	Rule	Check Award - Missing Parent 
-- 13	Rule	Check Award - Renewals imported as Parents
-- 14	Rule	Check Budget - Invalid Award or Budget Duration
---15	Rule	Check Budget - Incorrect Funding Amounts
-- 16	Rule	Check Budget - Annulized Value
-- 17	Rule	Check Budget - Invalid Award Type
--
-- 21	Rule	Check CSO - Missing Codes/Relevance
-- 22	Rule	Check CSO - Invalid Codes
-- 23	Rule	Check CSO - Not 100% Relevance
-- 24	Rule	Check CSO - Mismatched Codes/Relevances
-- 25	Rule	Check CSO - Historical Codes
-- 26	Rule	Check CSO - Duplicate CSO Codes
--
-- 31	Rule	Check CancerType - Missing Codes/Relevance
-- 32	Rule	Check CancerType - Invalid Codes
-- 33	Rule	Check CancerType - Not 100% Relevance
-- 34	Rule	Check CancerType - Number of codes <> Number of Rel
-- 35	Rule	Check CancerType - Duplicate CancerType Codes
--
-- 41	Rule	Check FundingOrg Existance
-- 42	Rule	Check FundingOrgDiv Existance
-- 43	Rule	Check Institution - not-mapped 
--

/***********************************************************************************************/

IF @RuleId = 1
BEGIN
	SELECT 'Placeholder' AS Status

END 


--Checking Parent projects ...
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA

-- Get all AwardCodes
SELECT Distinct CAST('New' AS VARCHAR(25)) AS Type, AwardCode INTO #awardCodes FROM UploadWorkBook

UPDATE #awardCodes SET Type='Existing' 
FROM #awardCodes a 
JOIN (SELECT p.* FROM Project p 
		JOIN ProjectFunding f ON p.ProjectID = f.ProjectID 
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID 
	  WHERE o.SponsorCode = @PartnerCode) pp ON a.AwardCode = pp.AwardCode

------------------------------------------------------------------
-- Check if AltAwardCodes not unique (check both workbook and existing ProjectFunding)
-------------------------------------------------------------------
IF @RuleId = 11
BEGIN

	DECLARE @DupAltID TABLE
	(
		[Dup Source] varchar(25),
		[AltAwardCode] varchar(50),	
		[Dup Count] INT
	)

	INSERT INTO @DupAltID SELECT 'Duplicate in Workbook' AS Source, Altid AS AltAwardCode, Count(*) AS "Dup Count" FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1
	INSERT INTO @DupAltID SELECT 'Exist in ICRP' AS Source, AltAwardCode, 1 FROM ProjectFunding f
		JOIN UploadWorkBook u ON f.AltAwardCode = u.AltID

	SELECT * FROM @DupAltID

END

-------------------------------------------------------------------
-- Check New AwardCodes without Parent Category 
-------------------------------------------------------------------
IF @RuleId = 12
BEGIN
	SELECT n.AwardCode INTO #newNoParent FROM 
	(SELECT * FROM #awardcodes where Type='New') n
	LEFT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
	WHERE p.AwardCode IS NULL

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #newNoParent d JOIN UploadWorkbook u ON d.AwardCode = u.AwardCode
END

-------------------------------------------------------------------
-- Check renewals imported as Parents
-------------------------------------------------------------------
IF @RuleId = 13
BEGIN
	SELECT p.* INTO #RenewalWithParent FROM 
		(SELECT * FROM #awardcodes where Type='Existing') n
		JOIN #parentProjects p ON n.AwardCode = p.AwardCode
		
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate
	FROM #RenewalWithParent d 
	JOIN UploadWorkbook u ON d.AwardCode = u.AwardCode
END

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
IF @RuleId = 14
BEGIN
	SELECT AwardCode, AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, AwardStartDate, AwardEndDate) AS AwardDuration, 
		DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS BudgetDuration INTO #budgetDates FROM UploadWorkBook 		

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.AwardStartDate, u.AwardEndDate, u.BudgetStartDate, u.BudgetEndDate 
	FROM #budgetDates c JOIN UploadWorkbook u ON c.AwardCode = u.AwardCode WHERE c.AwardDuration < 0 OR c.BudgetDuration < 0

END
	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
IF @RuleId = 15
BEGIN
	SELECT AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook WHERE ISNULL(AwardFunding,0) < 0

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #fundingAmount c JOIN UploadWorkbook u ON c.AltID = u.AltID 

END


-------------------------------------------------------------------
-- Check Annulized Value
-------------------------------------------------------------------
IF @RuleId = 16
BEGIN
	SELECT AltID, IsAnnualized INTO #annu from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('Y','N')

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.IsAnnualized, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #annu c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 


-------------------------------------------------------------------
-- Check AwardType Codes
-------------------------------------------------------------------
IF @RuleId = 17 AND object_id('tmp_awardtype') is null
BEGIN	
	SELECT ALtID AS AltAwardCode, AwardType INTO #atlist
	FROM UploadWorkBook

	CREATE TABLE tmp_awardtype
	(	
		AltAwardCode VARCHAR(50),
		AwardType VARCHAR(2000)	
	)


	DECLARE @AltAwardCode_at as VARCHAR(50)
	DECLARE @AwardTypes as NVARCHAR(2000)
 
	DECLARE @atcursor as CURSOR;

	SET @atcursor = CURSOR FOR
	SELECT AltAwardCode, AwardType FROM #atlist;
 
	OPEN @atcursor;
	FETCH NEXT FROM @atcursor INTO @AltAwardCode_at, @AwardTypes;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
	 INSERT INTO tmp_awardtype SELECT @AltAwardCode_at, value FROM  dbo.ToStrTable(@AwardTypes)
	 FETCH NEXT FROM @atcursor INTO @AltAwardCode_at, @AwardTypes;
	END
 
	CLOSE @atcursor;
	DEALLOCATE @atcursor;

	UPDATE tmp_awardtype SET AwardType = LTRIM(RTRIM(AwardType))

END 

IF @RuleId = 17
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.AwardType FROM tmp_awardtype a 
		JOIN UploadWorkbook u ON a.AltAwardCode = u.AltID		
	WHERE a.AwardType NOT IN ('R', 'C', 'T')

-------------------------------------------------------------------
-- 21	Rule	Check CSO - Missing Codes/Relevance
-- 22	Rule	Check CSO - Invalid Codes
-- 23	Rule	Check CSO - Not 100% Relevance
-- 24	Rule	Check CSO - Number of codes <> Number of Rel
-- 25	Rule	Check CSO - Historical Codes
-------------------------------------------------------------------
-------------------------------------------------------------------
-- Rule 11:  Check CSO - Missing Codes/Relevance
-------------------------------------------------------------------
IF @RuleId = 21
BEGIN
	SELECT AwardCode, AltID AS AltAwardCode, CSOCodes, CSORel
	FROM UploadWorkBook WHERE ISNULL(csocodes,'')='' or ISNULL(csorel,'')=''
END 	
	
-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF @RuleId IN (22, 23, 24, 25) AND (object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null)
BEGIN	

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_pcsoRel	

	-- Prepare CSO temp tables
	SELECT ALtID AS AltAwardCode, CSOCodes, CSORel, AwardType INTO #clist
	FROM UploadWorkBook

	CREATE TABLE tmp_pcso
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		CSO VARCHAR(2000)	
	)

	CREATE TABLE tmp_pcsorel 
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Rel decimal(18,2)
	)

	DECLARE @AltAwardCode as VARCHAR(50)
	DECLARE @csoList as NVARCHAR(2000)
	DECLARE @csoRelList as NVARCHAR(2000)
 
	DECLARE @csocursor as CURSOR;

	SET @csocursor = CURSOR FOR
	SELECT AltAwardCode, CSOCodes , CSORel FROM #clist;
 
	OPEN @csocursor;
	FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
		INSERT INTO tmp_pcsorel SELECT @AltAwardCode,
		CASE LTRIM(RTRIM(value))
		WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
		FROM  dbo.ToStrTable(@csoRelList) 

		DBCC CHECKIDENT ('tmp_pcso', RESEED, 0)
		DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0)

		FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
	END
 
	CLOSE @csocursor;
	DEALLOCATE @csocursor;

	UPDATE tmp_pcso SET cso = LTRIM(RTRIM(cso))
	UPDATE tmp_pcsorel SET Rel = LTRIM(RTRIM(Rel))	
	
END

-------------------------------------------------------------------	
-- Rule - Check CSO - Invalid Codes
-------------------------------------------------------------------
IF @RuleId = 22
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.CSOCodes, u.CSORel FROM tmp_pcso c 
		JOIN UploadWorkbook u ON c.AltAwardCode = u.AltID
		LEFT JOIN CSO cso ON c.cso = cso.Code
	WHERE cso.Code IS NULL

-------------------------------------------------------------------
-- Rule - Check CSO - Not 100% Relevance
-------------------------------------------------------------------
IF @RuleId = 23
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.CSOCodes, u.CSORel, t.TotalRel FROM (SELECT AltAwardCode, SUM(Rel) AS TotalRel FROM tmp_pcsorel GROUP BY AltAwardCode) t 
		JOIN UploadWorkbook u ON t.AltAwardCode = u.AltID
	WHERE (t.TotalRel < 99.00) OR (t.TotalRel > 100.00)

-------------------------------------------------------------------
-- Rule - Check CSO - # of codes <> # of Rel
-------------------------------------------------------------------
IF @RuleId = 24
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.CSOCodes, u.CSORel 
	FROM (SELECT c.AltAwardCode AS cAltAwardCode, r.AltAwardCode AS rAltAwardCode FROM tmp_pcso c
				FULL OUTER JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
				WHERE c.AltAwardCode IS NULL OR r.AltAwardCode IS NULL) t
	JOIN UploadWorkbook u ON (t.cAltAwardCode = u.AltID) OR (t.rAltAwardCode = u.AltID)

-------------------------------------------------------------------
-- Rule - Check Historical CSO Codes
-------------------------------------------------------------------
IF @RuleId = 25
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.CSOCodes, u.CSORel 
	FROM tmp_pcso t
		JOIN CSO c ON t.CSO = c.Code 
		JOIN UploadWorkbook u ON t.AltAwardCode = u.AltID
	WHERE c.IsActive <> 1
	
-----------------------------------------------------------------	
-- 26 Check Duplicate CancerType Codes
-----------------------------------------------------------------
IF @RuleId = 26
	SELECT d.AltAwardCode, u.CSOCodes, u.CSORel FROM (SELECT DISTINCT AltAwardCode FROM tmp_pcso GROUP BY AltAwardCode, CSO Having Count(*) > 1) d
		JOIN UploadWorkbook u ON d.AltAwardCode = u.AltID

-------------------------------------------------------------------
-- 	Rule 31 - 	Check CancerType - Missing Codes/Relevance
-- 	Rule 32 - 	Check CancerType - Invalid Codes
-- 	Rule 33 - 	Check CancerType - Not 100% Relevance
-- 	Rule 34 -	Check CancerType - # of codes <> # of Rel
-- 	Rule 35 -	Check CancerType - Duplicate CancerType codes
-------------------------------------------------------------------
-- Rule: Check CancerType Codes
IF @RuleId = 31
BEGIN
	SELECT AltID, sitecodes, siterel INTO #site from UploadWorkBook where ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #site c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 

-----------------------------------------------------------------
-- Rebuild Site temp table if not exist
-----------------------------------------------------------------
IF @RuleId IN (32, 33, 34) AND (object_id('tmp_psite') is null OR object_id('tmp_psiterel') is null)
BEGIN
	IF object_id('tmp_psite') is NOT null
		drop table tmp_psite
	IF object_id('tmp_psiterel') is NOT null
		drop table tmp_psiterel	
	
	-- Prepare Site temp tables		
	SELECT ALtID AS AltAwardCode, SiteCodes, SiteRel, AwardType INTO #slist
	FROM UploadWorkBook

	CREATE TABLE tmp_psite
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Code VARCHAR(2000)	
	)

	CREATE TABLE tmp_psiterel
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),	
		Rel decimal(18,2)
	)

	DECLARE @siteList as NVARCHAR(2000)
	DECLARE @siteRelList as NVARCHAR(2000)
 
	DECLARE @ctcursor as CURSOR;

	SET @ctcursor = CURSOR FOR
	SELECT AltAwardCode, SiteCodes , SiteRel FROM #slist;
 
	OPEN @ctcursor;
	FETCH NEXT FROM @ctcursor INTO @AltAwardCode, @siteList, @siteRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO tmp_psite SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@siteList)
		INSERT INTO tmp_psiterel SELECT @AltAwardCode,
		CASE LTRIM(RTRIM(value))
		WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
		FROM  dbo.ToStrTable(@siteRelList) 
 
		DBCC CHECKIDENT ('tmp_psite', RESEED, 0)
		DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0)

		FETCH NEXT FROM @ctcursor INTO @AltAwardCode, @siteList, @siteRelList;
	END
 
	CLOSE @ctcursor;
	DEALLOCATE @ctcursor;

	UPDATE tmp_psite SET code = LTRIM(RTRIM(code))
	UPDATE tmp_psiterel SET Rel = LTRIM(RTRIM(Rel))

END

-------------------------------------------------------------------
-- 	Rule - 	Check CancerType - Invalid Codes
-------------------------------------------------------------------
IF @RuleId = 32
	SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.SiteCodes, u.SiteRel 
	FROM tmp_psite s 
		JOIN UploadWorkbook u ON s.AltAwardCode = u.AltID
		LEFT JOIN CancerType ct ON s.Code = ct.ICRPCode
	WHERE ct.ICRPCode IS NULL

-------------------------------------------------------------------
-- 	Rule - 	Check CancerType - Not 100% Relevance
-------------------------------------------------------------------
IF @RuleId = 33
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.SiteCodes, u.SiteRel, t.TotalRel 
	FROM (SELECT AltAwardCode, SUM(Rel) AS TotalRel FROM tmp_psiterel GROUP BY AltAwardCode) t 
		JOIN UploadWorkbook u ON t.AltAwardCode = u.AltID
	WHERE (t.TotalRel < 99.00) OR (t.TotalRel > 100.00)			

-------------------------------------------------------------------
-- 	Rule -	Check CancerType - # of codes <> # of Rel	
-------------------------------------------------------------------
IF @RuleId = 34
SELECT DISTINCT u.AwardCode, u.AltID AS AltAwardCode, u.SiteCodes, u.SiteRel
	FROM (SELECT s.AltAwardCode AS sAltAwardCode, r.AltAwardCode AS rAltAwardCode FROM tmp_psite s
				FULL OUTER JOIN tmp_psiterel r ON s.AltAwardCode = r.AltAwardCode AND s.Seq = r.Seq
				WHERE s.AltAwardCode IS NULL OR r.AltAwardCode IS NULL) t
	JOIN UploadWorkbook u ON (t.sAltAwardCode = u.AltID) OR (t.rAltAwardCode = u.AltID)

-----------------------------------------------------------------	
-- 26 Check Duplicate CancerType Codes
-----------------------------------------------------------------
IF @RuleId = 35
	SELECT d.AltAwardCode, u.SiteCodes, u.SiteRel FROM (SELECT DISTINCT AltAwardCode FROM tmp_psite GROUP BY AltAwardCode, Code Having Count(*) > 1) d
		JOIN UploadWorkbook u ON d.AltAwardCode = u.AltID

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
IF @RuleId = 41
BEGIN
	SELECT DISTINCT FundingOrgAbbr INTO #org from UploadWorkBook 
	where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)
	
	SELECT DISTINCT c.*	FROM #org c 
	JOIN UploadWorkbook u ON c.FundingOrgAbbr = u.FundingOrgAbbr
END 

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
IF @RuleId = 42
BEGIN

	SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.FundingDivAbbr, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #orgDiv c JOIN UploadWorkbook u ON c.FundingDivAbbr = u.FundingDivAbbr
END 
	
-------------------------------------------------------------------
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
IF @RuleId = 43
BEGIN

	SELECT DISTINCT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
		LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
		LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
	WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)
	
	SELECT DISTINCT u.InstitutionICRP, u.City
	FROM #missingInst c JOIN UploadWorkbook u ON c.InstitutionICRP = u.InstitutionICRP AND c.City = u.City
END 

GO


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_Import]    Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_Import]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_Import]
GO 

CREATE PROCEDURE [dbo].[DataUpload_Import] 
@PartnerCode varchar(25),
@FundingYears VARCHAR(25),
@ImportNotes  VARCHAR(1000),
@ReceivedDate  datetime,
@Type varchar(25)  -- 'New', 'Update'
  
AS

--declare @PartnerCode varchar(25) = 'NIH'
--declare @FundingYears VARCHAR(25) = '2014'
--declare @ImportNotes  VARCHAR(1000) = 'NCI FY2014 New'
--declare @ReceivedDate  datetime = '06-07-2017'
--declare @Type varchar(25) = 'NEW' 

BEGIN TRANSACTION;

BEGIN TRY     

-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')

UPDATE UploadWorkbook SET AwardTitle = SUBSTRING(AwardTitle, 2, LEN(AwardTitle)-2)
where LEFT(AwardTitle, 1) = '"' AND RIGHT(AwardTitle, 1) = '"' 

UPDATE UploadWorkbook SET techabstract = SUBSTRING(techabstract, 2, LEN(techabstract)-2)
where LEFT(techabstract, 1) = '"' AND RIGHT(techabstract, 1) = '"'

-------------------------------------------------------------------------------------------
-- Insert Missing  Institutions
--------------------------------------------------------------------------------------------

-----------------------------------
-- Insert Data Upload Status
-----------------------------------
DECLARE @DataUploadStatusID_stage INT
DECLARE @DataUploadStatusID_prod INT

INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())
	
SET @DataUploadStatusID_stage = IDENT_CURRENT( 'DataUploadStatus' )  
	
-- also insert a DataUploadStatus record in icrp_data
INSERT INTO icrp_data.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())

SET @DataUploadStatusID_prod = IDENT_CURRENT( 'icrp_data.dbo.DataUploadStatus' )  

/***********************************************************************************************/
--  New AwardCodes for imported partner
/***********************************************************************************************/
SELECT Distinct CAST('New' AS VARCHAR(25)) AS Type, CAST(NULL AS INT) AS ProjectID, CAST(NULL AS INT) AS FundingOrgID, AwardCode INTO #awardCodes FROM UploadWorkBook

UPDATE #awardCodes SET Type='Existing', ProjectID=pp.ProjectID, FundingOrgID = pp.FundingOrgID
FROM #awardCodes a 
JOIN (SELECT o.FundingOrgID, p.* FROM Project p 
		JOIN ProjectFunding f ON p.ProjectID = f.ProjectID 
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID 
	  WHERE o.SponsorCode = @PartnerCode) pp ON a.AwardCode = pp.AwardCode	

SELECT u.AwardCode, MIN(u.Childhood) AS Childhood, MIN(u.AwardStartDate) AS AwardStartDate, MIN(u.AwardEndDate) AS AwardEndDate, MIN(u.AwardType) AS AwardType INTO #newParentProjects 
from UploadWorkBook u
JOIN (SELECT * FROM #awardCodes WHERE Type='New') n ON u.AwardCode = n.AwardCode
GROUP BY u.AwardCode

-----------------------------------
-- Import base Projects
-----------------------------------
INSERT INTO Project (IsChildhood, AwardCode, ProjectStartDate, ProjectEndDate, DataUploadStatusID, CreatedDate, UpdatedDate)
SELECT CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
		AwardCode, AwardStartDate, AwardEndDate, @DataUploadStatusID_stage, getdate(), getdate()
FROM #newParentProjects

-----------------------------------
-- Import Project Abstract
-----------------------------------
DECLARE @seed INT
SELECT @seed=MAX(projectAbstractID)+1 FROM projectAbstract 

CREATE TABLE UploadAbstractTemp (	
	ID INT NOT NULL IDENTITY(1,1),
	AwardCode NVARCHAR(50),
	Altid NVARCHAR(50),
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]

DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed)

INSERT INTO UploadAbstractTemp (AwardCode, Altid, TechAbstract, PublicAbstract) SELECT DISTINCT AwardCode, Altid, TechAbstract, PublicAbstract FROM UploadWorkBook 

UPDATE UploadAbstractTemp SET PublicAbstract = NULL where PublicAbstract = '0' OR PublicAbstract = ''
UPDATE UploadAbstractTemp SET TechAbstract = '' where TechAbstract = '0' OR TechAbstract IS NULL

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO ProjectAbstract (ProjectAbstractID, TechAbstract, PublicAbstract) 
SELECT ID, TechAbstract, PublicAbstract FROM UploadAbstractTemp  WHERE AwardCode IS NOT NULL

SET IDENTITY_INSERT ProjectAbstract OFF;  -- SET IDENTITY_INSERT to OFF. 

-----------------------------------
-- Import ProjectFunding 
-----------------------------------
INSERT INTO ProjectFunding ([Title],[ProjectID],[FundingOrgID],	[FundingDivisionID], [ProjectAbstractID], [DataUploadStatusID],	[Category], [AltAwardCode], [Source_ID], [MechanismCode], 
	[MechanismTitle], [FundingContact], [IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], [CreatedDate], [UpdatedDate])
SELECT u.AwardTitle, p.ProjectID, o.FundingOrgID, d.FundingDivisionID, a.ID, @DataUploadStatusID_stage,
	u.Category, u.AltId, u.SourceId, u.FundingMechanismCode, u.FundingMechanism, u.FundingContact, 
	CASE ISNULL(u.IsAnnualized, '') WHEN 'A' THEN 1 ELSE 0 END AS IsAnnualized, 
	u.AwardFunding, 
	u.BudgetStartDate, u.BudgetEndDate, getdate(), getdate()
FROM UploadWorkBook u
JOIN UploadAbstractTemp a ON u.AwardCode = a.AwardCode AND u.AltId = a.Altid
JOIN (select distinct p.ProjectID, p.AWardCode from project p  --75035
	left join projectfunding f on p.projectid = f.projectid
	left join fundingorg o on o.FundingOrgID = f.fundingorgid
	where (o.sponsorcode IS NULL) OR (o.Sponsorcode = @PartnerCode)) p ON u.AwardCode = p.awardCode
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation

-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
INSERT INTO ProjectFundingInvestigator ([ProjectFundingID], [LastName],	[FirstName],[ORC_ID],[OtherResearch_ID],[OtherResearch_Type],[IsPrivateInvestigator],[InstitutionID],[InstitutionNameSubmitted])
SELECT DISTINCT f.ProjectFundingID, u.PILastName, u.PIFirstName, u.ORCID, u.OtherResearcherID, u.OtherResearcherIDType, 1 AS isPI, ISNULL(inst.InstitutionID,1) AS InstitutionID, u.SubmittedInstitution
FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	LEFT JOIN (SELECT i.InstitutionID, i.Name, i.City, m.OldName, m.oldCity 
	           FROM Institution i LEFT JOIN InstitutionMapping m ON i.name = m.newName AND i.City = m.newCity) inst 
     ON (u.InstitutionICRP = inst.Name AND u.City = inst.City) OR (u.InstitutionICRP = inst.OldName AND u.City = inst.oldCity)

-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null
BEGIN

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_psite
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_psiterel	
	
	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	SELECT AltID AS AltAwardCode, CSOCodes, CSORel INTO #clist FROM UploadWorkBook 

	CREATE TABLE tmp_pcso
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		CSO VARCHAR(50)	
	)

	CREATE TABLE tmp_pcsorel 
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Rel Decimal (18, 2)
	)

	DECLARE @AltAwardCode as INT
	DECLARE @csoList as NVARCHAR(50)
	DECLARE @csoRelList as NVARCHAR(50)
 
	DECLARE @csocursor as CURSOR;

	SET @csocursor = CURSOR FOR
	SELECT AltAwardCode, CSOCodes , CSORel FROM #clist;
 
	OPEN @csocursor;
	FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN

	 INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
	 INSERT INTO tmp_pcsorel SELECT @AltAwardCode, CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		FROM  dbo.ToStrTable(@csoRelList) 

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0)
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0)

	 FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
	END
 
	CLOSE @csocursor;
	DEALLOCATE @csocursor;

	UPDATE tmp_pcso SET CSO = LTRIM(RTRIM(CSO))	

END

-----------------------------------
-- Import ProjectCSO
-----------------------------------
INSERT INTO ProjectCSO SELECT f.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM tmp_pcso c 
	JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode


-----------------------------------
-- Import ProjectCancerType
-----------------------------------

-----------------------------------------------------------------
-- Rebuild Site temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_psite') is null OR object_id('tmp_psiterel') is null
BEGIN

	IF object_id('tmp_psite') is NOT null
		drop table tmp_psite
	IF object_id('tmp_psiterel') is NOT null
		drop table tmp_psiterel	

	SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, u.SiteCodes, u.SiteRel INTO #slist
	FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltId = f.AltAwardCode

	CREATE TABLE tmp_psite
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Code VARCHAR(50)	
	)

	CREATE TABLE tmp_psiterel
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),	
		Rel Decimal (18, 2)
	)
	
	DECLARE @sAltAwardCode as VARCHAR(50)
	DECLARE @siteList as NVARCHAR(2000)
	DECLARE @siteRelList as NVARCHAR(2000)
 
	DECLARE @ctcursor as CURSOR;

	SET @ctcursor = CURSOR FOR
	SELECT AltAwardCode, SiteCodes , SiteRel FROM #slist;
 
	OPEN @ctcursor;
	FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN
 
	 INSERT INTO tmp_psite SELECT @sAltAwardCode, value FROM  dbo.ToStrTable(@siteList)
	 INSERT INTO tmp_psiterel SELECT @sAltAwardCode, 
		 CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		 FROM  dbo.ToStrTable(@siteRelList) 
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0)
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0)

	 FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;
	END
 
	CLOSE @ctcursor;
	DEALLOCATE @ctcursor;

	UPDATE tmp_psite SET code = LTRIM(RTRIM(code))	
END

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT f.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM tmp_psite c 
	JOIN tmp_psiterel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN CancerType ct ON c.code = ct.ICRPCode
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode

-----------------------------------
-- Import Project_ProjectTye (only the new AwardCode)
-----------------------------------
SELECT p.ProjectID, p.AwardCode, b.AwardType INTO #plist FROM #newParentProjects b
JOIN (SELECT * FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_stage) p ON p.AwardCode = b.AwardCode

	
DECLARE @ptype TABLE
(	
	ProjectID INT,	
	ProjectType VARCHAR(15)
)

DECLARE @projectID as INT
DECLARE @typeList as NVARCHAR(50)
 
DECLARE @ptcursor as CURSOR;

SET @ptcursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #plist) p;
 
OPEN @ptcursor;
FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @ptype SELECT @projectID, value FROM  dbo.ToStrTable(@typeList) 
 FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;
END
 
CLOSE @ptcursor;
DEALLOCATE @ptcursor;

INSERT INTO Project_ProjectType (ProjectID, ProjectType)
SELECT ProjectID,
		CASE ProjectType
		  WHEN 'C' THEN 'Clinical Trial'
		  WHEN 'R' THEN 'Research'
		  WHEN 'T' THEN 'Training'
		END
FROM @ptype	


----------------------------------------------------
-- Post Import Checking
----------------------------------------------------
-------------------------------------------------------------------------------------------
---- checking Imported Award Sponsor
-------------------------------------------------------------------------------------------	
select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
	from projectfunding f 
		join FundingOrg o on o.FundingOrgID = f.FundingOrgID
	where f.DataUploadStatusID = @DataUploadStatusID_stage and o.SponsorCode <> @PartnerCode

IF EXISTS (select * from #postSponsor)
	PRINT 'Post Import Check - Sponsor Code - Failed'

-------------------------------------------------------------------------------------------
---- checking Missing PI
-------------------------------------------------------------------------------------------	
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
	PRINT 'Post Import Check - Instititutions Mapping - Failed'

-------------------------------------------------------------------------------------------
---- checking Duplicate PI
-------------------------------------------------------------------------------------------	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage AND i.IsPrivateInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)
	PRINT 'Post-Checking duplicate PIs ==> Failed'
	
-------------------------------------------------------------------------------------------
---- checking missing PI
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingPI from projectfunding f
left join ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)
	PRINT 'Pre-Checking Missing PIs ==> Failed'

	
-------------------------------------------------------------------------------------------
---- checking missing CSO
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingCSO from projectfunding f
left join ProjectCSO pc on f.projectfundingid = pc.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pc.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)
	PRINT 'Pre-Checking Missing CSO ==> Failed'

-------------------------------------------------------------------------------------------
---- checking missing CancerType
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingSite from projectfunding f
left join ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and ct.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)
	PRINT 'Pre-Checking Missing CancerType ==> Failed'


-----------------------------------
-- Import ProjectFundingExt
-----------------------------------
-- call php code to calculate and populate calendar amounts


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
DELETE FROM ProjectSearch

DBCC CHECKIDENT ('[ProjectSearch]', RESEED, 0)

-- REBUILD All Abstract
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract FROM ProjectAbstract a
		JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
		GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

-------------------------------------------------------------------------------------------
-- Insert DataUploadLog 
--------------------------------------------------------------------------------------------
DECLARE @DataUploadLogID INT

INSERT INTO DataUploadLog (DataUploadStatusID, [CreatedDate])
VALUES (@DataUploadStatusID_stage, getdate())

SET @DataUploadLogID = IDENT_CURRENT( 'DataUploadLog' )  

DECLARE @Count INT

-- Insert Project Count
SELECT @Count=COUNT(*) FROM Project WHERE dataUploadStatusID = @DataUploadStatusID_stage
UPDATE DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectAbstractCount
SELECT @Count=COUNT(*) FROM ProjectAbstract a
JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCSOCount
SELECT @Count=COUNT(*) FROM ProjectCSO c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCancerTypeCount Count
SELECT @Count=COUNT(*) FROM ProjectCancerType c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert Project_ProjectType Count
SELECT @Count=COUNT(*) FROM 
(SELECT DISTINCT t.ProjectID, t.ProjectType FROM Project_ProjectType t
JOIN #plist p ON t.ProjectID = p.ProjectID
) pt

UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingCount
SELECT @Count=COUNT(*) FROM ProjectFunding 
WHERE dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingInvestigatorCount Count
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearch TotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

INSERT INTO icrp_data.dbo.DataUploadLog ([DataUploadStatusID], [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate]) 
	SELECT @DataUploadStatusID_prod, [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate] 
	FROM icrp_dataload.dbo.DataUploadLog where DataUploadStatusID=@DataUploadStatusID_stage

-----------------------------------------------------------------
-- Drop temp table
-----------------------------------------------------------------
IF object_id('UploadAbstractTemp') is NOT null
	drop table UploadAbstractTemp
IF object_id('tmp_pcso') is NOT null
	drop table tmp_pcso
IF object_id('tmp_pcsoRel') is NOT null
	drop table tmp_pcsoRel
IF object_id('tmp_psite') is NOT null
	drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
	drop table tmp_psiterel
IF object_id('tmp_awardType') is NOT null
	drop table tmp_awardType


COMMIT TRANSACTION

END TRY

BEGIN CATCH
      IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_SyncProd]     Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_SyncProd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_SyncProd] 
GO 

CREATE PROCEDURE [dbo].[DataUpload_SyncProd]    

@DataUploadStatusID_Stage INT

AS

-------------------------------------------------
-- Retrieve DataUploadStatusID and Seed Info
------------------------------------------------
declare @DataUploadStatusID_Prod INT
declare @PartnerCode VARCHAR(25)
declare @Type VARCHAR(25)

BEGIN TRANSACTION;

BEGIN TRY 

	IF ((SELECT COUNT(*) FROM icrp_data.dbo.DataUploadStatus p
		JOIN icrp_dataload.dbo.DataUploadStatus s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type WHERE s.DataUploadStatusID = @DataUploadStatusID_Stage) = 1)
	BEGIN
		SELECT @DataUploadStatusID_Prod = p.DataUploadStatusID, @Type = p.[Type], @PartnerCode=p.PartnerCode FROM icrp_data.dbo.DataUploadStatus p
			JOIN icrp_dataload.dbo.DataUploadStatus s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type
		WHERE s.DataUploadStatusID = @DataUploadStatusID_Stage
	END
	ELSE
	BEGIN			  
      RAISERROR ('Failed to retrieve Prod DataUploadStatusID', 16, 1)
	END
	
	PRINT 'icrp_data DataUploadStatusID = ' + CAST(@DataUploadStatusID_Prod AS varchar(25))
	PRINT 'icrp_dataload DataUploadStatusID = ' + CAST(@DataUploadStatusID_Stage AS varchar(25))
	PRINT 'PartnerCode = ' + @PartnerCode
	PRINT 'Type = ' + @Type

	/***********************************************************************************************/
	-- Import Data
	/***********************************************************************************************/
	PRINT '*******************************************************************************'
	PRINT '***************************** Import Data  ************************************'
	PRINT '******************************************************************************'

	-----------------------------------
	-- Import Project
	-----------------------------------
	PRINT '-- Import Project'

	INSERT INTO icrp_data.dbo.project ([IsChildhood], [AwardCode], [ProjectStartDate], [ProjectEndDate], [DataUploadStatusID], [CreatedDate], [UpdatedDate])
	SELECT [IsChildhood],[AwardCode],[ProjectStartDate],[ProjectEndDate], @DataUploadStatusID_Prod, getdate(),getdate()
	FROM icrp_dataload.dbo.Project WHERE [DataUploadStatusID] = @DataUploadStatusID_Stage	

	-----------------------------------
	-- Import Project Abstract
	-----------------------------------
	PRINT '-- Import Project Abstract'
	
	DECLARE @seed INT
	SELECT @seed=MAX(projectAbstractID)+1 FROM projectAbstract 
	PRINT 'ProjectAbstract Seed = ' + CAST(@seed AS varchar(25))


	CREATE TABLE UploadAbstractTemp (	
		ID INT NOT NULL IDENTITY(1,1),
		ProjectFundindID INT,	
		TechAbstract NVARCHAR (MAX) NULL,
		PublicAbstract NVARCHAR (MAX) NULL
	) ON [PRIMARY]

	DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed)

	INSERT INTO UploadAbstractTemp (ProjectFundindID, TechAbstract,	PublicAbstract) SELECT pf.projectFundingID, a.[TechAbstract], a.[PublicAbstract]
		FROM icrp_dataload.dbo.projectAbstract a
		JOIN icrp_dataload.dbo.projectfunding pf ON a.projectAbstractID =  pf.projectAbstractID  WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	SET IDENTITY_INSERT icrp_data.dbo.projectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

	INSERT INTO icrp_data.dbo.ProjectAbstract ([projectAbstractID], [TechAbstract], [PublicAbstract],[CreatedDate],[UpdatedDate])
	SELECT ID, [TechAbstract], [PublicAbstract],getdate(),getdate()
	FROM UploadAbstractTemp 

	SET IDENTITY_INSERT icrp_data.dbo.projectAbstract OFF;  -- SET IDENTITY_INSERT to ON. 

	--select count(*) from projectAbstract --136948, 145092
	--print 145092 - 136948

	-----------------------------------
	-- Import ProjectFunding
	-----------------------------------
	PRINT '-- Import ProjectFunding'	

	INSERT INTO icrp_data.dbo.projectfunding ([Title],[ProjectID],[FundingOrgID],	[FundingDivisionID],[ProjectAbstractID],[DataUploadStatusID],[Category],[AltAwardCode],[Source_ID],
		[MechanismCode],[MechanismTitle],[FundingContact],[IsAnnualized],[Amount],[BudgetStartDate],[BudgetEndDate],[CreatedDate],[UpdatedDate])
	
	SELECT pf.[Title], newp.[ProjectID], prodo.[FundingOrgID], proddiv.[FundingDivisionID], a.ID, @DataUploadStatusID_Prod, pf.[Category], pf.[AltAwardCode], pf.[Source_ID],
		pf.[MechanismCode],pf.[MechanismTitle],pf.[FundingContact],pf.[IsAnnualized],pf.[Amount],pf.[BudgetStartDate],pf.[BudgetEndDate],getdate(),getdate()	
	
	FROM icrp_dataload.dbo.ProjectFunding pf 
		JOIN icrp_dataload.dbo.Project p ON pf.projectid = p.ProjectID
		JOIN icrp_dataload.dbo.FundingOrg o ON pf.fundingorgID = o.FundingOrgID
		JOIN icrp_data.dbo.fundingorg prodo ON prodo.Abbreviation = o.Abbreviation AND prodo.sponsorcode = o.sponsorcode	
		LEFT JOIN icrp_dataload.dbo.FundingDivision d ON pf.FundingDivisionID = d.FundingDivisionID		
		LEFT JOIN icrp_data.dbo.FundingDivision proddiv ON proddiv.Abbreviation= o.Abbreviation
		LEFT JOIN  (
				select distinct p.ProjectID, p.AWardCode from icrp_data.dbo.project p  --75035
					left join icrp_data.dbo.projectfunding f on p.projectid = f.projectid
					left join icrp_data.dbo.fundingorg o on o.FundingOrgID = f.fundingorgid
				where (o.sponsorcode IS NULL) OR (o.Sponsorcode = @PartnerCode)

			) newp ON newp.AwardCode = p.AwardCode

		JOIN UploadAbstractTemp a ON pf.ProjectFundingID = a.ProjectFundindID		

	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage	

	-----------------------------------
	-- Import ProjectFundingInvestigator
	-----------------------------------
	PRINT '-- Import ProjectFundingInvestigator'

	INSERT INTO icrp_data.dbo.ProjectFundingInvestigator
	SELECT newpf.ProjectFundingID, pi.LastName, pi.FirstName, pi.ORC_ID, pi.OtherResearch_ID, pi.OtherResearch_Type, pi.IsPrivateInvestigator, ISNULL(newi.InstitutionID,1), InstitutionNameSubmitted, getdate(),getdate()
	FROM icrp_dataload.dbo.ProjectFundingInvestigator pi
		JOIN icrp_dataload.dbo.projectfunding pf ON pi.ProjectFundingID =  pf.ProjectFundingID  
		JOIN icrp_data.dbo.projectfunding newpf ON newpf.AltAwardCode =  pf.AltAwardCode  
		JOIN icrp_dataload.dbo.Institution i ON pi.institutionID = i.institutionID
		LEFT JOIN icrp_data.dbo.Institution newi ON newi.Name = i.Name AND newi.City = i.City
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage
				
	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	PRINT '-- Import ProjectCSO'

	INSERT INTO icrp_data.dbo.ProjectCSO
	SELECT new.ProjectFundingID, cso.CSOCode, cso.Relevance, cso.RelSource, getdate(),getdate()
	FROM icrp_dataload.dbo.ProjectCSO cso
		JOIN icrp_dataload.dbo.projectfunding pf ON cso.ProjectFundingID =  pf.ProjectFundingID  
		JOIN icrp_data.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import ProjectCancerType
	-----------------------------------
	PRINT '-- Import ProjectCancerType'

	INSERT INTO icrp_data.dbo.ProjectCancerType
	SELECT new.ProjectFundingID, ct.CancerTypeID, ct.Relevance, ct.RelSource, getdate(),getdate(), ct.EnterBy
	FROM icrp_dataload.dbo.ProjectCancerType ct
	JOIN icrp_dataload.dbo.projectfunding pf ON ct.ProjectFundingID =  pf.ProjectFundingID  
	JOIN icrp_data.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import Project_ProjectTye
	-----------------------------------
	PRINT '-- Import Project_ProjectTye'

	INSERT INTO icrp_data.dbo.Project_ProjectType
	SELECT DISTINCT np.ProjectID, pt.ProjectType, getdate(),getdate()
	FROM icrp_dataload.dbo.Project_ProjectType pt
		JOIN icrp_dataload.dbo.Project p ON pt.ProjectID = p.ProjectID
		JOIN (SELECT * FROM icrp_data.dbo.Project WHERE DataUploadStatusID = @DataUploadStatusID_Prod) np ON p.AwardCode = np.AwardCode	
	WHERE p.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import ProjectFundingExt
	-----------------------------------
	PRINT '-- Import ProjectFundingExt'

	INSERT INTO icrp_data.dbo.ProjectFundingExt
	SELECT new.ProjectFundingID, ex.CalendarYear, ex.CalendarAmount, getdate(),getdate()
	FROM icrp_dataload.dbo.ProjectFundingExt ex
		JOIN icrp_dataload.dbo.projectfunding pf ON ex.ProjectFundingID =  pf.ProjectFundingID  
		JOIN icrp_data.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	
	----------------------------------------------------
	-- Post Import Checking
	----------------------------------------------------
	-------------------------------------------------------------------------------------------
	---- checking Imported Award Sponsor
	-------------------------------------------------------------------------------------------	
	select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
		from icrp_data.dbo.projectfunding f 
			join icrp_data.dbo.FundingOrg o on o.FundingOrgID = f.FundingOrgID
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and o.SponsorCode <> @PartnerCode

	IF EXISTS (select * from #postSponsor)
	BEGIN
		PRINT 'Post Import Check - Sponsor Code - Failed'
		RAISERROR ('Post Import Check - Sponsor Code - Failed', 16, 1)
	END

	-------------------------------------------------------------------------------------------
	---- checking Missing PI
	-------------------------------------------------------------------------------------------	
	select f.altawardcode into #postNotmappedInst 
		from icrp_data.dbo.ProjectFundingInvestigator pi 
			join icrp_data.dbo.projectfunding f on pi.ProjectFundingID = f.ProjectFundingID			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.InstitutionID = 1

	IF EXISTS (select * from #postNotmappedInst)
	BEGIN
		PRINT 'Post Import Check - Instititutions Mapping - Failed'
		RAISERROR ('Post Import Check - Instititutions Mapping - Failed', 16, 1)
	END		

	-------------------------------------------------------------------------------------------
	---- checking Duplicate PI
	-------------------------------------------------------------------------------------------	
	select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
		from icrp_data.dbo.projectfunding f
			join icrp_data.dbo.projectfundinginvestigator i on f.projectfundingid = i.projectfundingid			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod AND i.IsPrivateInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1
	
	IF EXISTS (select * FROM #postdupPI)		
	BEGIN
		PRINT 'Post-Checking duplicate PIs ==> Failed'
		RAISERROR ('Post-Checking duplicate PIs ==> Failed', 16, 1)
	END	
	
	-------------------------------------------------------------------------------------------
	---- checking missing PI
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingPI from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.ProjectFundingID is null
		
	IF EXISTS (select * FROM #postMissingPI)	
	BEGIN
		PRINT 'Pre-Checking Missing PIs ==> Failed'
		RAISERROR ('Pre-Checking Missing PIs ==> Failed', 16, 1)
	END	
	
	-------------------------------------------------------------------------------------------
	---- checking missing CSO
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingCSO from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectCSO pc on f.projectfundingid = pc.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pc.ProjectFundingID is null
	
	IF EXISTS (select * FROM #postMissingCSO)
		BEGIN
		PRINT 'Pre-Checking Missing CSO ==> Failed'
		RAISERROR ('Pre-Checking Missing CSO ==> Failed', 16, 1)
	END		

	-------------------------------------------------------------------------------------------
	---- checking missing CancerType
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingSite from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and ct.ProjectFundingID is null

	
	IF EXISTS (select * FROM #postMissingCSO)			
	BEGIN
		PRINT 'Pre-Checking Missing CancerType ==> Failed'
		RAISERROR ('Pre-Checking Missing CancerType ==> Failed', 16, 1)
	END	


	-------------------------------------------------------------------------------------------
	-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
	--------------------------------------------------------------------------------------------
	PRINT 'Rebuild [ProjectSearch]'

	DELETE FROM icrp_data.dbo.ProjectSearch

	DBCC CHECKIDENT ('[ProjectSearch]', RESEED, 0)

	-- REBUILD All Abstract
	INSERT INTO icrp_data.dbo.ProjectSearch (ProjectID, [Content])
	SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
	FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract 
			FROM ProjectAbstract a
				JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
			GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

	PRINT 'Total Imported ProjectSearch = ' + CAST(@@RowCount AS varchar(10))

	-------------------------------------------------------------------------------------------
	-- Insert DataUploadLog 
	--------------------------------------------------------------------------------------------
	PRINT 'INSERT DataUploadLog'

	DECLARE @DataUploadLogID INT

	SELECT @DataUploadLogID = DataUploadLogID FROM icrp_data.dbo.DataUploadLog WHERE DataUploadStatusID = @DataUploadStatusID_Prod	
	
	PRINT '@DataUploadLogID = ' + CAST(@DataUploadLogID AS varchar(10))

	DECLARE @Count INT

	-- Insert Project Count
	SELECT @Count=COUNT(*) FROM Project	
	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectAbstractCount
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectAbstract a
		JOIN icrp_data.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID =	@DataUploadLogID

	-- Insert ProjectCSOCount
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectCSO c 
		JOIN icrp_data.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectCancerTypeCount Count
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectCancerType c 
		JOIN icrp_data.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert Project_ProjectType Count
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.Project_ProjectType t
		JOIN icrp_data.dbo.Project p ON t.ProjectID = p.ProjectID	
	WHERE p.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectFundingCount
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectFunding 
	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectFundingInvestigatorCount Count
	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectFundingInvestigator pi
		JOIN icrp_data.dbo.ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectSearch TotalCount
	SELECT @Count=COUNT(*) FROM ProjectSearch

	UPDATE icrp_data.dbo.DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-------------------------------------------------------------------------------------------
	-- Update FundingOrg LastImpoet Date/Desc
	--------------------------------------------------------------------------------------------
	UPDATE icrp_data.dbo.fundingorg SET LastImportDate=getdate(), LastImportDesc = i.Note
	FROM icrp_data.dbo.fundingorg o 
		JOIN (SELECT DISTINCT FundingOrgID, d.Note FROM icrp_data.dbo.ProjectFunding f
				JOIN icrp_data.dbo.DataUploadStatus d ON f.DataUploadStatusID = d.DataUploadStatusID
				WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod) i  ON o.FundingOrgID = i.FundingOrgID
				
	-------------------------------------------------------------------------------------------
	-- Mark DataUpload Completed
	--------------------------------------------------------------------------------------------
	UPDATE icrp_data.dbo.DataUploadStatus SET Status = 'Completed', [UploadToProdDate] = getdate() WHERE DataUploadStatusID = @DataUploadStatusID_Prod
	UPDATE icrp_dataload.dbo.DataUploadStatus SET Status = 'Completed', [UploadToProdDate] = getdate()  WHERE DataUploadStatusID = @DataUploadStatusID_Stage

	--SELECT * from icrp_data.dbo.DataUploadStatus WHERE DataUploadStatusID = @DataUploadStatusID_Prod
	--SELECT * from icrp_dataload.dbo.DataUploadStatus  WHERE DataUploadStatusID = @DataUploadStatusID_Stage	
	--select * from icrp_dataload.dbo.datauploadlog WHERE DataUploadStatusID = @DataUploadStatusID_Stage
	--SELECT * from icrp_data.dbo.datauploadlog WHERE DataUploadStatusID = @DataUploadStatusID_Prod
	
	
	-----------------------------------------------------------------
	-- Drop temp table
	-----------------------------------------------------------------
	IF object_id('UploadAbstractTemp') is NOT null
		drop table UploadAbstractTemp

	PRINT 'Post checing => pass and commit'
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      --IF @@trancount > 0 
	  BEGIN
		PRINT 'Error => rollback'
		ROLLBACK TRANSACTION
	  END
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO
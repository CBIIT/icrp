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
	SELECT categoryName, CAST(SUM(Relevance)/100 AS decimal(16,2)) AS Relevance, SUM(USDAmount) AS USDAmount, count(*) AS ProjectCount INTO #stats FROM
		(SELECT c.categoryName, Relevance, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
		 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r		
			JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
			JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
			JOIN CSO c ON c.code = pc.csocode
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
	GROUP BY categoryName
		
	SELECT @ResultCount = SUM(Relevance) FROM #stats	
	SELECT @ResultAmount = SUM([USDAmount]) FROM #stats

	IF @Type = 'Amount'
		SELECT * FROM #stats ORDER BY [USDAmount] Desc
	ELSE		
		SELECT * FROM #stats ORDER BY Relevance DESC
	
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
	SELECT CancerType, ISNULL(CAST(SUM(Relevance)/100 AS decimal(16,2)),0) AS Relevance,  SUM(USDAmount) AS USDAmount, Count(*) AS ProjectCount INTO #stats	FROM 
		(SELECT c.Name AS CancerType, Relevance, (f.Amount * ISNULL(cr.ToCurrencyRate, 1)) AS USDAmount
		 FROM (SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)) r			
			JOIN ProjectFunding f ON r.ProjectID = f.ProjectID
			JOIN ProjectCancerType pc ON f.projectFundingID = pc.projectFundingID	
			JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = o.Currency) r
	GROUP BY CancerType	
				
	SELECT @ResultCount = SUM(Relevance) FROM #stats	
	SELECT @ResultAmount = SUM([USDAmount]) FROM #stats

	IF @Type = 'Amount'
		SELECT * FROM #stats ORDER BY [USDAmount] Desc
	ELSE		
		SELECT * FROM #stats ORDER BY Relevance DESC
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
	SELECT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, pt.ProjectType AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
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
		t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.icrpURL,'

	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ' t.TechAbstract,'

	SET @SQLQuery = @SQLQuery + ' calendaryear, calendaramount FROM projectfundingext ext
				JOIN #temp t ON ext.ProjectFundingID = t.ProjectFundingID    
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
	SELECT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, pt.ProjectType AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
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

	SELECT @PivotColumns_CSOs= COALESCE(@PivotColumns_CSOs + ',','') + QUOTENAME(cso) FROM 
	(
		SELECT DISTINCT c.Code + ' ' + c.Name AS cso FROM [dbo].[projectCSO] pc
		JOIN CSO c ON pc.CSOCode = c.code
		JOIN #temp t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.cso

	SELECT   @PivotColumns_CancerTypes= COALESCE(@PivotColumns_CancerTypes + ',','') + QUOTENAME(CancerType) FROM 
	(
		SELECT DISTINCT c.Name AS CancerType FROM (SELECT * FROM [dbo].[ProjectCancerType] where isnull(relevance, 0) <> 0) pc
		JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID	
		JOIN #temp t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CancerType

	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = N'SELECT * '+
		'FROM (SELECT t.ProjectID AS ICRPProjectID, t.ProjectFundingID AS ICRPProjectFundingID, t.AwardCode, t.AwardTitle, t.AwardType, t.Source_ID, t.AltAwardCode, FundingCategory, IsChildhood,
				t.AwardStartDate, t.AwardEndDate, t.BudgetStartDate, t.BudgetEndDate, t.AwardAmount, t.FundingIndicator, t.Currency, t.FundingMechanism, t.FundingMechanismCode, SponsorCode, t.FundingOrg, FundingOrgType,
				t.FundingDiv, t.FundingDivAbbr, t.FundingContact, t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.icrpURL,'
	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ' t.TechAbstract,'

		SET @SQLQuery = @SQLQuery +  N'calendaryear, calendaramount, cso.code + '' '' + cso.Name AS cso, pcso.Relevance AS csoRel, c.Name AS CancerType, pc.Relevance AS CancerTypeRel	
				FROM projectfundingext ext
					JOIN #temp t ON ext.ProjectFundingID = t.ProjectFundingID   
					JOIN ProjectCSO pcso ON ext.projectFundingID = pcso.projectFundingID
					JOIN CSO cso ON pcso.CSOCode = cso.Code
					JOIN ProjectCancerType pc ON ext.projectFundingID = pc.projectFundingID
					JOIN CancerType c ON pc.CancerTypeID = c.CancerTypeID 
				) exp			
		PIVOT
		( 
			SUM(calendaramount) 
			  FOR calendaryear IN (' + @PivotColumns_Years + ')
		) AS amount

		PIVOT
		( 
			MAX(csoRel)
			  FOR cso IN  (' + @PivotColumns_CSOs + ')
		) AS c

		PIVOT
		( 
			MAX(CancerTypeRel)
			  FOR CancerType IN (' + @PivotColumns_CancerTypes + ')
		) AS cancer'
		
	----Execute dynamic query	
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
JOIN DataUploadLog l ON u.DataUploadStatusID = l.DataUploadStatusID
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
	WHERE (@type = 'funding') OR (@type = 'Search' AND LastImportDate IS NOT NULL)
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

SELECT CategoryName, Code, Name, Code + '  ' + Name AS DisplayName
FROM CSO
WHERE IsActive = 1
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

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[DataUpload_IntegrityCheck]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_IntegrityCheck]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_IntegrityCheck]
GO 

CREATE PROCEDURE [dbo].[DataUpload_IntegrityCheck] 
  
AS

/***********************************************************************************************/
-- Data Integrigy Check Rules - New Upload
--
-- 1	Rule	Check Duplicate AltAwardCodes
-- 2	Rule	Check New AwardCodes with Missing Parent Category
-- 3	Rule	Check Old AwardCode with Parent Category
-- 4	Rule	Check Incorrect Award or Budget Duration
---5	Rule	Check Incorrect Funding Amounts
-- 6	Rule	Check Incorrect CSO Codes/Relevance
-- 7	Rule	Check Historical CSO Codes
-- 8	Rule	Check CancerType Codes/Relevance
-- 9	Rule	Check Annulized Value
-- 10	Rule	Check FundingOrg Existance
-- 11	Rule	Check FundingOrgDiv Existance
-- 12	Rule	Check not-mapped Institution
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
SELECT Distinct AwardCode INTO #a FROM UploadWorkBook

--Checking Parent projects ...
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA

SELECT * INTO #awardCodes FROM (
	SELECT 'Existing' AS Type, a.AwardCode FROM #a a JOIN Project p ON a.AwardCode = p.AwardCode
	UNION
	SELECT 'New' AS Type, a.AwardCode FROM #a a LEFT JOIN Project p ON a.AwardCode = p.AwardCode WHERE p.AwardCode IS NULL
) a

DECLARE @TotalProjectFunding INT
DECLARE @TotalAwardCodes INT
DECLARE @TotalProjectsWithParentCategory INT
DECLARE @TotalNewParentProjects INT
DECLARE @ExistingParentProjects INT

SELECT @TotalProjectFunding = COUNT(*) FROM UploadWorkBook
SELECT @TotalAwardCodes = COUNT(*) FROM #a
SELECT @TotalProjectsWithParentCategory = COUNT(*) FROM #parentProjects
SELECT @ExistingParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='Existing'
SELECT @TotalNewParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='New'

INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Total Imported Project Funding',  @TotalProjectFunding)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Total Project AwardCodes',  @TotalAwardCodes)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'New AwardCodes',  @TotalNewParentProjects)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Existing AwardCodes',  @ExistingParentProjects)
INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'New AwardCodes with Parent Category',  @TotalProjectsWithParentCategory)

-------------------------------------------------------------------
-- Check unique Project Funding AltAwardCode 
-------------------------------------------------------------------
--SELECT Altid INTO #dupAltId FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1

--IF EXISTS (SELECT * FROM #dupAltId)
--	INSERT INTO @DataUploadReport SELECT 1, 'Rule', 'Check Duplicate AltAwardCodes', COUNT(*) FROM #dupAltId
--ELSE
--	INSERT INTO @DataUploadReport SELECT 1, 'Rule', 'Check Duplicate AltAwardCodes', 0

------------------------------------------------------------------
-- Check if AltAwardCodes already exist in ICRP
-------------------------------------------------------------------
--SELECT u.AwardCode, u.AltID INTO #AltId FROM UploadWorkbook u
--JOIN (SELECT f.ALtAwardCode, o.Abbreviation AS FundingOrgAbbr FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) e ON u.AltID = e.ALtAwardCode AND u.FundingOrgAbbr = e.FundingOrgAbbr

--IF EXISTS (select * from #AltId)
--BEGIN
--	PRINT 'ERROR ==> AltAwardCode already exist in ICRP'
--	SELECT 'AltAwardCode Already Exists in ICRP' AS Issue, AwardCode, AltID AS AltAwardCode FROM #AltId
--END 
--ELSE
--	PRINT 'Checking AltAwardCode NOT exist in ICRP ==> Pass'
	
------------------------------------------------------------------
-- Check if AltAwardCodes not unique (check both workbook and existing ProjectFunding)
-------------------------------------------------------------------
SELECT * INTO #dupAltId FROM (
	SELECT Altid AS AltAwardCode FROM UploadWorkBook 
	UNION
	SELECT AltAwardCode FROM ProjectFunding
	) a GROUP BY AltAwardCode HAVING COUNT(*) > 1


IF EXISTS (SELECT * FROM #dupAltId)
	INSERT INTO @DataUploadReport SELECT 1, 'Rule', 'Check Duplicate AltAwardCodes', COUNT(*) FROM #dupAltId
ELSE
	INSERT INTO @DataUploadReport SELECT 1, 'Rule', 'Check Duplicate AltAwardCodes', 0


-------------------------------------------------------------------
-- Check New AWardCodes without Parent Category 
-------------------------------------------------------------------
SELECT n.AwardCode INTO #newNoParent FROM 
(SELECT * FROM #awardcodes where Type='New') n
LEFT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
WHERE p.AwardCode IS NULL

IF EXISTS (SELECT * FROM #newNoParent)
	INSERT INTO @DataUploadReport SELECT 2, 'Rule', 'Check New AwardCodes with Missing Parent Category', COUNT(*) FROM #newNoParent
ELSE
	INSERT INTO @DataUploadReport SELECT 2, 'Rule', 'Check New AwardCodes with Missing Parent Category', 0

-------------------------------------------------------------------
-- Check Old AwardCode with Parent Category 
-------------------------------------------------------------------
SELECT 'Issue AwardCode Should NOT be Parent' AS Issue, p.* INTO #oldWithParent FROM 
(SELECT * FROM #awardcodes where Type='Existing') n
JOIN #parentProjects p ON n.AwardCode = p.AwardCode

IF EXISTS (SELECT * FROM #oldWithParent)
	INSERT INTO @DataUploadReport SELECT 3, 'Rule', 'Check Old AwardCode with Parent Category', COUNT(*) FROM #oldWithParent
ELSE
	INSERT INTO @DataUploadReport SELECT 3, 'Rule', 'Check Old AwardCode with Parent Category', 0

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
SELECT AwardCode, AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, AwardStartDate, AwardEndDate) AS AwardDuration, 
		DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS BudgetDuration INTO #budgetDates FROM UploadWorkBook 		

IF EXISTS (SELECT * FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0)
	INSERT INTO @DataUploadReport SELECT 4, 'Rule', 'Check Incorrect Award or Budget Duration', COUNT(*) FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0
ELSE
	INSERT INTO @DataUploadReport SELECT 4, 'Rule', 'Check Incorrect Award or Budget Duration', 0
	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
SELECT AwardCode, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook WHERE ISNULL(AwardFunding,0) < 0

IF EXISTS (SELECT * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0)
  INSERT INTO @DataUploadReport SELECT 5, 'Rule', 'Check Incorrect Funding Amounts', COUNT(*) FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0
ELSE
	INSERT INTO @DataUploadReport SELECT 5, 'Rule', 'Check Incorrect Funding Amounts', 0

-------------------------------------------------------------------
-- Check CSO Codes
-------------------------------------------------------------------
SELECT csocodes, csorel INTO #cso from UploadWorkBook where ISNULL(csocodes,'')='' or ISNULL(csorel,'')=''

IF EXISTS (select * from #cso)
	INSERT INTO @DataUploadReport SELECT 6, 'Rule', 'Check Incorrect CSO Codes/Relevance', COUNT(*) FROM #cso
ELSE
	INSERT INTO @DataUploadReport SELECT 6, 'Rule', 'Check Incorrect CSO Codes/Relevance', 0
		
-------------------------------------------------------------------
-- Check Historical CSO Codes
-------------------------------------------------------------------
SELECT CSOCodes INTO #oldCSO from UploadWorkBook where sitecodes like '%7.1%' OR sitecodes like '%7.2%' OR sitecodes like '%7.3%' OR sitecodes like '%1.6%' OR sitecodes like '%6.8%'

IF EXISTS (select * FROM #oldCSO)
	INSERT INTO @DataUploadReport SELECT 7, 'Rule', 'Check Historical CSO Codes', COUNT(*) FROM #oldCSO
ELSE
	INSERT INTO @DataUploadReport SELECT 7, 'Rule', 'Check Historical CSO Codes', 0

-------------------------------------------------------------------
-- Check CancerType Codes
-------------------------------------------------------------------
SELECT sitecodes, siterel INTO #site from UploadWorkBook where ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''

IF EXISTS (select * FROM #site)
	INSERT INTO @DataUploadReport SELECT 8, 'Rule', 'Check CancerType Codes/Relevance', COUNT(*) FROM #site
ELSE
	INSERT INTO @DataUploadReport SELECT 8, 'Rule', 'Check CancerType Codes/Relevance', 0
	
-------------------------------------------------------------------
-- Check AwardType Codes - TBD
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
-- Check Annulized Value
-------------------------------------------------------------------
SELECT IsAnnualized INTO #annu from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('Y','N')

IF EXISTS (select * FROM #annu)
	INSERT INTO @DataUploadReport SELECT 9, 'Rule', 'Check Annulized Value', COUNT(*) FROM #annu
ELSE
	INSERT INTO @DataUploadReport SELECT 9, 'Rule', 'Check Annulized Value', 0

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
SELECT DISTINCT FundingOrgAbbr INTO #org from UploadWorkBook 
where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)

IF EXISTS (SELECT * FROM #org)
	INSERT INTO @DataUploadReport SELECT 10, 'Rule', 'Check FundingOrg Existance', COUNT(*) FROM #org
ELSE
	INSERT INTO @DataUploadReport SELECT 10, 'Rule', 'Check FundingOrg Existance', 0

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
IF EXISTS (SELECT * FROM #orgDiv)
	INSERT INTO @DataUploadReport SELECT 11, 'Rule', 'Check FundingOrgDiv Existance', COUNT(*) FROM #org
ELSE
	INSERT INTO @DataUploadReport SELECT 11, 'Rule', 'Check FundingOrgDiv Existance', 0

	
-------------------------------------------------------------------
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
SELECT DISTINCT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
	LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
	LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)

IF EXISTS (select * FROM #missingInst)
	INSERT INTO @DataUploadReport SELECT 12, 'Rule', 'Check not-mapped Institution', COUNT(*) FROM #missingInst
ELSE
	INSERT INTO @DataUploadReport SELECT 12, 'Rule', 'Check not-mapped Institution', 0

-------------------------------------------------------------------
-- Return Data IntegrityCheck Report
-------------------------------------------------------------------
SELECT * FROM @DataUploadReport

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[DataUpload_GetDateCheckDetails]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_GetDateCheckDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_GetDateCheckDetails]
GO 

CREATE PROCEDURE [dbo].[DataUpload_GetDateCheckDetails] 
@RuleId INT
  
AS

/***********************************************************************************************/
-- Data Integrigy Check Rules - New Upload
--
-- 1	Rule	Check Duplicate AltAwardCodes
-- 2	Rule	Check New AwardCodes with Missing Parent Category
-- 3	Rule	Check Old AwardCode with Parent Category
-- 4	Rule	Check Incorrect Award or Budget Duration
---5	Rule	Check Incorrect Funding Amounts
-- 6	Rule	Check Incorrect CSO Codes/Relevance
-- 7	Rule	Check Historical CSO Codes
-- 8	Rule	Check CancerType Codes/Relevance
-- 9	Rule	Check Annulized Value
-- 10	Rule	Check FundingOrg Existance
-- 11	Rule	Check FundingOrgDiv Existance
-- 12	Rule	Check not-mapped Institution
--
/***********************************************************************************************/

SELECT Distinct AwardCode INTO #a FROM UploadWorkBook

--Checking Parent projects ...
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA

SELECT * INTO #awardCodes FROM (
	SELECT 'Existing' AS Type, a.AwardCode FROM #a a JOIN Project p ON a.AwardCode = p.AwardCode
	UNION
	SELECT 'New' AS Type, a.AwardCode FROM #a a LEFT JOIN Project p ON a.AwardCode = p.AwardCode WHERE p.AwardCode IS NULL
) a

------------------------------------------------------------------
-- Check if AltAwardCodes not unique (check both workbook and existing ProjectFunding)
-------------------------------------------------------------------
IF @RuleId = 1
BEGIN
	SELECT * INTO #dupAltId FROM (
		SELECT Altid AS AltAwardCode FROM UploadWorkBook 
		UNION
		SELECT AltAwardCode FROM ProjectFunding
		) a 
	GROUP BY AltAwardCode HAVING COUNT(*) > 1

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #dupAltId d JOIN UploadWorkbook u ON d.AltAwardCode = u.AltID

END

-------------------------------------------------------------------
-- Check New AwardCodes without Parent Category 
-------------------------------------------------------------------
IF @RuleId = 2
BEGIN
	SELECT n.AwardCode INTO #newNoParent FROM 
	(SELECT * FROM #awardcodes where Type='New') n
	LEFT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
	WHERE p.AwardCode IS NULL

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #newNoParent d JOIN UploadWorkbook u ON d.AwardCode = u.AwardCode
END

-------------------------------------------------------------------
-- Check Old AwardCode with Parent Category 
-------------------------------------------------------------------
IF @RuleId = 3
BEGIN
	SELECT p.* INTO #oldWithParent FROM 
		(SELECT * FROM #awardcodes where Type='Existing') n
		JOIN #parentProjects p ON n.AwardCode = p.AwardCode

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #oldWithParent d JOIN UploadWorkbook u ON d.AwardCode = u.AwardCode
END

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
IF @RuleId = 4
BEGIN
	SELECT AwardCode, AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, AwardStartDate, AwardEndDate) AS AwardDuration, 
		DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS BudgetDuration INTO #budgetDates FROM UploadWorkBook 		

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #budgetDates c JOIN UploadWorkbook u ON c.AwardCode = u.AwardCode WHERE c.AwardDuration < 0 OR c.BudgetDuration < 0

END
	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
IF @RuleId = 5
BEGIN
	SELECT AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook WHERE ISNULL(AwardFunding,0) < 0

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #fundingAmount c JOIN UploadWorkbook u ON c.AltID = u.AltID 

END

-------------------------------------------------------------------
-- Check CSO Codes
-------------------------------------------------------------------
IF @RuleId = 6
BEGIN
	SELECT AltID, csocodes, csorel INTO #cso from UploadWorkBook where ISNULL(csocodes,'')='' or ISNULL(csorel,'')=''
	
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #cso c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 
		
-------------------------------------------------------------------
-- Check Historical CSO Codes
-------------------------------------------------------------------
IF @RuleId = 7
BEGIN
	SELECT AltID, CSOCodes INTO #oldCSO from UploadWorkBook where sitecodes like '%7.1%' OR sitecodes like '%7.2%' OR sitecodes like '%7.3%' OR sitecodes like '%1.6%' OR sitecodes like '%6.8%'

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #oldCSO c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 

-------------------------------------------------------------------
-- Check CancerType Codes
-------------------------------------------------------------------
IF @RuleId = 8
BEGIN
	SELECT AltID, sitecodes, siterel INTO #site from UploadWorkBook where ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #site c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 

-------------------------------------------------------------------
-- Check AwardType Codes - TBD
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
-- Check Annulized Value
-------------------------------------------------------------------
IF @RuleId = 9
BEGIN
	SELECT AltID, IsAnnualized INTO #annu from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('Y','N')

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.IsAnnualized, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #annu c JOIN UploadWorkbook u ON c.AltID = u.AltID
END 

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
IF @RuleId = 10
BEGIN
	SELECT DISTINCT FundingOrgAbbr INTO #org from UploadWorkBook 
	where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)
	
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.FundingOrgAbbr, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #org c JOIN UploadWorkbook u ON c.FundingOrgAbbr = u.FundingOrgAbbr
END 

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
IF @RuleId = 11
BEGIN

	SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.FundingDivAbbr, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #orgDiv c JOIN UploadWorkbook u ON c.FundingDivAbbr = u.FundingDivAbbr
END 
	
-------------------------------------------------------------------
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
IF @RuleId = 12
BEGIN

	SELECT DISTINCT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
		LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
		LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
	WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)
	
	SELECT DISTINCT u.InstitutionICRP, u.City
	FROM #missingInst c JOIN UploadWorkbook u ON c.InstitutionICRP = u.InstitutionICRP AND c.City = u.City
END 
	
GO

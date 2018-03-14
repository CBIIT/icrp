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
	@PageSize int = 50, -- return all by default
	@PageNumber int = 1, -- return all results by default; otherwise pass in the page number
	@SortCol varchar(50) = 'title', -- Ex: 'title', 'pi', 'code', 'inst', 'FO', city, state, country ....
	@SortDirection varchar(4) = 'ASC',  -- 'ASC' or 'DESC'
    @termSearchType varchar(25) = NULL,  -- No full text search by default; otherwise 'Any', 'None', 'All', 'Exact'
	@terms varchar(4000) = NULL,  -- No full text search by default;
	@InvestigatorType varchar(250) = NULL, -- No full text search by default; otherwise 'All', 'PI', 'Collab'
	@institution varchar(250) = NULL,
	@piLastName varchar(50) = NULL,
	@piFirstName varchar(50) = NULL,
	@piORCiD varchar(50) = NULL,
	@awardCode varchar(50) = NULL,
	@yearList varchar(1000) = NULL, 
	@cityList varchar(1000) = NULL, 
	@stateList varchar(1000) = NULL,
	@countryList varchar(1000) = NULL,
	@regionList varchar(100) = NULL,
	@FundingOrgTypeList varchar(50) = NULL,
	@fundingOrgList varchar(1000) = NULL, 
	@cancerTypeList varchar(1000) = NULL, 
	@projectTypeList varchar(1000) = NULL,
	@CSOList varchar(1000) = NULL,	
	@IsChildhood bit = NULL,	
	@searchCriteriaID INT OUTPUT,  -- return the searchID	
	@ResultCount INT OUTPUT  -- return the searchID	
	
AS   
	DECLARE @IsFiltered bit = 0
	
	IF @InvestigatorType = 'All'
		SELECT @InvestigatorType = NULL

	----------------------------------
	-- Get all Projects 
	----------------------------------
	SELECT * INTO #projFunding  FROM vwProjectFundings   -- All project funding records including PI and collaborator
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding institutions and PI do NOT meet the criteria
	-------------------------------------------------------------------------
	IF (@InvestigatorType IS NOT NULL)
	BEGIN	
		SET @IsFiltered = 1	

		DELETE FROM #projFunding WHERE (@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND IsPrincipalInvestigator = 0) OR (@InvestigatorType = 'Collab' AND IsPrincipalInvestigator = 1)   -- Search only PI, Collaborators or all			   
		
	END
	
	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@awardCode IS NOT NULL) OR (@IsChildhood IS NOT NULL)
	BEGIN	
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 
			(SELECT ProjectFundingID FROM #projFunding WHERE 
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
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 
			(SELECT ProjectFundingID FROM #projFunding WHERE city IN (SELECT * FROM dbo.ToStrTable(@cityList)))		
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI State do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @stateList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE [State] IN (SELECT * FROM dbo.ToStrTable(@stateList)))				
	END	

	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI Country do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @countryList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE [Country] IN (SELECT * FROM dbo.ToStrTable(@countryList)))				
	END
	
	-------------------------------------------------------------------------
	-- Exclude the projects which funding PI Region do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @regionList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE RegionID NOT IN 			
			(SELECT RegionID FROM #projFunding WHERE [RegionID] IN (SELECT * FROM dbo.ToIntTable(@regionList)))				
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org type do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE FundingOrgType IN (SELECT * FROM dbo.ToStrTable(@FundingOrgTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Org do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @fundingOrgList IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT ProjectFundingID FROM #projFunding WHERE FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@fundingOrgList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @cancerTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

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

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT p.ProjectFundingID FROM #projFunding p
			JOIN ProjectCancerType ct ON p.ProjectFundingID = ct.ProjectFundingID WHERE CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))

	END

	-------------------------------------------------------------------------
	-- Exclude the projects which ProjectType do NOT meet the criteria
	-------------------------------------------------------------------------
	IF @projectTypeList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
			JOIN Project_ProjectType pt WITH (NOLOCK) ON p.ProjectID = pt.ProjectID WHERE ProjectType IN (SELECT * FROM dbo.ToStrTable(@projectTypeList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding CSO do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @CSOList  IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT p.ProjectFundingID FROM #projFunding p
				JOIN ProjectCSO cso WITH (NOLOCK) ON p.ProjectFundingID = cso.ProjectFundingID WHERE CSOCode IN (SELECT * FROM dbo.ToStrTable(@CSOList)))
	END

	-------------------------------------------------------------------------
	-- Exclude the projects which funding Years do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF @yearList IS NOT NULL
	BEGIN
		SET @IsFiltered = 1	

		DELETE FROM #projFunding 
		WHERE ProjectFundingID NOT IN 			
			(SELECT DISTINCT f.ProjectFundingID FROM #projFunding f
				--JOIN ProjectFunding f ON p.projectID = f.ProjectID
				JOIN ProjectFundingExt ext WITH (NOLOCK) ON f.ProjectFundingID = ext.ProjectFundingID WHERE [CalendarYear] IN (SELECT * FROM dbo.ToIntTable(@yearList)))
	END	
	
	-------------------------------------------------------------------------
	-- Terms Search Filter
	-- Exclude the projects which funding CancerType do NOT meet the criteria
	-------------------------------------------------------------------------	
	IF (@termSearchType IS NOT NULL) AND (@terms IS NOT NULL)
	BEGIN
		SET @IsFiltered = 1	

		DECLARE @searchWords VARCHAR(1000)

		SELECT @searchWords = 
		CASE @termSearchType
			WHEN 'Exact' THEN '"'+ @terms + '"'
			WHEN 'Any' THEN REPLACE(@terms,' ',' OR ')
			ELSE REPLACE(@terms,' ',' AND ') -- All or None	
		END 		

		IF (@termSearchType = 'None')  ---- do not contain any words specified		
		BEGIN
			DELETE FROM #projFunding WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
				JOIN ProjectSearch s ON p.projectID = s.ProjectID  			
			 WHERE NOT CONTAINS(s.content, @searchWords)
			)
		END

		ELSE 
		 ---- Contain Any, All or Exeact words
		BEGIN
			DELETE FROM #projFunding WHERE ProjectID NOT IN 			
			(SELECT p.ProjectID FROM #projFunding p
				LEFT JOIN ProjectSearch s ON p.projectID = s.ProjectID  
			WHERE CONTAINS(s.content, @searchWords)
			)
		END		
				
	END	

	----------------------------------
	-- Retrieve Result counts
	----------------------------------	
	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	SELECT DISTINCT ProjectID, AwardCode INTO #baseProj FROM #projFunding	
	
	SELECT @ResultCount=COUNT(*) FROM #baseProj	
	SELECT @TotalRelatedProjectCount=COUNT(*) FROM (SELECT DISTINCT ProjectFundingID FROM #projFunding) u	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #projFunding	

	----------------------------------
	-- Save search criteria
	----------------------------------	
	SET @searchCriteriaID = 0  -- no filters
	

	IF @IsFiltered = 1   -- Only record search criteria if filtered
	BEGIN		
		DECLARE @ProjectIDList VARCHAR(max) = '' 	

		SELECT @ProjectIDList = @ProjectIDList + 
			   ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
		FROM #baseProj	

		INSERT INTO SearchCriteria ([termSearchType],[terms],[institution],[piLastName],[piFirstName],[piORCiD],[awardCode],
			[yearList], [cityList],[stateList],[countryList],[regionList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [IsChildhood], [InvestigatorType])
			VALUES ( @termSearchType,@terms,@institution,@piLastName,@piFirstName,@piORCiD,@awardCode,@yearList,@cityList,@stateList,@countryList,@regionList,
				@fundingOrgList,@cancerTypeList,@projectTypeList,@CSOList, @FundingOrgTypeList,	@IsChildhood, @InvestigatorType)
									 
		SELECT @searchCriteriaID = SCOPE_IDENTITY()		

		INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
		
	END
	ELSE
	BEGIN
		UPDATE SearchResult SET Results = NULL,ResultCount=@ResultCount, TotalRelatedProjectCount=@TotalRelatedProjectCount, LastBudgetYear=@LastBudgetYear, IsEmailSent=0 WHERE SearchCriteriaID =0
	END
	
	
	--------------------------------------------------------------------
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------vvvv
	SELECT base.ProjectID, base.AwardCode, f.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName,
	 pi.ORC_ID AS piORCiD, i.Name AS institution, f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort
	FROM #baseProj base
		JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding GROUP BY ProjectID) maxf ON base.ProjectID = maxf.ProjectID
		JOIN ProjectFunding f ON maxf.ProjectFundingID = f.ProjectFundingID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
		JOIN (SELECT * FROM ProjectFundingInvestigator  WHERE IsPrincipalInvestigator = 1) pi ON pi.ProjectFundingID = maxf.ProjectFundingID
		JOIN Institution i ON pi.InstitutionID = i.InstitutionID
	ORDER BY 
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC ' THEN f.Title  END ASC, --title ASC
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN base.AwardCode  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.LastName  END ASC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN pi.FirstName  END ASC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN i.Name  END ASC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'ASC' THEN i.City  END ASC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'ASC' THEN i.State  END ASC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'ASC' THEN i.Country  END ASC,		
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN o.Abbreviation  END ASC,
		CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN f.Title  END DESC,
		CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN base.AwardCode  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.LastName  END DESC,
		CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN pi.FirstName  END DESC,
		CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN i.Name END DESC,
		CASE WHEN @SortCol = 'city ' AND @SortDirection = 'DESC' THEN i.City  END DESC,
		CASE WHEN @SortCol = 'state ' AND @SortDirection = 'DESC' THEN i.State  END DESC,
		CASE WHEN @SortCol = 'country' AND @SortDirection = 'DESC' THEN i.Country  END DESC,		
		CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN o.Abbreviation END DESC
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

	DECLARE @ProjectIDs VARCHAR(max) 
	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT DISTINCT ProjectID From Project
		SELECT @ResultCount = COUNT(*) FROM @Result
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
	END

	SELECT ProjectID INTO #base FROM @Result

	--------------------------------------------------------------------
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------
	SELECT r.ProjectID, p.AwardCode, maxf.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID
		JOIN (SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID FROM ProjectFunding f GROUP BY ProjectID) maxf ON r.ProjectID = maxf.ProjectID
		JOIN ProjectFunding f ON maxf.ProjectFundingID = f.projectFundingID
		JOIN  (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID
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

	--------------------------------------------------------------------	
	-- Sort and Pagination
	--   Note: Return only base projects and projects' most recent funding
	--------------------------------------------------------------------
	SELECT r.ProjectID, p.AwardCode, r.projectfundingID AS LastProjectFundingID, f.Title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCiD, i.Name AS institution, 
		f.Amount, i.City, i.State, i.country, o.FundingOrgID, o.Name AS FundingOrg, o.Abbreviation AS FundingOrgShort 
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID		 
		 JOIN ProjectFunding f ON r.ProjectFundingID = f.projectFundingID
		 JOIN  (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID
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
	IF @SearchID = 0
	BEGIN
	   SELECT ResultCount AS TotalProjectCount, TotalRelatedProjectCount, LastBudgetYear FROM SearchResult  WHERE SearchCriteriaID = @SearchID  -- TBD
	END
	ELSE
	BEGIN
		SELECT ResultCount AS TotalProjectCount, TotalRelatedProjectCount, LastBudgetYear FROM SearchResult  WHERE SearchCriteriaID = @SearchID
	END

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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0  -- all projects
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE  -- with filters by searchID
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END
		
	SELECT ProjectID INTO #proj FROM @Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectID, f.ProjectFundingID, f.Amount, pii.Country, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))

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

		SELECT country, 0 AS [Count], (SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS USDAmount INTO #AmountStats 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY country 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	

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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
		
			SELECT @YearList = YearList,
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID	

	END	
	
	SELECT ProjectID INTO #proj FROM @Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, c.categoryName, pc.Relevance, f.Amount, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCSO WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CSO c ON c.code = pc.csocode	
	 WHERE	(@CSOlist IS NULL) OR (c.Code IN (SELECT VALUE AS CSOCode FROM dbo.ToStrTable(@CSOlist))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))

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
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
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

		SELECT categoryName, SUM(Relevance)/100 AS Relevance, (SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS USDAmount INTO #AmountStats 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY categoryName 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project
	
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
		
			SELECT @YearList = YearList,
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	SELECT ProjectID INTO #proj FROM @Result

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
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN (SELECT * FROM ProjectCancerType WHERE isnull(Relevance,0) <> 0) pc ON f.projectFundingID = pc.projectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID	
	 WHERE	(@CancerTypelist IS NULL) OR (ct.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist)) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))

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
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
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

		SELECT CancerType, SUM(Relevance)/100 AS Relevance, (SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS USDAmount INTO #AmountStats 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY CancerType 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

	DECLARE @ProjectIDs VARCHAR(max) 
	DECLARE @ProjectTypeList VARCHAR(1000) = NULL
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
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ResultCount=ResultCount, @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
		
		SELECT @ProjectTypeList = ProjectTypeList,
				@YearList = YearList,
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
		
	END	
	
	SELECT ProjectID INTO #proj FROM @Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, pt.ProjectType, f.Amount, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN Project_ProjectType pt ON r.ProjectID = pt.ProjectID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE (@ProjectTypeList IS NULL) OR (pt.ProjectType IN (SELECT VALUE AS ProjectTypeID FROM dbo.ToStrTable(@ProjectTypeList))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))
	 
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
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
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

		SELECT ProjectType, 0 AS [Count], (SUM(f.Amount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS USDAmount INTO #AmountStats 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY ProjectType 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
	END	
	
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
	@Type varchar(25) = 'Count',  -- 'Count' or 'Amount'	
	@ResultCount INT OUTPUT,  -- return the total project count		
	@ResultAmount float OUTPUT  -- return the total project funding amount	
AS   

	------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project			
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END
	
	SELECT ProjectID INTO #proj FROM @Result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT f.ProjectID, f.ProjectFundingID, ext.CalendarYear, ext.CalendarAmount, o.Currency INTO #pf 
	FROM #proj r		
		JOIN ProjectFunding f ON r.ProjectID = f.ProjectID	
		JOIN ProjectFundingExt ext ON ext.ProjectFundingID = f.ProjectFundingID
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
	WHERE (@YearList IS NULL) OR (ext.CalendarYear IN (SELECT VALUE AS [CalendarYear] FROM dbo.ToStrTable(@YearList))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))
	 
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
	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@CountryList IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.projectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID	
				JOIN Country c ON i.Country = c.Abbreviation							
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))

	------------------------------------------------------------------------------
	--   Get ProjectType/AwardType Stats
	------------------------------------------------------------------------------
	IF @Type = 'Count'
	BEGIN	
		
		SELECT CalendarYear AS Year, COUNT(*) AS [Count], 0  AS USDAmount INTO #CountStats FROM #pf GROUP BY CalendarYear 
		SELECT @ResultCount = SUM(Count) FROM #CountStats
		SELECT * FROM #CountStats ORDER BY [Count] Desc
			
	END
	
	ELSE --  'Amount'
	
	BEGIN 

		SELECT CalendarYear AS Year, 0 AS [Count], (SUM(f.CalendarAmount) * ISNULL(MAX(cr.ToCurrencyRate), 1)) AS USDAmount INTO #AmountStats 
		FROM #pf f
			LEFT JOIN (SELECT * FROM CurrencyRate WHERE ToCurrency = 'USD' AND Year=@Year) cr ON cr.FromCurrency = f.Currency			
		GROUP BY CalendarYear 

		SELECT @ResultAmount = SUM([USDAmount]) FROM #AmountStats	
		SELECT * FROM #AmountStats ORDER BY USDAmount Desc		
			
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

SELECT pf.ProjectFundingID, pf.title, pi.LastName AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID, ISNULL(co.Count,0) AS CollabCount,
		i.Name AS Institution, i.City, i.State, i.Country, r.Name AS Region, pf.Category,
		pf.ALtAwardCode AS AltAwardCode, o.Abbreviation AS FundingOrganization,	pf.BudgetStartDate, pf.BudgetEndDate
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID
	JOIN (SELECT ProjectFundingID, InstitutionID, LastName, FirstName, ORC_ID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON pf.ProjectFundingID = pi.ProjectFundingID  -- PI	
	JOIN Institution i ON i.InstitutionID = pi.InstitutionID	
	JOIN Country c ON i.Country = c.Abbreviation
	JOIN lu_Region r ON r.RegionID = c.RegionID
	JOIN FundingOrg o ON o.FundingOrgID = pf.FundingOrgID
	LEFT JOIN (SELECT ProjectFundingID, COUNT(*) AS [Count] FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 0 GROUP BY ProjectFundingID) co ON pf.ProjectFundingID = co.ProjectFundingID  -- Collaborators
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
	f.FundingContact, 
	CASE 
		WHEN pi.LastName IS NULL AND pi.FirstName IS NULL THEN ''
		ELSE CONCAT(ISNULL(pi.LastName, ''), ', ', ISNULL(pi.FirstName, ''))
	END AS piName, 
	pi.ORC_ID, pi.IsPrincipalInvestigator, i.Name AS Institution, i.City, i.State, i.Country, i.Latitude, i.Longitude, r.Name AS Region, a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract
FROM ProjectFunding f	
	JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
	JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = f.ProjectFundingID
	JOIN Institution i ON i.InstitutionID = pi.InstitutionID
	JOIN Country c ON i.Country = c.Abbreviation
	JOIN lu_Region r ON r.RegionID = c.RegionID
	JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE f.ProjectFundingID = @ProjectFundingID
ORDER BY pi.IsPrincipalInvestigator DESC, pi.LastName,  pi.FirstName

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

DECLARE @SearchCriteria TABLE
(
	[Name] varchar(50),
	[Value] varchar(250)
)

IF @SearchID = 0
BEGIN
	SELECT * FROM @SearchCriteria
END
ELSE
BEGIN
	DECLARE @filterList varchar(2000)

	SELECT * INTO #criteria FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	IF EXISTS (SELECT * FROM #criteria WHERE TermSearchType IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Term Search Type:', TermSearchType FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE Terms IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Terms:', Terms FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE ProjectTypeList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Project Type(s):', ProjectTypeList FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE AwardCode IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Award Code:', AwardCode FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE Institution IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Institution:', Institution FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE piLastName IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'PI Last Name:', piLastName FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE piFirstName IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'PI First Name:', piFirstName FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE piORCiD IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'PI ORCiD', piORCiD FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE YearList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Year(s):', YearList FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE CityList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'City:', CityList FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE StateList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'State:', StateList FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE CountryList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Country(ies):', CountryList FROM #criteria

	SELECT @filterList= RegionList FROM #criteria
	IF @filterList IS NOT NULL
	BEGIN
		INSERT INTO @SearchCriteria VALUES ('Region(s):', '')
		INSERT INTO @SearchCriteria SELECT '', Name FROM lu_Region WHERE RegionID IN (SELECT * FROM dbo.ToIntTable(@filterList))
	END

	IF EXISTS (SELECT * FROM #criteria WHERE FundingOrgTypeList IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Funding Org Type(s):', FundingOrgTypeList FROM #criteria	


	SELECT @filterList= FundingOrgList FROM #criteria
	IF @filterList IS NOT NULL
	BEGIN
		INSERT INTO @SearchCriteria VALUES ('Funding Organization(s):', '')
		INSERT INTO @SearchCriteria SELECT '', SponsorCode + ' - ' + Name FROM FundingOrg WHERE FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@filterList))
	END

	IF EXISTS (SELECT * FROM #criteria WHERE IsChildhood IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Childhood Cancer:', CASE IsChildhood WHEN 1 THEN 'Yes' ELSE 'No' END FROM #criteria

	IF EXISTS (SELECT * FROM #criteria WHERE [InvestigatorType] IS NOT NULL)
		INSERT INTO @SearchCriteria SELECT 'Investigator Search Type:', [InvestigatorType] FROM #criteria

	SELECT @filterList= CancerTypeList FROM #criteria
	IF @filterList IS NOT NULL
	BEGIN
		INSERT INTO @SearchCriteria VALUES ('Cancer Type(s):', '')
		INSERT INTO @SearchCriteria SELECT '', Name FROM CancerType WHERE CancerTypeID IN (SELECT * FROM dbo.ToIntTable(@filterList))
	END

	SELECT @filterList= CSOList FROM #criteria
	IF @filterList IS NOT NULL
	BEGIN
		INSERT INTO @SearchCriteria VALUES ('CSO(s):', '')
		INSERT INTO @SearchCriteria SELECT '', Name FROM CSO WHERE Code IN (SELECT * FROM dbo.ToStrTable(@filterList))
	END

		select * from @SearchCriteria
END

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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
		
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END
		
	SELECT ProjectID INTO #base FROM @Result

	-----------------------------------------------------------		
	--  Get all related projects with dolloar amounts
	-----------------------------------------------------------			 
	SELECT DISTINCT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, CAST(NULL AS VARCHAR(100)) AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
		CASE p.IsChildhood 
		   WHEN 1 THEN 'Yes' 
		   WHEN 0 THEN 'No' ELSE '' 
		END AS IsChildhood,  
		p.ProjectStartDate AS AwardStartDate, p.ProjectEndDate AS AwardEndDate, f.BudgetStartDate,  f.BudgetEndDate, f.Amount AS AwardAmount, 
		CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator, o.Currency,
		f.MechanismTitle AS FundingMechanism, f.MechanismCode AS FundingMechanismCode, o.SponsorCode, o.Name AS FundingOrg, o.Type AS FundingOrgType, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, f.FundingContact, 
		pi.LastName  AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCID, i.Name AS Institution, i.City, i.State, i.Country, l.Name AS Region,  -- only PI name and institution
		@Siteurl+CAST(p.Projectid AS varchar(10)) AS icrpURL, a.TechAbstract
	INTO #pf
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID		
		JOIN ProjectFunding f ON p.ProjectID = f.PROJECTID
		JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID		
		--JOIN (SELECT ProjectFundingID, Count(*) AS COUNT FROM ProjectFundingInvestigator GROUP BY ProjectFundingID) people ON people.ProjectFundingID = f.ProjectFundingID		
		JOIN ProjectFundingInvestigator people ON people.ProjectFundingID = f.ProjectFundingID		
		JOIN (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON pi.ProjectFundingID = f.ProjectFundingID	
		JOIN Institution i ON i.InstitutionID = pi.InstitutionID
		JOIN Country c ON c.Abbreviation = i.Country
		JOIN lu_Region l ON c.RegionID = l.RegionID
		JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID
		LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID	
		
	WHERE	((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList)))) AND
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND people.IsPrincipalInvestigator = 0)) AND   -- Search only PI, Collaborators or all
			((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@CountryList IS NULL) OR (i.Country IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@CountryList)))) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))

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
	
	---------------------------------------------------------------------------------------------------------
	-- Special handling for AwardType	 - convert multiple AwardType to a comma delimited string
	---------------------------------------------------------------------------------------------------------
	UPDATE #pf SET AwardType = AWardTypes
	FROM #pf t
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
		JOIN #pf t ON  e.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CalendarYear	 

	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = N'SELECT * FROM (SELECT t.ProjectID AS ICRPProjectID, t.ProjectFundingID AS ICRPProjectFundingID, t.AwardTitle, t.AwardType, 
		t.AwardCode, t.Source_ID, t.AltAwardCode, t.FundingCategory,
		t.IsChildhood, t.AwardStartDate, t.AwardEndDate, t.BudgetStartDate,  t.BudgetEndDate, t.AwardAmount, t.FundingIndicator, t.Currency, 
		t.FundingMechanism, t.FundingMechanismCode, t.SponsorCode, t.FundingOrg, t.FundingOrgType, t.FundingDiv, t.FundingDivAbbr, t.FundingContact, 
		t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.Region, t.icrpURL'

	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ', t.TechAbstract'

	IF @PivotColumns IS NOT NULL  
	BEGIN
		SET @SQLQuery = @SQLQuery + ', calendaryear, calendaramount FROM projectfundingext ext
				JOIN #pf t ON ext.ProjectFundingID = t.ProjectFundingID    
				) cal			
		PIVOT( SUM(calendaramount) 
				FOR calendaryear IN (' + @PivotColumns + ')) AS P'		
	END

	ELSE
	
	BEGIN
		SET @SQLQuery = @SQLQuery + ' FROM #pf t) AS P'		
	END

	----Execute dynamic query		
	EXEC sp_executesql @SQLQuery
    											  
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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT DISTINCT ProjectID From vwProjectFundings		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

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
			@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END		

	SELECT ProjectID INTO #base FROM @Result

	-----------------------------------------------------------		
	--  Get all related projects with dolloar amounts
	-----------------------------------------------------------
	SELECT DISTINCT p.ProjectID, f.ProjectFundingID, f.Title AS AwardTitle, CAST(NULL AS VARCHAR(100)) AS AwardType, p.AwardCode, f.Source_ID, f.AltAwardCode, f.Category AS FundingCategory,
		CASE p.IsChildhood 
		   WHEN 1 THEN 'Yes' 
		   WHEN 0 THEN 'No' ELSE '' 
		END AS IsChildhood, 
		p.ProjectStartDate AS AwardStartDate, p.ProjectEndDate AS AwardEndDate, f.BudgetStartDate,  f.BudgetEndDate, f.Amount AS AwardAmount, 
		CASE f.IsAnnualized WHEN 1 THEN 'A' ELSE 'L' END AS FundingIndicator, o.Currency, 
		f.MechanismTitle AS FundingMechanism, f.MechanismCode AS FundingMechanismCode, o.SponsorCode, o.Name AS FundingOrg, o.Type AS FundingOrgType, d.name AS FundingDiv, d.Abbreviation AS FundingDivAbbr, '' AS FundingContact, 
		pi.LastName  AS piLastName, pi.FirstName AS piFirstName, pi.ORC_ID AS piORCID,i.Name AS Institution, i.City, i.State, i.Country, l.Name AS Region,   -- PI only
		@Siteurl+CAST(p.Projectid AS varchar(10)) AS icrpURL, a.TechAbstract
	INTO #pf
	FROM #base r
		JOIN Project p ON r.ProjectID = p.ProjectID		
		JOIN ProjectFunding f ON p.ProjectID = f.PROJECTID
		JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON people.ProjectFundingID = f.ProjectFundingID		
		JOIN (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON pi.ProjectFundingID = f.ProjectFundingID	
		JOIN Institution i ON pi.InstitutionID = i.InstitutionID	-- get PI Instituttion	
		JOIN Country c ON c.Abbreviation = i.Country
		JOIN lu_Region l ON c.RegionID = l.RegionID		
		JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	
		LEFT JOIN FundingDivision d ON d.FundingDivisionID = f.FundingDivisionID
	WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND people.IsPrincipalInvestigator = 0)) AND   -- Search only PI, Collaborators or all
			((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))

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
	

	---------------------------------------------------------------------------------------------------		
	-- Special handling for AwardType: convert multiple AwardType to a comma delimited string
	---------------------------------------------------------------------------------------------------				
	UPDATE #pf SET AwardType = AWardTypes
	FROM #pf t
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
		JOIN #pf t ON  e.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CalendarYear	 

	-----------------------------------------------------------		
	--  Get all Project CSOs and convert them to columns
	-----------------------------------------------------------	
	SELECT @PivotColumns_CSOs= COALESCE(@PivotColumns_CSOs + ',','') + QUOTENAME(cso) FROM 
	(
		SELECT DISTINCT c.Code + ' ' + c.Name AS cso FROM [dbo].[projectCSO] pc
		JOIN CSO c ON pc.CSOCode = c.code
		JOIN #pf t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.cso

	-----------------------------------------------------------		
	--  Get all project CancerTypes and convert them to columns
	-----------------------------------------------------------	
	SELECT   @PivotColumns_CancerTypes= COALESCE(@PivotColumns_CancerTypes + ',','') + QUOTENAME(CancerType) FROM 
	(
		SELECT DISTINCT c.Name AS CancerType FROM (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pc
		JOIN CancerType c ON c.CancerTypeID = pc.CancerTypeID	
		JOIN #pf t ON  pc.projectfundingid = t.projectfundingid
	) AS p	 
	ORDER BY p.CancerType

	--Create the dynamic query with all the values for pivot column at runtime
	SET   @SQLQuery = N'SELECT * '+
		'FROM (SELECT t.ProjectID AS ICRPProjectID, t.ProjectFundingID AS ICRPProjectFundingID, t.AwardCode, t.AwardTitle, t.AwardType, t.Source_ID, t.AltAwardCode, FundingCategory, IsChildhood,
				t.AwardStartDate, t.AwardEndDate, t.BudgetStartDate, t.BudgetEndDate, t.AwardAmount, t.FundingIndicator, t.Currency, t.FundingMechanism, t.FundingMechanismCode, SponsorCode, t.FundingOrg, FundingOrgType,
				t.FundingDiv, t.FundingDivAbbr, t.FundingContact, t.piLastName, t.piFirstName, t.piORCID, t.Institution, t.City, t.State, t.Country, t.Region, t.icrpURL'
	IF @IncludeAbstract = 1
		SET @SQLQuery = @SQLQuery + ', t.TechAbstract'

	IF (@PivotColumns_Years IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', calendaryear, calendaramount'
		
	IF (@PivotColumns_CSOs IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', cso.code + '' '' + cso.Name AS cso, pcso.Relevance AS csoRel'

	IF (@PivotColumns_CancerTypes IS NOT NULL)
		SET @SQLQuery = @SQLQuery +  N', c.Name AS CancerType, pc.Relevance AS CancerTypeRel'
		
	SET @SQLQuery = @SQLQuery +  N' FROM #pf t'

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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

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
			@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END

	SELECT ProjectID INTO #base FROM @Result

	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
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

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))	

	-----------------------------------------------------------		
	--  Get project CSOs
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, cso.CSOCode, cso.Relevance AS CSORelevance	
	FROM #pf pf		
		JOIN ProjectCSO cso ON pf.ProjectFundingID = cso.ProjectFundingID
	ORDER BY pf.ProjectID
	
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
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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

	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

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
			@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END

	SELECT ProjectID INTO #base FROM @Result

	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
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

	IF (@institution IS NOT NULL) OR (@piLastName IS NOT NULL) OR (@piFirstName IS NOT NULL) OR (@piORCiD IS NOT NULL) OR (@InvestigatorType IS NOT NULL) OR (@cityList IS NOT NULL) OR (@stateList IS NOT NULL) OR (@regionList IS NOT NULL)
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT DISTINCT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.projectFundingID
				JOIN Institution i ON pi.InstitutionID = i.InstitutionID
				JOIN Country c ON i.Country = c.Abbreviation				
			WHERE	((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND
					((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND pi.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(pi.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
					((@piLastName IS NULL) OR (pi.LastName like '%'+ @piLastName +'%')) AND 
					((@piFirstName IS NULL) OR (pi.FirstName like '%'+ @piFirstName +'%')) AND
					((@piORCiD IS NULL) OR (pi.ORC_ID like '%'+ @piORCiD +'%')) AND
					((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
					((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
					((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))))	
							 
	-----------------------------------------------------------		
	--  Get project CancerTypes
	-----------------------------------------------------------			 
	SELECT pf.ProjectID, pf.ProjectFundingID AS ICRPProjectFundingID, pf.AltAwardCode, ct.ICRPCode, ct.Name AS CancerType, pct.Relevance AS Relevance
	FROM #pf pf		
		JOIN (SELECT * FROM ProjectCancerType WHERE ISNULL(RelSource, '')='S') pct ON pf.ProjectFundingID = pct.ProjectFundingID
		JOIN CancerType ct ON ct.CancerTypeID = pct.CancerTypeID
	ORDER BY pf.ProjectID
	
GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectCollaboratorsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectCollaboratorsBysearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetProjectCollaboratorsBysearchID] 
GO 

CREATE PROCEDURE [dbo].[GetProjectCollaboratorsBysearchID]   
    @SearchID INT
AS   
  ------------------------------------------------------
	-- Get saved search results by searchID
	------------------------------------------------------	
	DECLARE @Result TABLE (
		ProjectID INT NOT NULL
	)

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
	
	IF @SearchID = 0
	BEGIN
		INSERT INTO @Result SELECT ProjectID From Project		
	END
	ELSE
	BEGIN
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID		
		
		INSERT INTO @Result SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

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
			@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END
	
	SELECT ProjectID INTO #base FROM @Result

	-----------------------------------------------------------		
	--  Get all project funding records
	-----------------------------------------------------------			 
	SELECT f.ProjectID, f.ProjectFundingID, f.AltAwardCode
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
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList))))
	ORDER BY f.ProjectID, f.ProjectFundingID

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
  
SELECT TOP 1 l.LibraryID, l.Filename, l.ThumbnailFilename, Title, Description 
FROM Library l
	JOIN LibraryFolder f ON l.LibraryFolderID = f.LibraryFolderID where f.Name = 'Newsletters'
ORDER BY l.CreatedDate DESC

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
ORDER BY u.UploadToStageDate DESC


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

	SELECT FundingOrgID, fo.Name, fo.Abbreviation, fo.SponsorCode + ' - ' + fo.Name AS DisplayName, fo.Type, fo.MemberType, fo.MemberStatus, fo.Country, fo.Currency, fo.Website,
			fo.SponsorCode, p.Name AS Partner, fo.IsAnnualized, fo.Note, fo.LastImportDate, fo.LastImportDesc, fo.Latitude, fo.Longitude
	FROM FundingOrg fo
		JOIN Partner p ON fo.SponsorCode = p.SponsorCode
	WHERE (@type = 'funding' AND MemberStatus<>'Merged') OR (@type = 'Search' AND LastImportDate IS NOT NULL)
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
	SELECT PartnerOrgID AS ID, SponsorCode + ' - ' + Name + CASE MemberType WHEN 'Partner' THEN ' (Partner)' ELSE '' END AS Name , IsActive FROM PartnerOrg ORDER BY SponsorCode, Name
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

SELECT c.Abbreviation AS Code, c.Name AS Country, r.RegionID, r.Name AS Region
FROM Country c
JOIN lu_Region r ON c.RegionID = r.RegionID
ORDER BY c.Abbreviation

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

SELECT i.Name, i.City, i.State, i.Postal, i.Country, l.Name AS Region, i.Longitude, i.Latitude, i.GRID
FROM Institution i
JOIN Country c ON i.Country = c.Abbreviation
JOIN lu_Region l ON c.RegionID = l.RegionID
WHERE i.Name <> 'Missing'
ORDER BY i.Name

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
WHERE  (ISNULL(IsEmailSent, 0) = 0 OR DATEDIFF(DAY, c.SearchDate, getdate()) > 30) AND (c.SearchCriteriaID <> 0)  -- only keep results for 30 days

DELETE searchresult
WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM #old)

DELETE searchCriteria
WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM #old)

GO



/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[MergeInstitutions]    Script Date: 12/29/2016																								 ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MergeInstitutions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MergeInstitutions]
GO 

CREATE PROCEDURE [dbo].[MergeInstitutions] 
@NewName varchar(250),
@NewCity varchar(50),
@OldName varchar(250),
@OldCity varchar(50)

AS

DECLARE @InstitutionID_deleted INT
DECLARE @InstitutionID_kept INT

IF ( (SELECT Count(1) FROM Institution WHERE Name = @NewName AND City = @NewCity) = 1) 
	SELECT @InstitutionID_kept= InstitutionID FROM Institution WHERE Name = @NewName AND City = @NewCity

IF ( (SELECT Count(1) FROM Institution WHERE Name = @OldName AND City = @OldCity) = 1) 
	SELECT @InstitutionID_deleted= InstitutionID FROM Institution WHERE Name = @OldName AND City = @OldCity

IF (@InstitutionID_deleted IS NULL) OR (@InstitutionID_kept IS NULL)
BEGIN
	PRINT CONCAT ('Either new or old Institution not found - [New: ', @NewName, ' / ', @NewCity, ']  [Old: ', @OldName, ' / ', @OldCity, ']')
	RETURN
END

-- add old institution into mapping table
IF NOT EXISTS (SELECT 1 FROM InstitutionMapping WHERE OldCity = @OldCity AND OldName = @OldName) 
	INSERT INTO InstitutionMapping ([NewName], [NewCity], [OldName], [OldCity]) VALUES (@NewName, @NewCity, @OldName, @OldCity)
ELSE
	UPDATE InstitutionMapping SET NewName = @NewName, NewCity = @NewCity WHERE OldCity = @OldCity AND OldName = @OldName

UPDATE ProjectFundingInvestigator set institutionid = @InstitutionID_kept where institutionid = @InstitutionID_deleted 
delete institution where institutionid = @InstitutionID_deleted

GO


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[ImportInstitutions]    Script Date: 12/14/2016 4:21:37 PM ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportInstitutions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ImportInstitutions]
GO 

CREATE PROCEDURE [dbo].[ImportInstitutions] 
  
AS

BEGIN TRY     	

	IF object_id('tmp_LoadInstitutions') is null
	BEGIN
		   RAISERROR ('Table tmp_LoadInstitutions not found', 16, 1)
	END

	-- replace city with accent names
	update tmp_LoadInstitutions set city ='Montréal' where city='Montreal'
	update tmp_LoadInstitutions set city ='Québec' where city='Quebec'
	update tmp_LoadInstitutions set city ='Zürich' where city='Zurich'
	update tmp_LoadInstitutions set city ='Pierre-Bénite' where city='Pierre-Benite'
	update tmp_LoadInstitutions set city ='Umeå' where city='Umea'
	update tmp_LoadInstitutions set city ='Münster' where city='Munster'	

	UPDATE tmp_LoadInstitutions set city = NULL where city='' OR city='NULL'
	UPDATE tmp_LoadInstitutions set State = NULL where State='' OR State='NULL'
	UPDATE tmp_LoadInstitutions set Country = NULL where Country='' OR Country='NULL'
	UPDATE tmp_LoadInstitutions set Latitude = NULL where Latitude=0
	UPDATE tmp_LoadInstitutions set Longitude = NULL where Longitude=0

	-- Data Check - Required Field Missing
	SELECT Name, City, Country, Latitude, Longitude
		INTO #missingReqFields FROM tmp_LoadInstitutions WHERE ISNULL(NAME , '') = '' OR ISNULL(City , '') = '' OR ISNULL(Country , '') = '' OR ISNULL(Latitude , 0) = 0 OR ISNULL(Longitude , 0) = 0

	IF EXISTS (SELECT 1 FROM #missingReqFields)
	BEGIN		
		
		SELECT 'Required Field Missing' AS [Data Issue], * FROM #missingReqFields
		RETURN
	END	

	-- Data Check - Invalid Country Code
	SELECT Name, City, Country
		INTO #invalidCountry FROM tmp_LoadInstitutions WHERE Country NOT IN (SELECT Abbreviation FROM Country)

	IF EXISTS (SELECT 1 FROM #invalidCountry)
	BEGIN		
		
		SELECT 'Invalid Country Code' AS [Data Issue], * FROM #invalidCountry
		RETURN
	END	


	-- Data Check - Invalid Coordinates
	SELECT Name, City, Country, latitude, longitude
		INTO #invalidCoodinates FROM tmp_LoadInstitutions WHERE (latitude < -90 or latitude > 90) OR (longitude < -180 or longitude > 180)

	IF EXISTS (SELECT 1 FROM #invalidCoodinates)
	BEGIN		
		
		SELECT 'Invalid Coordinates' AS [Data Issue], * FROM #invalidCoodinates
		RETURN
	END	

	-- Data Check - Existing Institutions
	SELECT Name, City, MAX([State]) AS [State], MAX([Country]) AS [Country], MAX([Postal]) AS [Postal], MAX([Longitude]) AS [Longitude], MAX([Latitude]) AS [Latitude], MAX([GRID]) AS Grid 
	INTO #unique FROM tmp_LoadInstitutions GROUP BY Name, City

	SELECT DISTINCT CONCAT(u.Name, '/', u.City) AS [Institution/City], CONCAT(u.State, ' ', u.Country) AS [Imported location], CONCAT(i.State, ' ', i.Country) AS [Existing location]
	INTO #exist FROM #unique u 
	JOIN Institution i ON u.Name = i.Name AND u.City = i.City	

	IF EXISTS (SELECT 1 FROM #exist)
	BEGIN		
		
		SELECT 'Institution Already exists' AS [Data Issue], * FROM #exist
		RETURN
	END	

	-- Data Check - Potential Duplicates
	SELECT DISTINCT CONCAT(t.Name, '/', t.City) AS [Imported Institution/City], CONCAT(m.[NewName], '/', m.[NewCity] ) AS [Existing Institution/City]
	INTO #dup FROM tmp_LoadInstitutions t
	JOIN InstitutionMapping m ON m.OldName = t.Name AND m.OldCity = t.City	

	IF EXISTS (SELECT 1 FROM #exist)
	BEGIN		
		
		SELECT 'Potential Duplicates' AS [Data Issue], * FROM #dup
		RETURN
	END	
		
	BEGIN TRANSACTION;
	
	-- Insert into icrp_data: DO NOT insert the institutions which already exist in the Institutions lookup 
	INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
		SELECT [Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID] FROM #unique 		

	-- Insert into icrp_dataload: Only insert the institutions which not exist in the Institutions lookup 		
	INSERT INTO icrp_dataload.dbo.Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
		SELECT [Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID] FROM #unique			

	-- Insert City coordinates into lu_city if they don't exist in lu_City
	INSERT INTO lu_City (Name, State, Country, Latitude, Longitude)	
	SELECT i.City, i.State, i.Country, i.Latitude, i.Longitude
	FROM (SELECT City, State, Country, MIN(Latitude) AS Latitude,  MIN(Longitude) AS Longitude FROM Institution GROUP BY City, State, Country) i
		LEFT JOIN lu_City c ON i.City=c.Name AND ISNULL(i.State, '') = ISNULL(c.State, '') AND i.Country = c.Country		
	WHERE i.City <> 'Missing' AND c.Name IS NULL AND i.Latitude IS NOT NULL AND i.Longitude IS NOT NULL

	-- return already exist institutions not being inserted 
	SELECT * FROM #unique

	IF object_id('tmp_LoadInstitutions') is not null
		DROP TABLE tmp_LoadInstitutions

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO



/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[ImportCollaborators]    Script Date: 12/14/2016 4:21:37 PM ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportCollaborators]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ImportCollaborators]
GO 

CREATE PROCEDURE [dbo].[ImportCollaborators]   	
@Count INT OUTPUT
AS

BEGIN TRY     	


	IF object_id('tmp_LoadCollaborators') is null
	BEGIN
		   RAISERROR ('Table tmp_LoadCollaborators not found', 16, 1)
	END
	-- Replace city name with accent
	update tmp_LoadCollaborators set city ='Montréal' where city='Montreal'
	update tmp_LoadCollaborators set city ='Québec' where city='Quebec'
	update tmp_LoadCollaborators set city ='Zürich' where city='Zurich'
	update tmp_LoadCollaborators set city ='Pierre-Bénite' where city='Pierre-Benite'
	update tmp_LoadCollaborators set city ='Umeå' where city='Umea'
	update tmp_LoadCollaborators set city ='Münster' where city='Munster'	

	-- so we don't insert empty space into the table
	update tmp_LoadCollaborators set lastname = null where lastname=''	
	update tmp_LoadCollaborators set firstname = null where firstname=''	
	update tmp_LoadCollaborators set ORC_ID = null where ORC_ID=''	
	update tmp_LoadCollaborators set OtherResearchID = null where OtherResearchID=''	
	update tmp_LoadCollaborators set OtherResearchType = null where OtherResearchType=''	
		
	-- Data Check - Missing Required Fields
	SELECT DISTINCT AwardCode, AltAwardCode, Lastname, FirstName, Institution, City INTO #missingFields
	FROM tmp_LoadCollaborators WHERE ISNULL(AwardCode, '') = '' OR ISNULL(AltAwardCode,'') = ''	

	IF EXISTS (SELECT 1 FROM #missingFields)
	BEGIN		
		
		SELECT 'Missing required field(s)' AS [Data Issue], * FROM #missingFields
		RETURN
	END	

	-- Data Check - Duplicate Collaborators in the datafile
	SELECT AwardCode, AltAwardCode, Lastname, FirstName, Institution, City, ORC_ID INTO #dupEntries
	FROM tmp_LoadCollaborators 
	GROUP BY AwardCode, AltAwardCode, Lastname, FirstName, Institution, City, ORC_ID 
	HAVING COUNT(*) > 1

	IF EXISTS (SELECT 1 FROM #dupEntries)
	BEGIN		
		
		SELECT 'Duplicate Entries in the data file' AS [Data Issue], * FROM #dupEntries
		RETURN
	END	
	
	-- Data Check - AltID not exist in ProjectFunding
	SELECT DISTINCT t.AwardCode, t.AltAwardCode INTO #missingProject
	from tmp_LoadCollaborators t
	LEFT JOIN ProjectFunding f ON t.AltAwardCode = f.AltAwardCode
	WHERE f.AltAwardCode IS NULL
	
	IF EXISTS (SELECT 1 FROM #missingProject)
	BEGIN		
		
		SELECT 'AltAwardCode does not exist' AS [Data Issue], * FROM #missingProject
		RETURN
	END	

	-- Data Check - collaborator Institution not exist in Institution lookup
	SELECT DISTINCT CONCAT(t.Institution, '/', t.City)  AS [CollabInstitution], CONCAT(m.NewName, '/', m.NewCity) AS [ICRPInstitution] INTO #missingInstitution
	from tmp_LoadCollaborators t
	LEFT JOIN Institution i ON t.Institution = i.Name AND t.City = i.City
	LEFT JOIN InstitutionMapping m ON m.OldName = t.Institution AND m.OldCity = t.City	
	WHERE i.Name IS NULL
		
	IF EXISTS (SELECT 1 FROM #missingInstitution)
	BEGIN		
		SELECT  'The Institution/City does not exist' AS [Data Issue], [CollabInstitution] AS [Collaborator Institution/City], 
		CASE [ICRPInstitution]
			WHEN '/' THEN '(no match)' ELSE [ICRPInstitution] END AS [Possible Matched ICRP Institution, City]
		FROM #missingInstitution
		RETURN
	END
	
	-- Data Check - collaborators already exist in projectFundingInvestigator table
	SELECT DISTINCT t.AltAwardCode, t.Institution, t.City, t.Lastname, t.Firstname INTO #existCollaborators
	from tmp_LoadCollaborators t
		JOIN ProjectFunding f ON t.AltAwardCode = f.AltAwardCode
		JOIN ProjectFundingInvestigator pi ON t.LastName = pi.LastName and t.FirstName = pi.FirstName AND f.ProjectFundingID = pi.ProjectFundingID
		JOIN Institution i ON t.Institution = i.Name AND t.City = i.City		
	WHERE ISNULL(pi.IsPrincipalInvestigator, 0) = 0

	IF EXISTS (SELECT 1 FROM #existCollaborators)
	BEGIN		
		SELECT  'Collaborator already exists' AS [Data Issue], * FROM #existCollaborators
		RETURN
	END
			
	SELECT @Count = 0

	BEGIN TRANSACTION;

	-- Data Check Passed - Start Import 
	INSERT INTO ProjectFundingInvestigator (ProjectFundingID, InstitutionID, [LastName], [FirstName], [ORC_ID], IsPrincipalInvestigator, OtherResearch_ID, OtherResearch_Type) 
	SELECT f.ProjectFundingID, i.InstitutionID, t.LastName, t.FirstName, t.ORC_ID, 0, t.OtherResearchID, t.OtherResearchType
	FROM tmp_LoadCollaborators t
		JOIN ProjectFunding f ON t.AltAwardCode = f.AltAwardCode
		JOIN Institution i ON t.Institution = i.Name AND t.City = i.City		

	SELECT @Count = @@ROWCOUNT

	-- return an empty table
	SELECT TOP 0 * FROM tmp_LoadCollaborators
	
	IF object_id('tmp_LoadCollaborators') is not null
		DROP TABLE tmp_LoadCollaborators

	COMMIT TRANSACTION

END TRY

BEGIN CATCH

    -- IF @@trancount > 0 
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
-- 11	Rule	Check Award - Duplicate AltAwardCodes((For NEW type only)
-- 12	Rule	Check Award - Missing Parent 
-- 13	Rule	Check Award - Multiple Parents
-- 14	Rule	Check Budget - Invalid Award or Budget Duration
---15	Rule	Check Budget - Incorrect Funding Amounts
-- 16	Rule	Check Budget - Annulized Value
-- 17	Rule	Check Budget - Invalid Award Type
-- 18	Rule	Check Award - Missing AltAwardCodes (For UPDATE type only)
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
-- 41	Rule	Check Institution - not-mapped 
-- 42	Rule	Check FundingOrg Existance
-- 43	Rule	Check FundingOrgDiv Existance
--

/***********************************************************************************************/
-- Suppress all messages for better performance 
SET NOCOUNT ON

DECLARE @DataUploadReport TABLE
(
	[ID] INT,
	[Type] varchar(25),
	[Description] varchar(250),
	[Count] INT
)

-------------------------------------------------------------------
-- Workaround Fix - set SiteCode = 0 if null and rel = 100
-- Workaround Fix - set [AwardFunding] = 0 if null
-------------------------------------------------------------------
update UploadWorkBook set SiteCodes='0' where (SiteCodes is null) AND (SiteRel = '100')
update UploadWorkBook set [AwardFunding]=0 where [AwardFunding] is null

-------------------------------------------------------------------
-- Get Project Category
-------------------------------------------------------------------
SELECT DISTINCT p.AwardCode, 
		CASE 
			WHEN ISNULL(u.AltID, '') = '' THEN f.AltAwardCode
			ELSE u.AltID END AS AltAwardCode,
		CASE 
			WHEN ISNULL(u.Category, '') = '' THEN f.Category
			ELSE u.Category END AS Category
	INTO #Category_New
FROM Project p
	JOIN ProjectFunding f ON f.ProjectID = p.ProjectID
	JOIN UploadWorkBook u ON u.AwardCode = p.AwardCode
	FULL OUTER JOIN UploadWorkBook u2 ON u2.AltId = f.AltAwardCode

SELECT a.AwardCode, a.AltAwardCode, COUNT(*) AS ParentCount INTO #ParentCategory
FROM #Category_New a
LEFT JOIN (SELECT AwardCode, AltAwardCode FROM #Category_New WHERE Category = 'Parent') p ON a.AltAwardCode = p.AltAwardCode
GROUP BY a.AwardCode, a.AltAwardCode


------------------------------------------------------------------
-- Check Required Fields Rule
-------------------------------------------------------------------
DECLARE @RuleName VARCHAR(100)
DECLARE @RuleID INT

SET @RuleID= 1
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT AltID INTO #MissingAmount FROM UploadWorkBook WHERE AwardFunding IS NULL

IF EXISTS (SELECT 1 FROM #MissingAmount)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #MissingAmount
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

IF @Type = 'New'
BEGIN
	-------------------------------------------------------------------
	-- Workbook Summary
	-------------------------------------------------------------------
	-- Get all AwardCodes
	SELECT Distinct CAST('New' AS VARCHAR(25)) AS Type, CAST(NULL AS INT) AS ProjectID, CAST(NULL AS INT) AS FundingOrgID, AwardCode, 0 AS IsParent 
	INTO #awardCodes FROM UploadWorkBook

	UPDATE #awardCodes SET Type='Existing', ProjectID=pp.ProjectID, FundingOrgID = pp.FundingOrgID
	FROM #awardCodes a 
	JOIN (SELECT p.ProjectID, o.FundingOrgID, p.AwardCode FROM Project p 
			JOIN ProjectFunding f ON p.ProjectID = f.ProjectID 
			JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID 
		  WHERE o.SponsorCode = @PartnerCode) pp ON a.AwardCode = pp.AwardCode	

	-- Get Project Funding record with parent category
	SELECT AwardCode, AltID, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'

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


End

IF @Type = 'Update'
BEGIN
	-------------------------------------------------------------------
	-- Workbook Summary
	-------------------------------------------------------------------
	DECLARE @TotalUpdates INT

	SELECT @TotalUpdates = COUNT(*) FROM (SELECT DISTINCT AltID FROM UploadWorkBook) u

	INSERT INTO @DataUploadReport VALUES (0, 'Summary', 'Total Updated Project Funding Records',  @TotalUpdates)

	-------------------------------------------------------------------
	-- Check Missing AltAwardCodes 
	-------------------------------------------------------------------
	SET @RuleID= 18
	select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.FundingOrgAbbr INTO #missingAltID 
	FROM UploadWorkBook u
		LEFT JOIN (SELECT p.AwardCode, f.AltAwardCode, o.Abbreviation FROM ProjectFunding f 
					JOIN Project p ON f.ProjectID = p.ProjectID
					JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) pf ON u.AltId = pf.AltAwardCode AND pf.Abbreviation = u.FundingOrgAbbr AND pf.AwardCode = u.AwardCode
	WHERE pf.AltAwardCode IS NULL

	IF EXISTS (SELECT * FROM #missingAltID)
		INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #missingAltID
	ELSE
		INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0	
		
	------------------------------------------------------------------
	-- Check if AltAwardCodes not unique (check both workbook and existing ProjectFunding)
	-------------------------------------------------------------------
	SET @RuleID= 11
	select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

	SELECT CASE WHEN (@Type ='Update') AND (ISNULL(u.NewAltId, '') <> '') THEN u.NewAltID ELSE pf.AltAWardCode END AS AltAWardCode INTO #AltID 
	FROM ProjectFunding pf
		JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID
		LEFT JOIN UploadWorkBook u ON pf.AltAwardCode = u.AltId
	WHERE o.Abbreviation IN (SELECT DISTINCT FundingOrgAbbr FROM UploadWorkBook)
	
	SELECT AltAWardCode into #dupAltId from #AltID group by AltAWardCode having count(*) > 1

	IF EXISTS (SELECT 1 from #dupAltId)
		INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #dupAltId
	ELSE
		INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

End
	
-------------------------------------------------------------------
-- Check New AwardCodes without Parent project 
-------------------------------------------------------------------
SET @RuleID= 12
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID	

IF EXISTS (SELECT * FROM #ParentCategory WHERE ParentCount = 0)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #ParentCategory WHERE ParentCount = 0
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check renewals imported as Parent 
-------------------------------------------------------------------
SET @RuleID= 13
SELECT @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID	

IF EXISTS (SELECT * FROM #ParentCategory WHERE ParentCount > 1)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #ParentCategory WHERE ParentCount > 1
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
IF object_id('tmp_mismatched_pcso') is NOT null
	drop table tmp_mismatched_pcso

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

CREATE TABLE tmp_mismatched_pcso
(	
	AltAwardCode VARCHAR(50),
	csolist VARCHAR(2000),
	csoRelList VARCHAR(2000)
)

DECLARE @csoList as NVARCHAR(2000)
DECLARE @csoRelList as NVARCHAR(2000)
DECLARE @csoCount as INT
DECLARE @csoRelCount as INT

DECLARE @csocursor as CURSOR;

SET @csocursor = CURSOR FOR
SELECT AltAwardCode, CSOCodes , CSORel FROM #list;
 
OPEN @csocursor;
FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN 
 SELECT @csoCount = count(*) FROM STRING_SPLIT(@csolist, ',')  
 SELECT @csoRelCount = count(*) FROM STRING_SPLIT(@csoRelList, ',')  

 IF @csoCount <> @csoRelCount
 BEGIN
	INSERT INTO tmp_mismatched_pcso VALUES (@AltAwardCode,@csoList, @csoRelList)
 END
 ELSE
 BEGIN
	 INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
	 INSERT INTO tmp_pcsorel SELECT @AltAwardCode, 
	 CASE LTRIM(RTRIM(value))
		 WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
	 FROM  dbo.ToStrTable(@csoRelList) 

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS
 END

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
-- Rule 24 - Check CSO - Mismatched count (# of codes <> # of Rel)
-----------------------------------------------------------------
SET @RuleID= 24
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

DECLARE @count1 INT
DECLARE @count2 INT

SELECT @count1=count(1) FROM tmp_mismatched_pcso

SELECT @count2 = count(1) FROM tmp_pcso c
	FULL OUTER JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
WHERE c.AltAwardCode IS NULL OR r.AltAwardCode IS NULL

IF @count1+@count2 > 0 
BEGIN
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, @count1+@count2	
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
-- Prepare Site temp tables
-----------------------------------------------------------------
IF object_id('tmp_psite') is NOT null
	drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
	drop table tmp_psiterel
IF object_id('tmp_mismatched_psite') is NOT null
	drop table tmp_mismatched_psite

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

CREATE TABLE tmp_mismatched_psite
(	
	AltAwardCode VARCHAR(50),
	sitelist VARCHAR(2000),
	siteRelList VARCHAR(2000)
)

DECLARE @siteList as NVARCHAR(2000)
DECLARE @siteRelList as NVARCHAR(2000)
DECLARE @siteCount as INT
DECLARE @siteRelCount as INT
 
DECLARE @ctcursor as CURSOR;

SET @ctcursor = CURSOR FOR
SELECT AltAwardCode, SiteCodes , SiteRel FROM #list;
 
OPEN @ctcursor;
FETCH NEXT FROM @ctcursor INTO @AltAwardCode, @siteList, @siteRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT @siteCount = count(*) FROM STRING_SPLIT(@siteList, ',')  
 SELECT @siteRelCount = count(*) FROM STRING_SPLIT(@siteRelList, ',')  

 IF @siteCount <> @siteRelCount
 BEGIN
	INSERT INTO tmp_mismatched_psite VALUES (@AltAwardCode,@siteList, @siteRelList)
 END
 ELSE
 BEGIN
	 INSERT INTO tmp_psite SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@siteList)
	 INSERT INTO tmp_psiterel SELECT @AltAwardCode, 
		CASE LTRIM(RTRIM(value))
		 WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
	 FROM  dbo.ToStrTable(@siteRelList) 
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS
 END
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
-- 	Rule 34 -	Check CancerType - Mismatched count (# of codes <> # of Rel	)
-----------------------------------------------------------------	
SET @RuleID= 34
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

DECLARE @sitecount1 INT
DECLARE @sitecount2 INT

SELECT @sitecount1=count(1) FROM tmp_mismatched_psite

SELECT @sitecount2 = count(1) FROM tmp_psite s
	FULL OUTER JOIN tmp_psiterel r ON s.AltAwardCode = r.AltAwardCode AND s.Seq = r.Seq
WHERE s.AltAwardCode IS NULL OR r.AltAwardCode IS NULL

IF @sitecount1 + @sitecount2 > 0
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, @count1+@count2
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
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
SET @RuleID= 41
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT u.InstitutionICRP, u.City INTO #missingInst FROM UploadWorkBook u
	LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
	--LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
WHERE (i.InstitutionID IS NULL) --AND (m.InstitutionMappingID IS NULL)

IF EXISTS (select * FROM #missingInst)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #missingInst
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
SET @RuleID= 42
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT ISNULL(FundingOrgAbbr, 'NULL') AS FundingOrgAbbr  INTO #org from UploadWorkBook 
where ISNULL(FundingOrgAbbr, 'NULL') NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg WHERE SponsorCode=@PartnerCode)

IF EXISTS (SELECT * FROM #org)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #org
ELSE
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, 0

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
SET @RuleID= 43
select @RuleName = Category + ' - ' + Name from lu_DataUploadIntegrityCheckRules where lu_DataUploadIntegrityCheckRules_ID =@RuleID

SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
IF EXISTS (SELECT * FROM #orgDiv)
	INSERT INTO @DataUploadReport SELECT @RuleID, 'Rule', @RuleName, COUNT(*) FROM #org
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
 @RuleId INT,
 @Type VARCHAR (10)  = 'New' -- 'New' or 'Update' 
  
AS


/***********************************************************************************************/
-- Data Integrigy Check Rules - New Upload
--
--
-- 1	Rule	Check Required Fields 
--
-- 11	Rule	Check Award - Duplicate AltAwardCodes
-- 12	Rule	Check Award - Missing Parent 
-- 13	Rule	Check Award - Multiple Parents
-- 14	Rule	Check Budget - Invalid Award or Budget Duration
---15	Rule	Check Budget - Incorrect Funding Amounts
-- 16	Rule	Check Budget - Annulized Value
-- 17	Rule	Check Budget - Invalid Award Type
-- 18	Rule	Check Award - Missing AltAwardCodes (For UPDATE type only)
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
-- 41	Rule	Check Institution - not-mapped 
-- 42	Rule	Check FundingOrg Existance
-- 43	Rule	Check FundingOrgDiv Existance
--

/***********************************************************************************************/
SET NOCOUNT ON

IF @RuleId = 1
BEGIN
	SELECT AwardCode, AltID INTO #MissingAmount FROM UploadWorkBook WHERE AwardFunding IS NULL

	IF EXISTS (SELECT 1 FROM #MissingAmount)
		SELECT 'Funding Amount' AS [Missing Field], AwardCode, AltID FROM #MissingAmount	
	ELSE
		SELECT 'NA' AS [Missing Field]

END 


--Checking Parent projects ...
SELECT AwardCode, AltID, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'

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
IF @Type = 'New'
BEGIN
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
END


IF @Type = 'Update'
	BEGIN
	IF @RuleId = 11
	BEGIN

		SELECT CASE WHEN ISNULL(u.NewAltId, '') <> '' THEN u.NewAltID ELSE pf.AltAWardCode END AS AltAwardCode, o.Abbreviation AS FundingOrgAbbr INTO #AltID 	
		FROM ProjectFunding pf
			JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID
			LEFT JOIN UploadWorkBook u ON pf.AltAwardCode = u.AltId
		WHERE o.Abbreviation IN (SELECT DISTINCT FundingOrgAbbr FROM UploadWorkBook)
	
		SELECT AltAWardCode, FundingOrgAbbr from #AltID group by AltAWardCode, FundingOrgAbbr having count(*) > 1
	
	END
END


------------------------------------------------------------------
-- Check if AltAwardCodes are not in ICRP
-------------------------------------------------------------------
IF @RuleId = 18
BEGIN

	SELECT u.AwardCode, u.AltId AS AltAwardCode, u.FundingOrgAbbr AS FundingOrg
	FROM UploadWorkBook u
		LEFT JOIN (SELECT f.AltAwardCode, o.Abbreviation FROM ProjectFunding f 
							JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) pf ON u.AltId = pf.AltAwardCode AND pf.Abbreviation = u.FundingOrgAbbr
	WHERE pf.AltAwardCode IS NULL

END


-------------------------------------------------------------------
-- Get Project Category
-------------------------------------------------------------------
SELECT DISTINCT p.AwardCode, 
		CASE 
			WHEN ISNULL(u.AltID, '') = '' THEN f.AltAwardCode
			ELSE u.AltID END AS AltAwardCode,
		CASE 
			WHEN ISNULL(u.Category, '') = '' THEN f.Category
			ELSE u.Category END AS Category
	INTO #Category_New
FROM Project p
	JOIN ProjectFunding f ON f.ProjectID = p.ProjectID
	JOIN UploadWorkBook u ON u.AwardCode = p.AwardCode
	FULL OUTER JOIN UploadWorkBook u2 ON u2.AltId = f.AltAwardCode

SELECT a.AwardCode, a.AltAwardCode, COUNT(*) AS ParentCount INTO #ParentCategory
FROM #Category_New a
LEFT JOIN (SELECT AwardCode, AltAwardCode FROM #Category_New WHERE Category = 'Parent') p ON a.AltAwardCode = p.AltAwardCode
GROUP BY a.AwardCode, a.AltAwardCode

-------------------------------------------------------------------
-- Check AwardCodes without Parent Category 
-------------------------------------------------------------------
IF @RuleId = 12
BEGIN
	SELECT AwardCode, AltAwardCode, ParentCount FROM #ParentCategory WHERE ParentCount = 0
END

-------------------------------------------------------------------
-- Check renewals imported as Parent 
-------------------------------------------------------------------
IF @RuleID= 13
BEGIN
	SELECT AwardCode, AltAwardCode, ParentCount FROM #ParentCategory WHERE ParentCount > 1
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

		DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
		DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

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
	
	UNION
	
	SELECT DISTINCT u.AwardCode, AltAwardCode, csolist, csoRelList 
	FROM tmp_mismatched_pcso t
		JOIN UploadWorkbook u ON t.AltAwardCode = u.AltID

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
 
		DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
		DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS

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
		
	UNION
	
	SELECT DISTINCT u.AwardCode, AltAwardCode, sitelist, siteRelList 
	FROM tmp_mismatched_psite t
		JOIN UploadWorkbook u ON t.AltAwardCode = u.AltID

-----------------------------------------------------------------	
-- 26 Check Duplicate CancerType Codes
-----------------------------------------------------------------
IF @RuleId = 35
	SELECT d.AltAwardCode, u.SiteCodes, u.SiteRel FROM (SELECT DISTINCT AltAwardCode FROM tmp_psite GROUP BY AltAwardCode, Code Having Count(*) > 1) d
		JOIN UploadWorkbook u ON d.AltAwardCode = u.AltID
				
-------------------------------------------------------------------
-- Check Institutions (Check both Institution lookup and mapping tables)
-------------------------------------------------------------------
IF @RuleId = 41
BEGIN
	SELECT DISTINCT CONCAT(u.InstitutionICRP, ', ', u.City) AS [Workbook Institution, City], CONCAT(m.NewName, ', ', m.NewCity) AS [Possible Matched Institution, City in ICRP] 
	FROM UploadWorkBook u
		LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
		LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
	WHERE (i.InstitutionID IS NULL) 
	
END 

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
IF @RuleId = 42
BEGIN

	SELECT DISTINCT ISNULL(FundingOrgAbbr, '') AS FundingOrgAbbr, @PartnerCode AS SponsorCode from UploadWorkBook 
		where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg WHERE SponsorCode=@PartnerCode)
		
END 

-------------------------------------------------------------------
-- Check FundinOrggDiv
-------------------------------------------------------------------
IF @RuleId = 43
BEGIN

	SELECT DISTINCT FundingDivAbbr INTO #orgDiv from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
	
	SELECT u.AwardCode, u.AltID AS AltAwardCode, u.FundingDivAbbr, u.BudgetStartDate, u.BudgetEndDate, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel  
	FROM #orgDiv c JOIN UploadWorkbook u ON c.FundingDivAbbr = u.FundingDivAbbr
END 	
	
GO


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_ImportNew]    Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_ImportNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_ImportNew]
GO 

CREATE PROCEDURE [dbo].[DataUpload_ImportNew] 
@PartnerCode varchar(25),
@FundingYears VARCHAR(25),
@ImportNotes  VARCHAR(1000),
@ReceivedDate  datetime
  
AS

DECLARE @Type varchar(15) = 'NEW'

SET NOCOUNT ON

BEGIN TRANSACTION;

BEGIN TRY     

--IF @ImportNotes = 'error'
--	RAISERROR ('Simulated Error for testing...', 16, 1);

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

DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed) WITH NO_INFOMSGS

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
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation AND o.SponsorCode = @PartnerCode
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation

-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
INSERT INTO ProjectFundingInvestigator ([ProjectFundingID], [LastName],	[FirstName],[ORC_ID],[OtherResearch_ID],[OtherResearch_Type],[IsPrincipalInvestigator],[InstitutionID],[InstitutionNameSubmitted])
SELECT DISTINCT f.ProjectFundingID, u.PILastName, u.PIFirstName, u.ORCID, u.OtherResearcherID, u.OtherResearcherIDType, 1 AS isPI, ISNULL(i.InstitutionID,1) AS InstitutionID, u.SubmittedInstitution
FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	LEFT JOIN Institution i ON u.InstitutionICRP = i.Name AND u.City = i.City
	
-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null
BEGIN

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_pcsoRel	
	
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

	DECLARE @AltAwardCode as VARCHAR(50)
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

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

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
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS

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

---------------------------------------------------------------------
-- Import Project_ProjectTye (only the new AwardCode)
---------------------------------------------------------------------
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
	 RAISERROR ('Post Import Check Error - Mis-matched Sponsor Code not match', 16, 1);

-------------------------------------------------------------------------------------------
---- checking Missing PI
-------------------------------------------------------------------------------------------	
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
	RAISERROR ('Post Import Check Error - Non-mapped Instititutions Mapping', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking Duplicate PI
-------------------------------------------------------------------------------------------	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)	
	RAISERROR ('Post Import Check Error - duplicate PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing PI
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingPI from projectfunding f
left join (SELECT projectFundingID, InstitutionID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator =1) pi on f.projectfundingid = pi.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)	
	RAISERROR ('Post Import Check Error - Missing PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing CSO
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingCSO from projectfunding f
left join ProjectCSO pc on f.projectfundingid = pc.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pc.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CSO', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking missing CancerType
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingSite from projectfunding f
left join ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and ct.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CancerType', 16, 1);	

-----------------------------------
-- Import ProjectFundingExt
-----------------------------------
-- call php code to calculate and populate calendar amounts


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract 
	FROM ProjectAbstract a
	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	WHERE f.DataUploadStatusID = @DataUploadStatusID_stage
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

-- Insert ProjectFundingInvestigatorCount Count (only pi)
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE pi.IsPrincipalInvestigator = 1 AND  f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearch TotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

INSERT INTO icrp_data.dbo.DataUploadLog ([DataUploadStatusID], [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate]) 
	SELECT @DataUploadStatusID_prod, [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate] 
	FROM icrp_dataload.dbo.DataUploadLog where DataUploadStatusID=@DataUploadStatusID_stage

-- return dataupload counts
SELECT  [DataUploadLogID],[DataUploadStatusID],[ProjectCount],[ProjectFundingCount],[ProjectFundingInvestigatorCount],[ProjectCSOCount],
		[ProjectCancerTypeCount],[Project_ProjectTypeCount],[ProjectAbstractCount],[ProjectSearchCount]
FROM DataUploadLog where DataUploadLogID=@DataUploadLogID

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
/****** Object:  StoredProcedure [dbo].[DataUpload_ImportUpdate]																													*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_ImportUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_ImportUpdate]
GO 

CREATE PROCEDURE [dbo].[DataUpload_ImportUpdate] 
@PartnerCode varchar(25),
@FundingYears VARCHAR(25),
@ImportNotes  VARCHAR(1000),
@ReceivedDate  datetime
  
AS

SET NOCOUNT ON;  

BEGIN TRANSACTION;

BEGIN TRY     

DECLARE @Type varchar(15) = 'UPDATE'

--IF @ImportNotes = 'error'
--	RAISERROR ('Simulated Error for testing...', 16, 1);

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

-- replace city with accent names
update UploadWorkbook set city ='Montréal' where city='Montreal'
update UploadWorkbook set city ='Québec' where city='Quebec'
update UploadWorkbook set city ='Zürich' where city='Zurich'
update UploadWorkbook set city ='Pierre-Bénite' where city='Pierre-Benite'
update UploadWorkbook set city ='Umeå' where city='Umea'

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
-- Archive to-be updated Project Funding records
/***********************************************************************************************/
INSERT INTO ProjectFundingArchive ([ProjectFundingID], FundingOrgID, FundingDivisionID, ProjectAbstractID, [Title], [Category], [AltAwardCode], [Source_ID], [MechanismCode], [MechanismTitle], [FundingContact],			
		[IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], DataUploadStatusID, ArchivedDate)
SELECT DISTINCT f.[ProjectFundingID], f.FundingOrgID, f.FundingDivisionID, f.ProjectAbstractID, f.[Title], f.[Category], f.[AltAwardCode], f.[Source_ID], f.[MechanismCode], f.[MechanismTitle], f.[FundingContact],			
		f.[IsAnnualized], f.[Amount], f.[BudgetStartDate], f.[BudgetEndDate], @DataUploadStatusID_stage, getdate() 
FROM UploadWorkbook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode

/***********************************************************************************************/
-- Start Import Data
/***********************************************************************************************/
-------------------------------------------------------
-- Update base Projects - Childhood, ProjectDates
------------------------------------------------------
UPDATE Project SET IsChildhood = 
	CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
ProjectStartDate = u.AwardStartDate, ProjectEndDate = u.AwardEndDate, UpdatedDate = getdate(), DataUploadStatusID = @DataUploadStatusID_stage
FROM Project p
	JOIN UploadWorkbook u ON p.AwardCode = u.AWardCode

-----------------------------------
-- Update Project Abstract
-----------------------------------
UPDATE ProjectAbstract SET TechAbstract=u.TechAbstract, PublicAbstract=u.PublicAbstract
FROM UploadWorkbook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID AND u.FundingOrgAbbr = o.Abbreviation	
	JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	

--------------------------------------------------------------------------------------------------------------------------------------------
-- Update ProjectFunding - AwardAmount, Title, Category, AwardDates, Source_ID, Mechanism, FundingContact,IsAnnualized
--------------------------------------------------------------------------------------------------------------------------------------------
UPDATE ProjectFunding SET AltAwardCode = CASE WHEN ISNULL(u.NewAltId, '') = '' THEN u.AltID ELSE u.NewAltID END,
							Title = u.AwardTitle, Category = u.Category, Source_ID = u.SourceID, 
							MechanismCode = u.FundingMechanismCode, MechanismTitle = u.FundingMechanism, FundingContact = u.FundingContact,
							IsAnnualized = 
								CASE ISNULL(u.IsAnnualized, '') 
								WHEN 'y' THEN 1 ELSE 0 END,
						 Amount  = u.AwardFunding, BudgetStartDate = u.BudgetStartDate, BudgetEndDate = u.BudgetEndDate, UpdatedDate = getdate(),
						 DataUploadStatusID =  @DataUploadStatusID_stage
FROM ProjectFunding f 	
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	JOIN UploadWorkbook u ON u.AltID = f.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation	

--------------------------------------------------------------------------------------------------------------------------------------------
-- Update ProjectFundingInvestigator  - PI name, ORCiD, Institution, OtherResearcherID, OtherResearcherIDType
--------------------------------------------------------------------------------------------------------------------------------------------
UPDATE ProjectFundingInvestigator SET LastName = u.PILastName, FirstName = u.PIFirstName, ORC_ID = u.ORCID, OtherResearch_ID= u.OtherResearcherID, OtherResearch_Type = u.OtherResearcherIDType, 
										InstitutionID = ISNULL(i.InstitutionID,1), InstitutionNameSubmitted = u.SubmittedInstitution, UpdatedDate = getdate()
FROM ProjectFundingInvestigator pi	
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON fa.ProjectFundingID = pi.ProjectFundingID
	JOIN FundingOrg o ON fa.FundingOrgID = o.FundingOrgID 
	JOIN UploadWorkbook u ON u.AltID = fa.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation		
	LEFT JOIN Institution i ON i.Name = u.InstitutionICRP AND i.City = i.City

	
----------------------------------------------------------------------
-- Remove old records and re-insert
----------------------------------------------------------------------
DELETE Project_ProjectType WHERE ProjectID IN
	(SELECT ProjectID FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_stage)	

DELETE ProjectCSO WHERE ProjectFundingID IN
	(SELECT ProjectFundingID FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadStatusID_stage)

DELETE ProjectCancerType WHERE ProjectFundingID IN
	(SELECT ProjectFundingID FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadStatusID_stage)

DELETE ProjectFundingExt WHERE ProjectFundingID IN
	(SELECT ProjectFundingID FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadStatusID_stage)	

-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null
BEGIN

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_pcsoRel	
	
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

	DECLARE @AltAwardCode as VARCHAR(50)
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

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
	END
 
	CLOSE @csocursor;
	DEALLOCATE @csocursor;

	UPDATE tmp_pcso SET CSO = LTRIM(RTRIM(CSO))	

END

----------------------------------------------------------------------
-- ProjectCSO - delete old then insert new
----------------------------------------------------------------------	
INSERT INTO ProjectCSO SELECT fa.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM tmp_pcso c 
	JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON c.AltAwardCode = fa.AltAwardCode

----------------------------------------------------------------------
-- ProjectCancerType - delete old then insert new
----------------------------------------------------------------------

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
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;
	END
 
	CLOSE @ctcursor;
	DEALLOCATE @ctcursor;

	UPDATE tmp_psite SET code = LTRIM(RTRIM(code))	
END


-----------------------------------
-- Update ProjectCancerType
-----------------------------------
INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT fa.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM tmp_psite c 
	JOIN tmp_psiterel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN CancerType ct ON c.code = ct.ICRPCode
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON c.AltAwardCode = fa.AltAwardCode

----------------------------------------------------------------------
-- Import Project_ProjectTye (only the new AwardCode)
----------------------------------------------------------------------
SELECT p.ProjectID, p.AwardCode, b.AwardType INTO #plist 
FROM (SELECT AwardCode, MAX(AWardType) AS AwardType FROM UploadWorkbook GROUP BY AwardCode) b
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

----------------------------------------------------------------------
-- Award Type/ProjectType - - delete old then insert new
----------------------------------------------------------------------
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
	 RAISERROR ('Post Import Check Error - Mis-matched Sponsor Code not match', 16, 1);

-------------------------------------------------------------------------------------------
---- checking Missing PI
-------------------------------------------------------------------------------------------	
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
	RAISERROR ('Post Import Check Error - Non-mapped Instititutions Mapping', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking Duplicate PI
-------------------------------------------------------------------------------------------	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)	
	RAISERROR ('Post Import Check Error - duplicate PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing PI
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingPI from projectfunding f
left join (SELECT projectFundingID, InstitutionID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator =1) pi on f.projectfundingid = pi.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)	
	RAISERROR ('Post Import Check Error - Missing PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing CSO
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingCSO from projectfunding f
left join ProjectCSO pc on f.projectfundingid = pc.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pc.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CSO', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking missing CancerType
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingSite from projectfunding f
left join ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and ct.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CancerType', 16, 1);	


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
DELETE ProjectSearch 		
FROM  ProjectSearch s
	JOIN Project p ON s.ProjectID = p.ProjectID	
WHERE p.DataUploadStatusID = @DataUploadStatusID_Stage	
		
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract, a.PublicAbstract 
		FROM ProjectAbstract a
			JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
			JOIN (SELECT ProjectID FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_Stage) p ON f.ProjectID = p.ProjectID				
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

-- Insert ProjectFundingInvestigatorCount Count (only pi)
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE pi.IsPrincipalInvestigator = 1 AND  f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearch TotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

INSERT INTO icrp_data.dbo.DataUploadLog ([DataUploadStatusID], [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate]) 
	SELECT @DataUploadStatusID_prod, [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate] 
	FROM icrp_dataload.dbo.DataUploadLog where DataUploadStatusID=@DataUploadStatusID_stage


-- return dataupload counts
SELECT  [DataUploadLogID],[DataUploadStatusID],[ProjectCount],[ProjectFundingCount],[ProjectFundingInvestigatorCount],[ProjectCSOCount],
		[ProjectCancerTypeCount],[Project_ProjectTypeCount],[ProjectAbstractCount],[ProjectSearchCount]
FROM DataUploadLog where DataUploadLogID=@DataUploadLogID

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

@DataUploadID INT

AS

SET NOCOUNT ON

-------------------------------------------------
-- Retrieve DataUploadStatusID and Seed Info
------------------------------------------------
declare @DataUploadStatusID_Stage INT
declare @DataUploadStatusID_Prod INT
declare @PartnerCode VARCHAR(25)
declare @Type VARCHAR(25)
DECLARE @DataUploadLogID INT
DECLARE @Count INT

SET @DataUploadStatusID_Stage = @DataUploadID


BEGIN TRANSACTION;

BEGIN TRY 


	IF ( (SELECT COUNT(*) 
			FROM (SELECT * FROM icrp_data.dbo.DataUploadStatus WHERE Status = 'Staging' ) p
			JOIN (SELECT * FROM icrp_dataload.dbo.DataUploadStatus WHERE Status = 'Staging' AND DataUploadStatusID = @DataUploadStatusID_Stage) s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type AND p.Note = s.Note) = 1)
	BEGIN
	
		SELECT @DataUploadStatusID_Prod = p.DataUploadStatusID, @Type = p.[Type], @PartnerCode=p.PartnerCode 
			FROM (SELECT * FROM icrp_data.dbo.DataUploadStatus WHERE Status = 'Staging') p
				JOIN (SELECT * FROM icrp_dataload.dbo.DataUploadStatus WHERE Status = 'Staging' and DataUploadStatusID = @DataUploadStatusID_Stage) s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type AND p.Note = s.Note
		
	END
	ELSE
	BEGIN			  
      RAISERROR ('Failed to retrieve Prod DataUploadStatusID', 16, 1)
	END
	
	SELECT @DataUploadLogID = DataUploadLogID FROM icrp_data.dbo.DataUploadLog WHERE DataUploadStatusID = @DataUploadStatusID_Prod	

	/***********************************************************************************************/
	-- Archive Project Funding records those will be updated
	/***********************************************************************************************/
	IF @Type = 'Update'
	BEGIN
		INSERT INTO icrp_data.dbo.ProjectFundingArchive ([ProjectFundingID], FundingOrgID, FundingDivisionID, ProjectAbstractID, [Title], [Category], [AltAwardCode], [Source_ID], [MechanismCode], [MechanismTitle], [FundingContact],			
												 		[IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], DataUploadStatusID, ArchivedDate)
			SELECT DISTINCT f.[ProjectFundingID], f.FundingOrgID, f.FundingDivisionID, f.ProjectAbstractID, f.[Title], f.[Category], f.[AltAwardCode], f.[Source_ID], f.[MechanismCode], f.[MechanismTitle], f.[FundingContact],			
					f.[IsAnnualized], f.[Amount], f.[BudgetStartDate], f.[BudgetEndDate], @DataUploadStatusID_Prod, getdate() 
			FROM icrp_dataload.dbo.ProjectFundingArchive fa
				JOIN icrp_data.dbo.ProjectFunding f ON fa.[AltAwardCode] = f.[AltAwardCode]
			WHERE fa.DataUploadStatusID = @DataUploadStatusID_Stage
	END

	/***********************************************************************************************/
	-- Import Data
	/***********************************************************************************************/
	-- Import Project	
	IF @Type = 'New'
	BEGIN
		INSERT INTO icrp_data.dbo.project ([IsChildhood], [AwardCode], [ProjectStartDate], [ProjectEndDate], [DataUploadStatusID], [CreatedDate], [UpdatedDate])
		SELECT [IsChildhood],[AwardCode],[ProjectStartDate],[ProjectEndDate], @DataUploadStatusID_Prod, getdate(),getdate()
		FROM icrp_dataload.dbo.Project WHERE [DataUploadStatusID] = @DataUploadStatusID_Stage	
	END
	ELSE  -- Update base projects
	BEGIN

		UPDATE icrp_data.dbo.Project SET IsChildhood = lp.IsChildhood, ProjectStartDate= lp.ProjectStartDate, ProjectEndDate= lp.ProjectEndDate, DataUploadStatusID=@DataUploadStatusID_Prod, UpdatedDate = getdate()
		FROM icrp_data.dbo.Project p
			JOIN icrp_dataload.dbo.Project lp ON p.AwardCode = lp.AwardCode
		WHERE lp.DataUploadStatusID = @DataUploadStatusID_Stage

	END

	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-----------------------------------
	-- Import Project Abstract
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		DECLARE @seed INT
		SELECT @seed=MAX(projectAbstractID)+1 FROM icrp_data.dbo.projectAbstract 
	
		CREATE TABLE UploadAbstractTemp (	
			ID INT NOT NULL IDENTITY(1,1),
			ProjectFundindID INT,	
			TechAbstract NVARCHAR (MAX) NULL,
			PublicAbstract NVARCHAR (MAX) NULL
		) ON [PRIMARY]

		DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed) WITH NO_INFOMSGS

		INSERT INTO UploadAbstractTemp (ProjectFundindID, TechAbstract,	PublicAbstract) SELECT pf.projectFundingID, a.[TechAbstract], a.[PublicAbstract]
			FROM icrp_dataload.dbo.projectAbstract a
			JOIN icrp_dataload.dbo.projectfunding pf ON a.projectAbstractID =  pf.projectAbstractID  WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

		SET IDENTITY_INSERT icrp_data.dbo.projectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

		INSERT INTO icrp_data.dbo.ProjectAbstract ([projectAbstractID], [TechAbstract], [PublicAbstract],[CreatedDate],[UpdatedDate])
		SELECT ID, [TechAbstract], [PublicAbstract],getdate(),getdate()
		FROM UploadAbstractTemp 		

		SET IDENTITY_INSERT icrp_data.dbo.projectAbstract OFF;  -- SET IDENTITY_INSERT to ON. 

		SELECT @Count = count(*) from UploadAbstractTemp
		UPDATE icrp_data.dbo.DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID =	@DataUploadLogID
	END
	ELSE  -- Update 
	BEGIN
		UPDATE icrp_data.dbo.ProjectAbstract SET TechAbstract = la.TechAbstract, PublicAbstract=la.PublicAbstract, UpdatedDate = getdate()
		FROM icrp_data.dbo.ProjectAbstract a
			JOIN icrp_data.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
			JOIN icrp_dataload.dbo.ProjectFundingArchive laf ON f.AltAwardCode = laf.AltAwardCode  -- use the archived AltAwardCode 			
			JOIN icrp_dataload.dbo.ProjectAbstract la ON la.ProjectAbstractID = laf.ProjectAbstractID			
		WHERE laf.DataUploadStatusID = @DataUploadStatusID_Stage

		SELECT @Count = @@ROWCOUNT
		UPDATE icrp_data.dbo.DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID =	@DataUploadLogID

	END 			

	-----------------------------------
	-- Import ProjectFunding
	-----------------------------------
	IF @Type = 'New'
	BEGIN
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
	END
	ELSE  -- Update 
	BEGIN
		UPDATE icrp_data.dbo.ProjectFunding SET Title = lf.Title,  AltAwardCode = lf.AltAwardCode, Category = lf.Category, Source_ID = lf.Source_ID, Amount = lf.Amount, BudgetStartDate = lf.BudgetStartDate, BudgetEndDate = lf.BudgetEndDate, 
				IsAnnualized = lf.IsAnnualized, DataUploadStatusID=@DataUploadStatusID_Prod, UpdatedDate = getdate()
		FROM icrp_data.dbo.ProjectFunding f
			JOIN (SELECT * FROM icrp_dataload.dbo.ProjectFundingArchive WHERE DataUploadStatusID=@DataUploadStatusID_Stage) laf ON f.AltAwardCode = laf.AltAwardCode  -- use the archived AltAwardCode 
			JOIN icrp_dataload.dbo.ProjectFunding lf ON laf.ProjectFundingID = lf.ProjectFundingID
		WHERE lf.DataUploadStatusID = @DataUploadStatusID_Stage

	END

	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-----------------------------------
	-- Import ProjectFundingInvestigator
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		INSERT INTO icrp_data.dbo.ProjectFundingInvestigator
		SELECT f.ProjectFundingID, pi.LastName, pi.FirstName, pi.ORC_ID, pi.OtherResearch_ID, pi.OtherResearch_Type, pi.IsPrincipalInvestigator, ISNULL(newi.InstitutionID,1), InstitutionNameSubmitted, getdate(),getdate()
		FROM icrp_dataload.dbo.ProjectFundingInvestigator pi
			JOIN icrp_dataload.dbo.projectfunding lf ON pi.ProjectFundingID =  lf.ProjectFundingID  
			JOIN icrp_data.dbo.projectfunding f ON f.AltAwardCode =  lf.AltAwardCode  
			JOIN icrp_dataload.dbo.Institution i ON pi.institutionID = i.institutionID
			LEFT JOIN icrp_data.dbo.Institution newi ON newi.Name = i.Name AND newi.City = i.City
		WHERE lf.[DataUploadStatusID] = @DataUploadStatusID_Stage
	END
	ELSE  -- Update 
	BEGIN
		
		UPDATE icrp_data.dbo.ProjectFundingInvestigator SET LastName = lpi.LastName, FirstName = lpi.FirstName, ORC_ID = lpi.ORC_ID, OtherResearch_ID= lpi.OtherResearch_ID, OtherResearch_Type = lpi.OtherResearch_Type, 
										InstitutionID = ISNULL(i.InstitutionID,1), InstitutionNameSubmitted = lpi.InstitutionNameSubmitted, UpdatedDate = getdate()
		FROM icrp_data.dbo.ProjectFundingInvestigator pi		
			JOIN icrp_data.dbo.ProjectFunding f ON pi.projectfundingid = f.ProjectFundingID
			JOIN icrp_dataload.dbo.ProjectFunding lf ON f.AltAwardCode = lf.AltAwardCode		
			JOIN (SELECT * FROM icrp_dataload.dbo.ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) lpi ON lf.ProjectFundingID = lpi.ProjectFundingID  -- only update PI
			JOIN icrp_dataload.dbo.Institution li ON li.InstitutionID = lpi.InstitutionID
			LEFT JOIN icrp_data.dbo.Institution i ON i.Name = li.Name AND i.City = li.City
		WHERE pi.IsPrincipalInvestigator=1 AND lf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	END
			
	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID
	
	-----------------------------------
				
	----------------------------------------------------------------------
	-- For Update - some records can be wiped out old and then re-imported 
	----------------------------------------------------------------------
	IF @Type = 'Update'
	BEGIN
		DELETE icrp_data.dbo.Project_ProjectType 
		FROM icrp_data.dbo.Project_ProjectType pt
			JOIN icrp_data.dbo.Project p ON pt.ProjectID = p.ProjectID			
		WHERE p.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data.dbo.ProjectCSO 
		FROM icrp_data.dbo.ProjectCSO cso
			JOIN icrp_data.dbo.ProjectFunding f ON cso.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data.dbo.ProjectCancerType 
		FROM icrp_data.dbo.ProjectCancerType ct
			JOIN icrp_data.dbo.ProjectFunding f ON ct.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data.dbo.ProjectFundingExt
		FROM icrp_data.dbo.ProjectFundingExt ext
			JOIN icrp_data.dbo.ProjectFunding f ON ext.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod
	
	END

	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	INSERT INTO icrp_data.dbo.ProjectCSO
	SELECT f.ProjectFundingID, cso.CSOCode, cso.Relevance, cso.RelSource, getdate(),getdate()
	FROM icrp_dataload.dbo.ProjectCSO cso
		JOIN icrp_dataload.dbo.projectfunding lf ON cso.ProjectFundingID =  lf.ProjectFundingID  
		JOIN icrp_data.dbo.projectfunding f ON f.AltAwardCode =  lf.AltAwardCode  
	WHERE lf.[DataUploadStatusID] = @DataUploadStatusID_Stage
	
	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-----------------------------------
	-- Import ProjectCancerType
	-----------------------------------
	INSERT INTO icrp_data.dbo.ProjectCancerType
		SELECT f.ProjectFundingID, lct.CancerTypeID, lct.Relevance, lct.RelSource, getdate(),getdate(),lct.EnterBy
		FROM icrp_dataload.dbo.ProjectCancerType lct
			JOIN icrp_dataload.dbo.projectfunding lf ON lct.ProjectFundingID =  lf.ProjectFundingID  
			JOIN icrp_data.dbo.projectfunding f ON f.AltAwardCode =  lf.AltAwardCode  
		WHERE lf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-----------------------------------
	-- Import Project_ProjectTye
	-----------------------------------
	INSERT INTO icrp_data.dbo.Project_ProjectType
	SELECT DISTINCT p.ProjectID, pt.ProjectType, getdate(),getdate()
	FROM icrp_dataload.dbo.Project_ProjectType pt
		JOIN icrp_dataload.dbo.Project lp ON pt.ProjectID = lp.ProjectID
		JOIN (SELECT * FROM icrp_data.dbo.Project WHERE DataUploadStatusID = @DataUploadStatusID_Prod) p ON lp.AwardCode = p.AwardCode	
	WHERE lp.[DataUploadStatusID] = @DataUploadStatusID_Stage

	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-----------------------------------
	-- Import ProjectFundingExt
	-----------------------------------
	INSERT INTO icrp_data.dbo.ProjectFundingExt
	SELECT new.ProjectFundingID, ex.CalendarYear, ex.CalendarAmount, getdate(),getdate()
	FROM icrp_dataload.dbo.ProjectFundingExt ex
		JOIN icrp_dataload.dbo.projectfunding pf ON ex.ProjectFundingID =  pf.ProjectFundingID  
		JOIN icrp_data.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	----------------------------------------------------
	-- Post Import Checking
	----------------------------------------------------	
	---- checking updated record counts	
	select 1 AS row INTO #mismatchUpdates
	FROM (SELECT * FROM icrp_data.dbo.DataUploadLog WHERE DataUploadStatusID = @DataUploadStatusID_Prod) p
		JOIN (SELECT * FROM icrp_dataload.dbo.DataUploadLog WHERE DataUploadStatusID = @DataUploadStatusID_Stage) s ON 1=1
	WHERE p.ProjectCount <> s.ProjectCount OR p.ProjectFundingCount <> s.ProjectFundingCount OR p.ProjectFundingInvestigatorCount <> s.ProjectFundingInvestigatorCount OR p.ProjectCSOCount <> s.ProjectCSOCount 
		OR p.ProjectCancerTypeCount <> s.ProjectCancerTypeCount OR p.Project_ProjectTypeCount <> s.Project_ProjectTypeCount OR p.ProjectAbstractCount <> s.ProjectAbstractCount OR p.ProjectSearchCount <> s.ProjectSearchCount
		
	IF EXISTS (select * FROM #mismatchUpdates)			
	BEGIN		
		RAISERROR ('Post Prod Sync Check - Mismatched Updated counts ==> Failed', 16, 1)
	END	

	---- checking Imported Award Sponsor	
	select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
		from icrp_data.dbo.projectfunding f 
			join icrp_data.dbo.FundingOrg o on o.FundingOrgID = f.FundingOrgID
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and o.SponsorCode <> @PartnerCode

	IF EXISTS (select * from #postSponsor)
	BEGIN		
		RAISERROR ('Post Prod Sync Check - Sponsor Code - Failed', 16, 1)
	END
		
	---- checking Missing PI	
	select f.altawardcode into #postNotmappedInst 
		from icrp_data.dbo.ProjectFundingInvestigator pi 
			join icrp_data.dbo.projectfunding f on pi.ProjectFundingID = f.ProjectFundingID			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.InstitutionID = 1

	IF EXISTS (select * from #postNotmappedInst)
	BEGIN		
		RAISERROR ('Post Prod Sync Check - Instititutions Mapping - Failed', 16, 1)
	END		
		
	---- checking Duplicate PI	
	select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
		from icrp_data.dbo.projectfunding f
			join icrp_data.dbo.projectfundinginvestigator i on f.projectfundingid = i.projectfundingid			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1
	
	IF EXISTS (select * FROM #postdupPI)		
	BEGIN		
		RAISERROR ('Post Prod Sync Check - DUplicate PIs ==> Failed', 16, 1)
	END	
		
	---- checking missing PI	
	select f.ProjectFundingID into #postMissingPI from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.ProjectFundingID is null
		
	IF EXISTS (select * FROM #postMissingPI)	
	BEGIN		
		RAISERROR ('Post Prod Sync Check - Missing PIs ==> Failed', 16, 1)
	END	
		
	---- checking missing CSO	
	select f.ProjectFundingID into #postMissingCSO from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectCSO pc on f.projectfundingid = pc.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pc.ProjectFundingID is null
	
	IF EXISTS (select * FROM #postMissingCSO)
	BEGIN
		RAISERROR ('Post Prod Sync Check - Missong CSOs ==> Failed', 16, 1)
	END		
		
	---- checking missing CancerType	
	select f.ProjectFundingID into #postMissingSite from icrp_data.dbo.projectfunding f
	left join icrp_data.dbo.ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and ct.ProjectFundingID is null

	
	IF EXISTS (select * FROM #postMissingSite)			
	BEGIN		
		RAISERROR ('Post Prod Sync Check - Missing CancerTypes -==> Failed', 16, 1)
	END	
		
-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
	DELETE icrp_data.dbo.ProjectSearch 		
	FROM  icrp_data.dbo.ProjectSearch s
		JOIN icrp_data.dbo.Project p ON s.ProjectID = p.ProjectID	
	WHERE p.DataUploadStatusID = @DataUploadStatusID_Prod	
		
	INSERT INTO icrp_data.dbo.ProjectSearch (ProjectID, [Content])
	SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
	FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract, a.PublicAbstract 
			FROM icrp_data.dbo.ProjectAbstract a
				JOIN icrp_data.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
				JOIN (SELECT ProjectID FROM icrp_data.dbo.Project WHERE DataUploadStatusID = @DataUploadStatusID_Prod) p ON f.ProjectID = p.ProjectID				
			GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

	SELECT @Count = @@ROWCOUNT
	UPDATE icrp_data.dbo.DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-------------------------------------------------------------------------------------------
	-- Insert DataUploadLog 
	--------------------------------------------------------------------------------------------			
	--IF @Type = 'New'
	--BEGIN
		
	--	-- Insert Project Count
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.Project	
	--	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert ProjectAbstractCount
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectAbstract a
	--		JOIN icrp_data.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	--	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID =	@DataUploadLogID

	--	-- Insert ProjectCSOCount
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectCSO c 
	--		JOIN icrp_data.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	--	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert ProjectCancerTypeCount Count
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectCancerType c 
	--		JOIN icrp_data.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	--	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert Project_ProjectType Count
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.Project_ProjectType t
	--		JOIN icrp_data.dbo.Project p ON t.ProjectID = p.ProjectID	
	--	WHERE p.dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert ProjectFundingCount
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectFunding 
	--	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert ProjectFundingInvestigatorCount Count
	--	SELECT @Count=COUNT(*) FROM icrp_data.dbo.ProjectFundingInvestigator pi
	--		JOIN icrp_data.dbo.ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
	--	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	--	-- Insert ProjectSearch TotalCount
	--	SELECT @Count=COUNT(*) FROM ProjectSearch

	--	UPDATE icrp_data.dbo.DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID
	--END

	-------------------------------------------------------------------------------------------
	-- Update FundingOrg LastImport Date/Desc
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
	
	-----------------------------------------------------------------
	-- Drop temp table
	-----------------------------------------------------------------
	IF object_id('UploadAbstractTemp') is NOT null
		drop table UploadAbstractTemp
			
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      --IF @@trancount > 0 	  
		ROLLBACK TRANSACTION
	        
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  


GO


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_RevertStageUpload]     Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
use icrp_dataload
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_RevertStageUpload]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_RevertStageUpload] 
GO 

CREATE PROCEDURE [dbo].[DataUpload_RevertStageUpload]    

@datauploadstatusid_stage INT,
@datauploadstatusid_prod INT

AS

SET NOCOUNT ON

--select * from datauploadstatus where datauploadstatusid = @datauploadstatusid_stage
--select * from icrp_data.dbo.datauploadstatus where datauploadstatusid = @datauploadstatusid_prod
--select * from datauploadlog where datauploadstatusid = @datauploadstatusid_stage
--select * from icrp_data.dbo.datauploadlog where datauploadstatusid = @datauploadstatusid_prod


BEGIN TRANSACTION
-- delete ProjectSearch
PRINT '-- delete ProjectSearch'

delete ProjectSearch 
from projectfunding f
join project p on p.projectid = f.projectid
join ProjectSearch s on p.projectid=s.ProjectID
where f.datauploadstatusid=@datauploadstatusid_stage


-- delete Project_ProjectType
PRINT '-- delete Project_ProjectType'

delete Project_ProjectType 
from project p 
join Project_ProjectType at on p.ProjectID = at.ProjectID
--join ProjectSearch s on p.projectid=s.ProjectID
where p.datauploadstatusid=@datauploadstatusid_stage

-- delete ProjectCancerType
PRINT '-- delete ProjectCancerType'

delete ProjectCancerType 
from  projectfunding f
join ProjectCancerType ct on f.ProjectFundingID = ct.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid_stage

-- delete ProjectCSO
PRINT '-- delete ProjectCSO'

delete ProjectCSO 
from  projectfunding f
join ProjectCSO c on f.ProjectFundingID = c.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid_stage


-- delete ProjectFundingInvestigator
PRINT '-- delete ProjectFundingInvestigator'

delete ProjectFundingInvestigator 
from  projectfunding f
join ProjectFundingInvestigator pi on f.ProjectFundingID = pi.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid_stage


-- delete ProjectFundingExt
PRINT '-- delete ProjectFundingExt'

DELETE ProjectFundingExt
from  projectfunding f
join ProjectFundingExt e ON f.ProjectFundingID = e.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid_stage


-- keep a copy of projectID / ProjectAbstractID
PRINT '-- keep a copy of projectID / ProjectAbstractID'

SELECT ProjectID INTO #ProjectID
from  project
where datauploadstatusid=@datauploadstatusid_stage

SELECT ProjectAbstractID INTO #ProjectAbstractID
from  projectfunding
where datauploadstatusid=@datauploadstatusid_stage


-- delete ProjectFunding
PRINT '-- delete ProjectFunding'

delete ProjectFunding 
where datauploadstatusid=@datauploadstatusid_stage

-- delete Project
PRINT '-- delete Project'

DELETE Project
where ProjectID IN (SELECT ProjectID FROM #ProjectID)


-- delete ProjectAbstract
PRINT '-- delete ProjectAbstract'

delete ProjectAbstract 
where ProjectAbstractID IN (SELECT ProjectAbstractID FROM #ProjectAbstractID)


-- delete RelatedProjects
-- Placeholder

-- delete RelatedSites
-- Placeholder



-- delete DataUploadStatus
Delete DataUploadLog WHERE DataUploadStatusID=@datauploadstatusid_stage
Delete icrp_data.dbo.DataUploadLog WHERE DataUploadStatusID=@datauploadstatusid_prod

Delete DataUploadStatus WHERE DataUploadStatusID=@datauploadstatusid_stage
Delete icrp_data.dbo.DataUploadStatus WHERE DataUploadStatusID=@datauploadstatusid_prod


--select top 5 * from datauploadstatus where datauploadstatusid = @datauploadstatusid_stage
--select top 5 * from icrp_data.dbo.datauploadstatus where datauploadstatusid = @datauploadstatusid_prod
--select top 5 * from datauploadlog where datauploadstatusid = @datauploadstatusid_stage
--select top 5 * from icrp_data.dbo.datauploadlog where datauploadstatusid = @datauploadstatusid_prod

Commit
--Rollback
GO
----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapRegionsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapRegionsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapRegionsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetMapRegionsBySearchID]  
@SearchID INT,
@AggregatedProjectCount INT OUTPUT,
@AggregatedPICount INT OUTPUT,
@AggregatedCollabCount INT OUTPUT  
AS   

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

	DECLARE @result TABLE
	(
		ProjectID INT
	)

	-- No filters. Return all counts - total related projects = 168423
	IF @SearchID = 0
	BEGIN
		INSERT INTO @result SELECT ProjectID FROM Project
	END
	ELSE  -- filtered results (based on searchID)
	BEGIN		
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID					

		INSERT INTO @result SELECT  [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
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
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	SELECT ProjectID INTO #base FROM @result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT c.RegionID, c.Abbreviation AS Country, i.City, f.ProjectFundingID, people.IsPrincipalInvestigator INTO #pf 
	FROM #base b		
		JOIN ProjectFunding f ON b.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  ((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND
			((@regionList IS NULL) OR (c.RegionID IN (SELECT VALUE AS RegionID FROM dbo.ToStrTable(@regionList)))) AND
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))	

	------------------------------------------------------------------------------
	--   Further filter on other seach criteria - years, cso, cancertype
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectCSO pc ON f.projectFundingID = pc.projectFundingID				
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
				JOIN ProjectCancerType pc ON f.projectFundingID = pc.projectFundingID				
			WHERE pc.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	
	------------------------------------------------------------------------------
	--   Get Region Stats
	------------------------------------------------------------------------------
	SELECT RegionID, Count(*) AS Count INTO #proj FROM (SELECT DISTINCT RegionID, ProjectFundingID FROM #pf) proj GROUP BY RegionID
	SELECT RegionID, Count(*) AS Count INTO #pi FROM (SELECT RegionID, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=1) p GROUP BY RegionID
	SELECT RegionID, Count(*) AS Count INTO #collab FROM (SELECT DISTINCT RegionID, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=0) collab GROUP BY RegionID

	-- Return RelatedProject Count, PI Count and collaborator Count by region
	SELECT r.RegionID, r.Name AS Region, ISNULL(p.Count, 0) AS TotalRelatedProjectCount, ISNULL(pi.Count,0) AS TotalPICount, ISNULL(c.Count, 0) AS TotalCollaboratorCount, r.Latitude, r.Longitude
	FROM #proj p
		LEFT JOIN #pi  pi ON p.RegionID = pi.RegionID
		LEFT JOIN #collab c ON p.RegionID = c.RegionID
		LEFT JOIN lu_Region r ON p.RegionID = r.RegionID
	ORDER BY p.Count DESC, pi.Count DESC, c.Count DESC, r.Name ASC

	SELECT @AggregatedProjectCount= Count(*) FROM (SELECT DISTINCT ProjectFundingID FROM #pf) proj
	SELECT @AggregatedPICount=SUM(Count) FROM #pi	
	SELECT @AggregatedCollabCount=SUM(Count) FROM #collab		

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapCountriesBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapCountriesBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapCountriesBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetMapCountriesBySearchID]  
@SearchID INT,
@RegionID INT,
@AggregatedProjectCount INT OUTPUT,
@AggregatedPICount INT OUTPUT,
@AggregatedCollabCount INT OUTPUT  
AS   

	DECLARE @ProjectIDs VARCHAR(max) 	
	DECLARE @CountryList VARCHAR(1000) = NULL
	DECLARE @cityList varchar(1000) = NULL 
	DECLARE @stateList varchar(1000) = NULL		
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

	DECLARE @result TABLE
	(
		ProjectID INT
	)

	-- No filters. Return all counts - total related projects = 168423
	IF @SearchID = 0
	BEGIN
		INSERT INTO @result SELECT ProjectID FROM Project
	END
	ELSE  -- filtered results (based on searchID)
	BEGIN		
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID					

		INSERT INTO @result SELECT  [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,
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
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	SELECT ProjectID INTO #base FROM @result

	----------------------------------		
	--   Filter on related projects
	----------------------------------
	SELECT DISTINCT c.RegionID, c.Abbreviation AS Country, i.City, f.ProjectFundingID, people.IsPrincipalInvestigator INTO #pf 
	FROM #base b		
		JOIN ProjectFunding f ON b.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE (c.RegionID = @RegionID) AND
			((@CountryList IS NULL) OR (i.[Country] IN (SELECT VALUE AS Country FROM dbo.ToStrTable(@countryList)))) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND			
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))	

	------------------------------------------------------------------------------
	--   Further filter on other seach criteria - years, cso, cancertype
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectCSO pc ON f.projectFundingID = pc.projectFundingID				
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
				JOIN ProjectCancerType pc ON f.projectFundingID = pc.projectFundingID				
		WHERE pc.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END


	----------------------------------		
	--   Get Region Stats
	----------------------------------	
	SELECT Country, Count(*) AS Count INTO #proj FROM (SELECT DISTINCT Country, ProjectFundingID FROM #pf) proj GROUP BY Country
	SELECT Country, Count(*) AS Count INTO #pi FROM (SELECT Country, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=1) p GROUP BY Country
	SELECT Country, Count(*) AS Count INTO #collab FROM (SELECT DISTINCT Country, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=0) collab GROUP BY Country

	-- Return RelatedProject Count, PI Count and collaborator Count by region
	SELECT ctry.Name AS Country, ctry.Abbreviation, ISNULL(p.Count, 0) AS TotalRelatedProjectCount, ISNULL(pi.Count,0) AS TotalPICount, ISNULL(c.Count, 0) AS TotalCollaboratorCount, ctry.Latitude, ctry.Longitude
	FROM #proj p
		JOIN Country ctry ON ctry.Abbreviation = p.Country
		LEFT JOIN #pi  pi ON p.Country = pi.Country
		LEFT JOIN #collab c ON p.Country = c.Country		
	ORDER BY p.Count DESC, pi.Count DESC, c.Count DESC, ctry.Name ASC

	SELECT @AggregatedProjectCount= Count(*) FROM (SELECT DISTINCT ProjectFundingID FROM #pf) proj
	SELECT @AggregatedPICount=SUM(Count) FROM #pi	
	SELECT @AggregatedCollabCount=SUM(Count) FROM #collab	
	
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapCitiesBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapCitiesBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapCitiesBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetMapCitiesBySearchID]  
@SearchID INT,
@RegionID INT,
@Country VARCHAR(2),
@AggregatedProjectCount INT OUTPUT,
@AggregatedPICount INT OUTPUT,
@AggregatedCollabCount INT OUTPUT  

AS   
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

	DECLARE @result TABLE
	(
		ProjectID INT
	)

	-- No filters. Return all counts - total related projects = 168423
	IF @SearchID = 0
	BEGIN
		INSERT INTO @result SELECT ProjectID FROM Project
	END
	ELSE  -- filtered results (based on searchID)
	BEGIN		
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID					

		INSERT INTO @result SELECT  [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,				
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,
				@cityList = cityList,
				@stateList = stateList,				
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END
	
	SELECT ProjectID INTO #base FROM @result

	----------------------------------		
	--   Find all related projects 
	----------------------------------
	SELECT DISTINCT f.ProjectFundingID, c.RegionID, c.Abbreviation AS Country, i.City, i.State, people.IsPrincipalInvestigator INTO #pf 
	FROM #base b		
		JOIN ProjectFunding f ON b.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  (c.Abbreviation = @Country ) AND (c.RegionID = @RegionID) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND
			((@cityList IS NULL) OR (i.City IN (SELECT VALUE AS City FROM dbo.ToStrTable(@cityList)))) AND
			((@stateList IS NULL) OR (i.State IN (SELECT VALUE AS State FROM dbo.ToStrTable(@stateList))))  AND			
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))	

	------------------------------------------------------------------------------
	--   Further filter on other seach criteria - years, cso, cancertype
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectCSO pc ON f.projectFundingID = pc.projectFundingID				
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
				JOIN ProjectCancerType pc ON f.projectFundingID = pc.projectFundingID				
			WHERE pc.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	------------------------------------------------------------------------------
	--   Get City Stats in that country
	------------------------------------------------------------------------------
	SELECT City, Country, State, Count(*) AS Count INTO #proj FROM (SELECT DISTINCT City, Country, State, ProjectFundingID FROM #pf) proj GROUP BY Country, City, State
	SELECT City, Country, State, Count(*) AS Count INTO #pi FROM (SELECT City, Country, State, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=1) p GROUP BY Country, City, State
	SELECT City, Country, State, Count(*) AS Count INTO #collab FROM (SELECT DISTINCT City, Country, State, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=0) collab GROUP BY Country, City, State

	-- Return RelatedProject Count, PI Count and collaborator Count by region
	SELECT p.City, p.State,
		CASE ISNULL(p.State, '')
			WHEN '' THEN p.City	ELSE p.City + ', ' + ISNULL(p.State, '') 
		END AS DisplayedCity,
		ISNULL(p.Count, 0) AS TotalRelatedProjectCount, ISNULL(pi.Count,0) AS TotalPICount, ISNULL(c.Count, 0) AS TotalCollaboratorCount, city.Latitude, city.Longitude
		FROM #proj p
			--JOIN Country ctry ON ctry.Abbreviation = p.City
			LEFT JOIN #pi  pi ON p.City = pi.City AND ISNULL(p.State, '')  = ISNULL(pi.State, '')
			LEFT JOIN #collab c ON p.City = c.City	AND ISNULL(p.State, '')  = ISNULL(c.State, '')
			LEFT JOIN lu_City city ON city.Country = @Country AND city.Name = p.CIty AND ISNULL(city.State, '')  = ISNULL(p.State, '')
		ORDER BY p.Count DESC, pi.Count DESC, c.Count DESC, p.City ASC

	SELECT @AggregatedProjectCount= Count(*) FROM (SELECT DISTINCT ProjectFundingID FROM #pf) proj
	SELECT @AggregatedPICount=SUM(Count) FROM #pi	
	SELECT @AggregatedCollabCount=SUM(Count) FROM #collab	

GO	

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapInstitutionsBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapInstitutionsBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapInstitutionsBySearchID]
GO 

CREATE PROCEDURE [dbo].[GetMapInstitutionsBySearchID]  
@SearchID INT,
@RegionID INT,
@Country VARCHAR(2),
@City VARCHAR(50),
@State VARCHAR(50) = NULL,
@AggregatedProjectCount INT OUTPUT,
@AggregatedPICount INT OUTPUT,
@AggregatedCollabCount INT OUTPUT  
AS   

DECLARE @ProjectIDs VARCHAR(max)	
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

	DECLARE @result TABLE
	(
		ProjectID INT
	)

	-- No filters. Return all counts - total related projects = 168423
	IF @SearchID = 0
	BEGIN
		INSERT INTO @result SELECT ProjectID FROM Project
	END
	ELSE  -- filtered results (based on searchID)
	BEGIN		
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID					

		INSERT INTO @result SELECT  [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)

		-- get search criteria to filter project funding records
		SELECT @YearList = YearList,				
				@CSOlist = CSOlist,
				@CancerTypelist = CancerTypelist,
				@InvestigatorType = InvestigatorType,
				@institution = institution,
				@piLastName = piLastName,
				@piFirstName = piFirstName,
				@piORCiD = piORCiD,				
				@FundingOrgTypeList = FundingOrgTypeList,
				@fundingOrgList = fundingOrgList 
		FROM SearchCriteria WHERE SearchCriteriaID = @SearchID

	END

	SELECT ProjectID INTO #base FROM @result
	
	----------------------------------		
	--   Find all related projects 
	----------------------------------		
	SELECT DISTINCT i.InstitutionID, i.Name AS Institution, i.City, f.ProjectFundingID, people.IsPrincipalInvestigator INTO #pf 
	FROM #base b		
		JOIN ProjectFunding f ON b.ProjectID = f.ProjectID	
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID		
		JOIN ProjectFundingInvestigator people ON f.projectFundingID = people.projectFundingID	  -- find pi and collaborators
		JOIN Institution i ON i.InstitutionID = people.InstitutionID		
		JOIN (SELECT InstitutionID, projectFundingID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi ON f.projectFundingID = pi.projectFundingID	  -- find PI country		
		JOIN Institution pii ON pi.InstitutionID = pii.InstitutionID		-- get PI country
		JOIN Country c ON c.Abbreviation = i.Country
	 WHERE  (c.Abbreviation = @Country ) AND (c.RegionID = @RegionID) AND (i.City = @City) AND (ISNULL(i.State, '') = ISNULL(@State,'')) AND
			((@InvestigatorType IS NULL) OR (@InvestigatorType = 'PI' AND people.IsPrincipalInvestigator = 1) OR (@InvestigatorType = 'Collab' AND ISNULL(people.IsPrincipalInvestigator, 0) = 0)) AND   -- Search only PI, Collaborators or all
			((@institution IS NULL) OR (i.Name like '%'+ @institution +'%')) AND			
			((@piLastName IS NULL) OR (people.LastName like '%'+ @piLastName +'%')) AND 
			((@piFirstName IS NULL) OR (people.FirstName like '%'+ @piFirstName +'%')) AND
			((@piORCiD IS NULL) OR (people.ORC_ID like '%'+ @piORCiD +'%')) AND			
			((@fundingOrgList IS NULL) OR (o.FundingOrgID IN (SELECT VALUE AS OrgID FROM dbo.ToStrTable(@fundingOrgList)))) AND
			((@FundingOrgTypeList IS NULL) OR (o.Type IN (SELECT VALUE AS type FROM dbo.ToStrTable(@FundingOrgTypeList))))		

	------------------------------------------------------------------------------
	--   Further filter on other seach criteria - years, cso, cancertype
	------------------------------------------------------------------------------
	IF @YearList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectFundingExt ext ON f.ProjectFundingID = ext.ProjectFundingID			
				WHERE ext.CalendarYear IN (SELECT VALUE AS Year FROM dbo.ToStrTable(@YearList)))
		
	IF @CSOList IS NOT NULL
		DELETE #pf WHERE ProjectFundingID NOT IN
			(SELECT f.ProjectFundingID FROM  #pf f
				JOIN ProjectCSO pc ON f.projectFundingID = pc.projectFundingID				
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
				JOIN ProjectCancerType pc ON f.projectFundingID = pc.projectFundingID				
		WHERE pc.CancerTypeID IN (SELECT CancerTypeID FROM #ctlist))
	END

	SELECT InstitutionID, Institution, Count(*) AS Count INTO #proj FROM (SELECT DISTINCT InstitutionID, Institution, ProjectFundingID FROM #pf) proj GROUP BY InstitutionID, Institution
	SELECT InstitutionID, Institution, Count(*) AS Count INTO #pi FROM (SELECT InstitutionID, Institution, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=1) p GROUP BY InstitutionID, Institution
	SELECT InstitutionID, Institution, Count(*) AS Count INTO #collab FROM (SELECT DISTINCT InstitutionID, Institution, ProjectFundingID FROM #pf WHERE IsPrincipalInvestigator=0) collab GROUP BY InstitutionID, Institution

	-- Return RelatedProject Count, PI Count and collaborator Count by region
	SELECT p.InstitutionID, p.Institution, ISNULL(p.Count, 0) AS TotalRelatedProjectCount, ISNULL(pi.Count,0) AS TotalPICount, ISNULL(c.Count, 0) AS TotalCollaboratorCount, i.Latitude, i.Longitude--, ctry.Latitude, ctry.Longitude
	FROM #proj p
		--JOIN Country ctry ON ctry.Abbreviation = p.City
		LEFT JOIN #pi  pi ON p.InstitutionID  = pi.InstitutionID
		LEFT JOIN #collab c ON c.InstitutionID = p.InstitutionID
		LEFT JOIN Institution i on p.InstitutionID = i.InstitutionID
	ORDER BY p.Count DESC, pi.Count DESC, c.Count DESC, p.Institution ASC

	SELECT @AggregatedProjectCount= Count(*) FROM (SELECT DISTINCT ProjectFundingID FROM #pf) proj
	SELECT @AggregatedPICount=SUM(Count) FROM #pi	
	SELECT @AggregatedCollabCount=SUM(Count) FROM #collab		
GO	
	

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddNewSearchBySearchID]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddNewSearchBySearchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddNewSearchBySearchID]
GO 

CREATE PROCEDURE [dbo].[AddNewSearchBySearchID]  
@SearchID INT,
@RegionID INT = NULL,
@Country VARCHAR(3) = NULL,
@City VARCHAR(50) = NULL,
@InstitutionID INT = NULL,
@searchCriteriaID INT OUTPUT,  -- return the searchID	
@ResultCount INT OUTPUT  -- return the searchID		
AS   

	DECLARE @project TABLE
	(
		ProjectID INT

	)
		
	IF @SearchID = 0  -- No filters. Return all projects 
	BEGIN
		INSERT INTO @project SELECT ProjectID FROM Project 
	END
	ELSE  -- filtered projects (based on searchID)
	BEGIN
		DECLARE @ProjectIDs VARCHAR(max) 	
		SELECT @ProjectIDs = Results FROM SearchResult WHERE SearchCriteriaID = @SearchID					
		
		INSERT INTO @project SELECT [VALUE] AS ProjectID FROM dbo.ToIntTable(@ProjectIDs)
	END

	-- Further drill down - Filter on Region, Country or City
	SELECT p.ProjectID, pf.Projectfundingid, pf.BudgetEndDate INTO #Proj
		FROM @project p
			JOIN ProjectFunding pf ON pf.ProjectID = p.ProjectID
			JOIN ProjectFundingInvestigator pi ON pf.ProjectFundingID = pi.ProjectFundingID  -- only get pi			
			JOIN Institution i ON pi.InstitutionID = i.InstitutionID
			JOIN Country c ON i.Country = c.Abbreviation			
		WHERE (@RegionID IS NULL OR @RegionID = c.RegionID) AND (@Country IS NULL OR @Country = i.Country) AND (@City IS NULL OR @City = i.City) AND (@InstitutionID IS NULL OR @InstitutionID = i.InstitutionID)
		
	----------------------------------
	-- Save search criteria
	----------------------------------	
	DECLARE @ProjectIDList VARCHAR(max) = '' 	
	DECLARE @TotalRelatedProjectCount INT
	DECLARE @LastBudgetYear INT

	SELECT @TotalRelatedProjectCount=COUNT(*) FROM (SELECT DISTINCT Projectfundingid FROM #Proj) pf

	SELECT DISTINCT ProjectID INTO #baseProj FROM #proj	
	SELECT @ResultCount=COUNT(*) FROM #baseProj	
	SELECT @LastBudgetYear=DATEPART(year, MAX(BudgetEndDate)) FROM #proj


	SELECT @ProjectIDList = @ProjectIDList + 
           ISNULL(CASE WHEN LEN(@ProjectIDList) = 0 THEN '' ELSE ',' END + CONVERT( VarChar(20), ProjectID), '')
	FROM #baseProj	

	DECLARE @InstitutionName VARCHAR(250)
	IF @InstitutionID IS NOT NULL
		SELECT @InstitutionName = Name FROM Institution WHERE InstitutionID = @InstitutionID

	IF @SearchID=0
	BEGIN
	INSERT INTO SearchCriteria ([cityList],[countryList],[RegionList], [institution])
		SELECT @City, @Country,@RegionID, @InstitutionName		
	END
	ELSE
	BEGIN	  

		INSERT INTO SearchCriteria ([termSearchType],[terms],[piLastName],[piFirstName],[piORCiD],[awardCode],
			[yearList], [stateList],[fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [IsChildhood], 
			[institution], [cityList], [countryList], [RegionList])

			SELECT [termSearchType],[terms],[piLastName],[piFirstName],[piORCiD],[awardCode],
				[yearList], [stateList], [fundingOrgList],[cancerTypeList],[projectTypeList],[CSOList], [FundingOrgTypeList], [IsChildhood],

				CASE
				WHEN @InstitutionName IS NULL THEN [institution]
				ELSE @InstitutionName END,				
				
				CASE
				WHEN @City IS NULL THEN [cityList]
				ELSE @City END,
				
				CASE
				WHEN @Country IS NULL THEN [countryList]
				ELSE @Country END,

				CASE
				WHEN @RegionID IS NULL THEN [RegionList]
				ELSE @RegionID END		
				
			FROM SearchCriteria WHERE SearchCriteriaID = @SearchID
	END									 
	SELECT @searchCriteriaID = SCOPE_IDENTITY()		
		
	INSERT INTO SearchResult (SearchCriteriaID, Results,ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent) VALUES ( @searchCriteriaID, @ProjectIDList, @ResultCount, @TotalRelatedProjectCount, @LastBudgetYear, 0)	
	
GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapLayers]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapLayers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapLayers]
GO 

CREATE PROCEDURE [dbo].[GetMapLayers]  
		
AS   

	SELECT l.[MapLayerID], p.Name AS GroupName, l.[Name], l.DisplayedName, l.[Summary],l.[Description], l.[DataSource], 
		CASE 
		WHEN g.ChildrenCount IS NULL THEN 'n' ELSE 'y' END AS HasChildren 
	FROM lu_MapLayer l	
		LEFT JOIN lu_MapLayer p ON l.[ParentMapLayerID] = p.MapLayerID
		LEFT JOIN (SELECT [ParentMapLayerID], count(*) AS ChildrenCount FROM lu_MapLayer GROUP BY [ParentMapLayerID]) g ON g.[ParentMapLayerID] = l.MapLayerID	
	 ORDER BY p.MapLayerID, l.Name
GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapLayerLegend]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapLayerLegend]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetMapLayerLegend]
GO 

CREATE PROCEDURE [dbo].[GetMapLayerLegend]  
	@MapLayerID	INT
AS   

SELECT * FROM
	(
		SELECT MapLayerLegendID, LegendName, LegendColor, DisplayOrder FROM lu_MapLayerLegend WHERE MapLayerID = @MapLayerID
		UNION
		SELECT MapLayerLegendID, LegendName, LegendColor, DisplayOrder FROM lu_MapLayerLegend WHERE MapLayerLegendID = 0
	) l
	ORDER BY DisplayOrder

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetMapLayerByCountry]    Script Date: 12/14/2016 4:21:47 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetMapLayerByCountry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].GetMapLayerByCountry
GO 

CREATE PROCEDURE [dbo].GetMapLayerByCountry  
	@MapLayerID	INT
AS   

	SELECT Country, MapLayerLegendID FROM CountryMapLayer WHERE MapLayerID = @MapLayerID	
		
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

	SELECT PartnerID, [Name],SponsorCode,Status,[Description],[Country],[Website],CAST([JoinedDate] AS DATE)AS JoinDate, email, IsDSASigned, latitude, longitude, LogoFile, Note
	FROM [Partner]
	ORDER BY SponsorCode

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetNonPartners]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetNonPartners]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetNonPartners]
GO 

CREATE  PROCEDURE [dbo].[GetNonPartners]
AS   

	SELECT [NonPartnerID], [Name], [Description], [Abbreviation], [Email], [Country], [Longitude],[Latitude],[Website], [LogoFile], [Note], [EstimatedInvest], [ContactPerson],[Position], [DoNotContact], [CancerOnly],[ResearchFunder]
	FROM [NonPartner] WHERE ConvertedDate is NULL  -- exclude those already converted to partner
	ORDER BY [Name]

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddPartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPartner]
GO 

CREATE  PROCEDURE [dbo].[AddPartner]	
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@Status [varchar](25) = 'Current',
	@PartnerID INT OUTPUT  -- return the newly inserted partnerID	
AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM Partner WHERE SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	INSERT INTO Partner ([Name],[Description], [SponsorCode], [Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate], [Latitude], [Longitude], Status, [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Description, @SponsorCode, @Email, @IsDSASigned,@Country, @Website,	@LogoFile, @Note,@JoinedDate, @Latitude, @Longitude, @Status, GETDATE(), GETDATE())

	SELECT @PartnerID = SCOPE_IDENTITY()
		
	-- Also insert the new partner into the PartnerOrg table
	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
	SELECT @Name, @SponsorCode, 'Partner', 1 

	-- Also Insert the newly inserted partner into the icrp_dataload database
	INSERT INTO icrp_dataload.dbo.Partner ([Name], [Description],[SponsorCode],[Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate], [Latitude], [Longitude], Status, [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Description, @SponsorCode, @Email, @IsDSASigned,@Country, @Website,	@LogoFile, @Note,@JoinedDate, @Latitude, @Longitude, @Status, GETDATE(), GETDATE())

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddNonPartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddNonPartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddNonPartner]
GO 

CREATE  PROCEDURE [dbo].[AddNonPartner]	
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),	
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),	
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@EstimatedInv [varchar](200),
	@DoNotContact bit,
	@CancerOnly bit,
	@ResearchFunder bit,
	@ContactPerson [varchar](200),
	@Position [varchar](100)

AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM Partner WHERE SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	INSERT INTO NonPartner ([Name],[Description],[Abbreviation],[Email],[Country],[Latitude], [Longitude],[Website],[LogoFile],[Note],[EstimatedInvest],[ContactPerson],[Position],[DoNotContact],[CancerOnly],[ResearchFunder],[CreatedDate],[UpdatedDate] )
	VALUES (@Name, @Description, @SponsorCode, @Email, @Country, @Latitude, @Longitude, @Website, @LogoFile, @Note,@EstimatedInv, @ContactPerson,@Position, @DoNotContact, @CancerOnly,	@ResearchFunder, GETDATE(), GETDATE())

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdatePartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdatePartner]
GO 

CREATE  PROCEDURE [dbo].[UpdatePartner]
	@PartnerID INT,
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@Status [varchar](25) = 'Current'
AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	DECLARE @OrgSponsorCode [varchar](50)
	SELECT @OrgSponsorCode = SponsorCode FROM Partner WHERE PartnerID =  @PartnerID

	IF EXISTS (SELECT 1 FROM Partner WHERE PartnerID <> @PartnerID AND SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	UPDATE Partner SET [Name] = @Name,
		[Description]  = @Description,
		[SponsorCode]  = @SponsorCode,
		[Email]  = @Email,
		[IsDSASigned] = @IsDSASigned,
		[Country] = @Country,
		[Website] = @Website,
		[LogoFile] = @LogoFile,
		[Note]  = @Note,
		[JoinedDate]  = @JoinedDate,	
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[Status] = @Status,
		[UpdatedDate] = getdate()
	WHERE PartnerID =  @PartnerID

	-- Also update icrp_dataload database
	UPDATE icrp_dataload.dbo.Partner SET [Name] = @Name,
		[Description]  = @Description,
		[SponsorCode]  = @SponsorCode,
		[Email]  = @Email,
		[IsDSASigned] = @IsDSASigned,
		[Country] = @Country,
		[Website] = @Website,
		[LogoFile] = @LogoFile,
		[Note]  = @Note,
		[JoinedDate]  = @JoinedDate,	
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[Status] = @Status,
		[UpdatedDate] = getdate()
	WHERE [SponsorCode] =  @OrgSponsorCode

	-- Also update other tables if the SponsorCode is changed
	IF (@SponsorCode <> @OrgSponsorCode)
	BEGIN
		UPDATE FundingOrg SET SponsorCode = @SponsorCode WHERE SponsorCode=@OrgSponsorCode
		UPDATE PartnerOrg SET SponsorCode = @SponsorCode WHERE SponsorCode=@OrgSponsorCode
	END

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdateNonPartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateNonPartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateNonPartner]
GO 

CREATE  PROCEDURE [dbo].[UpdateNonPartner]	
	@NonPartnerID int,
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),	
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),	
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6),
	@EstimatedInv [varchar](200),
	@DoNotContact bit,
	@CancerOnly bit,
	@ResearchFunder bit,
	@ContactPerson [varchar](200),
	@Position [varchar](100)

AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	SET NOCOUNT ON;
	
	DECLARE @OrgSponsorCode [varchar](50)
	SELECT @OrgSponsorCode = Abbreviation FROM NonPartner WHERE NonPartnerID =  @NonPartnerID

	IF EXISTS (SELECT 1 FROM Partner WHERE SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	UPDATE NonPartner SET 
		[Name] = @Name,
		[Description]  = @Description,
		[Abbreviation]  = @SponsorCode,
		[Email]  = @Email,		
		[Country] = @Country,
		[Website] = @Website,
		[LogoFile] = @LogoFile,
		[Note]  = @Note,		
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		EstimatedInvest = @EstimatedInv,
		DoNotContact  = @DoNotContact,
		CancerOnly = @CancerOnly,
		ResearchFunder= @ResearchFunder,
		ContactPerson  = @ContactPerson,
		Position  = @Position,		
		[UpdatedDate] = getdate()
	WHERE NonPartnerID =  @NonPartnerID

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddFundingOrg]								****************/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddFundingOrg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddFundingOrg]
GO 

CREATE  PROCEDURE [dbo].[AddFundingOrg]	
	@PartnerID INT,
	@Name [varchar](100),
	@Abbreviation [varchar](15),
	@Type [varchar](25),
	@Country [varchar](3),
	@Currency [varchar](3),	
	@MemberType [varchar](25),
	@MemberStatus [nchar](10),
	@IsAnnualized [bit],
	@Note [varchar](8000),
	@Website [varchar](200) ,
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6)	
AS   


BEGIN TRANSACTION;
BEGIN TRY    	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Return error if the  abbreviation already exist within the same sponsorcode
	DECLARE @SponsorCode [varchar](50)
	SELECT @SponsorCode = SponsorCode FROM Partner WHERE PartnerID =  @PartnerID

	IF EXISTS (SELECT 1 FROM FundingOrg WHERE SponsorCode = @SponsorCode AND Abbreviation = @Abbreviation)
	BEGIN
		   RAISERROR ('Funding Org Abbreviation already existed for the partner.', 16, 1)
	END

	INSERT INTO FundingOrg ([Name], Abbreviation, [Type],[Country], [Currency], [SponsorCode], 	[MemberType], [MemberStatus], [IsAnnualized],[Note], [Website],	[Latitude],	[Longitude],[CreatedDate], [UpdatedDate])
	VALUES (@Name, @Abbreviation, @Type, @Country, @Currency, @SponsorCode, @MemberType, @MemberStatus,	ISNULL(@IsAnnualized, 0), @Note, @Website, @Latitude, @Longitude, GETDATE(), GETDATE())
	

	-- Also Insert the new fundingorg into the PartnerOrg table
	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
	VALUES (@Name, @SponsorCode, 'Associate', 1)

	-- Also insert the new fundingorg into the icrp_dataload database
	INSERT INTO icrp_dataload.dbo.FundingOrg ([Name], Abbreviation, [Type],[Country], [Currency], [SponsorCode], 	[MemberType], [MemberStatus], [IsAnnualized],[Note], [Website],	[Latitude],	[Longitude], [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Abbreviation, @Type, @Country, @Currency, @SponsorCode, @MemberType, @MemberStatus,	ISNULL(@IsAnnualized, 0), @Note, @Website, @Latitude, @Longitude, GETDATE(), GETDATE())
	
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdateFundingOrg]								****************/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateFundingOrg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateFundingOrg]
GO 

CREATE  PROCEDURE [dbo].[UpdateFundingOrg]
	@FundingOrgID INT,
	@Name [varchar](100),
	@Abbreviation [varchar](15),
	@Type [varchar](25),
	@Country [varchar](3),
	@Currency [varchar](3),	
	@MemberType [varchar](25),
	@MemberStatus [nchar](10),
	@IsAnnualized [bit],
	@Note [varchar](8000),
	@Website [varchar](200) ,
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6)	
AS   


BEGIN TRANSACTION;
BEGIN TRY    	

	DECLARE @OrgAbbrev [varchar](50)
	DECLARE @SponsorCode [varchar](50)
	SELECT @OrgAbbrev = Abbreviation, @SponsorCode = SponsorCode FROM FundingOrg WHERE FundingOrgID =  @FundingOrgID

	-- Return error if the  abbreviation already exist within the same sponsorcode
	IF EXISTS (SELECT 1 FROM FundingOrg WHERE FundingOrgID <> @FundingOrgID AND SponsorCode = @SponsorCode AND Abbreviation = @Abbreviation)
	BEGIN
		   RAISERROR ('Funding Org Abbreviation already existed for the partner.', 16, 1)
	END

	UPDATE FundingOrg SET [Name] = @Name,		
		Abbreviation  = @Abbreviation,		
		[Type] = @Type,
		[Country] = @Country,
		[Currency] = @Currency,
		[MemberType] = @MemberType,
		[MemberStatus] = @MemberStatus,
		[IsAnnualized] = ISNULL(@IsAnnualized, 0),		
		[Note]  = @Note,
		[Website] = @Website,		
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE FundingOrgID =  @FundingOrgID

	-- Also update the icrp_dataload database
	UPDATE icrp_dataload.dbo.FundingOrg SET [Name] = @Name,		
		Abbreviation  = @Abbreviation,		
		[Type] = @Type,
		[Country] = @Country,
		[Currency] = @Currency,
		[MemberType] = @MemberType,
		[MemberStatus] = @MemberStatus,
		[IsAnnualized] = ISNULL(@IsAnnualized, 0),		
		[Note]  = @Note,
		[Website] = @Website,		
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE SponsorCode = @SponsorCode AND Abbreviation = @OrgAbbrev
		
	-- Also update PartnerOrg	- from User Registration
	UPDATE PartnerOrg SET Name = @Name, IsActive = 
	CASE 
		WHEN @MemberStatus = 'Current' THEN '1'  -- Current Member
		ELSE '0' END             -- Former Member
	WHERE SponsorCode=@SponsorCode AND Name = @Name	
	
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddLibraryFile]										****************/
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddLibraryFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddLibraryFile]
GO 

CREATE PROCEDURE [dbo].[AddLibraryFile](
	@LibraryFolderID INT,
	@Title VARCHAR(150),
	@Description VARCHAR(1000),
	@IsPublic BIT,
	@Filename VARCHAR(150),
	@ThumbnailFilename VARCHAR(150),
	@DisplayName VARCHAR(150)
) AS
	BEGIN TRANSACTION;
	BEGIN TRY    	
		SET NOCOUNT ON;
		DECLARE @ArchivedDate DATETIME;
		DECLARE @FileExtension VARCHAR(5) = RIGHT(@Filename,LEN(@Filename)-CHARINDEX('.',@Filename));
		SELECT @ArchivedDate=(CASE WHEN ArchivedDate IS NULL THEN NULL ELSE GETDATE() END) FROM LibraryFolder WHERE LibraryFolderID=@LibraryFolderID;
		INSERT INTO Library (Title,LibraryFolderID,Filename,ThumbnailFilename,Description,IsPublic,ArchivedDate,DisplayName) VALUES (@Title,@LibraryFolderID,@Filename,@ThumbnailFilename,@Description,@IsPublic,@ArchivedDate,@DisplayName);
		DECLARE @LibraryID INT = SCOPE_IDENTITY();
		IF @ThumbnailFilename IS NULL
			UPDATE Library SET Filename=CONCAT(@LibraryID,'.',@FileExtension) WHERE LibraryID=@LibraryID
		ELSE BEGIN
			DECLARE @ThumbExtension VARCHAR(5) = RIGHT(@ThumbnailFilename,LEN(@ThumbnailFilename)-CHARINDEX('.',@ThumbnailFilename));
			UPDATE Library SET Filename=CONCAT(@LibraryID,'.',@FileExtension),ThumbnailFilename=CONCAT(@LibraryID,'.',@ThumbExtension) WHERE LibraryID=@LibraryID;
		END;
		SELECT * FROM LIBRARY WHERE LibraryID=@LibraryID;
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @msg nvarchar(2048) = error_message()  
		RAISERROR (@msg, 16, 1)
	END CATCH;

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdateLibraryFile]										****************/
----------------------------------------------------------------------------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateLibraryFile]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateLibraryFile]
GO 

CREATE PROCEDURE [dbo].[UpdateLibraryFile](
	@LibraryID INT,
	@LibraryFolderID INT,
	@Title VARCHAR(150),
	@Description VARCHAR(1000),
	@IsPublic BIT,
	@Filename VARCHAR(150),
	@DisplayName VARCHAR(150)
) AS
	BEGIN TRANSACTION;
	BEGIN TRY    	
		SET NOCOUNT ON;
		UPDATE Library SET LibraryFolderID=@LibraryFolderID, Title=@Title, Description=@Description, IsPublic=@IsPublic, UpdatedDate=GETDATE(), DisplayName=@DisplayName WHERE LibraryID=@LibraryID;
		IF @Filename IS NOT NULL BEGIN
			DECLARE @FileExtension VARCHAR(5) = RIGHT(@Filename,LEN(@Filename)-CHARINDEX('.',@Filename));
			UPDATE Library SET Filename=CONCAT(@LibraryID,'.',@FileExtension) WHERE LibraryID=@LibraryID;
		END;
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		DECLARE @msg nvarchar(2048) = error_message()  
		RAISERROR (@msg, 16, 1)
	END CATCH;
	SELECT * FROM LIBRARY WHERE LibraryID=@LibraryID;
GO

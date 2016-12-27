USE [ICRP_Data]
GO


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
	@CSOList varchar(4000) = NULL -- string
AS   

DECLARE @searchWords VARCHAR(1000)

SELECT @searchWords = 
CASE @termSearchType
	WHEN 'Exact' THEN '"'+ @terms + '"'
	WHEN 'Any' THEN REPLACE(@terms,' ',' OR ')
	ELSE REPLACE(@terms,' ',' AND ') -- All or None	
END 

SELECT * FROM vwProjects p
--JOIN ProjectDocument d ON p.projectID = d.ProjectID  -- comment out for now
WHERE (@institution IS NULL OR institution like '%'+ @institution +'%') AND
	(@piLastName IS NULL OR piLastName like '%'+ @piLastName +'%') AND
	(@piFirstName IS NULL OR piFirstName like '%'+ @piFirstName +'%') AND
	(@piORCiD IS NULL OR piORCiD like '%'+ @piORCiD +'%') AND
	(@awardCode IS NULL OR AwardCode like '%'+ @awardCode +'%') AND
	(@cityList IS NULL OR city IN (SELECT * FROM dbo.ToStrTable(@cityList))) AND
	(@stateList IS NULL OR state IN (SELECT * FROM dbo.ToStrTable(@stateList))) AND
	(@countryList IS NULL OR country IN (SELECT * FROM dbo.ToStrTable(@countryList))) AND
	(@fundingOrgList IS NULL OR FundingOrgID IN (SELECT * FROM dbo.ToIntTable(@fundingOrgList))) AND
	(@cancerTypeList IS NULL OR CancerType IN (SELECT * FROM dbo.ToIntTable(@cancerTypeList))) AND
	(@projectTypeList IS NULL OR ProjectType IN (SELECT * FROM dbo.ToStrTable(@projectTypeList))) AND
	(@CSOList IS NULL OR CSOCode IN (SELECT * FROM dbo.ToStrTable(@CSOList)))
ORDER BY 
	CASE WHEN @SortCol = 'title ' AND @SortDirection = 'ASC' THEN Title  END ASC, --title ASC
	CASE WHEN @SortCol = 'code ' AND @SortDirection = 'ASC' THEN AwardCode  END ASC,
	CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piLastName  END ASC,
	CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'ASC' THEN piFirstName  END ASC,
	CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'ASC' THEN Institution  END ASC,
	CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'ASC' THEN FundingOrg  END ASC,
	CASE WHEN @SortCol = 'title ' AND @SortDirection = 'DESC' THEN Title  END DESC,
	CASE WHEN @SortCol = 'code ' AND @SortDirection = 'DESC' THEN AwardCode  END DESC,
	CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piLastName  END DESC,
	CASE WHEN @SortCol = 'pi ' AND @SortDirection = 'DESC' THEN piFirstName  END DESC,
	CASE WHEN @SortCol = 'Inst ' AND @SortDirection = 'DESC' THEN Institution  END DESC,
	CASE WHEN @SortCol = 'FO ' AND @SortDirection = 'DESC' THEN FundingOrg  END DESC
OFFSET ISNULL(@PageSize,50) * (ISNULL(@PageNumber, 1) - 1) ROWS
FETCH NEXT 
	CASE WHEN @PageNumber IS NULL THEN 999999999 ELSE ISNULL(@PageSize,50)
	END ROWS ONLY
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

SELECT p.ProjectStartDate, p.ProjectEndDate,  a.TechAbstract AS TechAbstract, a.PublicAbstract AS PublicAbstract, m.Title AS FundingMechanism 
FROM project p	
	JOIN FundingMechanism m ON p.FundingMechanismID = m.FundingMechanismID
	JOIN ProjectAbstract a ON p.ProjectAbstractID = a.ProjectAbstractID
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
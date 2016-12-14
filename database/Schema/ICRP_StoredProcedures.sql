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
DROP PROCEDURE [dbo].[YourSproc]
GO 

CREATE PROCEDURE [dbo].[GetProjects]
    @institution varchar(50),
	@piLastName varchar(50),
	@piFirstName varchar(50),
	@piORCiD varchar(50),
	@awardCode varchar(50),
	@city varchar(50),
	@state varchar(50),
	@country varchar(50),
	@fundingOrg int,
	@cancerType varchar(50),
	@projectType varchar(50),
	@CSO varchar(50)

AS   

SELECT * FROM vwProjects WHERE 
	institution = @institution AND
	piLastName = @piLastName AND
	piFirstName = @piFirstName AND
	piORCiD = @piORCiD AND
	AwardCode = @awardCode AND
	city = @city AND
	state = @state AND
	country = @country AND
	FundingOrg = @fundingOrg AND
	CancerType = @cancerType AND
	ProjectType = @projectType --AND
	--CSO = @CSO 
ORDER BY Title 

GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[GetProjectDetail]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetProjectDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[YourSproc]
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
DROP PROCEDURE [dbo].[YourSproc]
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
DROP PROCEDURE [dbo].[YourSproc]
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
DROP PROCEDURE [dbo].[YourSproc]
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
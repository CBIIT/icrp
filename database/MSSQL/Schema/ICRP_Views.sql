
/****** Object:  View [dbo].[vwProjects]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists(select 1 from sys.views where name='vwProjects' and type='v')
DROP VIEW [dbo].[vwProjects]
GO 


CREATE VIEW [dbo].[vwProjects] AS

SELECT DISTINCT p.ProjectID, pf.ProjectFundingID, p.AwardCode, pf.IsChildhood, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, fi.IsPrincipalInvestigator, i.Name AS institution, 
				i.City, i.State, i.country, fo.FundingOrgID AS FundingOrgID, fo.[Abbreviation] AS FundingOrg, fo.Type AS FundingOrgType,
				pt.ProjectType, ct.CancerTypeID, c.Name AS CancerType, cso.CSOCode, ext.CalendarYear, s.Content AS ProjectContent
FROM Project p	WITH (NOLOCK)
	JOIN ProjectFunding pf WITH (NOLOCK) ON p.ProjectID = pf.ProjectID 
	JOIN ProjectFundingExt ext WITH (NOLOCK) ON pf.ProjectFundingID = ext.ProjectFundingID
	JOIN ProjectFundingInvestigator fi WITH (NOLOCK) ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i WITH (NOLOCK) ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg fo WITH (NOLOCK) ON fo.FundingOrgID = pf.FundingOrgID
	JOIN Project_ProjectType pt WITH (NOLOCK) ON p.ProjectID = pt.ProjectID
	JOIN ProjectCancerType ct WITH (NOLOCK) ON pf.ProjectFundingID = ct.ProjectFundingID
	JOIN CancerType c WITH (NOLOCK) ON c.CancerTypeID = ct.CancerTypeID	
	JOIN ProjectCSO cso WITH (NOLOCK) ON pf.ProjectFundingID = cso.ProjectFundingID
	JOIN ProjectSearch s ON s.ProjectID = p.ProjectID
	
GO

/****** Object:  View [dbo].[vwProjectFundings]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists(select 1 from sys.views where name='vwProjectFundings' and type='v')
DROP VIEW [dbo].[vwProjectFundings]
GO 

CREATE VIEW [dbo].[vwProjectFundings] AS

SELECT DISTINCT p.ProjectID, p.AwardCode,  pf.IsChildhood, pf.ProjectFundingID, pf.Title, pf.FundingContact, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, fi.IsPrincipalInvestigator, i.Name AS institution, 
				pf.BudgetStartDate, pf.BudgetEndDate, pf.Amount, pf.Category, i.City, i.State, i.country, c.RegionID, pf.FundingOrgID, o.name AS FundingOrg, o.abbreviation AS FundingOrgShort, o.Type AS FundingOrgType
				
FROM Project p	WITH (NOLOCK)
	JOIN ProjectFunding pf WITH (NOLOCK) ON p.ProjectID = pf.ProjectID 	
	JOIN ProjectFundingInvestigator fi WITH (NOLOCK) ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i WITH (NOLOCK) ON i.InstitutionID = fi.InstitutionID	
	JOIN Country c ON i.Country = c.Abbreviation
	JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID 

GO
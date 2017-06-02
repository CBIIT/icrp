-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjects
-- -----------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS vwProjects;

CREATE VIEW vwProjects AS

SELECT DISTINCT p.ProjectID, pf.ProjectFundingID, p.AwardCode, p.IsChildhood, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, i.Name AS institution, 
				i.City, i.State, i.country, fo.FundingOrgID AS FundingOrgID, fo.Abbreviation AS FundingOrg, fo.Type AS FundingOrgType,
				pt.ProjectType, ct.CancerTypeID, c.Name AS CancerType, cso.CSOCode, ext.CalendarYear, s.Content AS ProjectContent
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID 
	JOIN ProjectFundingExt ext ON pf.ProjectFundingID = ext.ProjectFundingID
	JOIN ProjectFundingInvestigator fi ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg fo ON fo.FundingOrgID = pf.FundingOrgID
	JOIN Project_ProjectType pt ON p.ProjectID = pt.ProjectID
	JOIN ProjectCancerType ct ON pf.ProjectFundingID = ct.ProjectFundingID
	JOIN CancerType c ON c.CancerTypeID = ct.CancerTypeID	
	JOIN ProjectCSO cso ON pf.ProjectFundingID = cso.ProjectFundingID
	JOIN ProjectSearch s ON s.ProjectID = p.ProjectID;
	
-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjectFundings
-- -----------------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS vwProjectFundings;

CREATE VIEW vwProjectFundings AS

SELECT DISTINCT p.ProjectID, p.AwardCode,  p.IsChildhood, pf.ProjectFundingID, pf.Title, pf.FundingContact, fi.LastName  AS piLastName, fi.FirstName AS piFirstName, fi.ORC_ID AS piORCiD, i.Name AS institution, 
				pf.Amount, i.City, i.State, i.country, pf.FundingOrgID, o.name AS FundingOrg, o.abbreviation AS FundingOrgShort, o.Type AS FundingOrgType
				
FROM Project p
	JOIN ProjectFunding pf ON p.ProjectID = pf.ProjectID 	
	JOIN ProjectFundingInvestigator fi ON fi.ProjectFundingID = pf.ProjectFundingID	
	JOIN Institution i ON i.InstitutionID = fi.InstitutionID	
	JOIN FundingOrg o ON pf.FundingOrgID = o.FundingOrgID;
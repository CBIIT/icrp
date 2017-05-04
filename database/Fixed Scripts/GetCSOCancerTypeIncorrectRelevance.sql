/**************************************************************/
-- Project CancerType not add up to 100
/**************************************************************/
DECLARE @site TABLE (
ProjectFundingID INT,
Relevance decimal(18,2)
)

INSERT INTO @Site Select ProjectFundingID, SUM(ISNULL(Relevance,0)) from ProjectCancerType GROUP BY ProjectFundingID

SELECT * INTO #site FROM @site WHERE Relevance <> 100.00

select * from #site order by Relevance

SELECT f.ProjectFundingID,  f.Title, p.AwardCode, f.AltAwardCode, o.SponsorCode, o.Name AS FundingOrg,f.BudgetStartDate, f.BudgetEndDate, 
pi.LastName ASpiLastName, pi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.Country, pc.Relevance, ct.Name AS CancerType, s.Relevance AS TotalRelevance, a.TechAbstract
FROM #site s
JOIN ProjectFunding f ON s.ProjectFundingID=f.ProjectFundingID
JOIN Project p ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
JOIN Institution i ON i.InstitutionID = pi.InstitutionID
JOIN ProjectCancerType pc ON pc.ProjectFundingID = f.ProjectFundingID
JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID
JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE o.SponsorCode <> 'NIH'
ORDER BY o.SponsorCode, Projectfundingid


/**************************************************************/
-- Project CSO not add up to 100
/**************************************************************/
drop table #cso
select * from projectcso where projectfundingid=132891

DECLARE @cso TABLE (
ProjectFundingID INT,
Relevance decimal(18,2)
)

INSERT INTO @cso Select ProjectFundingID, SUM(ISNULL(Relevance,0)) from ProjectCSO GROUP BY ProjectFundingID
select * from @cso
SELECT * INTO #cso FROM @cso WHERE ISNULL(Relevance,0) <> 100.00

select * from #cso order by Relevance

SELECT f.ProjectFundingID,  f.Title, p.AwardCode, f.AltAwardCode, o.SponsorCode, o.Name AS FundingOrg,f.BudgetStartDate, f.BudgetEndDate, 
pi.LastName ASpiLastName, pi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.Country, pc.Relevance, pc.CSOCode, c.Relevance AS TotalRelevance, a.TechAbstract
FROM #cso c
JOIN ProjectFunding f ON c.ProjectFundingID=f.ProjectFundingID
JOIN Project p ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
JOIN Institution i ON i.InstitutionID = pi.InstitutionID
JOIN ProjectCSO pc ON pc.ProjectFundingID = f.ProjectFundingID
JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
ORDER BY o.SponsorCode, Projectfundingid

/**************************************************************/
-- Project coded to CSO7 (4433)
/**************************************************************/
--select * from cso
--select * from projectcso

SELECT f.ProjectFundingID,  f.Title, p.AwardCode, f.AltAwardCode, o.SponsorCode, o.Name AS FundingOrg,f.BudgetStartDate, f.BudgetEndDate, 
pi.LastName ASpiLastName, pi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.Country, pc.Relevance, pc.CSOCode, a.TechAbstract
FROM ProjectCSO pc
JOIN ProjectFunding f ON pc.ProjectFundingID=f.ProjectFundingID
JOIN Project p ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
JOIN Institution i ON i.InstitutionID = pi.InstitutionID
JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE pc.CSOCode IN ('7.1', '7.2', '7.3')
ORDER BY o.SponsorCode, Projectfundingid

/**************************************************************/
-- Project coded to CSO0 - Uncoded (857) 856?
/**************************************************************/
SELECT f.ProjectFundingID,  f.Title, p.AwardCode, f.AltAwardCode, o.SponsorCode, o.Name AS FundingOrg,f.BudgetStartDate, f.BudgetEndDate, 
pi.LastName ASpiLastName, pi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.Country, pc.Relevance, pc.CSOCode, a.TechAbstract
FROM ProjectCSO pc
JOIN ProjectFunding f ON pc.ProjectFundingID=f.ProjectFundingID
JOIN Project p ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
JOIN Institution i ON i.InstitutionID = pi.InstitutionID
JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE pc.CSOCode = '0'
ORDER BY o.SponsorCode, Projectfundingid

/**************************************************************/
-- Project coded to SIte Uncoded (857) 856?
/**************************************************************/
--select * from CancerType order by name

SELECT f.ProjectFundingID,  f.Title, p.AwardCode, f.AltAwardCode, o.SponsorCode, o.Name AS FundingOrg,f.BudgetStartDate, f.BudgetEndDate, 
pi.LastName ASpiLastName, pi.FirstName AS piFirstName, i.Name AS Institution, i.City, i.Country, pc.Relevance, pc.RelSource, ct.Name AS CancerType, a.TechAbstract
FROM ProjectCancerType pc
JOIN ProjectFunding f ON pc.ProjectFundingID=f.ProjectFundingID
JOIN Project p ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON o.FundingOrgID = f.FundingOrgID
JOIN ProjectFundingInvestigator pi ON f.ProjectFundingID = pi.ProjectFundingID
JOIN Institution i ON i.InstitutionID = pi.InstitutionID
JOIN CancerType ct ON ct.CancerTypeID = pc.CancerTypeID
JOIN ProjectAbstract a ON f.ProjectAbstractID = a.ProjectAbstractID
WHERE pc.CancerTypeID = 59 --and pc.RelSource = 'S'
ORDER BY o.SponsorCode, Projectfundingid


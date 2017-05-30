
----------------------------
-- Load Childhood dataset 
-----------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #ChildhoodByOrg (	
	FundingOrgName VARCHAR(100),
	Abbreviation VARCHAR(50),	
	Country VARCHAR(3),
	SponsorCode VARCHAR(50),
	ChildhoodCategory VARCHAR(15)
)

GO

BULK INSERT #ChildhoodByOrg
FROM 'C:\icrp\database\Cleanup\ChildhoodCancerByOrg.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  


--SET NOCOUNT ON;  
--GO 
CREATE TABLE #ChildhoodByProject (	
	ProjectID INT,
	ProjectFundingID INT,
	AwardCode VARCHAR(50),	
	AltAwardCode VARCHAR(50),	
	SponsorCode VARCHAR(50),
	FundingOrgName VARCHAR(100),
	IsChildhood VARCHAR(15)
)

GO

BULK INSERT #ChildhoodByProject
FROM 'C:\icrp\database\Cleanup\ChildhoodCancerByProject.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

--select * from #ChildhoodByOrg
--select * from #ChildhoodByProject  --5661
--select distinct ProjectID into #proj from #ChildhoodByProject --2254

--select * from #proj order by projectid

--select p.* FROM Project p
--JOIN (select distinct c.projectid,  o.FundingOrgID from #ChildhoodByProject c
--				JOIN ProjectFunding f  ON c.ProjectID = f.ProjectID) pc ON p.ProjectID = pc.ProjectID

--JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
--JOIN #ChildhoodByOrg c ON o.Abbreviation = c.Abbreviation
----full outer join #proj pp ON p.projectID = pp.projectid
--WHERE c.ChildhoodCategory = 'Some' --and (pp.ProjectID is null OR p.ProjectID is null)-- 2253

BEGIN TRANSACTION

UPDATE Project SET IsChildhood = 1 
FROM Project p
JOIN ProjectFunding f  ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
JOIN #ChildhoodByOrg c ON o.Abbreviation = c.Abbreviation
WHERE c.ChildhoodCategory = 'Y'

UPDATE Project SET IsChildhood = 0
FROM Project p
JOIN ProjectFunding f  ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
JOIN #ChildhoodByOrg c ON o.Abbreviation = c.Abbreviation
WHERE c.ChildhoodCategory = 'N'


UPDATE Project SET IsChildhood = 0  --46977
FROM Project p
JOIN ProjectFunding f  ON p.ProjectID = f.ProjectID
JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
JOIN #ChildhoodByOrg c ON o.Abbreviation = c.Abbreviation
WHERE c.ChildhoodCategory = 'Some'


UPDATE Project SET IsChildhood = 1  --46977
FROM Project p
	JOIN ProjectFunding f  ON p.ProjectID = f.ProjectID
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	JOIN #ChildhoodByOrg c ON o.Abbreviation = c.Abbreviation
	JOIN #ChildhoodByProject cp ON cp.projectid = p.ProjectID
WHERE c.ChildhoodCategory = 'Some'

--commit

rollback

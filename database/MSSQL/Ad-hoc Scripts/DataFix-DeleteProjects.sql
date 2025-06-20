drop table #delProj
GO

drop table #projAbst
GO

-----------------------------------------
-- 1. Delete ProjectFunding and Projects
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #delProjFunding (	
	[ProjectID] INT NOT NULL,
	[ProjectFundingID] INT NOT NULL,
	[AwardCode] [varchar](50) NOT NULL,
	[SourceID] [varchar](50) NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL
)

GO

BULK INSERT #delProjFunding
FROM 'C:\icrp\database\Cleanup\CCRA_ToDelete.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

select * from #delProjFunding

-- should return no records
select p.ProjectID, f.ProjectFundingID
from project p
LEFT join projectfunding f on p.projectID = f.projectID
WHERE f.ProjectFundingID IS NULL

select f.ProjectID, f.ProjectFundingID
from projectfunding f
RIGHT join #delProjFunding d on d.ProjectFundingID = f.ProjectFundingID

select p.ProjectID, d.ProjectFundingID
from project p
RIGHT join #delProjFunding d on d.ProjectID = p.ProjectID

BEGIN TRANSACTION

-- delete projectcso
delete projectcso 
from projectcso cso
join #delProjFunding dp on cso.ProjectFundingID = dp.ProjectFundingID

-- delete projectcancertype
delete projectcancertype 
from projectcancertype ct
join #delProjFunding dp on ct.ProjectFundingID = dp.ProjectFundingID

-- delete projectfundinginvestigator
delete projectfundinginvestigator 
from projectfundinginvestigator pi
join #delProjFunding dp on pi.ProjectFundingID = dp.ProjectFundingID

-- delete projectfundingext
delete projectfundingext 
from projectfundingext ext
join #delProjFunding dp on ext.ProjectFundingID = dp.ProjectFundingID


--SELECT pf.ProjectAbstractID INTO #projAbst
--From ProjectFunding pf
--JOIN #delProjFunding dp ON pf.ProjectFundingID = dp.ProjectFundingID
--WHERE pf.ProjectAbstractID <> 0

--select * from #projAbst


-- archive to be deleted project funding records
INSERT INTO ProjectFundingArchive ( [ProjectFundingID]
      ,[FundingOrgID]
      ,[FundingDivisionID]
      ,[ProjectAbstractID]
      ,[Title]
      ,[Category]
      ,[AltAwardCode]
      ,[Source_ID]
      ,[MechanismCode]
      ,[MechanismTitle]
      ,[FundingContact]
      ,[IsAnnualized]
      ,[Amount]
      ,[BudgetStartDate]
      ,[BudgetEndDate]
      ,[DataUploadStatusID]
      ,[ArchivedDate])-- SELECT * FROM 
	SELECT f.[ProjectFundingID]
      ,f.[FundingOrgID]
      ,f.[FundingDivisionID]
      ,f.[ProjectAbstractID]
      ,f.[Title]
      ,f.[Category]
      ,f.[AltAwardCode]
      ,f.[Source_ID]
      ,f.[MechanismCode]
      ,f.[MechanismTitle]
      ,f.[FundingContact]
      ,f.[IsAnnualized]
      ,f.[Amount]
      ,f.[BudgetStartDate]
      ,f.[BudgetEndDate]
      ,f.[DataUploadStatusID]
      ,getdate() 
from projectfunding f
join #delProjFunding dp on f.ProjectFundingID = dp.ProjectFundingID

-- delete projectfunding
delete projectfunding 
from projectfunding f
join #delProjFunding dp on f.ProjectFundingID = dp.ProjectFundingID

-- delete ProjectAbstract WHERE ProjectAbstractID IN (SELECT DISTINCT ProjectAbstractID From #projAbst)

-- checking if there are projects with no pfunding records ...
select p.ProjectID, f.ProjectFundingID INTO #delProj
from project p
LEFT join projectfunding f on p.projectID = f.projectID
WHERE f.ProjectFundingID IS NULL

select * from #delProj

delete Project_ProjectType
from Project_ProjectType pt
JOIN #delProj f on f.ProjectID = pt.ProjectID

--delete ProjectSearch
--from ProjectSearch ps
--JOIN #delProj f on f.ProjectID = ps.ProjectID

delete Project
from Project p
JOIN #delProj f on f.ProjectID = p.ProjectID


COMMIT
--ROLLBACK


-----------------------------------------
-- 2. Update SourceID
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #srcid (	
	[ProjectID] INT NOT NULL,
	[ProjectFundingID] INT NOT NULL,
	[AwardCode] [varchar](50) NOT NULL,
	[SourceID] [varchar](50) NOT NULL,
	[NewSourceID] [varchar](50) NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL
)

GO



BULK INSERT #srcid
FROM 'C:\icrp\database\Cleanup\ICRP_NIH_Update_SourceID.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #srcid

BEGIN TRANSACTION

UPDATE ProjectFunding SET Source_ID = s.newSourceID
FROM ProjectFunding pf
JOIN #srcid s ON pf.ProjectFundingID = s.ProjectFundingID

COMMIT
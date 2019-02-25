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
FROM 'C:\ICRP\database\Cleanup\20190215-NIHData\ICRP_NIH_Remove.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #delProjFunding

-- should return no records
select p.ProjectID, f.ProjectFundingID
from project p
LEFT join projectfunding f on p.projectID = f.projectID
WHERE f.ProjectFundingID IS NULL

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
FROM 'C:\ICRP\database\Cleanup\20190215-NIHData\ICRP_NIH_Update_SourceID.csv'
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


-----------------------------------------
-- 3. Update Amounts
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #amt (	
	[Fix] [varchar](100) NOT NULL,	
	[AwardCode] [varchar](50) NOT NULL,
	[SourceID] [varchar](50) NOT NULL,	
	[AltAwardCode] [varchar](50) NOT NULL,
	[CurrentAmt] Decimal(18,2) NOT NULL,
	[NewAmt] Decimal(18,2) NOT NULL
)

GO

BULK INSERT #amt
FROM 'C:\ICRP\database\Cleanup\20190215-NIHData\FundingFix_IntraExtramural_FY14_v2.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #amt

select * from projectfunding where AltAwardCode='1ZIEBC010843-08'

BEGIN TRANSACTION

UPDATE ProjectFunding SET Amount = a.NewAmt
FROM ProjectFunding pf
JOIN #amt a ON pf.AltAwardCode = a.AltAwardCode

COMMIT
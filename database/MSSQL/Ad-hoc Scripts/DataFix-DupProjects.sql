--drop table #cso
--GO

-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #dupProj (	
	[ProjectID] INT NOT NULL,
	[ProjectFundingID] INT NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL,
	[AwardTitle] [varchar](2000) NOT NULL,
	[AwardType] [varchar](50) NOT NULL,
	[AwardCode] [varchar](50) NOT NULL,
	[SourceID] [varchar](50) NOT NULL,
	[AwardStartDate] [datetime] NOT NULL,
	[AwardEndDate] [datetime] NOT NULL,
	[BudgetStartDate] [datetime] NOT NULL,
	[BudgetEndDate] [datetime] NOT NULL,
	[Amount] [float] NOT NULL
)

GO

BULK INSERT #dupProj
FROM 'C:\icrp\database\Cleanup\20180222\DupProjects.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #dupProj

select p.AwardCode, f.ProjectFundingID, f.AltAwardCode, f.Source_ID, f.BudgetStartDate, f.BudgetEndDate, f.Amount from #dupProj dp
join projectfunding f on dp.altawardcode = f.AltAwardCode
join project p on dp.projectid = p.ProjectID
order by p.AwardCode, f.ProjectFundingID, f.AltAwardCode, f.BudgetStartDate, f.BudgetEndDate, f.Amount

-- delete projectcso
delete projectcso 
from projectcso cso
join #dupProj dp on cso.ProjectFundingID = dp.ProjectFundingID

-- delete projectcancertype
delete projectcancertype 
from projectcancertype ct
join #dupProj dp on ct.ProjectFundingID = dp.ProjectFundingID

-- delete projectfundinginvestigator
delete projectfundinginvestigator 
from projectfundinginvestigator pi
join #dupProj dp on pi.ProjectFundingID = dp.ProjectFundingID

-- delete projectfundingext
delete projectfundingext 
from projectfundingext ext
join #dupProj dp on ext.ProjectFundingID = dp.ProjectFundingID

-- delete projectfunding
delete projectfunding 
from projectfunding f
join #dupProj dp on f.ProjectFundingID = dp.ProjectFundingID

select count(*) from projectfunding  -- 160971, 160936
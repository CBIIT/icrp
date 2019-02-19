drop table #site
go
drop table #pfid
GO

-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'
select * from cancertype
--SET NOCOUNT ON;  
--GO 
CREATE TABLE #site (		
	[ProjectFundingID] [int] NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL,
	[cancertype] [varchar](500) NOT NULL,	
	[rel] float NULL,
	[TotalRel] [int] NULL
)

GO

BULK INSERT #site
FROM 'C:\icrp\database\Cleanup\FixNIH_CancerTypeNot100.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- data check
select * from #site

select top 5 * from #site t
left join CancerType ct on t.cancertype = ct.Name
where t.cancertype is null

select distinct projectfundingid into #pfid from #site
select * from #pfid -- 9537

-- check total rel
select pct.projectfundingid, sum(isnull(pct.Relevance,null)) 
from ProjectCancerType pct
join #pfid t on pct.ProjectFundingID = t.ProjectFundingID
group by pct.ProjectFundingID
order by sum(isnull(pct.Relevance,null)) desc

begin transaction

	-- Delete existing project cancer types 
	delete ProjectCancerType where projectfundingid in (select projectfundingid from #pfid)  -- 32078

	-- Insert new project cancer types 
	INSERT INTO ProjectCancerType 
	SELECT s.[ProjectFundingID], ct.cancertypeid, s.[rel], 'S', getdate(), getdate(), 'S' 
		FROM #site s
		JOIN CancerType ct ON ct.Name = s.cancertype  --29243
--rollback
commit


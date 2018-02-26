--drop table #site
--GO

-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #site (	
	[ProjectID] [int] NOT NULL,
	[ProjectFundingID] [int] NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL,
	[icrpcode] [varchar](500) NOT NULL,
	[cancertype] [varchar](500) NOT NULL,
	[rel] [varchar](500) NULL
)

GO

BULK INSERT #site
FROM 'C:\icrp\database\Cleanup\20180222\SiteRel.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select top 5 * from #site
select top 5 * from ProjectCancerType
select top 5 * from CancerType

--drop table #removecso

select projectfundingid, count(*) as count, sum(CAST(rel AS float)) AS rel into #removesite from #site group by projectfundingid
select * from #site  -- 73420

select * from #removesite  -- 18146

-- ProjectCancerType
select c.projectfundingid, count(*) as count from ProjectCancerType c
join #removesite rem ON c.ProjectFundingID = rem.ProjectFundingID
group by c.projectfundingid

begin transaction
	delete ProjectCancerType where projectfundingid in (select projectfundingid from #removesite)

	INSERT INTO ProjectCancerType 
	SELECT s.[ProjectFundingID], ct.cancertypeid, s.[rel], 'S', getdate(), getdate(), 'S' 
		FROM #site s
		JOIN CancerType ct ON ct.ICRPCode = s.icrpcode

commit


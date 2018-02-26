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
CREATE TABLE #cso (	
	[ProjectID] [int] NOT NULL,
	[ProjectFundingID] [int] NOT NULL,
	[AltAwardCode] [varchar](50) NOT NULL,
	[csocode] [varchar](500) NOT NULL,
	[csorel] [varchar](500) NULL
)

GO

BULK INSERT #cso
FROM 'C:\icrp\database\Cleanup\20180222\CSORel.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #cso

--drop table #removecso

select projectfundingid, count(*) as count, sum(CAST(csorel AS float)) AS rel into #removecso from #cso group by projectfundingid


select * from #removecso

-- ProjectCSO
select c.projectfundingid, count(*) as count from ProjectCSO c
join #removecso rem ON c.ProjectFundingID = rem.ProjectFundingID
group by c.projectfundingid

begin transaction
	delete ProjectCSO where projectfundingid in (select projectfundingid from #removecso)

	INSERT INTO ProjectCSO SELECT [ProjectFundingID], [csocode], [csorel], 'S', getdate(), getdate() FROM #cso

commit


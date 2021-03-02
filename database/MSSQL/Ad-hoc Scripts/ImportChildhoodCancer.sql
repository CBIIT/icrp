drop table #childhood
GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #childhood (	
	[ProjectID] INT NOT NULL,
	[ProjectFundingID] INT NOT NULL,
	[SponsorCode] [varchar](50) NULL,
	[FundingOrgID] INT NULL,
	[IsChildhood] [varchar](10) NULL	
)

GO

BULK INSERT #childhood
FROM 'D:\ICRP\database\DataImport\Childhood\ICRPProdProject-ChildhoodData-v2.csv'
--FROM 'D:\ICRP\database\DataImport\Childhood\Childhood.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  
select * from #childhood 

select ischildhood, count(*) from ProjectFunding
group by ischildhood

BEGIN TRANSACTION
update ProjectFunding set ischildhood =
case c.IsChildhood
  WHEN 'y' THEN 1
  WHEN 'p' THEN 2
  ELSE 0
end
FROM ProjectFunding f
JOIN #childhood c ON c.ProjectFundingID = f.ProjectFundingID

COMMIT
ROLLBACK
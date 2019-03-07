--drop table #children
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #children (	
	[CancerTypeID] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,	
	[ICRPCode] [int] NOT NULL,
	[ICD10CodeInfo] [varchar](250) NULL,
	[IsCommonInChildren] [varchar](1) NOT NULL
)

GO

BULK INSERT #children
FROM 'C:\icrp\database\DataImport\2.3\isCommonInChildren.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #children order by CancerTypeID 
select Name, IsCommonInChildren from CancerType

BEGIN TRANSACTION
UPDATE CancerType SET IsCommonInChildren= NULL

UPDATE CancerType SET IsCommonInChildren = 
CASE 
WHEN c.IsCommonInChildren='y' THEN 1 ELSE 0
END 
FROM CancerType ct
JOIN #children c ON ct.CancerTypeID = c.CancerTypeID


UPDATE CancerType SET IsCommonInChildren = 0 WHERE IsCommonInChildren IS NULL

select DISTINCT IsCommonInChildren from CancerType
--commit

rollback

--select * from Institution where name in ('IIT Research Institute', 'Louisiana State University Health Sciences Center New Orleans')

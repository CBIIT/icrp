--drop table #Nonpartner
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Nonpartner (	
	[Name] [varchar](100) NOT NULL,
	[Abbrev] [varchar](50) NOT NULL,
	[Website] [varchar](50) NOT NULL,
	[Country] [varchar](25) NOT NULL,	
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Description] [varchar](2000) NULL,
	[EstimatedInvest] [varchar](25) NULL,		
	[Note] [varchar](8000) NULL,			
	[Email] [varchar](50) NULL,			
	[ContactPerson] [varchar](50) NULL,		
	[Position] [varchar](50) NULL,
	[DoNotContact] [varchar](50) NULL,
	[CancerOnly] [varchar](50) NULL,
	[ResearchFunder] [varchar](50) NULL
)

GO

BULK INSERT #Nonpartner
FROM 'C:\icrp\database\DataImport\CurrentRelease\Non-Partner\Non-partners.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  


select * from #Nonpartner


INSERT INTO Nonpartner ([Name],	[Abbreviation], [Description], [Email],[Country],[Longitude],[Latitude],[Website],[Note],[EstimatedInvest],	[ContactPerson],[Position],	[DoNotContact],	[CancerOnly],[ResearchFunder], CreatedDate, UpdatedDate)
SELECT Name, [Abbrev], [Description], [Email],[Country],[Longitude],[Latitude],[Website],[Note],[EstimatedInvest],[ContactPerson],[Position],	
		CASE [DoNotContact] WHEN 'y' THEN 1 ELSE 0 END,
		CASE [CancerOnly] WHEN 'y' THEN 1 ELSE 0 END,
		CASE [ResearchFunder] WHEN 'y' THEN 1 ELSE 0 END,
		getdate(), getdate() FROM #Nonpartner


select * from Nonpartner

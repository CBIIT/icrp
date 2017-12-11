--drop table #Partner
--go
-----------------------------------------
-- Insert New Partner
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Partner (	
	[Sponsor] [varchar](100) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Coordinates] [varchar](200) NULL	
)

GO

BULK INSERT #Partner
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Org\PartnerCoordinates.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

Select * from #Partner

update #Partner SET Coordinates = REPLACE(Coordinates, '"', '')

begin transaction

select * from partner

UPDATE Partner SET 
	Latitude = CAST(LEFT(u.[Coordinates], CHARINDEX(',', u.[Coordinates])-1) AS DECIMAL(9,6)),
	Longitude = CAST(RIGHT(u.[Coordinates], len(u.[Coordinates]) - CHARINDEX(',', u.[Coordinates])) AS DECIMAL(9,6))	
FROM Partner p
JOIN #Partner u ON p.SponsorCode = u.Sponsor

select * from Partner where latitude is null

commit
--rollback

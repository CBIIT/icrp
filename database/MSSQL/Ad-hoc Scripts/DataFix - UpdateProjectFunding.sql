--drop table #FundingOrg
--go
-----------------------------------------
-- Update FundingOrg
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #ProjectFunding (	
	[AltAwardCode] [varchar](100) NOT NULL,	
	[SourceID] [varchar](150) NOT NULL,
	[AwardFunding] [float] NOT NULL,
	[FundingOrg] [varchar](10) NULL,
	[NewAwardFunding] [float] NULL
)

GO

BULK INSERT #ProjectFunding
FROM 'C:\ICRP\database\Cleanup\ICRP_AwardFundingChanges_07mar19.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO  

Select * from #ProjectFunding

update #FundingOrg SET Coordinates = REPLACE(Coordinates, '"', '')

begin transaction

select * from FundingOrg where Latitude is null

UPDATE FundingOrg SET 
	Latitude = CAST(LEFT(u.[Coordinates], CHARINDEX(',', u.[Coordinates])-1) AS DECIMAL(9,6)),
	Longitude = CAST(RIGHT(u.[Coordinates], len(u.[Coordinates]) - CHARINDEX(',', u.[Coordinates])) AS DECIMAL(9,6))	
FROM FundingOrg f
JOIN #FundingOrg u ON f.SponsorCode = u.Sponsor AND f.Abbreviation = u.Abbreviation
WHERE u.Coordinates <> '#N/A'


UPDATE FundingOrg SET Latitude = 43.727458,	Longitude = -72.611635
FROM FundingOrg WHERE name = 'Make It Better (MIB) Agents'

UPDATE FundingOrg SET Latitude = 51.519299, Longitude = -0.130819 WHERE Abbreviation='WCRF UK'
UPDATE FundingOrg SET Latitude = 48.897882, Longitude = 2.252738 WHERE Abbreviation='WCRF FR'
UPDATE FundingOrg SET Latitude = 52.363813, Longitude = 4.906801 WHERE Abbreviation='WCRF NL'

select 'Missing Coords' AS Issue, * from FundingOrg where Latitude is null and MemberStatus <> 'Merged'

commit
--rollback


-- Org Missing coordinates - "Make It Better (MIB) Agents"


--select * from FundingOrg where latitude is not null
--select * from FundingOrg where latitude is null

--select * from #FundingOrg u
--JOIN FundingOrg f ON f.SponsorCode = u.Sponsor AND f.Abbreviation = u.Abbreviation
--where f.latitude is null 

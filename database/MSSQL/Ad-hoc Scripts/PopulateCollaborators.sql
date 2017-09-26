--drop table #Collaborators
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #Collaborators (	
	[AwardCode] [varchar](75) NOT NULL,
	[AltAwardCode] [varchar](75) NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[SubmittedInstitution] [varchar](250) NOT NULL,
	[Institution] [varchar](250) NOT NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](50) NULL,
	[Country] [varchar](3) NULL,
	[Postal] [varchar](50) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,	
	[GRID] [varchar](250) NULL,
	[ORC_ID] [varchar](19) NULL,
	[OtherResearchID] [INT] NULL,
	[OtherResearchType] [varchar](50) NULL,
	[IsNewInstitution] [varchar](5) NULL
)

GO

BULK INSERT #Collaborators
FROM 'C:\icrp\database\DataImport\Collaborators\Collaborator_Data_CCRA.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- Checking Data
select * from #Collaborators

select distinct c.Institution, c.City from #Collaborators c
LEFT JOIN Institution i ON c.Institution = i.Name AND c.City = i.City
WHERE i.InstitutionID IS NULL

select distinct Institution, City, [State],	[Country], [Postal], [Longitude], [Latitude], [GRID] from #Collaborators where IsNewInstitution = 'y'

-- Insert new institutions
INSERT INTO Institution (Name, City, [State],[Country], [Postal], [Longitude], [Latitude], [GRID])
select distinct Institution, City, [State],	[Country], [Postal], [Longitude], [Latitude], [GRID] from #Collaborators where IsNewInstitution = 'y'

-- Insert Collaborators
INSERT INTO ProjectFundingInvestigator (ProjectFundingID, [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], IsPrivateInvestigator, InstitutionID, InstitutionNameSubmitted)
SELECT pf.ProjectFundingID, c.[LastName], c.[FirstName], c.[ORC_ID], c.[OtherResearchID], c.[OtherResearchType], 0 AS IsPrimaryInvestigator, i.InstitutionID, c.SubmittedInstitution FROM #Collaborators c
JOIN ProjectFunding pf ON c.AltAwardCode = pf.AltAwardCode
JOIN Institution i ON c.Institution = i.Name AND c.City = i.City


select * from ProjectFundingInvestigator where IsPrivateInvestigator = 0 order by ProjectFundingID



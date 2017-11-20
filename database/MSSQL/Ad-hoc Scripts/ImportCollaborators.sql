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
	--[SubmittedInstitution] [varchar](250) NOT NULL,
	[Institution] [varchar](250) NOT NULL,
	[City] [varchar](50) NOT NULL,	
	[ORC_ID] [varchar](19) NULL,
	[OtherResearchID] [INT] NULL,
	[OtherResearchType] [varchar](50) NULL	
)

GO

BULK INSERT tmp_LoadCollaborators
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Collaborators\NIHCollaboratorsFY2014.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- Checking Data
select * from #Collaborators

update institution set city ='Montréal' where city ='Montreal'
update institution set city ='Zürich' where city ='Zurich'
update institution set city ='Québec' where city ='Quebec'
update institution set city ='Pierre-Bénite' where city ='Pierre-Benite'
update institution set city ='Umeå' where city ='Umea'

update #Collaborators set city ='Montréal' where city='Montreal'
update #Collaborators set city ='Québec' where city='Quebec'
update #Collaborators set city ='Zürich' where city='Zurich'
update #Collaborators set city ='Pierre-Bénite' where city='Pierre-Benite'
update #Collaborators set city ='Umeå' where city='Umea'

select * from institution where name like 'Centre Georges%' 
select * from institution where name like 'Helmholtz Zentrum%' 
select * from institution where name like 'Institut Catal%' and city ='Barcelona'
select * from institution where name like 'Institut Hospital del Mar%' and city ='Barcelona'  -- Institut Hospital del Mar d'Investigacions MÃ¨diques

begin transaction
update institution set name ='Centre Georges François Leclerc' where name like 'Centre Georges%' 
update institution set name ='Helmholtz Zentrum München (HZ)' where name like 'Helmholtz Zentrum%' 
update institution set name ='Institut Català d''Oncologia' where name like 'Institut Catal%' and city ='Barcelona'
update institution set name ='Institut Hospital del Mar d''Investigacions Mèdiques' where name like 'Institut Hospital del Mar%' and city ='Barcelona'

commit

rollback


select * from institution where city in ('Pecs', 'Pécs')
select * from institution where city in ('Umea', 'Umeå')

select distinct c.Institution AS collabInstitution, c.City AS collabCity, i2.Name AS lookupInstitution, i2.City AS lookupCity
from #Collaborators c
LEFT JOIN Institution i ON c.Institution = i.Name AND c.City = i.City
LEFT JOIN Institution i2 ON c.Institution = i2.Name 
WHERE i.InstitutionID IS NULL
ORDER BY  c.city, c.Institution

Centre hospitalier Lyon Sud	Pierre-Benite	
Centre hospitalier Lyon Sud	Pierre-Bénite




--select *
--from (select distinct Institution, City, [State],	[Country], [Postal], [Longitude], [Latitude], [GRID] from #Collaborators where IsNewInstitution = 'y') n
--join institution i ON n.Institution = i.name

--select * from institution where name='American College of Radiology - Philadelphia'

-- Insert new institutions
INSERT INTO Institution (Name, City, [State],[Country], [Postal], [Longitude], [Latitude], [GRID])
select distinct Institution, City, [State],	[Country], [Postal], [Longitude], [Latitude], [GRID] from #Collaborators where IsNewInstitution = 'y'

-- Insert Collaborators
INSERT INTO ProjectFundingInvestigator (ProjectFundingID, [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], IsPrincipalInvestigator, InstitutionID, InstitutionNameSubmitted)
SELECT pf.ProjectFundingID, c.[LastName], c.[FirstName], c.[ORC_ID], c.[OtherResearchID], c.[OtherResearchType], 0 AS IsPrimaryInvestigator, i.InstitutionID, c.SubmittedInstitution FROM #Collaborators c
JOIN ProjectFunding pf ON c.AltAwardCode = pf.AltAwardCode
JOIN Institution i ON c.Institution = i.Name AND c.City = i.City


select * from ProjectFundingInvestigator where IsPrincipalInvestigator = 0 order by ProjectFundingID



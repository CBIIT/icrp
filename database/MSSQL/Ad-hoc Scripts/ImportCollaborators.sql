--drop table #LoadCollaborators
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #LoadCollaborators (	
	[AwardCode] [varchar](75) NOT NULL,
	[AltAwardCode] [varchar](75) NOT NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[SubmittedInstitution] [varchar](250) NOT NULL,
	[Institution] [varchar](250) NOT NULL,
	[City] [varchar](50) NOT NULL,	
	[State] [varchar](50) NULL,	
	[Cuntry] [varchar](50) NULL,	
	[Zip] [varchar](50) NULL,	
	[longitude] decimal(9,6) NULL,	
	[latitude] decimal(9,6) NULL,	
	[Grid] [varchar](50) NULL,	
	[ORC_ID] [varchar](19) NULL,
	[OtherResearchID] [INT] NULL,
	[OtherResearchType] [varchar](50) NULL,
	[IsNewInstitution] varchar (1)
)

GO
select * from #LoadCollaborators

BULK INSERT #LoadCollaborators
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Collaborators\Collaborator_Data_CCRA-unicode.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- Checking Data
select * from #LoadCollaborators

select Institution,	[City],	[State], Cuntry, Zip, [Longitude],[Latitude],	[GRID] from #LoadCollaborators where IsNewInstitution = 'y'

  -- done in prod
update institution set city ='Montréal' where city ='Montreal'
update institution set city ='Zürich' where city ='Zurich'
update institution set city ='Québec' where city ='Quebec'
update institution set city ='Pierre-Bénite' where city ='Pierre-Benite'
update institution set city ='Umeå' where city ='Umea'

update #LoadCollaborators set city ='Montréal' where city='Montreal'
update #LoadCollaborators set city ='Québec' where city='Quebec'
update #LoadCollaborators set city ='Zürich' where city='Zurich'
update #LoadCollaborators set city ='Pierre-Bénite' where city='Pierre-Benite'
update #LoadCollaborators set city ='Umeå' where city='Umea'



update tmp_LoadCollaborators set [Institution] ='Helmholtz Zentrum München (HZ)' where [Institution] like 'Helmholtz Zentrum%' 
update tmp_LoadCollaborators set [Institution] = 'Saskatchewan Cancer Agency' where [Institution] ='Saskatchewan Cancer Agency/Foundation - Allan Blair Cancer Centre' and city ='Regina'
update tmp_LoadCollaborators set [Institution] = 'Mount Sinai Hospital' where [Institution] ='Mount Sinai Hospital & Lunenfeld-Tanenbaum Research Institute' and city ='Toronto'

update tmp_LoadCollaborators set city  = 'Parkville' where [Institution] ='Ludwig Institute for Cancer Research' and city ='Melbourne'
update tmp_LoadCollaborators set city  = 'Brisbane' where [Institution] ='Mater Private Hospital' and city ='Dublin'



select * from institution where name like 'Centre Georges%' 
select * from institution where name like 'Helmholtz Zentrum%' 
select * from institution where name like 'Institut Catal%' and city ='Barcelona'
select * from institution where name like 'Institut Hospital del Mar%' and city ='Barcelona'  -- Institut Hospital del Mar d'Investigacions MÃ¨diques


-- fixed encoding errors - done in prod
begin transaction
update institution set name ='Centre Georges François Leclerc' where name like 'Centre Georges%' 
update institution set name ='Helmholtz Zentrum München (HZ)' where name like 'Helmholtz Zentrum%' 
update institution set name ='Institut Català d''Oncologia' where name like 'Institut Catal%' and city ='Barcelona'
update institution set name ='Institut Hospital del Mar d''Investigacions Mèdiques' where name like 'Institut Hospital del Mar%' and city ='Barcelona'

commit

rollback


select * from institution where city in ('Pecs', 'Pécs')
select * from institution where city in ('Umea', 'Umeå')

select * from tmp_loadinstitutions where name like 'Helmholtz Zentrum%' 
select * from institution where name like 'Helmholtz Zentrum%' 
select * from institution where name like 'Saskatchewan%' 
select * from institution where name like 'Mount Sinai%' 

select distinct c.Institution AS collabInstitution, c.City AS collabCity, i2.Name AS lookupInstitution, i2.City AS lookupCity
from tmp_LoadCollaborators c
LEFT JOIN Institution i ON c.Institution = i.Name AND c.City = i.City
LEFT JOIN Institution i2 ON c.Institution = i2.Name 
WHERE i.InstitutionID IS NULL
ORDER BY  c.city, c.Institution


--select *
--from (select distinct Institution, City, [State],	[Country], [Postal], [Longitude], [Latitude], [GRID] from #Collaborators where IsNewInstitution = 'y') n
--join institution i ON n.Institution = i.name

--select * from institution where name='American College of Radiology - Philadelphia'


-- Insert Collaborators
INSERT INTO ProjectFundingInvestigator (ProjectFundingID, [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], IsPrincipalInvestigator, InstitutionID, InstitutionNameSubmitted)
SELECT pf.ProjectFundingID, c.[LastName], c.[FirstName], c.[ORC_ID], c.[OtherResearchID], c.[OtherResearchType], 0 AS IsPrimaryInvestigator, i.InstitutionID, c.SubmittedInstitution FROM #Collaborators c
JOIN ProjectFunding pf ON c.AltAwardCode = pf.AltAwardCode
JOIN Institution i ON c.Institution = i.Name AND c.City = i.City


select * from ProjectFundingInvestigator where IsPrincipalInvestigator = 0 order by ProjectFundingID



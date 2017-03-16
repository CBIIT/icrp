SET NOCOUNT ON
GO

-----------------------------
-- Country
-----------------------------
PRINT 'Migrate [Country]'

INSERT INTO Country
(Abbreviation, Name)
SELECT ABBREVIATION, name
FROM icrp.dbo.COUNTRY

-----------------------------
-- State
-----------------------------
INSERT INTO State
(Abbreviation, Name, Country)
SELECT ABBREVIATION, name, COUNTRY
FROM icrp.dbo.State

-----------------------------
-- ProjectType
-----------------------------
INSERT INTO ProjectType
(ProjectType)
SELECT Type
FROM icrp.dbo.PROJECTTYPE

-----------------------------
-- CSOCategory
-----------------------------
PRINT 'Migrate [CSOCategory]'

INSERT INTO CSOCategory
(Name, Code)
SELECT DISTINCT category, categoryCode from icrp.dbo.CSO order by categoryCode

-----------------------------
-- CSO
-----------------------------
INSERT INTO CSO
(Code, Name, ShortName, CategoryName, WeightName,SortOrder)
SELECT DISTINCT code, name, ShortName, Category, WEIGHTNAME, SortOrder from icrp.dbo.CSO order by code

UPDATE CSO SET IsActive = 0 WHERE code in ('1.6', '7.1', '7.2', '7.3')

-----------------------------
-- CancerType
-----------------------------
INSERT INTO CancerType
(Name, ICRPCode, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, ISCOMMON, ISARCHIVED, SORTORDER 
FROM icrp.dbo.SITE 
ORDER BY mappedid

-----------------------------
-- PrjectAbstract  -- TO DO (Only migrate active projects)
-----------------------------
PRINT 'Migrate [ProjectAbstract]'

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID, TechAbstract, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT a.ID, a.techAbstract, a.publicAbstract, a.dateadded, a.lastrevised
FROM icrp.dbo.Abstract a
	JOIN icrp.dbo.PROJECT p ON p.abstractId = a.ID
	JOIN icrp.dbo.TESTPROJECTACTIVE t ON t.PROJECTID = p.ID
ORDER BY id


update ProjectAbstract set TechAbstract = 'No abstract available for this Project funding.' where ProjectAbstractID =0

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

-----------------------------
-- Currency - De-dup...
-----------------------------
PRINT 'Migrate [Currency]'

INSERT INTO Currency
(Code, Description, SortOrder)
SELECT Currency, min(CURRENCYDESC), min(sortorder) as sortorder
	from icrp.dbo.CURRENCIES group by CURRENCY order by sortorder

-----------------------------
-- CurrencyRate
-----------------------------
INSERT INTO CurrencyRate
(YearOld, FromCurrency, FromCurrencyRate, ToCurrency, ToCurrencyRate, year)
SELECT year_old, FromCurrency, FromCurrencyRate, ToCurrency, ToCurrencyRate, year
	from icrp.dbo.CURRENCYRATE order by year

	
-----------------------------
-- Create Institution Lookup - load from excel
-----------------------------
--drop table [UploadInstitution]
--go
--delete InstitutionMapping
--go
--DBCC CHECKIDENT ('[InstitutionMapping]', RESEED, 0)
--go
--delete [Institution]
--go
--DBCC CHECKIDENT ('[Institution]', RESEED, 0)
--go

PRINT 'Create Institution Lookup'

CREATE TABLE [dbo].[UploadInstitution](
DataIssue_ICRP [varchar](250) NOT NULL,
institution_ICRP	[varchar](250) NOT NULL,
city_ICRP	[varchar](250) NOT NULL,
city_ICRP_corrected	[varchar](250) NOT NULL,
state_ICRP	[varchar](250) NOT NULL,
state_ICRP_corrected	[varchar](250) NOT NULL,
country_ICRP	[varchar](250) NOT NULL,
country_ICRP_corrected	[varchar](250) NOT NULL,
ICRP_CURRENT_Combination_Inst_City	[varchar](250) NOT NULL,
MATCHGRID [varchar](250) NOT NULL,
MATCHGRIDNote	[varchar](1000) NOT NULL,
IsNOTEMultiHost [varchar](250) NOT NULL,
DedupInstitution	[varchar](250) NOT NULL,
[Check] [varchar](50) NOT NULL,
City_Clean	[varchar](250) NOT NULL,
State_Clean	[varchar](250) NULL,
Name_GRID	[varchar](250) NOT NULL,
City_GRID	[varchar](250) NOT NULL,
Country_GRID	[varchar](250) NOT NULL,
Country_ICRP_ISO	[varchar](250) NOT NULL,
ID_GRID	[varchar](250) NOT NULL,
Lat_GRID	[decimal](9,6) NULL,
Lng_GRID [decimal](9,6) NULL,
)

GO


BULK INSERT [UploadInstitution]
FROM 'C:\icrp\database\Migration\ICRPInstitutions.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 

--select * from [UploadInstitution] where institution_ICRP like 'CEA-DSV-I2BM - %'

 --select distinct city_clean from [UploadInstitution] where city_clean like 'Mont%'
 --select distinct city_clean from [UploadInstitution] where city_clean like 'Que%'

UPDATE UploadInstitution SET City_ICRP = '' WHERE City_ICRP = 'NULL'
UPDATE UploadInstitution SET City_Clean = NULL WHERE City_Clean = 'NULL'
UPDATE UploadInstitution SET State_Clean = NULL WHERE State_Clean = 'NULL'
UPDATE UploadInstitution SET Country_ICRP_ISO = NULL WHERE Country_ICRP_ISO = 'NULL'
UPDATE UploadInstitution SET ID_GRID = NULL WHERE ID_GRID = 'NULL'

--select * from [UploadInstitution] where institution_icrp like 'Institut du Cancer de MontrTal (ICM)%'
--select distinct City_Clean from [UploadInstitution] order by city_clean

UPDATE UploadInstitution SET institution_ICRP = DedupInstitution WHERE ISNULL(institution_ICRP, '') = ''
UPDATE UploadInstitution SET DedupInstitution = institution_ICRP WHERE ISNULL(DedupInstitution, '') = ''
UPDATE UploadInstitution SET City_Clean = city_ICRP WHERE ISNULL(City_Clean, '') = ''
UPDATE UploadInstitution SET City_Clean = 'Montréal' WHERE City_Clean IN ('Montr?al', 'Montreal', 'MontrTal','Mont-Royal')
UPDATE UploadInstitution SET City_Clean = 'Québec' WHERE City_Clean IN ('Qu?bec', 'Qu??bec', 'Quebec', 'QuÃ©bec')
UPDATE UploadInstitution SET City_Clean = 'Lévis' WHERE City_Clean IN ('LTvis', 'L?vis', 'Levis')
UPDATE UploadInstitution SET City_Clean = 'Zürich' WHERE City_Clean IN ('Zurich')
UPDATE UploadInstitution SET City_Clean = 'St. Louis' WHERE City_Clean IN ('Saint Louis', 'St Louis')
UPDATE UploadInstitution SET City_Clean = 'Sault Ste. Marie' WHERE City_Clean IN ('Sault Ste Marie')
UPDATE UploadInstitution SET City_Clean = 'St. Catharines' WHERE City_Clean IN ('St Catharines')
UPDATE UploadInstitution SET City_Clean = 'Trois-Rivières' WHERE City_Clean IN ('Trois-RiviFres')
UPDATE UploadInstitution SET STATE_Clean = s.abbreviation FROM UploadInstitution u JOIN state s ON s.name = u.State_Clean
UPDATE UploadInstitution SET STATE_Clean = NULL where State_Clean = 'Pirkanmaa'
UPDATE UploadInstitution SET STATE_Clean = 'HH' where State_Clean = 'Hamburg'

UPDATE UploadInstitution SET DedupInstitution ='Hôpital Charles LeMoyne' WHERE DedupInstitution ='Hopital Charles-LeMoyne'
UPDATE UploadInstitution SET DedupInstitution ='Hôpital de la Cité-de-la-Santé' WHERE DedupInstitution ='Hopital de la Cité-de-la-Santé'
UPDATE UploadInstitution SET DedupInstitution ='Hôpital Maisonneuve-Rosemont' WHERE DedupInstitution ='Collège de Maisonneuve'
UPDATE UploadInstitution SET DedupInstitution ='Université du Québec en Abitibi-Témiscamingue', City_Clean = 'Rouyn-Noranda' WHERE DedupInstitution ='University of Quebec at Montreal'

-- Create a InstitutionMapping table to store historical Institution name+city combination (used for Data Upload)
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT DISTINCT institution_ICRP, City_ICRP, DedupInstitution, City_Clean  FROM UploadInstitution  -- 7123

-- Manually inserted not-mapped institutions 
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Ente ospedaliero ""Ospedali Galliera""', 'Genova', 'Ente Ospedaliero Ospedali Galliera', 'Genoa'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'HUMANITAS, INC.', '', 'Humanitas (United States)', 'Silver Spring'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'IFO - Italian National Cancer Institute ""Regina Elena""', 'Rome', 'IFO- Italian National Cancer Institute Regina Elina', 'Rome'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Inserm U1086 ""Cancers & Preventions"" - CHU de Caen', 'Caen', 'Centre Hospitalier Universitaire de Caen', 'Caen'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Institut Gustave Roussy-IGR - UPRES EA 3535 ""Pharmacologie et Nouveaux Traitements du Cancer', 'Villejuif', 'Institut Gustave Roussy', 'Villejuif'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'MASSACHUSETTS UNIV MED CTR', '', 'Massachusetts Institute of Technology', 'Cambridge'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'New York University, School of Medicine', 'New York', 'New York University', 'New York'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Rutgers, The State University of New Jersey', 'New Brunswick', 'Rutgers University', 'New Brunswick'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'SOCIAL AND SCIENTIFIC SYSTEMS, INC.', 'Paris', 'Social and Scientific Systems (United States)', 'Paris'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'UMR7587 (CNRS) - Langevin ""Ondes et Images""', 'Paris', 'Institut Langevin', 'Paris'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Institut universitaire de gériatrie de Sherbrooke (IUGS), pavillon d''Youville', 'Sherbrooke', 'Institut Universitaire De Gériatrie De Montréal', 'Montréal'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Algoma District Cancer Program - Sault Area Hospital', 'Sault Ste. Marie', 'Algoma University', 'Sault Ste. Marie'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Universitäts Spital Zürich', 'Zurich', 'University Hospital of Zurich', 'Zürich'

INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Centre de recherche de l''Hôpital Charles LeMoyne', 'Montréal', 'Hopital Charles-LeMoyne', 'Longueuil'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Centre de recherche de l''Hôpital Maisonneuve-Rosemont', 'Greenfield Park', 'Hôpital Maisonneuve-Rosemont', 'Montréal'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Centre de recherche de L''Hôtel-Dieu de Québec', 'Montréal', 'Hôtel-Dieu de Québec', 'Québec'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Centre de recherche de l’Hôpital Maisonneuve-Rosemont - pavillon Marcel-Lamoureux', 'Québec', 'Collège de Maisonneuve', 'Montréal'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'GeneNews™ Ltd.', 'Montréal', 'GeneNews™ Ltd.', 'Richmond Hill'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'McGill University and Genome Québec Innovation Centre', 'Mont-Royal', 'McGill University and Génome Québec Innovation Centre', 'Montréal'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Université du Québec à Montréal (UQAM)', 'Rouyn-Noranda', 'Université du Québec en Abitibi-Témiscamingue', 'Rouyn-Noranda'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Université du Québec à Trois-Rivières (UQTR)', 'Montréal', 'Université du Québec à Trois-Rivières', 'Trois-Rivières'
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Université du Québec en Abitibi-Témiscamingue, Rouyn-Noranda', 'Trois-Rivières', 'Université du Québec en Abitibi-Témiscamingue', 'Rouyn-Noranda'

-- Fix variations of NCI mappings
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='National Cancer Institute' AND OldCity = 'Bethesda'
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='National Cancer Institute' AND OldCity = 'Ft. Detrick'
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='National Cancer Institute' AND OldCity = 'Rockville'
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='National Cancer Institute (NCI)' AND OldCity = 'Bethesda'

UPDATE InstitutionMapping SET NewCity = NULL where NewCity = 'NULL' OR NewCity = ''
UPDATE InstitutionMapping SET OldCity = NULL where OldCity = 'NULL' OR OldCity = ''

-- Insert a placeholder for missing institution 
INSERT INTO [Institution] ([Name], [City])
SELECT 'Missing', 'Missing'

INSERT INTO [Institution] ([Name],[City],[State],[Country],[Longitude],[Latitude],[GRID])
SELECT DISTINCT MAX(DedupInstitution), City_Clean, MAX(State_Clean), MAX(Country_ICRP_ISO), MAX(Lng_GRID), MAX(Lat_GRID), MAX(ID_GRID)
FROM [UploadInstitution] GROUP BY DedupInstitution, City_Clean -- 3944


IF EXISTS (select name, city, count(*)  from [Institution] group by name, city having count(*) > 1)
BEGIN
	SELECT 'Duplicate Institutions', [Name], [City], count(*)  from [Institution] group by [Name], [City] having count(*) > 1
END
ELSE
	PRINT 'Institution Lookup table created Successfully'

--DBCC CHECKIDENT ('[Institution]', RESEED, 0)

-----------------------------------------
-- [PartnerApplication]
-----------------------------------------

PRINT 'Migrate [PartnerApplication]'

INSERT INTO [PartnerApplication]
SELECT '',
[ORGNAME],[ORGADD1],[ORGADD2],[ORGCITY],[ORGSTATE],[ORGCOUNTRY],[ORGZIP],
[EDPCNAME],[EDPCPOSITION],[EDPCPHONE],[EDPCEMAIL],[MISSIONDESC],[PROFILEDESC],
[INIYEAR],[CRESEARCHBUDGET],[REPORTPERIOD],[COPERATINGBUDGET],[NUMPROJECTS],
[TIER],[PAYMENTDT],[CONTACTNAME],[CONTACTPOSITION],[CONTACTPHONE],[CONTACTEMAIL],
[CONTACTADD1],[CONTACTADD2],[CONTACTCITY],[CONTACTSTATE],[CONTACTCOUNTRY],
[CONTACTZIP],[TERM1],[TERM2],[TERM3],[TERM4],[TERM5],[TERM6],[TERM7],[TERM8],[TERM9],
[SUPPLELETTER],[SUPPLEDOC],[ISCOMPLETED],[SUBMITDT],[SUBMITDT]
FROM icrp.dbo.tblMEMBERSHIPFORM

-----------------------------------------
-- Partners
-----------------------------------------
PRINT 'Migrate [Partner]'

INSERT INTO Partner 
SELECT [NMPARTNER],[TXTPARTNER],
	CASE ISNULL(s.code, '') WHEN '' THEN 'N/A - '+ LEFT([NMPARTNER], 10) ELSE s.code END,
	s.email, NULL, p.[COUNTRY], p.[WEBSITE], p.[LOGO],p.[MAPCOORDS], '', NULL, getdate(), getdate()
FROM icrp.dbo.tblPARTNERS p
LEFT JOIN icrp.dbo.sponsor s ON p.NMPARTNER = s.NAME

UPDATE Partner SET SponsorCode = 'INCa', EMail='recherche@institutcancer.fr' WHERE name = 'French National Cancer Institute'
UPDATE Partner SET SponsorCode = 'KWF', EMail='poz@kwfkankerbestrijding.nl' WHERE name = 'Dutch Cancer Society'
UPDATE Partner SET SponsorCode = 'CDMRP', EMail='cdmrp.pa@det.amedd.army.mil' WHERE name = 'Congressionally Directed Medical Research Programs'
UPDATE Partner SET SponsorCode = 'AVONFDN', EMail='info@avonfoundation.org' WHERE name = 'AVON Foundation'
UPDATE Partner SET SponsorCode = 'NCC', EMail=NULL WHERE name = 'National Cancer Center'
UPDATE Partner SET SponsorCode = 'CINSW'WHERE name = 'Cancer Institute New South Wales'

-- Set Joined Date
UPDATE Partner SET JoinedDate = o.JOINDATE
FROM Partner p
left join (SELECT SponsorCode, min(JOINDATE) AS JOINDATE FROM icrp.dbo.tblORG group by SponsorCode) o ON p.SponsorCode = o.SPONSORCODE

UPDATE Partner SET JoinedDate = '2014-5-15' WHERE Name ='Cancer Australia'

-- Update mission
UPDATE Partner SET Description='The Canadian Cancer Research Alliance (CCRA) is an alliance of organizations that collectively fund most of the cancer research conducted in Canada. Members include federal research funding programs/agencies, provincial research agencies, provincial cancer care agencies, cancer charities, and other voluntary associations. CCRA was created with the express purpose of fostering the development of partnerships among cancer research funders and promoting the development of national research priorities. For over a decade, CCRA has provided a forum for members to identify and establish collaborations to more effectively advance cancer research and cancer control. In this capacity, CCRA serves as the coordinating voice for cancer research in Canada.  CCRA data submitted to the ICRP includes the research portfolios of key government and non-governmental cancer research funders in Canada, where the research was active on or after 1 January 2005. For more information, please visit the CCRA website. http://www.ccra-acrc.ca' WHERE SponsorCode = 'CCRA'

UPDATE Partner SET IsDSASigned = o.DSASIGNED
FROM Partner p
LEFT JOIN icrp.dbo.tblORG o ON p.Name = o.Name

-----------------------------
-- FundingOrg
-----------------------------
PRINT 'Migrate [FundingOrg]'

SET IDENTITY_INSERT FundingOrg ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO FundingOrg
(FundingOrgID, Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
SELECT ID, NAME, [ABBREVIATION],
	CASE [COUNTRY] WHEN 'UK' THEN 'GB' ELSE country END AS Country, 
	[CURRENCY], [SponsorCode], '', NULL, [ISANNUALIZED],[LASTDATAIMPORT], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingorg

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

UPDATE FundingOrg SET MemberType = CASE ISNULL(p.Name, '') WHEN '' THEN 'Associate' ELSE 'Partner' END, MemberStatus='Current'
FROM  FundingOrg f
LEFT JOIN Partner p ON f.Name = p.Name

--select * from  FundingOrg where IsDSASigned is null (Check later)

-----------------------------
-- PartnerOrg
-----------------------------
PRINT 'Migrate [PartnerOrg]'


INSERT INTO PartnerOrg
	SELECT DISTINCT * FROM 
		(SELECT Name, SponsorCode, MemberType, 
			CASE MemberStatus WHEN 'Current' THEN 1 ELSE 0 END AS IsActive, 
			createddate, updateddate
		FROM FundingOrg	

		UNION
	
		SELECT p.Name, p.SponsorCode, 'Partner', 1, p.createddate, p.updateddate FROM Partner p
		LEFT JOIN FundingOrg f ON p.name = f.name WHERE f.FundingOrgID IS NULL

		UNION
			SELECT 'ICRP Operations Manager' AS Name, 'ICRP' AS SponsorCode, 'ICRP', 1, getdate(), getdate()
	
		UNION
			SELECT 'ICRP Tech Support' AS Name,  'ICRP' AS SponsorCode, 'ICRP', 1,  getdate(), getdate()) o

	ORDER BY SponsorCode, Name



-----------------------------
-- FundingDivision
-----------------------------
PRINT 'Migrate [FundingDivision]'

INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision

----------------------------------------------------------------------------------
-- Only migrate the active projects 
--  Exclude CA funding (CCRA) -- 29,748
----------------------------------------------------------------------------------
DECLARE @sortedProjects TABLE (
	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

INSERT INTO @sortedProjects SELECT ID, Code FROM icrp.dbo.project ORDER BY code, DateStart, BUDGETSTARTDATE, ImportYear, ID

SELECT DISTINCT s.SortedProjectID, f.SPONSORCODE, p.* INTO #activeProjects
FROM icrp.dbo.project p
join icrp.dbo.fundingorg f on p.FUNDINGORGID = f.ID
JOIN @sortedProjects s ON p.id = s.OldProjectID
JOIN icrp.dbo.TestProjectActive a ON p.ID = a.projectID
WHERE f.SPONSORCODE <> 'CCRA'
ORDER BY s.SortedProjectID


----------------------------------------------------------------------------------
-- Data Fix 
----------------------------------------------------------------------------------
/* Update AltID if not present */
--select * from #activeProjects

UPDATE #activeProjects SET AltId = code
FROM #activeProjects
where isnull(altid, '') = ''

/* Fix the NIH AwardCode - strippong out leading and training characters*/
UPDATE #activeProjects SET Code =
(case 	
	when INTERNALCODE like '%sub%' THEN left(internalcode, 8)
	when substring(internalcode, 13,1) = '-' THEN substring(internalcode, 5,8)
	when substring(internalcode, 9,1) = '-' THEN left(internalcode, 8)
	ELSE  internalcode 
END) 
FROM #activeProjects
WHERE SponsorCode = 'NIH'

/* Update NIH Project Category - Supplement */
UPDATE #activeProjects SET INTERNALCODE = NULL

UPDATE #activeProjects SET INTERNALCODE = 'Supplement'   -- 3,133 suplements
from #activeProjects
where SponsorCode='nih' and substring(right(altid, 2), 1,1) = 'S'

--select * from #activeProjects where INTERNALCODE is not null

UPDATE #activeProjects SET INTERNALCODE = 'Sub-project'  -- 259 sub
FROM #activeProjects
where SponsorCode='nih' AND INTERNALCODE IS NULL AND  altid like '%sub%'

UPDATE #activeProjects SET INTERNALCODE = 'Parent'  -- 4701 parent
FROM #activeProjects
where SponsorCode='nih' AND INTERNALCODE IS NULL and substring(altid, 1,1) = '1'  -- Application Type = 1 (New)

UPDATE #activeProjects SET INTERNALCODE = 'Sub-project'  -- 23,429 sub
FROM #activeProjects
where SponsorCode='nih' AND INTERNALCODE IS NULL AND (LEN(ALtID) = 15 OR LEN(ALtID) = 17) AND INTERNALCODE IS NULL 

-----------------------------
-- [Migration_Project]
-----------------------------
PRINT 'Create [Migration_Project]'

CREATE TABLE [dbo].[Migration_Project] (
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(255) NOT NULL,
	[SponsorCode] nvarchar(255) NOT NULL
)

-- Use AwardCode to group project (pull the oldest ProjectID - originally imported)
INSERT INTO [Migration_Project] ([OldProjectID], [AwardCode], [SponsorCode])		
	SELECT a.ID, bp.Code, bp.sponsorcode 
	FROM (SELECT code, sponsorcode, MIN(SortedProjectID) AS SortedProjectID FROM #activeProjects GROUP BY code, sponsorcode) bp
	JOIN #activeProjects a ON bp.SortedProjectID = a.SortedProjectID	 -- 60172

-----------------------------
-- Project
-----------------------------
PRINT 'Migrate [Project]'

SET IDENTITY_INSERT Project ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO Project  
(ProjectID, [AwardCode], [IsFunded],[ProjectStartDate],[ProjectEndDate],[CreatedDate],[UpdatedDate])
SELECT bp.ProjectID, p.code, p.[IsFunded], p.[DateStart], p.[DateEnd], p.[DATEADDED], p.[LASTREVISED]
FROM #activeProjects p
	JOIN Migration_Project bp ON p.id = bp.OldProjectID		
ORDER BY bp.ProjectID

SET IDENTITY_INSERT Project OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from Project
--DBCC CHECKIDENT ('[Project]', RESEED, 0)

--------------------------------------------------------------------------------------------
-- ProjectDocument  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
PRINT 'Migrate [ProjectDocument]'

INSERT INTO ProjectDocument
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

--------------------------------------------------------------------------------------------
-- ProjectDocument_JP  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
PRINT 'Migrate [ProjectDocument_JP]'

INSERT INTO ProjectDocument_JP
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search_JP s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

-----------------------------
-- Project_ProjectType
-----------------------------
PRINT 'Migrate [Project_ProjectType]'

INSERT INTO Project_ProjectType
(ProjectID, ProjectType)
select np.projectid, projecttype 
FROM [Migration_Project] bp
	join #activeProjects p on bp.OldProjectID = p.id
	join project np ON np.ProjectID = bp.ProjectID

	--delete from Project_ProjectType

-----------------------------
-- [Migration_ProjectFunding]
-----------------------------
PRINT 'Create [Migration_ProjectFunding]'

CREATE TABLE [dbo].[Migration_ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[NewProjectID] [int] NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AbstractID] [int] NOT NULL,
	[Title] varchar(1000) NULL, 
	[Institution] varchar(250) NULL, 
	[city] varchar(250) NULL, 
	[NewInstitution] varchar(250) NULL, 
	[NewCity] varchar(250) NULL, 
	[state] varchar(250) NULL, 
	[country] varchar(250) NULL, 
	[piLastName] varchar(250) NULL,
	[piFirstName] varchar(250) NULL,
	[piORC_ID] varchar(250) NULL,
	[OtherResearch_ID] int NULL,
	[OtherResearch_Type] varchar(50) NULL,
	[FundingOrgID] [int] NOT NULL,
	[FundingDivisionID] [int] NULL,
	[Category] varchar(50) NULL,
	[SponsorCode] [varchar] (100) NOT NULL,
	[AwardCode] [varchar](500) NOT NULL,	
	[AltAwardCode] [varchar](500) NOT NULL,
	[Source_ID] [varchar](50) NULL,
	[MechanismCode] [varchar](30) NULL,
	[MechanismTitle] [varchar](200) NULL,
	[FundingContact] [varchar](200) NULL,	
	[Amount] [float] NULL,
	[IsAnnualized] [bit] NOT NULL,
	[BudgetStartDate] [date] NULL,
	[BudgetEndDate] [date] NULL,	
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
)
GO

INSERT INTO [Migration_ProjectFunding] 
	([NewProjectID], [OldProjectID], [AbstractID], [Title],[Institution], [city], [newInstitution], [newcity], [state], [country], [piLastName], [piFirstName], [piORC_ID], 
	 [OtherResearch_ID], [OtherResearch_Type], [FundingOrgID], [FundingDivisionID], [category], [SponsorCode], [AwardCode], [AltAwardCode], [Source_ID], [MechanismCode], 
	 [MechanismTitle], [FundingContact], [Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT mp.ProjectID, op.ID, op.abstractID, op.title, op.institution, op.city,  op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,
	   op.OtherResearcherId, OtherResearcherIdType, op.FUNDINGORGID, op.FUNDINGDIVISIONID, op.internalcode, mp.sponsorcode, op.code, op.altid, op.SOURCE_ID, m.SPONSORMECHANISM,  
	   m.TITLE, op.fundingOfficer, pf.AMOUNT, 
	   CASE WHEN [Amount] = [AnnualizedAmount] THEN 1 ELSE 0 END AS [IsAnnualized],
	   op.BUDGETSTARTDATE, op.budgetenddate, op.[DATEADDED], op.[LASTREVISED]
FROM #activeProjects op   -- active projects from old icrp database
	 LEFT JOIN icrp.dbo.ProjectFunding pf ON op.ID = pf.ProjectID
	 LEFT JOIN icrp.dbo.Mechanism m ON m.ID = op.MechanismID
	 LEFT JOIN Migration_Project mp ON mp.AwardCode = op.code AND mp.sponsorcode = op.sponsorcode
ORDER BY mp.ProjectID, op.sortedProjectID

-----------------------------
-- ProjectFunding
-----------------------------
PRINT 'Migrate [ProjectFunding]'

SET IDENTITY_INSERT ProjectFunding ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectFunding 
([ProjectFundingID], [ProjectAbstractID], [Title],[ProjectID], [FundingOrgID], [FundingDivisionID], [Category], [AltAwardCode],	[Source_ID], [MechanismCode],[MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT [ProjectFundingID],[AbstractID], [Title], [NewProjectID], [FundingOrgID], [FundingDivisionID], [Category], [ALtAwardCode], [Source_ID],[MechanismCode], [MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate]
FROM [Migration_ProjectFunding]

SET IDENTITY_INSERT ProjectFunding OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

--delete from ProjectFunding
--DBCC CHECKIDENT ('[ProjectFunding]', RESEED, 0)
--select * from ProjectFunding  --200805

	 
-----------------------------
-- ProjectCSO
-----------------------------
INSERT INTO ProjectCSO
(ProjectFundingID, [CSOCode],[Relevance],[RelSource],[CreatedDate],[UpdatedDate])
SELECT mf.[ProjectFundingID], c.Code, pc.[RELEVANCE], pc.[RELSOURCE], pc.[DATEADDED], pc.[LASTREVISED]
FROM icrp.dbo.projectCSO pc
	JOIN [Migration_ProjectFunding] mf ON pc.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.CSO c ON pc.CSOID = c.id  -- 187005	

--delete from ProjectCSO
--DBCC CHECKIDENT ('[ProjectCSO]', RESEED, 0)
	

-----------------------------
-- ProjectCancerType
-----------------------------
INSERT INTO ProjectCancerType
(ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT mf.[ProjectFundingID], c.CancerTypeID, ps.RELEVANCE, ps.RELSOURCE, ps.ENTEREDBY 
FROM icrp.dbo.PROJECTSITE ps	
	JOIN [Migration_ProjectFunding] mf ON ps.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.SITE s ON ps.SITEID = s.ID
	JOIN CancerType c ON s.Name = c.NAME

-----------------------------
-- ProjectFundingExt
-----------------------------
PRINT 'Migrate [ProjectFundingExt]'

INSERT INTO ProjectFundingExt
([ProjectFundingID], [AncestorProjectID], [CalendarYear], [CalendarAmount])
SELECT m.[ProjectFundingID], a.[ProjectIDANCESTOR], a.[YEAR], a.[CALENDARAMOUNT_V2]
FROM icrp.dbo.[TestProjectActive] a
JOIN [Migration_ProjectFunding] m ON a.PROJECTID = m.OldProjectID

--delete from ProjectFundingExt
--DBCC CHECKIDENT ('[ProjectFundingExt]', RESEED, 0)
--select * from ProjectFundingExt  --200805

-----------------------------------------
-- ProjectFunding_Investigator (check investigator)
-----------------------------------------
PRINT 'Migrate [ProjectFunding_Investigator]'

UPDATE [Migration_ProjectFunding] SET City = NULL where city = 'NULL' OR city = ''

UPDATE [Migration_ProjectFunding] SET newInstitution = m.newName, [newCity] = m.newCity 
FROM [Migration_ProjectFunding] f
JOIN InstitutionMapping m ON f.institution = m.oldName AND ISNULL(f.city, '') = ISNULL(m.oldCity,'')
WHERE m.newName <> m.oldName OR ISNULL(m.oldCity, '') <> ISNULL(m.newCity, '')

UPDATE [Migration_ProjectFunding] SET newInstitution = 'Fox Chase Cancer Center', [newCity] = 'Philadelphia'
FROM [Migration_ProjectFunding] 
WHERE Institution = 'Institute for Cancer Research, Fox Chase Cancer Center'


INSERT INTO ProjectFundingInvestigator 
([ProjectFundingID], [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], [IsPrivateInvestigator], InstitutionID)
SELECT distinct m.ProjectFundingID, ISNULL(m.piLastName, '') AS LastName, m.piFirstName, m.piORC_ID, m.[OtherResearch_ID], m.OtherResearch_Type, 1 AS IsPrivateInvestigator, ISNULL(i.InstitutionID, 1) AS InstitutionID --into #tmp
FROM [Migration_ProjectFunding] m
	 LEFT JOIN Institution i ON i.name = m.newInstitution AND i.city = m.[newcity]
   
 -- test
 IF EXISTs (select * from  ProjectFundingInvestigator  where ISNULL(institutionid,1) = 1)
	BEGIN
		PRINT 'non-mapped Institutions'
		
		SELECT m.Institution AS Institution_ICRP, m.city AS city_ICRP, m.NewInstitution, m.Newcity --distinct m.institution,  m.city
		FROM [Migration_ProjectFunding] m	
			LEFT JOIN Institution i ON (i.name = m.newInstitution AND i.city = m.[newcity])  
		WHERE i.InstitutionID is null	
	 END
	 ELSE
		PRINT 'All ProjectFunsings are mapped to Institutions Lookup!!'	

--delete ProjectFundingInvestigator
	
--------------------------------------------------
-- Migrate LibraryFolder and Library 
--------------------------------------------------
PRINT 'Migrate LibraryFolder'

CREATE TABLE [dbo].[UploadLibrary](
Filename [varchar](150) NOT NULL,
Title [varchar](150),
Description [varchar](1000),
ParentFolder [varchar](250) NOT NULL,
SubFolder1  [varchar](250) NOT NULL,
SubFolder2  [varchar](250) NOT NULL,
IsArchived bit,
IsPublic	[bit]
)

GO


BULK INSERT [UploadLibrary]
FROM 'C:\icrp\database\Migration\Library.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'ROOT', 0, 0, getdate(),getdate())

-- Insert public folders
INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Publications', 1, 1, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Newsletters', 1, 1, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'Meeting Reports', 1, 1, getdate(),getdate())

-- Insert non-public folders
INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
SELECT ParentFolder, 1, 0, getdate(),getdate() FROM (select distinct ParentFolder from [UploadLibrary]) l

-- Insert 1st level sub-folders
INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
SELECT l.SubFolder1, l.LibraryFolderID, 0, getdate(),getdate() FROM 
(select p.libraryFolderID, u.ParentFolder, u.SubFolder1 from (select distinct ParentFolder, SubFolder1 from [UploadLibrary] where SubFolder1 <> '') u
 join LibraryFolder p ON u.ParentFolder = p.Name) l

 -- Insert 2nd level sub-folders
INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
SELECT l.SubFolder2, l.LibraryFolderID, 0, getdate(),getdate() FROM 
(select p.libraryFolderID, u.SubFolder1, u.SubFolder2 from (select distinct ParentFolder, SubFolder1, subfolder2 from [UploadLibrary] where SubFolder2 <> '') u
 join LibraryFolder p ON u.SubFolder1 = p.Name) l

 
--select distinct name, parentfolderid from LibraryFolder

-----------------------------------------
-- Library
-----------------------------------------
PRINT 'Migrate Library'	

-- Insert public documents
DECLARE @PublicationsFolderID INT
DECLARE @NewsLettersFolderID INT
DECLARE @MeetingReportsFolderID INT

SELECT @PublicationsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Publications'
SELECT @NewsLettersFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Newsletters'
SELECT @MeetingReportsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Meeting Reports'

-- public publications
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfBreastCancer_ShortReport_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'Metastatic Breast Cancer Alliance Report 2014','An analysis of MBC clinical trials and grant funding from the ICRP and related databases from 2000 through 2013', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID, '2014_NCRI_Childrens_Cancer_Research_Analysis.pdf','2014_NCRI_Childrens_Cancer_Research_Analysis_Cover.png', 'Children''s Cancer Research','A report on international research investment in childhood cancer in 2008, by the UK National Cancer Research Institute and members of the International Cancer Research Partnership', 1, NULL, DATEADD(second,1, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_GYN_analysis.pdf','GYN_cover.png', 'Gynecologic Cancers Portfolio Analysis','Summary of the burden of gynecologic cancers in the United States and investments in research by the National Cancer Institute and members of the International Cancer Research Partnership', 1, NULL,DATEADD(second,2, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Report_2005-08.pdf','ICRP_Data_Report_Cover.png', 'ICRP Data Report 2005-2008','This is the first, co-operative international analysis of the cancer research landscape, based on data from over 50 current member organizations about their individual projects and programs, each classified by type of cancer and type of research', 1, NULL,DATEADD(second,3, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfluences_BreastCancer_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'ICRP report on environmental influences in breast cancer (2014)','An analysis of the research landscape in this area, examining trends in investment, research activity and gaps across a range of environmental carcinogens and lifestyle factors', 1, NULL,DATEADD(second,4, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Obesity_Cancer_Report_2014.pdf','ICRP_Obesity_Cancer_Report_2014_cover.png', 'ICRP report into obesity and cancer research (2014)','This report examines trends in investment and publication outputs for research on the role of obesity in cancer', 1, NULL,DATEADD(second,5, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Translational_Methodology_2015.pdf','ICRP_Translational_Methodology_2015.png', 'ICRP Translational Research Methodology (2015)','This report details a robust and easy way to identify translational research awards and monitor trends in this area, using the ICRP’s Common Scientific Outline (CSO)', 1, NULL,DATEADD(second,6, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_ChildhoodCancer_2016.pdf','ICRP_ChildhoodCancer_2016.png', 'ICRP Childhood Cancer Analysis 2016','An overview of research investment in cancers affecting children, adolescents and young adults in the ICRP portfolio', 1, NULL,DATEADD(second,7, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Disparities_ShortReport_2016.pdf','ICRP_Disparities_ShortReport_2016.png', 'ICRP Health Disparities Report 2016','An overview of research investment in health disparities and inequities in the ICRP portfolio', 1, NULL,DATEADD(second,8, getdate()), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_LungCancer_2016.pdf','ICRP_LungCancer_2016.png', 'ICRP Lung Cancer Overview 2016','An overview of research investment in lung cancer in the ICRP portfolio', 1, NULL, DATEADD(second,9, getdate()), getdate())

-- public newsletters
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Feb2015.pdf','newsletter_2015_02.png', 'ICRP Newsletter, February 2015','Includes evaluation highlights presented at the San Antonio Breast Cancer Symposium, news about ICRP landscape reports and information about the ICRP annual meeting', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_November_2015.pdf','newsletter_2015_11.png', 'ICRP Newsletter, November 2015','Includes details on the launch of a new, more user-friendly version (V2) of the cancer classification system or Common Scientific Outline (CSO)', 1, NULL,DATEADD(minute,1, getdate()), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Summer_2015.pdf','.png', 'ICRP Newsletter, Summary 2015','ICRP Newsletter, Summary 2015', 1, getdate(),getdate(), getdate())

-- public Meeting Reports
INSERT INTO Library VALUES(@MeetingReportsFolderID,'ICRP_2016_Annual meeting_BriefSummary.pdf','report_2016_08.png', 'ICRP 2016 Annual Meeting Report','This report summarizes the ICRP''s 2016 annual meeting on Health Disparities, hosted by the American Cancer Society', 1, NULL,getdate(), getdate())

-- Insert non-public documents into root level folder
INSERT INTO Library 
SELECT f.LibraryFolderID, l.Filename, NULL, l.Title, l.Description, 0, 
CASE l.IsArchived WHEN 1 THEN getdate() ELSE NULL END, getdate(), getdate()
FROM (select Filename, Title, Description, ParentFolder, IsArchived, IsPublic from UploadLibrary where subfolder1 ='' and subfolder2 ='') l
JOIN (SELECT LibraryFolderID, Name FROM Libraryfolder WHERE ParentFolderID = 1) f ON l.ParentFolder = f.Name

-- Insert non-public documents into sub-folder 1
INSERT INTO Library 
SELECT f.LibraryFolderID, l.Filename, NULL, l.Title, l.Description, 0, 
CASE l.IsArchived WHEN 1 THEN getdate() ELSE NULL END, getdate(), getdate()
FROM (select Filename, Title, Description, ParentFolder, SubFolder1, IsArchived, IsPublic from UploadLibrary where subfolder1 <> '' and subfolder2 ='') l
JOIN (SELECT LibraryFolderID, Name FROM Libraryfolder WHERE ParentFolderID <> 1) f ON l.subfolder1 = f.Name

-- Insert non-public documents into sub-folder 2
INSERT INTO Library 
SELECT f.LibraryFolderID, l.Filename, NULL, l.Title, l.Description, 0, 
CASE l.IsArchived WHEN 1 THEN getdate() ELSE NULL END, getdate(), getdate()
FROM (select Filename, Title, Description, ParentFolder, SubFolder2, IsArchived, IsPublic from UploadLibrary where subfolder2 <>'') l
JOIN (SELECT LibraryFolderID, Name FROM Libraryfolder WHERE ParentFolderID <> 1) f ON l.SubFolder2 = f.Name

-- Move files to archive folder
DECLARE @DocumentArchiveFolderID INT

SELECT @DocumentArchiveFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Document Archive'
Update Library SET ArchivedDate = getdate(), LibraryFolderID = @DocumentArchiveFolderID WHERE filename = 'ICRPCommittees_Members_30may13.xlsx'

-----------------------------
-- DataUploadStatus
-----------------------------
INSERT INTO DataUploadStatus
SELECT PARTNER,	[FUNDINGYEAR], [STATUS],[RECEIVEDDATE],	[PREIMPORTDATE],
	[UPLOADDEVDBDATE],[COPYSTAGEDBDATE], [COPYPROCDBDATE],[NOTE], [submitdt]
FROM icrp.dbo.tblDATAUPLOADPROCESSINFO
	
----------------------------
-- CancerType Description
-----------------------------
CREATE TABLE #CancerType (		
	[ICRPCode] VARCHAR(10),	
	[ICD10CodeInfo] NVARCHAR(250),
	[Description] VARCHAR(1000)
)
GO

BULK INSERT #CancerType
FROM 'C:\icrp\database\Migration\CancerType.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO

UPDATE CancerType Set [Description] = t.[Description], [ICD10CodeInfo]=t.[ICD10CodeInfo]
FROM CancerType c
JOIN #CancerType t ON c.ICRPCode = CAST(t.[ICRPCode] AS INT)


----------------------------
-- Institution
-----------------------------
--CREATE TABLE Institution_Temp (	
--	[Name] VARCHAR(1000),
--	[City_ICRP] VARCHAR(1000),
--	[City_ICRP_Correciton] VARCHAR(1000),
--	[State_ICRP] VARCHAR(1000),
--	[State_ICRP_Correction] VARCHAR(1000),
--	[Country_ICRP] VARCHAR(1000),
--	[Country_ICRP_Correction] VARCHAR(1000),
--	[DeDup_Institution] VARCHAR(1000),
--	[Grid_Name] VARCHAR(1000),
--	[Grid_City] VARCHAR(1000),
--	[Grid_Country] VARCHAR(1000),
--	[ISO_Country] VARCHAR(1000),
--	[Grid_ID] VARCHAR(1000),
--	[Grid_Lat] VARCHAR(1000),
--	[Grid_Lng] VARCHAR(1000)
--)
--GO

--BULK INSERT Institution_Temp
--FROM 'C:\Developments\icrp\database\Migration\Institution.csv'
--WITH
--(
--	FIRSTROW = 2,
--	FIELDTERMINATOR = ',',
--	ROWTERMINATOR = '\n'
--)
--GO


-----------------------------
-- Country Income Band
-- High income - H
-- Low income  - L
-- Lower middle income - ML
-- Upper middle income - MU
--    42 COUNTRIES HAVE NO INCOME BAND
-----------------------------
CREATE TABLE #CountryCodeMapping (	
	Two VARCHAR(2),
	Three VARCHAR(3)
)
GO

BULK INSERT #CountryCodeMapping
FROM 'C:\icrp\database\Migration\CountryCodeMapping.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

CREATE TABLE #IncomeBand(	
	CountryCode VARCHAR(10),
	IncomeGroup VARCHAR(50)
)
GO

BULK INSERT #IncomeBand
FROM 'C:\icrp\database\Migration\IncomeBand.csv'
WITH
(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)
GO

Update Country Set IncomeBand =
	CASE i.IncomeGroup
		 WHEN 'High income' THEN 'H'
		 WHEN 'Low income' THEN 'L'
		 WHEN 'Lower middle income' THEN 'ML'
		 WHEN 'Upper middle income' THEN 'MU'
		 ELSE NULL END 
FROM Country c
JOIN #CountryCodeMapping m ON c.Abbreviation = m.two
JOIN #IncomeBand i ON m.three = i.CountryCode



-----------------------------
-- Migrate users to drupal
-- -1: registering
-- 0: Archived
-- 1: partner
-- 2: Manager
-- 3: Admin
-----------------------------
--SELECT l.FNAME AS FirstName, l.LNAME AS LastName, l.EMAIL, o.NAME AS Organization, 
--		CASE l.ACCESSLEVEL
--		  WHEN 1 THEN 'Partner'
--		  WHEN 2 THEN 'Manager'		  
--		  ELSE NULL END AS Role, 
--		  CASE l.ACCESSLEVEL
--		  WHEN -1 THEN 'Registering'
--		  WHEN 0 THEN 'Block'		  
--		  ELSE 'Approved' END AS Access		  
--    INTO #users
--	FROM icrp.dbo.tblLogin l
--    	JOIN icrp.dbo.tblORG o ON o.ID = l.ORGID
--	WHERE l.ACCESSLEVEL <> 3  -- do not migrate admin accounts
--	AND o.name <> 'IMSWeb'
	
	
--	UPDATE #users SET Organization = 'Avon Foundation for Women' WHERE Organization = 'Avon Foundation'
--	UPDATE #users SET Organization = 'Canadian Breast Cancer Research Alliance' WHERE Organization = 'Canadian Cancer Research Alliance'
--	UPDATE #users SET Organization = 'Canadian Cancer Society' WHERE Organization = 'Canadian Cancer Society Research Institute'
--	UPDATE #users SET Organization = 'Cancer Australia' WHERE Organization = 'Cancer Institute New South Wales'
--	UPDATE #users SET Organization = 'KWF Kankerbestrijding / Dutch Cancer Society' WHERE Organization = 'Dutch Cancer Society'
--	UPDATE #users SET Organization = 'National Cancer Center, Japan' WHERE Organization = 'National Cancer Center (Japan)'
--	UPDATE #users SET Organization = 'Cancer Research UK' WHERE Organization = 'National Cancer Research Institute'
--	UPDATE #users SET Organization = 'Northern Ireland Health & Social Care - R & D Office' WHERE Organization = 'Northern Ireland R & D Office'
--	UPDATE #users SET Organization = 'Welsh Assembly Government - Office of R & D' WHERE Organization = 'Welsh Assembly Government'

--	UPDATE #users SET Organization = ISNULL(o.SponsorCode, '')  + ' - ' + u.Organization
--	FROM #users u
--	LEFT JOIN FundingOrg o ON u.Organization = o.Name

--	UPDATE #users SET Organization = 'NIH' + Organization
--	FROM #users WHERE Organization = ' - National Institutes of Health'

--	UPDATE #users SET Organization = 'ICRP - Operations Manager'
--	FROM #users WHERE Organization = ' - ICRP Operations Manager'


--	select * from #users where Organization like ' - %'

--	/*select distinct Organization FROM #users o
--	LEFT JOIN FUNDINGORG f ON o.Organization = f.name
--	WHERE f.name is null*/

	
SET NOCOUNT OFF
GO

SET NOCOUNT ON
GO

-----------------------------
-- Country
-----------------------------
PRINT 'Migrate [Country] ..................................'

INSERT INTO Country
(Abbreviation, Name)
SELECT ABBREVIATION, name
FROM icrp.dbo.COUNTRY

UPDATE COUNTRY SET Abbreviation='UK' WHERE Abbreviation = 'GB'

-----------------------------
-- State
-----------------------------
PRINT 'Migrate [State]  ..................................'

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
PRINT 'Migrate [CSOCategory]  ..................................'

INSERT INTO CSOCategory
(Name, Code)
SELECT DISTINCT category, categoryCode from icrp.dbo.CSO order by categoryCode

-----------------------------
-- CSO
-----------------------------
INSERT INTO CSO
(Code, Name, ShortName, CategoryName, WeightName,SortOrder)
SELECT DISTINCT code, name, ShortName, Category, WEIGHTNAME, SortOrder from icrp.dbo.CSO order by code

UPDATE CSO SET IsActive = 0 WHERE code in ('1.6', '6.8', '7.1', '7.2', '7.3')

-----------------------------
-- CancerType
-----------------------------
INSERT INTO CancerType
(Name, ICRPCode, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, ISCOMMON, ISARCHIVED, SORTORDER 
FROM icrp.dbo.SITE 
ORDER BY mappedid

update ProjectCancerType set CancerTypeID=8 where CancerTypeID=9
delete CancerType where CancerTypeID=9
 
-----------------------------
-- CancerTypeRollUp
-----------------------------

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (58, 22)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (58, 25)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (58, 28)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (58, 32)

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 13)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 56)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 16)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 45)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 21)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 34)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (17, 46)

--Genital System, Female
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (18, 10)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (18, 12)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (18, 51)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (18, 57)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (18, 60)

-- Genital System, Male
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (19, 36)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (19, 38)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (19, 47)

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 24)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 29)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 33)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 35)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 49)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 54)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (20, 55)

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 30)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 6)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 15)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 37)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 40)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (31, 63)

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (39, 26)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (39, 29)

INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (50, 3)
INSERT INTO CancerTypeRollUp (CancerTypeRollUpID, CancerTypeID) VALUES (50, 23)

----select icrpcode, cancertypeid from cancertype where ICRPCode in (55, 3,25)
----select * from cancertype where ICRPCode in (12)


-----------------------------
-- Currency - De-dup...
-----------------------------
PRINT 'Migrate [Currency]  ..................................'

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

PRINT 'Create Institution Lookup  ..................................'

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


CREATE TABLE [dbo].[UploadNIHInstitution](
institution_ICRP	[varchar](250) NOT NULL,
city_ICRP	[varchar](250) NOT NULL,
city_ICRP_corrected	[varchar](250) NOT NULL,
DedupInstitution	[varchar](250) NOT NULL,
City_Clean	[varchar](250) NOT NULL,
State_Clean	[varchar](250) NULL,
Country_ICRP_ISO	[varchar](250) NOT NULL,
ID_GRID	[varchar](250) NOT NULL,
Lat_GRID	[decimal](9,6) NULL,
Lng_GRID [decimal](9,6) NULL,
)

GO


BULK INSERT [UploadNIHInstitution]
FROM 'C:\icrp\database\Migration\NIHNewInstitutions.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 



CREATE TABLE [dbo].[UploadNIHInstitutionName](
institution_ICRP	[varchar](250) NOT NULL,
city_ICRP	[varchar](250) NOT NULL,
DedupInstitution	[varchar](250) NOT NULL,
City_Clean	[varchar](250) NOT NULL
)

GO


BULK INSERT [UploadNIHInstitutionName]
FROM 'C:\icrp\database\Migration\NIHInstitutionsName.csv'
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
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT DISTINCT institution_ICRP, City_ICRP, DedupInstitution, City_Clean  FROM [UploadNIHInstitution]  -- 22
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT DISTINCT institution_ICRP, City_ICRP, DedupInstitution, City_Clean  FROM [UploadNIHInstitutionName]  -- 39 Total:7183

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
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='NCI' AND OldCity = 'Bethesda'
UPDATE InstitutionMapping SET NewName='National Cancer Institute (NIH)', NewCity = 'Rockville' where OldName='Nih/National Cancer Institute' AND OldCity = 'Bethesda'
UPDATE InstitutionMapping SET NewName='National Institute of Nursing Research (NIH)', NewCity = 'Bethesda' where OldName='NIH/NINR' AND OldCity = 'Bethesda'


UPDATE InstitutionMapping SET NewCity = NULL where NewCity = 'NULL' OR NewCity = ''
UPDATE InstitutionMapping SET OldCity = NULL where OldCity = 'NULL' OR OldCity = ''

-- Insert a placeholder for missing institution 
INSERT INTO [Institution] ([Name], [City])
SELECT 'Missing', 'Missing'

INSERT INTO [Institution] ([Name],[City],[State],[Country],[Longitude],[Latitude],[GRID])
SELECT DISTINCT MAX(DedupInstitution), City_Clean, MAX(State_Clean), MAX(Country_ICRP_ISO), MAX(Lng_GRID), MAX(Lat_GRID), MAX(ID_GRID)
FROM [UploadInstitution] GROUP BY DedupInstitution, City_Clean -- 3941

INSERT INTO [Institution] ([Name],[City],[State],[Country],[Longitude],[Latitude],[GRID])
SELECT DISTINCT MAX(DedupInstitution), City_Clean, MAX(State_Clean), MAX(Country_ICRP_ISO), MAX(Lng_GRID), MAX(Lat_GRID), MAX(ID_GRID)
FROM [UploadNIHInstitution] GROUP BY DedupInstitution, City_Clean -- 21

IF EXISTS (select name, city, count(*)  from [Institution] group by name, city having count(*) > 1)
BEGIN
	SELECT 'Duplicate Institutions', [Name], [City], count(*)  from [Institution] group by [Name], [City] having count(*) > 1
END
ELSE
	PRINT 'Institution Lookup table created Successfully'


DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM Institution

PRINT 'Total Imported Institutions = ' + @total
GO

--DBCC CHECKIDENT ('[Institution]', RESEED, 0)

-----------------------------------------
-- [PartnerApplication]					
-----------------------------------------
PRINT 'Migrate [PartnerApplication]  ..................................'

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
PRINT 'Migrate [Partner]  ..................................'

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

INSERT INTO Partner VALUES ('American Society for Radiation Oncology', 'ASTRO is the premier radiation oncology society in the world, with more than 10,000 members who are physicians, nurses, biologist, physicists, radiation therapists, dosimetrists and other health care professionals who specialize in treating patients with radiation therapies. These medical professionals, found at hospitals, cancer treatment centers and academic research facilities around the globe, make up the radiation therapy treatment teams that are critical in the fight against cancer. Together, these teams, treat more than 1 million cancer patients each year. As the leading organization in radiation oncology, the Society is dedicated to improving patient care through professional education and training, support for clinical practice and health policy standards, advancement of science and research and advocacy. ASTRO provides members with the continuing medical education, health policy analysis, patient information resources and advocacy that they need to succeed in today’s ever-changing health care delivery system. https://www.astro.org/About-ASTRO.aspx',
'ASTRO',NULL,NULL, 'US', 'www.astro.org',NULL,NULL,NULL,'2017-3-16', getdate(), getdate())

UPDATE Partner SET JoinedDate = '2014-5-15' WHERE Name ='Cancer Australia'
UPDATE Partner SET JoinedDate = '2011-1-21' WHERE Name ='American Institute for Cancer Research'
UPDATE Partner SET JoinedDate = '2008-5-13' WHERE Name ='AVON Foundation'
UPDATE Partner SET JoinedDate = '2000-1-1' WHERE Name ='Oncology Nursing Society Foundation'

--UPDATE Partner SET JoinedDate = '2017-3-16' WHERE Name ='American Society for Radiation Oncology'

-- Update mission
UPDATE Partner SET Description='The Canadian Cancer Research Alliance (CCRA) is an alliance of organizations that collectively fund most of the cancer research conducted in Canada. Members include federal research funding programs/agencies, provincial research agencies, provincial cancer care agencies, cancer charities, and other voluntary associations. CCRA was created with the express purpose of fostering the development of partnerships among cancer research funders and promoting the development of national research priorities. For over a decade, CCRA has provided a forum for members to identify and establish collaborations to more effectively advance cancer research and cancer control. In this capacity, CCRA serves as the coordinating voice for cancer research in Canada.  CCRA data submitted to the ICRP includes the research portfolios of key government and non-governmental cancer research funders in Canada, where the research was active on or after 1 January 2005. For more information, please visit the CCRA website. http://www.ccra-acrc.ca' WHERE SponsorCode = 'CCRA'

UPDATE Partner SET IsDSASigned = o.DSASIGNED
FROM Partner p
LEFT JOIN icrp.dbo.tblORG o ON p.Name = o.Name

-----------------------------
-- FundingOrg
-----------------------------
PRINT 'Migrate [FundingOrg]  ..................................'

SET IDENTITY_INSERT FundingOrg ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO FundingOrg
(FundingOrgID, Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
SELECT ID, NAME, [ABBREVIATION],
	CASE [COUNTRY] WHEN 'GB' THEN 'UK' ELSE country END AS Country, 
	[CURRENCY], [SponsorCode], '', NULL, [ISANNUALIZED],[LASTDATAIMPORT], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingorg

SET IDENTITY_INSERT FundingOrg OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO FundingOrg
(Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
VALUES ('Cancer Institute New South Wales','CINSW','CA','AUD','CINSW','Partner', 'Current',0,NULL, getdate(), getdate())

INSERT INTO FundingOrg
(Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
VALUES ('American Society for Radiation Oncology','ASTRO','US','USD','ASTRO','Partner', 'Current',0, NULL, getdate(), getdate())

INSERT INTO FundingOrg
(Name, [Abbreviation], [Country], [CURRENCY], [SponsorCode], [MemberType],[MemberStatus],[ISANNUALIZED],
LastImportDate, CreatedDate, UpdatedDate)
VALUES ('Worldwide Cancer Research','WCR','UK','GBP','NCRI','Associate', 'Current',1, NULL, getdate(), getdate())

UPDATE FundingOrg SET MemberType = CASE ISNULL(p.Name, '') WHEN '' THEN 'Associate' ELSE 'Partner' END, MemberStatus='Current'
FROM  FundingOrg f
LEFT JOIN Partner p ON f.Name = p.Name

--select * from  FundingOrg where IsDSASigned is null (Check later)

-- Import Type
CREATE TABLE [dbo].[UploadFundingOrgType](
Name [varchar](250) NULL,
Type	[varchar](100) NULL
)

GO


BULK INSERT [UploadFundingOrgType]
FROM 'C:\icrp\database\Migration\FundingOrgType.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 

UPDATE fundingorg SET Type = t.type
FROM fundingOrg o
JOIN [UploadFundingOrgType] t ON t.name =o.name 

UPDATE FundingOrg SET Type = 'Non-profit' WHERE Abbreviation = 'QBCF'
UPDATE FundingOrg SET Type = 'Government' WHERE Abbreviation = 'FRQS'
UPDATE FundingOrg SET Type = 'Government' WHERE Abbreviation = 'DGOS'

-----------------------------
-- PartnerOrg
-----------------------------
PRINT 'Migrate [PartnerOrg]  ..................................'


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
			SELECT 'Operations Manager' AS Name, 'ICRP' AS SponsorCode, 'ICRP', 1, getdate(), getdate()
	
		UNION
			SELECT 'Tech Support' AS Name,  'ICRP' AS SponsorCode, 'ICRP', 1,  getdate(), getdate()) o

	ORDER BY SponsorCode, Name



-----------------------------
-- FundingDivision
-----------------------------
PRINT 'Migrate [FundingDivision]  ..................................'

INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision

----------------------------------------------------------------------------------
-- Only migrate the active projects and all NIH projects
--  Exclude CA funding (CCRA) -- 29,748
-----------------------------------------------------------------------------------
--drop table #migratedProjectFunding
--drop table #migrated
--drop table [Migration_Project]
-- Update NIH project funding Amount (were $0 in the current system)
CREATE TABLE UploadNIHFundingAmountUpdate (
	ProjectID INT NULL,
	AwardCode varchar(150) NULL,
	AltAwardCode varchar(150) NULL,
	Amount float NULL
)

GO

BULK INSERT UploadNIHFundingAmountUpdate
FROM 'C:\icrp\database\Migration\NIHFundingAmount-Update.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 

-- Delete not migrated projects
CREATE TABLE UploadExcludedProjects (
	AwardCode varchar(150) NULL,
	AltAwardCode varchar(150) NULL
)

GO

BULK INSERT UploadExcludedProjects
FROM 'C:\icrp\database\Migration\DoNotMigratedProjects.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 


CREATE TABLE sortedProjects (
	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL
)

--DECLARE @sortedProjects TABLE (
--	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
--	[OldProjectID] [int] NOT NULL	
--)

-- sorted by code, DateStart, BUDGETSTARTDATE, ImportYear, ID
INSERT INTO sortedProjects SELECT ID FROM icrp.dbo.project ORDER BY code, DateStart, BUDGETSTARTDATE, ImportYear, ID

CREATE TABLE [dbo].[Migration_Project] (
	[OldProjectID] [int] NOT NULL,		
	[SponsorCode] nvarchar(255) NOT NULL,
	[Code] nvarchar(255) NOT NULL,		
	[altid] [varchar] (50) NULL,
	[SOURCE_ID] [varchar] (50) NULL,	
	[INTERNALCODE] [varchar] (2000) NULL,
	[FundingOrgID] int NULL,	
	[IsActive] bit NULL	
)


----------------------------------------------------------------------------------------------------
-- Get all unique active projects (with funding info), exclude CCRA. 
----------------------------------------------------------------------------------------------------
-- If multiple funding records, keep the original one 
-- Total 64,154 active project funding records (55 projects with multiple funding)
INSERT INTO [Migration_Project] ([OldProjectID],[SponsorCode],[Code],[altid],[SOURCE_ID],[INTERNALCODE],[FundingOrgID],[IsActive]) 
SELECT MAX(p.ID) AS ProjectID, o.sponsorcode, p.code, p.altId, p.SOURCE_ID, p.INTERNALCODE, p.FundingOrgID, 1 AS IsActive
	FROM icrp.dbo.project p   -- 206582
		JOIN (
						SELECT ISNULL(pf.PROJECTID, u.ProjectID) AS ProjectID FROM icrp.dbo.ProjectFunding pf  
							FULL OUTER JOIN UploadNIHFundingAmountUpdate u ON u.ProjectID = pf.ProjectID 
		     ) f ON p.ID = f.ProjectID
		join icrp.dbo.fundingorg o on p.FUNDINGORGID = o.ID  -- 200937
		JOIN (select distinct projectid from icrp.dbo.TestProjectActive) t ON p.ID = t.PROJECTID 
	WHERE o.SPONSORCODE <> 'CCRA'  -- 63140
	GROUP BY p.code, p.altId, p.SOURCE_ID, p.INTERNALCODE, o.[SponsorCode], p.FundingOrgID  
	
		
----------------------------------------------------------------------------------------------------
-- Get all unique NIH inactive projects  (with funding info) should also be migrated to the new site
----------------------------------------------------------------------------------------------------  
--  63,907 NIH previous funding projects
INSERT INTO [Migration_Project]  ([OldProjectID],[SponsorCode],[Code],[altid],[SOURCE_ID],[INTERNALCODE],[FundingOrgID],[IsActive])
SELECT DISTINCT i.ProjectID, i.sponsorcode, i.code, i.altId, i.SOURCE_ID, i.INTERNALCODE,  i.FUNDINGORGID, 0  
FROM (SELECT MIN(p.id) AS ProjectID, p.code, p.altId, p.SOURCE_ID, p.INTERNALCODE,  o.sponsorcode, p.fundingOrgID  
		FROM icrp.dbo.project p
			--JOIN (select * from icrp.dbo.ProjectFunding where ISNULL(amount,0)<>0) f ON p.ID = f.ProjectID
			JOIN icrp.dbo.ProjectFunding f ON p.ID = f.ProjectID
			join icrp.dbo.fundingorg o on p.FUNDINGORGID = o.ID
			LEFT JOIN icrp.dbo.TestProjectActive a ON a.PROJECTID = p.id		 
		WHERE o.SponsorCode = 'NIH' AND a.PROJECTID IS NULL
		GROUP BY p.code, p.altId, p.SOURCE_ID, p.INTERNALCODE, o.[SponsorCode], p.fundingOrgID) i 	
LEFT JOIN [Migration_Project] m ON m.Code = i.Code AND m.altid = i.altId AND m.SOURCE_ID = i.SOURCE_ID AND m.INTERNALCODE = i.INTERNALCODE AND m.FundingOrgID = i.FundingOrgID
WHERE m.[OldProjectID] IS NULL


-- Delete awardcode 'F32AI106058-01A1'. Per Eddie: This is a data issue. F type awards don’t last that long, and from what I can tell, this grant was never awarded any dollars.
delete [Migration_Project] where code ='F32AI106058-01A1'

--select e.*, m.* from UploadExcludedProjects e
--LEFT JOIN [Migration_Project] m ON m.Code = e.AwardCode AND m.altid = e.AltAwardCode 
DELETE [Migration_Project] -- remove 52 NIH Projects (QVR shows $0)
FROM [Migration_Project] m
JOIN UploadExcludedProjects e ON m.Code = e.AwardCode AND m.altid = e.AltAwardCode

--print @@rowcount  -- 28?? should be 52

-- totally 126,570 project fundings
-- Total base projects: 104800

SELECT DISTINCT s.SortedProjectID, m.SPONSORCODE, m.IsActive, p.* INTO #migratedProjectFunding
FROM icrp.dbo.project p
	JOIN [Migration_Project] m ON p.ID = m.[OldProjectID]
	JOIN sortedProjects s ON p.id = s.OldProjectID	
ORDER BY s.SortedProjectID

--print @@rowcount 
--select distinct code, altId, SOURCE_ID, INTERNALCODE, sponsorcode, FundingOrgID from #migratedProjectFunding --126570
--select distinct code, sponsorcode from #migratedProjectFunding =104800

----------------------------------------------------------------------------------
-- Fix NIH Data
----------------------------------------------------------------------------------
/* Update AltID if not present */
--select * from #migratedProjectFunding

UPDATE #migratedProjectFunding SET AltId = code
FROM #migratedProjectFunding
where isnull(altid, '') = ''

/* Fix the NIH AwardCode - stripping out leading and training characters*/
UPDATE #migratedProjectFunding SET Code =
(case 	
	when INTERNALCODE like '%sub%' THEN left(internalcode, 8)
	when substring(internalcode, 13,1) = '-' THEN substring(internalcode, 5,8)
	when substring(internalcode, 9,1) = '-' THEN left(internalcode, 8)
	ELSE  internalcode 
END) 
FROM #migratedProjectFunding
WHERE SponsorCode = 'NIH'

/* Use InternalCode field for Category */

-- Identify intramural projects - Sub-Project
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Sub-project'  
from #migratedProjectFunding
where SponsorCode='nih' and substring(INTERNALCODE, 9,1) = '-' AND INTERNALCODE like '%sub%'

UPDATE #migratedProjectFunding SET INTERNALCODE = NULL WHERE INTERNALCODE <> 'Sub-project'

-- Identify extramural projects - Parent
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Parent'  
from #migratedProjectFunding
where SponsorCode='nih' and INTERNALCODE IS NULL and substring(altid, 13,1) = '-' AND substring(altid, 1,1) = '1' 

-- Identify extramural projects - Renewal
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Renewal'  
from #migratedProjectFunding
where SponsorCode='nih' and INTERNALCODE IS NULL and substring(altid, 13,1) = '-' AND substring(altid, 1,1) = '2' 

-- Identify extramural projects - Renewal
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Supplement'  
from #migratedProjectFunding
where SponsorCode='nih' and INTERNALCODE IS NULL and substring(altid, 13,1) = '-' AND substring(altid, 1,1) = '3' 

-- Identify extramural projects - Renewal
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Non-competing'  
from #migratedProjectFunding
where SponsorCode='nih' and INTERNALCODE IS NULL and substring(altid, 13,1) = '-' AND substring(altid, 1,1) = '5' 

-- Identify extramural projects - Renewal
UPDATE #migratedProjectFunding SET INTERNALCODE = 'Other'  
from #migratedProjectFunding
where SponsorCode='nih' and INTERNALCODE IS NULL and substring(altid, 13,1) = '-' 

-----------------------------
-- [Migration_Project_Base]  -- 60174
-----------------------------
PRINT 'Create [Migration_Project_Base]  ..................................'  -- 59631
--select top 10 * from #migratedProjectFunding
CREATE TABLE [dbo].[Migration_Project_Base] (
	[NewProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,	
	[SponsorCode] nvarchar(255) NOT NULL,
	[AwardCode] nvarchar(255) NOT NULL	
)

-- Use AwardCode and sponsorcode to group project (pull the oldest ProjectID - originally imported)
INSERT INTO [Migration_Project_Base] ([OldProjectID], [SponsorCode], [AwardCode])		
	SELECT a.ID, a.sponsorcode, a.Code
	FROM (SELECT code, sponsorcode, MIN(SortedProjectID) AS SortedProjectID FROM #migratedProjectFunding GROUP BY code, sponsorcode) bp  -- 106,285 base projects
	JOIN #migratedProjectFunding a ON bp.SortedProjectID = a.SortedProjectID	 -- 59631
	
	--SELECT *  FROM [Migration_Project_Base]-- GROUP BY code, sponsorcode
	--	SELECT code, sponsorcode  FROM #migratedProjectFunding GROUP BY code, sponsorcode

	--	SELECT code, sponsorcode  FROM Migration_Project 
	--	SELECT code, sponsorcode  FROM Migration_Project GROUP BY code, sponsorcode

-----------------------------
-- Project  -- 59631 base projects
-----------------------------
PRINT 'Migrate [Project]  ..................................'

SET IDENTITY_INSERT Project ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO Project  
(ProjectID, [AwardCode], [ProjectStartDate],[ProjectEndDate],[CreatedDate],[UpdatedDate])
SELECT bp.[NewProjectID], mp.code, mp.[DateStart], mp.[DateEnd], mp.[DATEADDED], mp.[LASTREVISED]
FROM [Migration_Project_Base] bp
	JOIN #migratedProjectFunding mp ON mp.id = bp.OldProjectID		
ORDER BY bp.[NewProjectID]

SET IDENTITY_INSERT Project OFF;  -- SET IDENTITY_INSERT to ON. 
GO 


DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM Project

PRINT 'Total Imported base projects = ' + @total

--------------------------------------------------------------------
-- PrjectAbstract  -- Only migrate abstract for migration_projects
--------------------------------------------------------------------
PRINT 'Migrate [ProjectAbstract]  ..................................'

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID, TechAbstract, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT a.ID, a.techAbstract, a.publicAbstract, a.dateadded, a.lastrevised
FROM icrp.dbo.Abstract a
	JOIN #migratedProjectFunding m ON m.abstractId = a.ID
ORDER BY a.id

update ProjectAbstract set TechAbstract = 'No abstract available for this Project funding.' where ProjectAbstractID =0
update ProjectAbstract set PublicAbstract = NULL where PublicAbstract = '0'

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectAbstract

PRINT 'Total Imported ProjectAbstract = ' + @total

--delete from Project
--DBCC CHECKIDENT ('[Project]', RESEED, 0)
GO
------------------------------
-- Project_ProjectType
-----------------------------
PRINT 'Migrate [Project_ProjectType]  ..................................'

INSERT INTO Project_ProjectType
(ProjectID, ProjectType)
select np.projectid, op.projecttype 
FROM [Migration_Project_base] bp
	join #migratedProjectFunding op on bp.OldProjectID = op.id
	join project np ON np.ProjectID = bp.[NewProjectID]

	--delete from Project_ProjectType

-----------------------------
-- [Migration_ProjectFunding]
-----------------------------
PRINT 'Create [Migration_ProjectFunding]  ..................................'

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
	[FundingContact] [varchar](75) NULL,	
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
SELECT bp.NewProjectID, op.ID, op.abstractID, op.title, op.institution, op.city,  op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,
	   op.OtherResearcherId, OtherResearcherIdType, op.FUNDINGORGID, op.FUNDINGDIVISIONID, op.internalcode, bp.sponsorcode, op.code, op.altid, op.SOURCE_ID, m.SPONSORMECHANISM,  
	   m.TITLE, op.fundingOfficer, pf.AMOUNT, 
	   CASE WHEN [Amount] = [AnnualizedAmount] THEN 1 ELSE 0 END AS [IsAnnualized],
	   op.BUDGETSTARTDATE, op.budgetenddate, op.[DATEADDED], op.[LASTREVISED]
FROM #migratedProjectFunding op   -- active projects from old icrp database
	 LEFT JOIN icrp.dbo.ProjectFunding pf ON op.ID = pf.ProjectID
	 LEFT JOIN icrp.dbo.Mechanism m ON m.ID = op.MechanismID
	 LEFT JOIN Migration_Project_base bp ON bp.AwardCode = op.code AND bp.sponsorcode = op.sponsorcode
ORDER BY bp.NewProjectID, op.sortedProjectID

-- UPDATE NIH funding amount
UPDATE [Migration_ProjectFunding] SET amount = u.amount
FROM [Migration_ProjectFunding] m
JOIN UploadNIHFundingAmountUpdate u ON m.[OldProjectID] = u.projectID

--select * from UploadNIHFundingAmountUpdate

-----------------------------
-- Fix Budget Start/End Date issues
-----------------------------

CREATE TABLE [dbo].[UploadProjectCorrections](
AwardCode varchar(150) NULL,
AltAwardCode varchar(150) NULL,
projectStartDate date NULL,
projectEndDate date NULL,
BudgetStartDate date NULL,
BudgetEndDate date NULL,
Amount float NULL,
Type varchar(25) NULL
)

GO

BULK INSERT [UploadProjectCorrections]
FROM 'C:\icrp\database\Migration\ProjectCorrections.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO 


-- Update Project dates
UPDATE project SET projectStartDate=b.projectStartDate, projectEndDate = b.projectEndDate
--select p.projectStartDate, p.projectEndDate, m.BudgetStartDate, m.BudgetEndDate, m.Amount
FROM project p 
join [Migration_ProjectFunding] m ON m.NewProjectID = p.ProjectID
JOIN (SELECT * FROM [UploadProjectCorrections] WHERE Type='date') b ON  m.awardcode = b.awardcode and m.AltAwardCode = b.AltAwardCode
GO

-- Update Budget dates
UPDATE [Migration_ProjectFunding] SET BudgetStartDate=b.BudgetStartDate, budgetEnddate=b.budgetEnddate
FROM [Migration_ProjectFunding] m 
JOIN (SELECT * FROM [UploadProjectCorrections] WHERE Type='date') b ON  m.awardcode = b.awardcode and m.AltAwardCode = b.AltAwardCode
GO

-- Update Amount
UPDATE [Migration_ProjectFunding] SET Amount=a.Amount
FROM [Migration_ProjectFunding] m 
JOIN (SELECT * FROM [UploadProjectCorrections] WHERE Type='amount') a ON  m.awardcode = a.awardcode and m.AltAwardCode = a.AltAwardCode
GO

-----------------------------
-- ProjectFunding
-----------------------------
PRINT 'Migrate [ProjectFunding]  ..................................'

SET IDENTITY_INSERT ProjectFunding ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectFunding 
([ProjectFundingID], [ProjectAbstractID], [Title],[ProjectID], [FundingOrgID], [FundingDivisionID], [Category], [AltAwardCode],	[Source_ID], [MechanismCode],[MechanismTitle], [FundingContact],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT [ProjectFundingID],[AbstractID], [Title], [NewProjectID], [FundingOrgID], [FundingDivisionID], [Category], [ALtAwardCode], [Source_ID],[MechanismCode], [MechanismTitle],[FundingContact], [Amount], [IsAnnualized], [BudgetStartDate],[BudgetEndDate], [CreatedDate],[UpdatedDate]
FROM [Migration_ProjectFunding]

SET IDENTITY_INSERT ProjectFunding OFF;  -- SET IDENTITY_INSERT to ON. 
GO 

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectFunding

PRINT 'Total Imported ProjectFunding = ' + @total


--delete from ProjectFunding
--DBCC CHECKIDENT ('[ProjectFunding]', RESEED, 0)
--select * from ProjectFunding  --200805

GO

-------------------------------------------------------------------------------------------
-- ProjectSearch   -- 75638
--------------------------------------------------------------------------------------------
PRINT 'Migrate [ProjectSearch]  ..................................'

INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT pf.ProjectID, '<Title>'+pf.Title + '</Title><FundingContact>'+ISNULL(pf.FundingContact,'') + '</FundingContact><TechAbstract>'
	   +a.TechAbstract + '</TechAbstract><PublicAbstract>' + ISNULL(a.PublicAbstract,'') + '</PublicAbstract>' AS Content 
FROM (SELECT MAX(f.ProjectFundingID) AS ProjectFundingID FROM ProjectAbstract a
	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
GROUP BY a.TechAbstract) fa
JOIN ProjectFunding pf ON fa.ProjectFundingID = pf.ProjectFundingID
JOIN ProjectAbstract a ON pf.ProjectAbstractID = a.ProjectAbstractID

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectSearch

PRINT 'Total Imported ProjectSearch = ' + @total
GO


--------------------------------------------------------------------------------------------
-- ProjectSearch_JP
--------------------------------------------------------------------------------------------
--PRINT 'Migrate [ProjectSearch_JP]'

--INSERT INTO ProjectSearch_JP (ProjectFundingID, [Content])
--SELECT MIN(f.ProjectFundingID), TechAbstract FROM ProjectAbstract a
--	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
--GROUP BY a.TechAbstract 

-----------------------------
-- ProjectCSO
-----------------------------
PRINT 'Migrate [ProjectCSO]  ..................................'

INSERT INTO ProjectCSO
(ProjectFundingID, [CSOCode],[Relevance],[RelSource],[CreatedDate],[UpdatedDate])
SELECT mf.[ProjectFundingID], c.Code, pc.[RELEVANCE], pc.[RELSOURCE], pc.[DATEADDED], pc.[LASTREVISED]
FROM icrp.dbo.projectCSO pc
	JOIN [Migration_ProjectFunding] mf ON pc.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.CSO c ON pc.CSOID = c.id  -- 187005	

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectCSO

PRINT 'Total Imported ProjectCSO = ' + @total

--delete from ProjectCSO
--DBCC CHECKIDENT ('[ProjectCSO]', RESEED, 0)
	
GO
-----------------------------
-- ProjectCancerType
-----------------------------
PRINT 'Migrate [ProjectCancerType]  ..................................'

INSERT INTO ProjectCancerType
(ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT mf.[ProjectFundingID], c.CancerTypeID, ps.RELEVANCE, ps.RELSOURCE, ps.ENTEREDBY 
FROM icrp.dbo.PROJECTSITE ps	
	JOIN [Migration_ProjectFunding] mf ON ps.PROJECTID = mf.OldProjectID	
	JOIN icrp.dbo.SITE s ON ps.SITEID = s.ID
	JOIN CancerType c ON s.Name = c.NAME

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectCancerType

PRINT 'Total Imported ProjectCancerType = ' + @total

GO

-----------------------------------------------------------------------
-- ProjectFundingExt - Do not pull over NIH calendar amounts (will recalculate amounts)
-----------------------------------------------------------------------
PRINT 'Migrate [ProjectFundingExt]  ..................................'

INSERT INTO ProjectFundingExt
([ProjectFundingID], [CalendarYear], [CalendarAmount])
SELECT m.[ProjectFundingID], a.[YEAR], a.[CALENDARAMOUNT_V2]
FROM icrp.dbo.[TestProjectActive] a
	JOIN [Migration_ProjectFunding] m ON a.PROJECTID = m.OldProjectID
WHERE m.sponsorcode <> 'NIH' and ISNULL(a.CALENDARAMOUNT_v2,0) <> 0

--delete from ProjectFundingExt
--DBCC CHECKIDENT ('[ProjectFundingExt]', RESEED, 0)
--select * from ProjectFundingExt  --200805

-----------------------------------------
-- ProjectFundingInvestigator (check investigator)
-----------------------------------------

PRINT 'Migrate [ProjectFunding_Investigator]   ..................................'

UPDATE [Migration_ProjectFunding] SET City = NULL where city = 'NULL' OR city = ''

UPDATE InstitutionMapping SET NewName ='Hotel Dieu De Montreal', NewCity ='Montreal' WHERE OldName = 'HOTEL DIEU DE MONTREAL'

UPDATE Institution SET City = 'Montréal' WHERE City IN ('Montr?al', 'Montreal', 'MontrTal','Mont-Royal')
UPDATE Institution SET City = 'Québec' WHERE City IN ('Qu?bec', 'Qu??bec', 'Quebec', 'QuÃ©bec')
UPDATE Institution SET City = 'Lévis' WHERE City IN ('LTvis', 'L?vis', 'Levis')
UPDATE Institution SET City = 'Zürich' WHERE City IN ('Zurich')
UPDATE Institution SET City = 'St. Louis' WHERE City IN ('Saint Louis', 'St Louis')
UPDATE Institution SET City = 'Sault Ste. Marie' WHERE City IN ('Sault Ste Marie')
UPDATE Institution SET City = 'St. Catharines' WHERE City IN ('St Catharines')
UPDATE Institution SET City = 'Trois-Rivières' WHERE City IN ('Trois-RiviFres')

UPDATE InstitutionMapping SET NewCity = 'Montréal' WHERE NewCity IN ('Montr?al', 'Montreal', 'MontrTal','Mont-Royal')
UPDATE InstitutionMapping SET NewCity = 'Québec' WHERE NewCity IN ('Qu?bec', 'Qu??bec', 'Quebec', 'QuÃ©bec')
UPDATE InstitutionMapping SET NewCity = 'Lévis' WHERE NewCity IN ('LTvis', 'L?vis', 'Levis')
UPDATE InstitutionMapping SET NewCity = 'Zürich' WHERE NewCity IN ('Zurich')
UPDATE InstitutionMapping SET NewCity = 'St. Louis' WHERE NewCity IN ('Saint Louis', 'St Louis')
UPDATE InstitutionMapping SET NewCity = 'Sault Ste. Marie' WHERE NewCity IN ('Sault Ste Marie')
UPDATE InstitutionMapping SET NewCity = 'St. Catharines' WHERE NewCity IN ('St Catharines')
UPDATE InstitutionMapping SET NewCity = 'Trois-Rivières' WHERE NewCity IN ('Trois-RiviFres')

UPDATE InstitutionMapping SET NewName ='Humanitas (United States)', NewCity = 'Silver Spring' WHERE NewCity = 'Silver Spring|'

INSERT INTO InstitutionMapping VALUES ('Humanitas Inc.','Silver Spring','Humanitas (United States)','Silver Spring')
INSERT INTO InstitutionMapping VALUES ('Humanitas Inc.','','Humanitas (United States)','Silver Spring')
INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'Advanced Genetic Systems', 'Sunnyvale', 'Advanced Genetic Systems (United States)', 'San Francisco'

UPDATE [Migration_ProjectFunding] SET newInstitution = m.newName, [newCity] = m.newCity 
FROM [Migration_ProjectFunding] f
JOIN InstitutionMapping m ON (f.institution = m.oldName AND ISNULL(f.city, '') = ISNULL(m.oldCity,'')) OR 
							 (f.institution = m.oldName) OR (f.institution = m.newName)
WHERE m.newName <> m.oldName OR ISNULL(m.oldCity, '') <> ISNULL(m.newCity, '')

UPDATE [Migration_ProjectFunding] SET newInstitution = 'Fox Chase Cancer Center', [newCity] = 'Philadelphia'
FROM [Migration_ProjectFunding] 
WHERE Institution = 'Institute for Cancer Research, Fox Chase Cancer Center'
--select count(*) from Institution

-- Manually insert the missing institutions into lookup
INSERT INTO Institution (Name, City, State, Country) 
SELECT distinct m.Institution, ISNULL(m.city, ''), m.state, m.country 
FROM [Migration_ProjectFunding] m
	 LEFT JOIN Institution i ON (i.name = m.newInstitution AND i.city = m.[newcity]) OR (i.name = m.newInstitution) 
	 where i.institutionid is null

delete Institution where name='Hotel Dieu De Montreal' and State=''
delete Institution where name='Humanitas Inc'


INSERT INTO ProjectFundingInvestigator 
([ProjectFundingID], [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], [IsPrivateInvestigator], InstitutionID)
SELECT distinct m.ProjectFundingID, ISNULL(m.piLastName, '') AS LastName, m.piFirstName, m.piORC_ID, m.[OtherResearch_ID], m.OtherResearch_Type, 1 AS IsPrivateInvestigator, ISNULL(i.InstitutionID, 1) AS InstitutionID --into #tmp
FROM [Migration_ProjectFunding] m
	 LEFT JOIN Institution i ON (i.name = m.newInstitution AND i.city = m.[newcity]) OR (i.name = m.newInstitution)
	 
-----------------------------------------------------------------
	 --select distinct institution, city into #i2
	 --FROM [Migration_ProjectFunding] m
		--join projectfundinginvestigator i ON m.ProjectFUndingID = i.ProjectFUndingID 
	 --WHERE i.institutionid =1 --PROJECTFUNDINGID in (82,150)

	 --select * from #i1 a
	 --left join #i2 b on a.institution = b.institution and a.city = b.city

	 --select 'icrp', * from Migration_ProjectFunding where institution like '%Humanitas Inc%'
	 --select 'lookup', * from institution where name like '%Humanitas %'
	 --select 'mapping', * from institutionmapping where oldname like '%Humanitas Inc%'
	 --select institution, city, newInstitution, newcity from  [Migration_ProjectFunding] where institution like '%Humanitas Inc%'
	 ----94	Advanced Genetic Systems, Inc.	San Francisco	Advanced Genetic Systems (United States)	San Francisco

	 --select * from UploadInstitution where institution_icrp like '%Humanitas Inc%'
	 --select * from UploadNIHInstitution where institution_icrp like '%Humanitas Inc%'
	 --select * from UploadNIHInstitutionName where institution_icrp like '%Humanitas Inc%' 
	 
	 --select top 10 * from projectfundinginvestigator
  -- select * from icrp.dbo.project where institution like '%Advanced Genetic%' 
  -- select * from icrp.dbo.TESTPROJECTACTIVE where projectid=148469
  -- select * from icrp.dbo.projectfunding where projectid=148469
    
   ---------------------------------------------------------------------------------
UPDATE ProjectFundingInvestigator SET ORC_ID = '0000-0001-7571-0304'
WHERE LastName='Irwin' AND FirstName = 'Melinda'

 -- test
 declare @notmapped int
 select @notmapped=count(*) from  ProjectFundingInvestigator  where ISNULL(institutionid,1) = 1
 IF EXISTS (select * from  ProjectFundingInvestigator  where ISNULL(institutionid,1) = 1)
	BEGIN
		PRINT 'non-mapped Institutions = ' + CAST (@notmapped AS varchar(10))
		
		SELECT distinct 'Institution not-mapped', ISNULL(m.Institution,'') AS Institution_ICRP, ISNULL(m.city,'') AS city_ICRP, m.NewInstitution, m.Newcity --distinct m.institution,  m.city
		FROM [Migration_ProjectFunding] m	
			join projectfundinginvestigator i ON m.ProjectFUndingID = i.ProjectFUndingID 
		WHERE i.InstitutionID = 1	

	 END
	 ELSE
		PRINT 'All ProjectFunsings are mapped to Institutions Lookup!!'	

--delete ProjectFundingInvestigator

DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectFundingInvestigator

PRINT 'Total Imported ProjectFundingInvestigator = ' + @total
	
GO
--------------------------------------------------
-- Migrate LibraryFolder and Library 
--------------------------------------------------
PRINT 'Migrate LibraryFolder   ..................................'

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


 INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[CreatedDate],[UpdatedDate])
VALUES ( 'ICRP_Data_Evaluation', 11, 0, getdate(),getdate())
 
--select distinct name, parentfolderid from LibraryFolder

-----------------------------------------
-- Library
-----------------------------------------
PRINT 'Migrate Library   ..................................'

-- Insert public documents
DECLARE @PublicationsFolderID INT
DECLARE @NewsLettersFolderID INT
DECLARE @MeetingReportsFolderID INT
DECLARE @ICRPDataFolderID INT

SELECT @PublicationsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Publications'
SELECT @NewsLettersFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Newsletters'
SELECT @MeetingReportsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Meeting Reports'
SELECT @ICRPDataFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='ICRP_Data_Evaluation'

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

INSERT INTO Library VALUES(@ICRPDataFolderID,'nci.xlsx', NULL, 'ICRP NCI Data Analysis','ICRP NCI Data Analysis', 1, NULL,getdate(), getdate())

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
	
UPDATE DataUploadStatus SET [Status] = 'Complete'

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

UPDATE CancerType SET Description ='Use this code for urinary cancers other than: Bladder (3), Kidney or Wilm''s tumor (25). The computer program will automatically map these cancer sites to this category'
WHERE Name='Urinary System'

UPDATE CancerType SET Description ='Includes Kidney cancer and Wilm''s tumor (60)'
WHERE Name='Kidney Cancer'

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
---------------------------
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

--	select * from #users
	
	
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



-- delete NIH Special awards - SP50

--begin transaction

--delete projectfundingext 
--from projectfundingext e
--JOIN projectfunding f on f.projectfundingid = e.projectfundingid
--where f.projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--delete projectcso 
--from projectcso c
--JOIN projectfunding f on f.projectfundingid = c.projectfundingid
--where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--delete projectcancertype
--from projectcancertype ct
--JOIN projectfunding f on f.projectfundingid = ct.projectfundingid
--where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)


--delete projectfundingInvestigator 
--from projectfundingInvestigator i
--JOIN projectfunding f on f.projectfundingid = i.projectfundingid
--where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--delete projectfunding where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)


--delete Project_ProjectType where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--delete project where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)


--delete projectabstract 
--from projectabstract a
--join projectfunding f on a.ProjectAbstractID = f.ProjectAbstractID
--where f.projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--delete projectsearch where projectid in (7837
--,9511
--,9512
--,12867
--,13782
--,13783
--,14896
--,30278)

--commit
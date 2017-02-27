-----------------------------
-- Country
-----------------------------
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
INSERT INTO CSOCategory
(Name, Code)
SELECT DISTINCT category, categoryCode from icrp.dbo.CSO order by categoryCode

-----------------------------
-- CSO
-----------------------------
INSERT INTO CSO
(Code, Name, ShortName, CategoryName, WeightName,SortOrder)
SELECT DISTINCT code, name, ShortName, Category, WEIGHTNAME, SortOrder from icrp.dbo.CSO order by code

-----------------------------
-- CancerType
-----------------------------
INSERT INTO CancerType
(Name, ICRPCode, IsCommon, IsArchived, SortOrder)
SELECT DISTINCT name, mappedID, 
	ISCOMMON, ISARCHIVED, SORTORDER from icrp.dbo.SITE order by mappedid

-----------------------------
-- PrjectAbstract
-----------------------------
SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO ProjectAbstract
(ProjectAbstractID, TechAbstract, PublicAbstract, CreatedDate, UpdatedDate)
SELECT DISTINCT ID, techAbstract, publicAbstract, dateadded, lastrevised
	from icrp.dbo.Abstract order by id

SET IDENTITY_INSERT ProjectAbstract OFF;   -- SET IDENTITY_INSERT to OFF. 
GO  

-----------------------------
-- Currency - De-dup...
-----------------------------
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
-- Institution
-----------------------------
INSERT INTO Institution
(Name, City, State, Country)
SELECT DISTINCT institution, ISNULL(city, ''), ISNULL(state,''), ISNULL(country, '')
FROM icrp.dbo.Project
WHERE ISNULL(institution,'') <> ''
ORDER BY institution

--delete FROM Institution
--DBCC CHECKIDENT ('[Institution]', RESEED, 0)

-----------------------------------------
-- [PartnerApplication]
-----------------------------------------
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

UPDATE Partner SET JoinedDate = o.JOINDATE
FROM Partner p
left join (SELECT SponsorCode, min(JOINDATE) AS JOINDATE FROM icrp.dbo.tblORG group by SponsorCode) o ON p.SponsorCode = o.SPONSORCODE

UPDATE Partner SET IsDSASigned = o.DSASIGNED
FROM Partner p
LEFT JOIN icrp.dbo.tblORG o ON p.Name = o.Name

-----------------------------
-- FundingOrg
-----------------------------
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
-- FundingDivision
-----------------------------
INSERT INTO FundingDivision
(FundingOrgID, Name, [Abbreviation], CreatedDate, UpdatedDate)
SELECT FundingOrgID, NAME, [ABBREVIATION], [DATEADDED], [LASTREVISED]
FROM icrp.dbo.fundingdivision

----------------------------------------------------------------------------------
-- Only migrate the active projects 
----------------------------------------------------------------------------------
DECLARE @sortedProjects TABLE (
	[SortedProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

INSERT INTO @sortedProjects SELECT ID, COde FROM icrp.dbo.project ORDER BY code, DateStart, BUDGETSTARTDATE, ImportYear, ID

SELECT DISTINCT s.SortedProjectID, p.* INTO #activeProjects
FROM icrp.dbo.project p
JOIN @sortedProjects s ON p.id = s.OldProjectID
JOIN icrp.dbo.TestProjectActive a ON p.ID = a.projectID
ORDER BY s.SortedProjectID

----------------------------------------------------------------------------------
-- Fix NIH AwardCode First by strippong out leading and training characters
----------------------------------------------------------------------------------
/* Fix the NIH AwardCode */
UPDATE #activeProjects SET Code =
(case 	
	when INTERNALCODE like '%sub%' THEN left(internalcode, 8)
	when substring(internalcode, 13,1) = '-' THEN substring(internalcode, 5,8)
	when substring(internalcode, 9,1) = '-' THEN left(internalcode, 8)
	ELSE  internalcode 
END) 
FROM #activeProjects a
JOIN icrp.dbo.FundingOrg f ON a.FUNDINGORGID = f.ID
WHERE f.SponsorCode = 'NIH'

/* Not fixed NIH code */
--select * from #activeProjects a
--JOIN FundingOrg f ON a.FUNDINGORGID = f.ID
--where f.SponsorCode='nih' and  len(code) <> 8

-----------------------------
-- [Migration_Project]
-----------------------------
CREATE TABLE [dbo].[Migration_Project] (
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AwardCode] nvarchar(1000) NOT NULL
)

-- Use AwardCode to group project (pull the oldest ProjectID - originally imported)
INSERT INTO [Migration_Project] ([OldProjectID], [AwardCode])		
	SELECT a.ID, bp.Code FROM (SELECT code, MIN(SortedProjectID) AS SortedProjectID FROM #activeProjects GROUP BY code) bp
	JOIN #activeProjects a ON bp.SortedProjectID = a.SortedProjectID	

-----------------------------
-- Project
-----------------------------
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
INSERT INTO ProjectDocument
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

--------------------------------------------------------------------------------------------
-- ProjectDocument_JP  - TBD: change to save the most recent project content/abstract?
--------------------------------------------------------------------------------------------
INSERT INTO ProjectDocument_JP
(ProjectID, [Content])
SELECT m.[ProjectID], s.[Text]
FROM icrp.dbo.search_JP s
	JOIN Migration_Project m ON s.ProjectID = m.OldProjectID

-----------------------------
-- Project_ProjectType
-----------------------------
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
CREATE TABLE [dbo].[Migration_ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[NewProjectID] [int] NOT NULL,
	[OldProjectID] [int] NOT NULL,
	[AbstractID] [int] NOT NULL,
	[Title] varchar(1000) NULL, 
	[Institution] varchar(250) NULL, 
	[city] varchar(250) NULL, 
	[state] varchar(250) NULL, 
	[country] varchar(250) NULL, 
	[piLastName] varchar(250) NULL,
	[piFirstName] varchar(250) NULL,
	[piORC_ID] varchar(250) NULL,
	[OtherResearch_ID] int NULL,
	[OtherResearch_Type] varchar(50) NULL,
	[FundingOrgID] [int] NOT NULL,
	[FundingDivisionID] [int] NULL,
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
	([NewProjectID], [OldProjectID], [AbstractID], [Title],[Institution], [city], [state], [country], [piLastName], [piFirstName], [piORC_ID], 
	 [OtherResearch_ID], [OtherResearch_Type], [FundingOrgID], [FundingDivisionID], [AwardCode], [AltAwardCode], [Source_ID], [MechanismCode], 
	 [MechanismTitle], [FundingContact], [Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT mp.ProjectID, op.ID, op.abstractID, op.title, op.institution, op.city, op.state, op.country, op.piLastName, op.piFirstName,  op.piORCiD,
	   op.OtherResearcherId, OtherResearcherIdType, op.FUNDINGORGID, op.FUNDINGDIVISIONID, op.code, op.altid, op.SOURCE_ID, m.SPONSORMECHANISM,  
	   m.TITLE, op.fundingOfficer, pf.AMOUNT, 
	   CASE WHEN [Amount] = [AnnualizedAmount] THEN 1 ELSE 0 END AS [IsAnnualized],
	   op.BUDGETSTARTDATE, op.budgetenddate, op.[DATEADDED], op.[LASTREVISED]
FROM #activeProjects op   -- active projects from old icrp database
	 LEFT JOIN icrp.dbo.ProjectFunding pf ON op.ID = pf.ProjectID
	 LEFT JOIN icrp.dbo.Mechanism m ON m.ID = op.MechanismID
	 LEFT JOIN Migration_Project mp ON mp.AwardCode = op.code	 	 
ORDER BY mp.ProjectID, op.sortedProjectID
 
-----------------------------
-- ProjectFunding
-----------------------------
SET IDENTITY_INSERT ProjectFunding ON;  -- SET IDENTITY_INSERT to ON. 
GO 

INSERT INTO ProjectFunding 
([ProjectFundingID], [ProjectAbstractID], [Title],[ProjectID], [FundingOrgID], [FundingDivisionID], [AltAwardCode],	[Source_ID], [MechanismCode],[MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate])
SELECT [ProjectFundingID],[AbstractID], [Title], [NewProjectID], [FundingOrgID], [FundingDivisionID], [ALtAwardCode], [Source_ID],[MechanismCode], [MechanismTitle],[Amount], [IsAnnualized], [BudgetStartDate],	[BudgetEndDate], [CreatedDate],[UpdatedDate]
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
INSERT INTO ProjectFundingExt
([ProjectID], [AncestorProjectID], [CalendarYear], [CalendarAmount])
SELECT p.[ProjectID], a.[ProjectIDANCESTOR], a.[YEAR], a.[CALENDARAMOUNT_V2]
FROM icrp.dbo.[TestProjectActive] a
JOIN Migration_Project p ON a.PROJECTID = p.OldProjectID

--delete from ProjectFundingExt
--DBCC CHECKIDENT ('[ProjectFundingExt]', RESEED, 0)
--select * from ProjectFundingExt  --200805

-----------------------------------------
-- ProjectFunding_Investigator (check investigator)
-----------------------------------------
INSERT INTO ProjectFundingInvestigator 
([ProjectFundingID], [LastName], [FirstName], [ORC_ID], [OtherResearch_ID], [OtherResearch_Type], [IsPrivateInvestigator], InstitutionID)
SELECT distinct f.ProjectFundingID, ISNULL(f.piLastName, ''), f.piFirstName, f.piORC_ID, f.[OtherResearch_ID], f.OtherResearch_Type, 1 AS IsPrivateInvestigator, inst.InstitutionID
FROM [Migration_ProjectFunding] f
	 LEFT JOIN Institution inst ON inst.name = f.Institution AND 
									(ISNULL(f.city, '') = ISNULL(inst.city, '')) AND 
									(ISNULL(f.state, '') = ISNULL(inst.state, '')) AND
									(ISNULL(f.country, '') = ISNULL(inst.country, ''))	  --200774	
WHERE inst.InstitutionID IS NOT NULL



-----------------------------------------
-- LibraryFolder
-----------------------------------------
SET IDENTITY_INSERT LibraryFolder ON;  -- SET IDENTITY_INSERT to ON. 
GO  

INSERT INTO LibraryFolder ([LibraryFolderID],[Name],[ParentFolderID],[IsPublic],[ArchivedDate],[CreatedDate],[UpdatedDate])
SELECT FID, [FOLDERNAME],[PARENTFOLDERID],0, 
CASE isArchived WHEN 1 THEN  getdate() ELSE NULL END AS [ArchivedDate], 
getdate(),getdate()
FROM icrp.dbo.tblFILEFOLDERS

SET IDENTITY_INSERT LibraryFolder OFF;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[ArchivedDate],[CreatedDate],[UpdatedDate])
VALUES ( 'Publications', 1, 1, NULL, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[ArchivedDate],[CreatedDate],[UpdatedDate])
VALUES ( 'Newsletters', 1, 1, NULL, getdate(),getdate())

INSERT INTO LibraryFolder ([Name],[ParentFolderID],[IsPublic],[ArchivedDate],[CreatedDate],[UpdatedDate])
VALUES ( 'Meeting Reports', 1, 1, NULL, getdate(),getdate())

go
-----------------------------------------
-- Library
-----------------------------------------
INSERT INTO Library 
SELECT [FID],[FILENAME],'', [FILETITLE],[DESCRIPTION], 0, [DATEARCHIVED],getdate(), getdate()
FROM icrp.dbo.tblLIBRARY

--select * from Library where ispublic=1

-- public publications
DECLARE @PublicationsFolderID INT
DECLARE @NewsLettersFolderID INT
SELECT @PublicationsFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Publications'
SELECT @NewsLettersFolderID=LibraryFolderID FROM LibraryFolder WHERE Name='Newsletters'

INSERT INTO Library VALUES(@PublicationsFolderID, '2014_NCRI_Childrens_Cancer_Research_Analysis.pdf','2014_NCRI_Childrens_Cancer_Research_Analysis_Cover.png', 'Children''''s Cancer Research','A report on international research investment in childhood cancer in 2008, by the UK National Cancer Research Institute and members of the International Cancer Research Partnership', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_ChildhoodCancer_2016.pdf','ICRP_ChildhoodCancer_2016.png', 'ICRP Childhood Cancer Analysis 2016','An overview of research investment in cancers affecting children, adolescents and young adults in the ICRP portfolio', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Disparities_ShortReport_2016.pdf','ICRP_Disparities_ShortReport_2016.png', 'ICRP Health Disparities Report 2016','An overview of research investment in health disparities and inequities in the ICRP portfolio', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfBreastCancer_ShortReport_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'Metastatic Breast Cancer Alliance Report 2014','An analysis of MBC clinical trials and grant funding from the ICRP and related databases from 2000 through 2013', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_EnvInfluences_BreastCancer_2014.pdf','ICRP_EnvInfluences_BreastCancer_2014_cover.png', 'ICRP report on environmental influences in breast cancer (2014)','An analysis of the research landscape in this area, examining trends in investment, research activity and gaps across a range of environmental carcinogens and lifestyle factors', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_GYN_analysis.pdf','GYN_cover.png', 'Gynecologic Cancers Portfolio Analysis','Summary of the burden of gynecologic cancers in the United States and investments in research by the National Cancer Institute and members of the International Cancer Research Partnership', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Obesity_Cancer_Report_2014.pdf','ICRP_Obesity_Cancer_Report_2014_cover.png', 'ICRP report into obesity and cancer research (2014)','This report examines trends in investment and publication outputs for research on the role of obesity in cancer', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Report_2005-08.pdf','ICRP_Data_Report_Cover.png', 'ICRP Data Report 2005-2008','This is the first, co-operative international analysis of the cancer research landscape, based on data from over 50 current member organizations about their individual projects and programs, each classified by type of cancer and type of research', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'ICRP_Translational_Methodology_2015.pdf','ICRP_Translational_Methodology_2015.png', 'ICRP Translational Research Methodology (2015)','This report details a robust and easy way to identify translational research awards and monitor trends in this area, using the ICRP’s Common Scientific Outline (CSO)', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@PublicationsFolderID,'MBCAlliance-Chapter-2.pdf','MBCAlliance-Chapter-2.png', '','', 1, NULL,getdate(), getdate())

-- public newsletters
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Feb2015.pdf','newsletter_2015_02.png', 'ICRP Newsletter, February 2015','Includes evaluation highlights presented at the San Antonio Breast Cancer Symposium, news about ICRP landscape reports and information about the ICRP annual meeting', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_November_2015.pdf','newsletter_2015_11.png', 'ICRP Newsletter, November 2015','Includes details on the launch of a new, more user-friendly version (V2) of the cancer classification system or Common Scientific Outline (CSO)', 1, NULL,getdate(), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_Newsletter_Summer_2015.pdf','.png', 'ICRP Newsletter, Summary 2015','ICRP Newsletter, Summary 2015', 1, getdate(),getdate(), getdate())
INSERT INTO Library VALUES(@NewsLettersFolderID,'ICRP_2016_Annual meeting_BriefSummary.pdf','report_2016_08.png', 'ICRP 2016 Annual Meeting Report','This report summarizes the ICRP''''s 2016 annual meeting on Health Disparities, hosted by the American Cancer Society', 1, getdate(),getdate(), getdate())

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


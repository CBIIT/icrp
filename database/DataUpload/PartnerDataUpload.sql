Use icrp_dataload
GO

----------------------------
-- REstart - del all temp tables 
-----------------------------
--drop table UploadWorkBook
-- go
--drop table #awardCodes
--go
--drop table #parentProjects
--go

----------------------------
-- Load Workbook 
-----------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

SET NOCOUNT ON;  
GO 
--select * from UploadWorkBook
CREATE TABLE UploadWorkBook (	
	AwardCode NVARCHAR(50),
	AwardStartDate Date,
	AwardEndDate date,
	SourceId VARCHAR(50),
	AltId VARCHAR(50),
	AwardTitle VARCHAR(1000),
	Category VARCHAR(25),
	AwardType VARCHAR(50),
	Childhood VARCHAR(5),
	BudgetStartDate date,
	BudgetEndDate date,
	CSOCodes VARCHAR(500),
	CSORel VARCHAR(500),
	SiteCodes VARCHAR(500),
	SiteRel VARCHAR(500),
	AwardFunding float,
	IsAnnualized VARCHAR(1),
	FundingMechanismCode VARCHAR(30),
	FundingMechanism VARCHAR(200),
	FundingOrgAbbr VARCHAR(50),
	FundingDiv VARCHAR(50),
	FundingDivAbbr VARCHAR(50),
	FundingContact VARCHAR(50),
	PILastName VARCHAR(50),
	PIFirstName VARCHAR(50),
	SubmittedInstitution VARCHAR(250),
	City VARCHAR(50),
	State VARCHAR(3),
	Country VARCHAR(3),
	PostalZipCode VARCHAR(15),
	InstitutionICRP VARCHAR(4000),
	Latitute decimal(9,6),
	Longitute decimal(9,6),
	GRID VARCHAR(50),
	TechAbstract NVARCHAR(max),
	PublicAbstract NVARCHAR(max),
	RelatedAwardCode VARCHAR(200),
	RelationshipType VARCHAR(200),
	ORCID VARCHAR(25),
	OtherResearcherID INT,
	OtherResearcherIDType VARCHAR(1000),
	InternalUseOnly  NVARCHAR(MAX)
)

GO

BULK INSERT UploadWorkBook
FROM 'C:\icrp\database\DataUpload\ICRPDataSubmission_KOMEN_20170407.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  -- import errors row #: 609, 6909 (Total: 13591)


-----------------------------------
-- Workbook Datafix - Institution  -- KOMEN
-----------------------------------
begin transaction
update uploadworkbook set city ='Amherst Center' where InstitutionICRP='University of Massachusetts Amherst'
update uploadworkbook set city ='Stanford' where InstitutionICRP='Stanford University'
commit


-----------------------------------
-- Workbook Datafix - | -- ASTRO
-----------------------------------
--UPDATE UploadWorkBook SET TechAbstract = 'I propose to develop statistical methods to (1) assess the performance of diagnostic tests and prognostic scores and (2) estimate risk (cumulative incidence) functions and, from them, individualized ''what if'' probabilities of benefit if a specific medical or lifestyle intervention is selected. In aim (1) the primary focus will be on the ''c'' statistic derived from multiple logistic regression. The initial biostatistical use of c was as the area under the roc curve (auc), to measure the discriminant ability of imaging tests (interpreted on a rating scale) and laboratory tests (measured on an interval scale). However, the index is also standard output from the SAS (multiple) LOGISTIC procedure and is increasingly used to assess the ability of diagnostic and prognostic scoring systems derived from a vector of predictors. If calculated from the same data from which the model is fitted, the statistic overestimates the true performance of the system. Indeed, by construction, the c statistic calculated from PROC LOGISTIC cannot be less than the null 0.5. Several authors (from Cornfield and Lachenbruch several decades ago, to Copas, Rockette, and Pinsky recently) have studied the factors that determine the magnitude of this bias. I propose to develop a simple ''adjusted-c'' statistic, similar to the adjusted-r-squared statistic. I expect that the needed attenuation/shrinkage will be a function of the numbers of cases and non-cases, and the numbers of useful - and useless - candidate predictor variables. A secondary focus will be on simplified lower confidence bound for the true auc when - in the simple imaging or laboratory test situations - the observed auc is unity. Obuchowshi has provided limits for this situation, but unfortunately they are too distribution-specific to be of general use. My plan is to draw on the simplicity and closed-form formulae based on overlapping exponential distributions, and on the insights on the var(auc) structure in our paper in Academic Radiology in 1997. Aim (2) has two parts. The first is to develop guidelines for a novel way (developed with my colleague Miettinen) to fit smooth-in-time hazard functions to survival-type data, where the event E=1 represents an undesirable outcome. The purpose is to estimate cumulative incidence as a function of a vector of patient characteristics and lifestyle/medical management options. The approach is based on sampling the person-moments; the main unknown is the choice of the sampling approach that gives the most stable estimate of the individualized cumulative incidence. The second aim is to derive an interval estimate for the probability of benefit within a time horizon T, for an individual with a personal profile vector x, and contemplated medical/behavioral Action (A=1) or not (A=0), i.e. the difference Prob[E=1 | x, T, A=0] - Prob[E=1 | x, T,A=1]. The hope is to have the individualized interval be test-based, so that it can be calculated from the information usually contained in study reports. We focus on individualized risk differences as a response to the inordinate emphasis on the ''average'' patient and on hazard ratios rather than what matters to an individual: for individuals such as I, with profile x, what is the difference in the probability of E over a time-horizon T if I choose one action over another? As an example, consider the 2005 NEJM report on an RCT which documented the extent to which radical prostatectomy reduces the risk of death from prostate cancer: the ''average'' prostate cancer case-fatality rate within 10 years was 15% for those randomized to watchful waiting and 10% for those randomized to surgery; the hazard ratio was 0.55. The report contained no useful information for men with a patient/tumour profile (age at diagnosis, Gleason score, pre-treatment PSA level) that was more/less favourable than the ''average'' profile to which the summary results presumably apply. With methods that are aimed at individualized risk, and that do not rely on the non-smooth estimates obtained from Cox''s proportional hazards model, we plan to change the contemporary culture of statistical reporting to be more responsive to individual ''clients''.'
--WHERE AltId = '10769_1'

--UPDATE UploadWorkBook SET TechAbstract = 'The program of research addressing five research aims, was undertaken by a research team (organized into the Evidence Expert Panel, Best Practices Expert Panel and the main Scientific Office): Research Aims: 1. Using existing KT resources, to identify and analyze high quality systematic reviews and guidelines (e.g. Cochrane Review) in the published literature evaluating the effectiveness of interventions directed to change behaviour across stakeholder groups. A measurement tool to operationalize the degree of KT intervention effectiveness was developed. 2. Using a targeted review, to analyze selected frameworks, models and theories that may be useful in directing KT strategy, planning, and practice to improve quality in cancer control. 3. Using key informant interviews and questionnaire methodologies, to identify best Canadian KT practices in use, being tested or targeted to improve cancer control. A tool to operationalize the concept of ‘best practices’ was developed. 4. Using consensus methodology, findings from Aims 1 to 3 will be integrated to identify gaps and priorities in the KT research field as it relates to improving cancer control. 5. The planning and implementation of a strategy to facilitate the use and application of the findings using integrated- and end-of-grant KT principles. Final Reports: 1. Knowledge Translation for Cancer Control in Canada: A Casebook. 2. Knowledge translation to improve quality of cancer control in Canada: What we know and what is next. Publication: Brouwers MC, Makarski J, Garcia K, Bouseh S, Hafid T. Improving cancer control in Canada one case at a time: the "Knowledge Translation in Cancer" casebook. Curr Oncol. 2011;18(2):76-83. PubMed PMID: 21505598; PubMed Central PMCID: PMC3070706 PDF | APPENDIX A | APPENDIX B | HTML Brouwers MC; Garcia K; Makarski J; Daraz L; of the Evidence Expert Panel and of the KT for Cancer Control in Canada Project Research Team. The landscape of knowledge translation interventions in cancer control: What do we know and where to next? A review of systematic reviews. Implementation Science 2011, 6, 130. doi:10.1186/1748-5908-6-130 PDF | HTML'
--WHERE AltId = '18497_1'

-------------------------------------------------------------------
-- New Institutions  -- KOMEN
-------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM Institution WHERE Name = 'Martin Luther University Halle-Wittenberg' AND City='Halle')
	INSERT INTO Institution VALUES('Martin Luther University Halle-Wittenberg', NULL, 51.486389, 11.968889,NULL, 'Halle', NULL, 'DE','grid.9018.0', getdate(), getdate())

/***********************************************************************************************/
-- Validation
/***********************************************************************************************/
PRINT '******************************************************************************'
PRINT '***************************** Data Integrity Check ***************************'
PRINT '******************************************************************************'

-- Check related project base data
--drop table #awardCodes
--go
--drop table #parentProjects
--go

-------------------------------------------------------------------
-- Check AwardCode uniqueness
-------------------------------------------------------------------

SELECT Distinct AwardCode INTO #awardCodes FROM UploadWorkBook

--SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA
SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook

DECLARE @TotalAwardCodes INT
DECLARE @TotalParentProjects INT

SELECT @TotalAwardCodes = COUNT(*) FROM #awardCodes
SELECT @TotalParentProjects = COUNT(*) FROM #parentProjects

PRINT 'Checking Total parent projects = total award codes...'
IF @TotalAwardCodes <> @TotalParentProjects
BEGIN
  PRINT 'ERROR ==> Total parent projects <> total award codes'
  SELECT 'No parent Category' AS Issue, AwardCode FROM #awardCodes WHERE AwardCode NOT IN (SELECT AwardCode FROM #parentProjects)
END
ELSE
	PRINT 'Checking Total parent projects = total award codes  ==> Pass'

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
PRINT 'Checking Budget Dates........'
--drop table #budgetDates

SELECT AwardCode, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS duration INTO #budgetDates FROM UploadWorkBook

IF EXISTS (SELECT * FROM #budgetDates WHERE duration < 2)
BEGIN
  PRINT 'ERROR ==> Budget Durations <= 1 day'
  SELECT 'Budget Duration too small' AS Issue, * FROM #budgetDates WHERE duration < 2
END
ELSE
BEGIN
DECLARE @minduration int
	SELECT @minduration = MIN(duration) FROM #budgetDates
	PRINT 'Checking Budget Dates (MIN duration is ' + CAST (@minduration AS varchar(10)) + ' => Pass'
END

--select * from UploadWorkBook where awardcode='10238_2'

	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
PRINT 'Checking Funding Amount........'
-- drop table #fundingAmount
SELECT AwardCode, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook

IF EXISTS (SELECT * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) <= 0)
BEGIN
  PRINT 'WARNING ==> Funding Amount <= 0'
  SELECT 'No Funding Amount' AS Issue, * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) <= 0
END

ELSE

BEGIN	
	PRINT 'Checking Funding Amount => Pass'
END

-------------------------------------------------------------------
-- Check CSO Codes
-------------------------------------------------------------------
IF EXISTS (select csocodes, csorel from UploadWorkBook where ISNULL(csocodes,'')='' or ISNULL(csorel,'')='')
BEGIN
  PRINT 'ERROR ==> Missing CSO Codes / Relevance'
  SELECT DISTINCT 'Missing CSO Codes / / Relevance' AS Issue, AwardCode, AltId from UploadWorkBook 	
	WHERE ISNULL(csocodes,'')='' or ISNULL(csoRel,'')=''
END
ELSE
	PRINT 'Checking Missing CSO Codes / Relevance  ==> Pass'

		
-------------------------------------------------------------------
-- Check Historical CSO Codes
-------------------------------------------------------------------
IF EXISTS (select sitecodes from UploadWorkBook where sitecodes like '%7.1%' OR sitecodes like '%7.2%' OR sitecodes like '%7.3%' OR sitecodes like '%1.6%' OR sitecodes like '%6.8%')
BEGIN
  PRINT 'ERROR ==> Historical CSO Codes'
  SELECT DISTINCT 'Historical CSO Codes' AS Issue, AwardCode, AltId, sitecodes from UploadWorkBook 
	WHERE ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''
END
ELSE
	PRINT 'Checking Historical CSO Codes  ==> Pass'

-------------------------------------------------------------------
-- Check CancerType Codes
-------------------------------------------------------------------
IF EXISTS (select sitecodes, siterel from UploadWorkBook where ISNULL(sitecodes,'')='' or ISNULL(siterel,'')='')
BEGIN
  PRINT 'ERROR ==> Missing CancerType Codes / Relevance'
  SELECT DISTINCT 'Missing CancerType Codes / Relevance' AS Issue, AwardCode, AltId from UploadWorkBook 
	WHERE ISNULL(sitecodes,'')='' or ISNULL(siterel,'')=''
END
ELSE
	PRINT 'Checking Missing CancerType Codes / Relevance ==> Pass'


	
-------------------------------------------------------------------
-- Check AwardType Codes
-------------------------------------------------------------------
IF EXISTS (select AwardType from UploadWorkBook where ISNULL(AwardType,'') NOT IN ('R','C','T'))
BEGIN
  PRINT 'ERROR ==> Incorrect AwardType'
  SELECT DISTINCT 'Incorrect AwardType' AS Issue, AwardType from UploadWorkBook 
	WHERE ISNULL(AwardType,'') NOT IN ('R','C','T')
END
ELSE
	PRINT 'Checking Incorrect AwardType ==> Pass'

-------------------------------------------------------------------
-- Check Annulized Value
-------------------------------------------------------------------
IF EXISTS (select IsAnnualized from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('A','N'))
BEGIN
  PRINT 'ERROR ==> Incorrect Annualized Value'
  SELECT DISTINCT 'Incorrect Annualized' AS Issue, IsAnnualized from UploadWorkBook 
	WHERE ISNULL(IsAnnualized,'') NOT IN ('A','N')
END
ELSE
	PRINT 'Checking Incorrect Annualized ==> Pass'

-------------------------------------------------------------------
-- Check FundingOrg
-------------------------------------------------------------------
IF EXISTS (SELECT DISTINCT FundingOrgAbbr from UploadWorkBook 
where FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg))
BEGIN
  PRINT 'ERROR ==> FundingOrg Not Exist --> Add FundingOrg First'
  SELECT DISTINCT 'Missing FundingOrg' AS Issue, FundingOrgAbbr from UploadWorkBook 
	WHERE FundingOrgAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingOrg)
END
ELSE
	PRINT 'Checking FundingOrg  ==> Pass'

-------------------------------------------------------------------
-- Check FundingDiv
-------------------------------------------------------------------
IF EXISTS (SELECT DISTINCT FundingDivAbbr from UploadWorkBook 
	WHERE FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
BEGIN
  PRINT 'ERROR ==> FundingDiv Not Exist --> Add FundingDiv First'
 SELECT DISTINCT 'Missing FundingDiv' AS Issue, FundingDivAbbr from UploadWorkBook 
	WHERE FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision)
END
ELSE
	PRINT 'Checking FundingDiv  ==> Pass'

-------------------------------------------------------------------
-- Check unique Project Funding Altid 
-------------------------------------------------------------------
IF EXISTS (SELECT Altid, Count(*) AS Count FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1)
BEGIN
  PRINT 'ERROR ==> Altid not unique'
 SELECT 'Duplicate Altid' AS Issue, Altid, Count(*) AS Count FROM UploadWorkBook GROUP BY Altid HAVING COUNT(*) > 1
END
ELSE
	PRINT 'Checking unique Project Funding Altid   ==> Pass'

-------------------------------------------------------------------
-- Check duplicate Project Funding
-------------------------------------------------------------------
IF EXISTS (select AltId, count(*) from UploadWorkBook group by AwardCode, AltId, BudgetStartDate, BudgetEndDate having count(*) >1)
BEGIN
SELECT 'Duplicate Project Funding' AS Issue, AwardCode,  AltId, BudgetStartDate, BudgetEndDate, count(*) AS Count from UploadWorkBook group by AwardCode, AltId, BudgetStartDate, BudgetEndDate having count(*) >1
END 
ELSE
	PRINT 'Checking duplicate Project Funding   ==> Pass'

-- Check if AwardCodes alreadt exist in ICRP
--IF EXISTS (select * FROM UploadWorkBook WHERE AwardCode IN (SELECT AwardCode FROM Project) )
--BEGIN
--	SELECT 'AwardCode Exists' AS Issue, AwardCode from UploadWorkBook WHERE AwardCode IN (SELECT AwardCode FROM Project)
--END 


-------------------------------------------------------------------
-- Check Institutions
-------------------------------------------------------------------
--drop table #missingInst
--go

SELECT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) OR (u.InstitutionICRP = m.OldName AND u.City = m.newCity)
WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)
--select * from #missingInst
IF EXISTS (select * FROM #missingInst)
BEGIN
	SELECT DISTINCT 'Institution cannot be mapped' AS Issue, w.InstitutionICRP AS 'workbook - Institution Name', w.city AS 'workbook - Institution city'
	FROM (select Institution FROM #missingInst group by InstitutionICRP, city) m
	LEFT JOIN Institution l ON m.InstitutionICRP = l.Name
	LEFT JOIN UploadWorkBook w ON m.Institution = w.InstitutionICRP
	ORDER BY  w.institution 
END 
ELSE
	PRINT 'Checking Institution Mapping   ==> Pass'

	--select * from UploadWorkBook

	--select distinct SponsorCode from FundingOrg where SponsorCode in ('CCR','GTDR','PDF')

-- Debug missing institution
--select institution, city, Country, GRID, Longitute, Latitute from UploadWorkBook where institution like '%Wisconsin%'
--select * FROM Institution where name like '%Wisconsin%' --'%UCLA%'
--select * FROM InstitutionMapping where oldname like '%Wisconsin%' OR newname like '%Wisconsin%'

-- Insert institution Mappings
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'UCLA', 'Los Angeles', 'University of California Los Angeles', 'Los Angeles'
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'University of Alabama Birmingham', 'Birmingham', 'University of Birmingham', 'Birmingham'
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'University of Maryland Medical Center', 'Baltimore', 'University of Maryland, Baltimore', 'Baltimore'
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'University of Wisconsin Hospitals and Clinics', 'Madison', 'University of Wisconsin - Madison', 'Madison'
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'William Beaumont Hospital Research Institute', 'Royal Oak', 'William Beaumont Hospital', 'Royal Oak'

-------------------------------------------------------------------
-- PreCheck no duplicate institutions and no missing pi info
-------------------------------------------------------------------
--drop table #dupPI

select f.projectfundingid into #dupPI from projectfunding f
	join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid
	join fundingorg o on f.FundingOrgID = o.FundingOrgID
	where o.SponsorCode = 'KOMEN'
	group by f.projectfundingid having count(*) > 1

	
IF EXISTS (select * FROM #dupPI)
BEGIN
	SELECT DISTINCT 'Duplicate PIs' AS Issue, pf.projectfundingid, i.institutionid, o.sponsorcode, o.name as FundingOrg, p.awardcode, pf.altawardcode, pf.budgetstartdate, pf.budgetenddate, 
	fi.lastname AS piLastName, fi.FirstName AS piFirstName, i.name as institution, i.city, i.Country 
	from #dupPI d
		join projectfunding pf on pf.projectfundingid = d.projectfundingid
		join project p on pf.projectid = p.projectid
		join fundingorg  o on o.sponsorCode = 'CCRA'
		join projectfundinginvestigator fi on pf.projectfundingid = fi.projectfundingid
		join institution i on i.institutionid = fi.institutionid
	order by o.sponsorcode, pf.AltAwardCode  -- 14907
END 
ELSE
	PRINT 'Pre-Checking duplicate PIs ==> Pass'

-- checking missing PI
select f.ProjectFundingID into #missingPI from projectfunding f
join fundingorg o on f.FundingOrgID = o.FundingOrgID
left join ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
where o.SponsorCode = 'KOMEN' and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #missingPI)
BEGIN
	SELECT DISTINCT 'Pre-Check Missing PIs' AS Issue, *
	from #missingPI
END 
ELSE
	PRINT 'Pre-Checking Missing PIs ==> Pass'

GO

BEGIN TRANSACTION
-----------------------------------
-- Insert Data Upload Status
-----------------------------------
DECLARE @DataUploadStatusID INT
DECLARE @PartnerCode VARCHAR(25) = 'KOMEN'
DECLARE @FundingYears VARCHAR(25) = '2016'
DECLARE @ImportNotes  VARCHAR(1000) = 'Projects commencing in FY2016'

INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', '4/7/2017', '4/7/2017', '4/7/2017',  '4/7/2017', NULL, @ImportNotes, getdate())


SET @DataUploadStatusID = IDENT_CURRENT( 'DataUploadStatus' )  

PRINT 'DataUploadStatusID = ' + CAST(@DataUploadStatusID AS varchar(10))

INSERT INTO icrp_data.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', '4/7/2017', '4/7/2017', '4/7/2017',  '4/7/2017', NULL, @ImportNotes, getdate())

/***********************************************************************************************/
-- Import Data
/***********************************************************************************************/
PRINT '*******************************************************************************'
PRINT '***************************** Import Data  ************************************'
PRINT '******************************************************************************'

-----------------------------------
-- Import base Projects
-----------------------------------
PRINT 'Import base Projects'

INSERT INTO Project 
SELECT CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
		AwardCode, AwardStartDate, AwardEndDate, getdate(), getdate()
FROM #parentProjects

PRINT 'Total Imported projects = ' + CAST(@@RowCount AS varchar(10))


-----------------------------------
-- Import Project Abstract
-----------------------------------
PRINT '-- Import Project Abstract'

CREATE TABLE UploadAbstract (	
	ID INT NOT NULL IDENTITY(1,1),
	AwardCode NVARCHAR(50),
	Altid NVARCHAR(50),
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]

SET IDENTITY_INSERT UploadAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO UploadAbstract (ID) SELECT ProjectAbstractID FROM ProjectAbstract

SET IDENTITY_INSERT UploadAbstract OFF  -- SET IDENTITY_INSERT to ON. 

INSERT INTO UploadAbstract (AwardCode, Altid, TechAbstract, PublicAbstract) SELECT DISTINCT AwardCode, Altid, TechAbstract, PublicAbstract FROM UploadWorkBook 

UPDATE ProjectAbstract SET PublicAbstract = NULL where PublicAbstract = '0'

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO ProjectAbstract (ProjectAbstractID, TechAbstract, PublicAbstract) 
SELECT ID, TechAbstract, PublicAbstract FROM UploadAbstract  WHERE AwardCode IS NOT NULL

PRINT 'Total Imported ProjectAbstract = ' + CAST(@@RowCount AS varchar(10))

SET IDENTITY_INSERT ProjectAbstract OFF;  -- SET IDENTITY_INSERT to OFF. 


DECLARE @total VARCHAR(10)
SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectAbstract

PRINT 'Total ProjectAbstract = ' + @total

-----------------------------------
-- Import ProjectFunding
-----------------------------------
PRINT 'Import ProjectFunding'

INSERT INTO ProjectFunding
SELECT u.AwardTitle, p.ProjectID, o.FundingOrgID, d.FundingDivisionID, a.ID, @DataUploadStatusID,    --ProjectAbtractID
	u.Category, u.AltId, u.SourceId, u.FundingMechanismCode, u.FundingMechanism, u.FundingContact, 
	CASE ISNULL(u.IsAnnualized, '') WHEN 'A' THEN 1 ELSE 0 END, 
	u.AwardFunding, 
	u.BudgetStartDate, u.BudgetEndDate, getdate(), getdate()
FROM UploadWorkBook u
JOIN UploadAbstract a ON u.AwardCode = a.AwardCode AND u.AltId = a.Altid
JOIN Project p ON u.AwardCode = p.awardCode
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation

--DECLARE @total VARCHAR(10)
--SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM Institution

--PRINT 'Total Imported Institutions = ' + @total
--GO

PRINT 'Total newly Imported ProjectFunding = ' + CAST(@@RowCount AS varchar(10))


-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
PRINT '-- Import ProjectFundingInvestigator'

INSERT INTO ProjectFundingInvestigator ([ProjectFundingID], [LastName],	[FirstName],[ORC_ID],[OtherResearch_ID],[OtherResearch_Type],[IsPrivateInvestigator],[InstitutionID],[InstitutionNameSubmitted])
SELECT DISTINCT f.ProjectFundingID, u.PILastName, u.PIFirstName, u.ORCID, u.OtherResearcherID, u.OtherResearcherIDType, 1, ISNULL(inst.InstitutionID,1) AS InstitutionID, u.SubmittedInstitution
FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	LEFT JOIN (SELECT i.InstitutionID, i.Name, i.City, m.OldName, m.oldCity 
	           FROM Institution i 
				 LEFT JOIN InstitutionMapping m ON i.name = m.newName AND i.City = m.newCity) inst 
     ON (u.InstitutionICRP = inst.Name AND u.City = inst.City) -- OR (u.SubmittedInstitution= inst.OldName AND u.City = inst.OldCity) OR (u.InstitutionICRP = inst.OldName AND u.City = inst.OldCity) 

PRINT 'Total newly Imported ProjectFundingInvestigator = ' + CAST(@@RowCount AS varchar(10))

--DECLARE @total VARCHAR(10)
--SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM ProjectFundingInvestigator

--PRINT 'Total Imported ProjectFundingInvestigator = ' + @total

select * from uploadworkbook where InstitutionICRP like '%Maisonneuve-Rosemont%' or SubmittedInstitution  like '%Maisonneuve-Rosemont%'
----------------------------------------------------
-- Post Import Checking
----------------------------------------------------
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
BEGIN
	select 'Post Import Check - Not-mapped institution', * 
	from #postNotmappedInst i	
END
ELSE
	PRINT 'Post Import Check - Instititutions all mapped'

	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)
BEGIN
	SELECT DISTINCT 'Duplicate PIs' AS Issue, d.*, fi.lastname AS piLastName, fi.FirstName AS piFirstName, i.name as institution, i.city, i.Country 
	from #postdupPI d
		join projectfundinginvestigator fi on d.projectfundingid = fi.projectfundingid
		join institution i on i.institutionid = fi.institutionid
	order by d.AltAwardCode 
END 
ELSE
	PRINT 'Post-Checking duplicate PIs ==> Pass'

-- checking missing PI
select f.ProjectFundingID into #postMissingPI from projectfunding f
join fundingorg o on f.FundingOrgID = o.FundingOrgID
left join ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
where o.SponsorCode = 'KOMEN' and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)
BEGIN
	SELECT DISTINCT 'Post-Check Missing PIs' AS Issue, *
	from #missingPI
END 
ELSE
	PRINT 'Pre-Checking Missing PIs ==> Pass'

		
-----------------------------------
-- Import ProjectCSO
-----------------------------------
PRINT 'Import ProjectCSO'

SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel, AwardType INTO #list
FROM UploadWorkBook u
JOIN ProjectFunding f ON u.AltId = f.AltAwardCode

DECLARE @pcso TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,
	CSO VARCHAR(50)	
)

DECLARE @pcsorel TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,	
	Rel VARCHAR(50)
)

DECLARE @projectFundingID as INT
DECLARE @csoList as NVARCHAR(50)
DECLARE @csoRelList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectFundingID, CSOCodes , CSORel FROM #list;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectFundingID, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @pcso SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoList)
 INSERT INTO @pcsorel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoRelList) 
 FETCH NEXT FROM @cursor INTO @projectFundingID, @csolist, @csoRelList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO ProjectCSO SELECT c.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM @pcso c 
JOIN @pcsorel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq


GO
-----------------------------------
-- Import ProjectCancerType
-----------------------------------
PRINT 'Import ProjectCancerType'

DECLARE @psite TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,
	Code VARCHAR(50)	
)

DECLARE @psiterel TABLE
(
	Seq INT NOT NULL IDENTITY (1,1),
	ProjectFundingID INT,	
	Rel VARCHAR(50)
)

DECLARE @projectFundingID as INT
DECLARE @siteList as NVARCHAR(50)
DECLARE @siteRelList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectFundingID, SiteCodes , SiteRel FROM #list;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectFundingID, @siteList, @siteRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @psite SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteList)
 INSERT INTO @psiterel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteRelList) 
 FETCH NEXT FROM @cursor INTO @projectFundingID, @siteList, @siteRelList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT c.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM @psite c 
JOIN CancerType ct ON c.code = ct.ICRPCode
JOIN @psiterel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq

GO

-----------------------------------
-- Import Project_ProjectTye
-----------------------------------
PRINT 'Import Project_ProjectTye'

DECLARE @ptype TABLE
(	
	ProjectID INT,	
	ProjectType VARCHAR(15)
)

DECLARE @projectID as INT
DECLARE @typeList as NVARCHAR(50)
 
DECLARE @cursor as CURSOR;

SET @cursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #list) p;
 
OPEN @cursor;
FETCH NEXT FROM @cursor INTO @projectID, @typeList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @ptype SELECT @projectID, value FROM  dbo.ToStrTable(@typeList) 
 FETCH NEXT FROM @cursor INTO @projectID, @typeList;
END
 
CLOSE @cursor;
DEALLOCATE @cursor;

INSERT INTO Project_ProjectType (ProjectID, ProjectType)
SELECT ProjectID,
		CASE ProjectType
		  WHEN 'C' THEN 'Clinical Trial'
		  WHEN 'R' THEN 'Research'
		  WHEN 'T' THEN 'Training'
		END
FROM @ptype	

GO


-----------------------------------
-- Import ProjectFundingExt
-----------------------------------
-- call php code to calculate and populate calendar amounts


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
PRINT 'Rebuild [ProjectSearch]'

DELETE FROM ProjectSearch

DBCC CHECKIDENT ('[ProjectSearch]', RESEED, 0)
GO

-- REBUILD All Abstract
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT f.ProjectID, '<Title>'+ f.Title+'</Title><FundingContact>'+ ISNULL(f.fundingContact, '')+ '</FundingContact><TechAbstract>' + a.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(a.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(ProjectAbstractID) AS ProjectAbstractID FROM ProjectAbstract GROUP BY TechAbstract) ma
	JOIN ProjectFunding f ON ma.ProjectAbstractID = f.ProjectAbstractID
	JOIN ProjectAbstract a ON ma.ProjectAbstractID = a.ProjectAbstractID

PRINT 'Total Imported ProjectSearch = ' + CAST(@@RowCount AS varchar(10))

-------------------------------------------------------------------------------------------
-- Insert DataUploadLog 
--------------------------------------------------------------------------------------------

select * from datauploadstatus order by DataUploadStatusID desc
PRINT 'INSERT DataUploadLog'

DECLARE @DataUploadStatusID INT = 65
DECLARE @DataUploadLogID INT

INSERT INTO DataUploadLog (DataUploadStatusID, [CreatedDate])
VALUES (@DataUploadStatusID, getdate())

SET @DataUploadLogID = IDENT_CURRENT( 'DataUploadLog' )  

PRINT '@DataUploadLogID = ' + CAST(@DataUploadLogID AS varchar(10))

DECLARE @Count INT

-- Insert Project Count
SELECT @Count=COUNT(*) FROM Project c 
JOIN ProjectFunding f ON c.ProjectID = f.ProjectID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectAbstractCount
SELECT @Count=COUNT(*) FROM ProjectAbstract a
JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCSOCount
SELECT @Count=COUNT(*) FROM ProjectCSO c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCancerTypeCount Count
SELECT @Count=COUNT(*) FROM ProjectCancerType c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert Project_ProjectType Count
SELECT @Count=COUNT(*) FROM Project_ProjectType t
JOIN Project p ON t.ProjectID = p.ProjectID 
JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingCount
SELECT @Count=COUNT(*) FROM ProjectFunding 
WHERE dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingInvestigatorCount Count
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @@RowCount WHERE DataUploadLogID = @DataUploadLogID


-- Insert ProjectSearchTotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch s
JOIN Project p ON s.ProjectID = p.ProjectID 
JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

select * from datauploadlog

--commit

rollback


SET NOCOUNT OFF;  
GO 
-------------------------------------------------------------------------------------------
-- Fix character Issues - CA
--------------------------------------------------------------------------------------------
--CREATE TABLE UploadWorkBookCharacterFix (	
--	AwardCode NVARCHAR(50),
--	AltId VARCHAR(50),
--	AwardTitle NVARCHAR(1000),
--	PILastName NVARCHAR(50),
--	PIFirstName NVARCHAR(50)
--)

--GO 

----drop table UploadWorkBookCharacterFix
--BULK INSERT UploadWorkBookCharacterFix
--FROM 'C:\icrp\database\DataUpload\DataWorkbook_CA_unicode.csv'  --DataWorkbook_CA_utf8.csv'
--WITH
--(
--	FIRSTROW = 2,
--	--DATAFILETYPE ='widechar',  -- unicode format
--	FIELDTERMINATOR = '|',
--	ROWTERMINATOR = '\n'
--)
--GO  -- import errors row #: 609, 6909 (Total: 13591)

--UPDATE ProjectFunding SET Title = fix.AwardTitle
--FROM ProjectFunding f
--	JOIN UploadWorkBookCharacterFix fix ON f.Altawardcode = fix.AltId
--	JOIN fundingorg o ON f.fundingorgid = o.fundingorgid
--where o.sponsorcode = 'CCRA' AND fix.AwardTitle <> '#N/A'

--UPDATE ProjectFundingInvestigator SET FirstName = fix.PIFirstName, LastName = fix.PILastName
--FROM ProjectFunding f
--	JOIN UploadWorkBookCharacterFix fix ON f.Altawardcode = fix.AltId
--	JOIN ProjectFundingInvestigator i ON i.ProjectFundingID = f.ProjectFundingID
--	JOIN fundingorg o ON f.fundingorgid = o.fundingorgid
--where o.sponsorcode = 'CCRA'

-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE ProjectFunding SET Title = SUBSTRING(title, 2, LEN(title)-2)
where LEFT(title, 1) = '"' AND RIGHT(title, 1) = '"'  --87

UPDATE ProjectFunding SET Title = SUBSTRING(title, 2, LEN(title)-2)
where LEFT(title, 1) = '"' AND RIGHT(title, 1) = '"'  --15

UPDATE projectabstract SET techabstract = SUBSTRING(techabstract, 2, LEN(techabstract)-2)
where LEFT(techabstract, 1) = '"' AND RIGHT(techabstract, 1) = '"'  --87

UPDATE projectabstract SET publicAbstract = SUBSTRING(publicAbstract, 2, LEN(publicAbstract)-2)
where LEFT(publicAbstract, 1) = '"' AND RIGHT(publicAbstract, 1) = '"'  --87

-------------------------------------------------------------------------------------------
-- Total Stats
--------------------------------------------------------------------------------------------
DECLARE @totalProject VARCHAR(10)
DECLARE @totalProjectFunding VARCHAR(10)
SELECT @totalProject = CAST(COUNT(*) AS varchar(10)) FROM Project

PRINT 'Total Imported Base Project = ' + @totalProject

SELECT @totalProjectFunding = CAST(COUNT(*) AS varchar(10)) FROM ProjectFunding

PRINT 'Total Imported ProjectFunding = ' + @totalProjectFunding

GO

-------------------------------------------------------------------------------------------
-- Run php icrp_funding_calculator.php ec2-54-87-136-189.compute-1.amazonaws.com,51000 icrp_data id pwd
--------------------------------------------------------------------------------------------


/***********************************************************************************************/
-- Data Integrigy Check
/***********************************************************************************************/
PRINT '******************************************************************************'
PRINT '***************************** Data Integrity Check ***************************'
PRINT '******************************************************************************'

SET NOCOUNT ON
GO

-- Check related project base data
--drop table #awardCodes
--go
--drop table #parentProjects
--go
--drop table #a
--go

DECLARE @SponsorCode varchar(25) = 'NIH'
--DECLARE @HasParentRelationship bit = 1

-------------------------------------------------------------------
-- Check AwardCode uniqueness
-------------------------------------------------------------------
PRINT 'Checking Unique AwardCode ...'
SELECT Distinct AwardCode INTO #a FROM UploadWorkBook

--IF @HasParentRelationship = 1
--BEGIN
	PRINT 'Checking Parent projects ...'
	SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA
-- END
--ELSE
--	PRINT '@HasParentRelationship=0  -- uncomment this'
--	--SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook

SELECT * INTO #awardCodes FROM (
	SELECT 'Existing' AS Type, a.AwardCode FROM #a a JOIN Project p ON a.AwardCode = p.AwardCode
	UNION
	SELECT 'New' AS Type, a.AwardCode FROM #a a LEFT JOIN Project p ON a.AwardCode = p.AwardCode WHERE p.AwardCode IS NULL
) a

DECLARE @TotalRelatedProjects INT
DECLARE @TotalAwardCodes INT
DECLARE @TotalProjectsWithParentCategory INT
DECLARE @TotalNewParentProjects INT
DECLARE @ExistingParentProjects INT

SELECT @TotalRelatedProjects = COUNT(*) FROM UploadWorkBook
SELECT @TotalAwardCodes = COUNT(*) FROM #a
SELECT @TotalProjectsWithParentCategory = COUNT(*) FROM #parentProjects
SELECT @ExistingParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='Existing'
SELECT @TotalNewParentProjects = COUNT(*) FROM #AwardCodes WHERE Type='New'


PRINT 'Total Imported Project Funding= ' + CAST(@TotalRelatedProjects AS VARCHAR(25))
PRINT 'Total AwardCodes (parent) = ' + + CAST(@TotalAwardCodes AS VARCHAR(25))
PRINT '  => New Parent Awards Count= ' + CAST(@TotalNewParentProjects AS VARCHAR(25))
PRINT '  => Existing Parent Awards Count = ' + CAST(@ExistingParentProjects AS VARCHAR(25))
PRINT 'Projects with Parent Category Count = ' + CAST(@TotalProjectsWithParentCategory AS VARCHAR(25))

-------------------------------------------------------------------
-- Check New Parent Project without Parent Category 
-------------------------------------------------------------------
PRINT 'Checking New Parent Project Category ...'


SELECT n.AwardCode INTO #noParent FROM 
(SELECT * FROM #awardcodes where Type='New') n
LEFT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
WHERE p.AwardCode IS NULL

IF EXISTS (SELECT * FROM #noParent)
BEGIN
	PRINT 'ERROR ==> New AwardCode without Parent Category'
	SELECT 'Issue - New AwardCode without Parent Category' AS Issue, AwardCode FROM #noParent
END
ELSE
	PRINT 'Checking new AwardCode with Parent Category  ==> Pass'

-------------------------------------------------------------------
-- Check AwardCode with Incorrect Parent Category 
-------------------------------------------------------------------
PRINT 'Checking AwardCode with Incorrect Parent Category  ...'

SELECT 'Issue AwardCode Should NOT be Parent' AS Issue, p.* FROM 
(SELECT * FROM #awardcodes where Type='New') n
RIGHT JOIN #parentProjects p ON n.AwardCode = p.AwardCode
WHERE n.AwardCode IS NULL

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
PRINT 'Checking Budget Dates........'
--drop table #budgetDates

SELECT AwardCode, AltID, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, DATEDIFF(day, AwardStartDate, AwardEndDate) AS AwardDuration, 
		DATEDIFF(day, BudgetStartDate, BudgetEndDate) AS BudgetDuration INTO #budgetDates FROM UploadWorkBook

IF EXISTS (SELECT * FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0)
BEGIN
  PRINT 'ERROR ==> Award or Budget Durations < 0 day'
  SELECT 'Award or Budget Duration too small' AS Issue, * FROM #budgetDates WHERE AwardDuration < 0 OR BudgetDuration < 0
END
ELSE
BEGIN
DECLARE @minduration int
	SELECT @minduration = MIN(AwardDuration) FROM #budgetDates
	PRINT 'Checking Award/Budget Dates (MIN duration is ' + CAST (@minduration AS varchar(10)) + ' => Pass'
END

--select * from UploadWorkBook where awardcode='10238_2'

	
-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
PRINT 'Checking Funding Amount........'
-- drop table #fundingAmount
SELECT AwardCode, AwardStartDate, AwardEndDate, BudgetStartDate, BudgetEndDate, AwardFunding INTO #fundingAmount FROM UploadWorkBook

IF EXISTS (SELECT * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0)
BEGIN
  PRINT 'WARNING ==> Funding Amount <= 0'
  SELECT 'No Funding Amount' AS Issue, * FROM #fundingAmount WHERE ISNULL(AwardFunding,0) < 0
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
  SELECT DISTINCT 'Missing CSO Codes / Relevance' AS Issue, AwardCode, AltId, CSOCodes, CSORel from UploadWorkBook 	
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
--IF EXISTS (select AwardType from UploadWorkBook where ISNULL(AwardType,'') NOT IN ('R','C','T'))
--BEGIN
--  PRINT 'ERROR ==> Incorrect AwardType'
--  SELECT DISTINCT 'Incorrect AwardType' AS Issue, AwardCode, AltId, AwardType from UploadWorkBook 
--	WHERE ISNULL(AwardType,'') NOT IN ('R','C','T')
--END
--ELSE
--	PRINT 'Checking Incorrect AwardType ==> Pass'

	

-------------------------------------------------------------------
-- Check Annulized Value
-------------------------------------------------------------------
IF EXISTS (select IsAnnualized from UploadWorkBook where ISNULL(IsAnnualized,'') NOT IN ('Y','N'))
BEGIN
  PRINT 'ERROR ==> Incorrect Annualized Value'
  SELECT DISTINCT 'Incorrect Annualized' AS Issue, AwardCode, AltId, IsAnnualized from UploadWorkBook 
	WHERE ISNULL(IsAnnualized,'') NOT IN ('Y','N')
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
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision)))
BEGIN
  PRINT 'ERROR ==> FundingDiv Not Exist --> Add FundingDiv First'
 SELECT DISTINCT 'Missing FundingDiv' AS Issue, AwardCode, AltID, FundingDivAbbr from UploadWorkBook 
	WHERE (ISNULL(FundingDivAbbr, '')) != '' AND (FundingDivAbbr NOT IN (SELECT DISTINCT Abbreviation FROM FundingDivision))
END
ELSE
	PRINT 'Checking FundingDiv  ==> Pass'
	
-------------------------------------------------------------------
-- Check duplicate Project Funding
-------------------------------------------------------------------
SELECT AltAwardCode, FundingOrgAbbr, COUNT(*) AS Count INTO #dup FROM 
(
	SELECT AltId AS AltAwardCode, FundingOrgAbbr FROM UploadWorkBook
	UNION 
	(SELECT f.AltAwardCode, o.Abbreviation AS FundingOrgAbbr FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID)
) a
group by AltAwardCode, FundingOrgAbbr having count(*) >1

IF EXISTS (select * from #dup)
BEGIN
SELECT 'Duplicate Project Funding' AS Issue, AltAwardCode,  FundingOrgAbbr, [count] from #dup
END 
ELSE
	PRINT 'Checking duplicate Project Funding   ==> Pass'

	
------------------------------------------------------------------
-- Check if AwardCodes already exist in ICRP
-------------------------------------------------------------------
IF EXISTS (select * FROM #parentProjects WHERE AwardCode IN (SELECT AwardCode From Project))
BEGIN
	PRINT 'ERROR ==> Parent AwardCode already exist'
	SELECT 'Parent AwardCode Exists' AS Issue, AwardCode FROM (select AwardCode FROM #parentProjects WHERE AwardCode IN (SELECT AwardCode From Project)) p
END 

------------------------------------------------------------------
-- Check if AltAwardCodes already exist in ICRP
-------------------------------------------------------------------
SELECT u.AwardCode, u.AltID INTO #AltId FROM UploadWorkbook u
JOIN (SELECT f.ALtAwardCode, o.Abbreviation AS FundingOrgAbbr FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) e ON u.AltID = e.ALtAwardCode AND u.FundingOrgAbbr = e.FundingOrgAbbr

IF EXISTS (select * from #AltId)
BEGIN
	PRINT 'ERROR ==> AltAwardCode already exist in ICRP'
	SELECT 'AltAwardCode Already Exists in ICRP' AS Issue, AwardCode, AltID AS AltAwardCode FROM #AltId
END 
ELSE
	PRINT 'Checking AltAwardCode NOT exist in ICRP ==> Pass'

-------------------------------------------------------------------
-- Check Institutions
-------------------------------------------------------------------
--drop table #missingInst
--go

-- Check both Institution lookup and mapping tables
SELECT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
	LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
	LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) 
WHERE (i.InstitutionID IS NULL) AND (m.InstitutionMappingID IS NULL)

IF EXISTS (select * FROM #missingInst)
BEGIN
	PRINT 'ERROR => Checking Institution Mapping (Some cannot be mapped)'

	SELECT DISTINCT 'Institution cannot be mapped' AS Issue, w.InstitutionICRP AS 'workbook - Institution Name', w.city AS 'workbook - Institution city'
	FROM (select InstitutionICRP, city FROM #missingInst group by InstitutionICRP, city) m
	LEFT JOIN Institution l ON m.InstitutionICRP = l.Name
	LEFT JOIN UploadWorkBook w ON m.InstitutionICRP = w.InstitutionICRP
	ORDER BY  w.InstitutionICRP 
END 
ELSE
	PRINT 'Checking Institution Mapping   ==> Pass'

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
-- PreCheck no multiple PIs/Institutions per funding
-------------------------------------------------------------------
--drop table #dupPI
select f.projectfundingid into #dupPI from projectfunding f
	join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid
	join fundingorg o on f.FundingOrgID = o.FundingOrgID
	where o.SponsorCode = @SponsorCode
	group by f.projectfundingid having count(*) > 1

	
IF EXISTS (select * FROM #dupPI)
BEGIN
	SELECT DISTINCT 'Duplicate PIs' AS Issue, pf.projectfundingid, i.institutionid, o.sponsorcode, o.name as FundingOrg, p.awardcode, pf.altawardcode, pf.budgetstartdate, pf.budgetenddate, 
	fi.lastname AS piLastName, fi.FirstName AS piFirstName, i.name as institution, i.city, i.Country 
	from #dupPI d
		join projectfunding pf on pf.projectfundingid = d.projectfundingid
		join project p on pf.projectid = p.projectid
		join fundingorg  o on o.sponsorCode = @SponsorCode
		join projectfundinginvestigator fi on pf.projectfundingid = fi.projectfundingid
		join institution i on i.institutionid = fi.institutionid
	order by o.sponsorcode, pf.AltAwardCode  -- 14907
END 
ELSE
	PRINT 'Pre-Checking duplicate PIs ==> Pass'

-------------------------------------------------------------------
-- PreCheck no missing PI info
-------------------------------------------------------------------
select f.ProjectFundingID into #missingPI from projectfunding f
join fundingorg o on f.FundingOrgID = o.FundingOrgID
left join ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
where o.SponsorCode = @SponsorCode and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #missingPI)
BEGIN
	SELECT DISTINCT 'ERROR => Pre-Check Missing PIs' AS Issue, *
	from #missingPI
END 
ELSE
	PRINT 'Pre-Checking Missing PIs ==> Pass'

GO




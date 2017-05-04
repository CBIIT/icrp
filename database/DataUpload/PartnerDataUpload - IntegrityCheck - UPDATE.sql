SET NOCOUNT ON
GO
/***********************************************************************************************/
-- Data Integrigy Check
/***********************************************************************************************/
PRINT '******************************************************************************'
PRINT '***************************** Data Integrity Check ***************************'
PRINT '******************************************************************************'

-- Check related project base data
--drop table #awardCodes
--go
--drop table #parentProjects
--go

DECLARE @SponsorCode varchar(25) = 'PanCAN'
DECLARE @HasParentRelationship bit = 1

-------------------------------------------------------------------
-- Check BudgetDates
-------------------------------------------------------------------
PRINT 'Checking Budget Dates........'

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

-------------------------------------------------------------------
-- Check Funding Amount
-------------------------------------------------------------------
PRINT 'Checking Funding Amount........'

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

	
-------------------------------------------------------------------
-- Check if AltAwardCodes NOT exist in ICRP
-------------------------------------------------------------------
select fo.AltAwardCode, fo.Abbreviation INTO #notExistAwards FROM UploadWorkBook u
JOIN (SELECT f.AltAwardCode, o.Abbreviation FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) fo ON u.AltID = fo.AltAwardCode AND u.FundingOrgAbbr = fo.Abbreviation
WHERE fo.AltAwardCode IS NULL

IF EXISTS (select * FROM #notExistAwards)
BEGIN
	PRINT 'ERROR ==> AltAwardCode Not Exist for update'
	SELECT 'AltAwardCode Exists' AS Issue, * from #notExistAwards
END 

ELSE

BEGIN	
	PRINT 'Checking AltAwardCode Not Exist for update => Pass'
END

-------------------------------------------------------------------
-- Check Institutions
-------------------------------------------------------------------
--drop table #missingInst
--go

SELECT u.InstitutionICRP, u.SubmittedInstitution, u.City INTO #missingInst FROM UploadWorkBook u
LEFT JOIN Institution i ON (u.InstitutionICRP = i.Name AND u.City = i.City)
--LEFT JOIN InstitutionMapping m ON (u.InstitutionICRP = m.OldName AND u.City = m.OldCity) OR (u.InstitutionICRP = m.OldName AND u.City = m.newCity)
WHERE (i.InstitutionID IS NULL) --AND (m.InstitutionMappingID IS NULL)

--select * from #missingInst
IF EXISTS (select * FROM #missingInst)
BEGIN
	PRINT 'Checking Institution Mapping   ==> Some cannot be mapped'

	SELECT DISTINCT 'Institution cannot be mapped' AS Issue, w.InstitutionICRP AS 'workbook - Institution Name', w.city AS 'workbook - Institution city'
	FROM (select InstitutionICRP, city FROM #missingInst group by InstitutionICRP, city) m
	LEFT JOIN Institution l ON m.InstitutionICRP = l.Name
	LEFT JOIN UploadWorkBook w ON m.InstitutionICRP = w.InstitutionICRP
	ORDER BY  w.InstitutionICRP 
END 
ELSE
	PRINT 'Checking Institution Mapping   ==> Pass'

-- Insert institution Mappings
--INSERT INTO InstitutionMapping (OldName, OldCity, NewName, NewCity) SELECT 'UCLA', 'Los Angeles', 'University of California Los Angeles', 'Los Angeles'

-------------------------------------------------------------------
-- PreCheck no duplicate institutions and no missing pi info
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

-- checking missing PI
select f.ProjectFundingID into #missingPI from projectfunding f
join fundingorg o on f.FundingOrgID = o.FundingOrgID
left join ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
where o.SponsorCode = @SponsorCode and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #missingPI)
BEGIN
	SELECT DISTINCT 'Pre-Check Missing PIs' AS Issue, *
	from #missingPI
END 
ELSE
	PRINT 'Pre-Checking Missing PIs ==> Pass'

GO




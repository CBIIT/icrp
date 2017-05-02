
SET NOCOUNT ON;  
GO 

BEGIN TRANSACTION 

-----------------------------------
-- SET DataUpload Parameters
-----------------------------------
DECLARE @DataUploadStatusID INT
DECLARE @PartnerCode varchar(25) = 'PanCAN'
DECLARE @FundingYears VARCHAR(25) = '2015-2016'
DECLARE @ImportNotes  VARCHAR(1000) = 'FY2015 NEW, FY2016 New'
DECLARE @HasParentRelationship bit = 1
DECLARE @IsProd bit = 0

-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE UploadWorkbook SET AwardTitle = SUBSTRING(AwardTitle, 2, LEN(AwardTitle)-2)
where LEFT(AwardTitle, 1) = '"' AND RIGHT(AwardTitle, 1) = '"' 

UPDATE UploadWorkbook SET AwardTitle = SUBSTRING(AwardTitle, 2, LEN(AwardTitle)-2)
where LEFT(AwardTitle, 1) = '"' AND RIGHT(AwardTitle, 1) = '"' 

UPDATE UploadWorkbook SET techabstract = SUBSTRING(techabstract, 2, LEN(techabstract)-2)
where LEFT(techabstract, 1) = '"' AND RIGHT(techabstract, 1) = '"'  --87

UPDATE UploadWorkbook SET publicAbstract = SUBSTRING(publicAbstract, 2, LEN(publicAbstract)-2)
where LEFT(publicAbstract, 1) = '"' AND RIGHT(publicAbstract, 1) = '"'  --87


-----------------------------------
-- Insert Data Upload Status
-----------------------------------
IF @IsProd = 0
BEGIN  -- Staging

	INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
	VALUES (@PartnerCode, @FundingYears, 'Staging', 'NEW', '4/10/2017', '4/26/2017', '4/26/2017',  '4/26/2017', NULL, @ImportNotes, getdate())
	
	select * from DataUploadStatus where PartnerCode=@PartnerCode

	SET @DataUploadStatusID = IDENT_CURRENT( 'DataUploadStatus' )  

	PRINT 'DataUploadStatusID = ' + CAST(@DataUploadStatusID AS varchar(10))

	INSERT INTO icrp_data.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status],[Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
	VALUES (@PartnerCode, @FundingYears, 'Staging', 'NEW', '4/10/2017', '4/26/2017', '4/26/2017',  '4/26/2017', NULL, @ImportNotes, getdate())

END

ELSE  -- Production

BEGIN
	select @DataUploadStatusID = DataUploadStatusID from DataUploadStatus where PartnerCode=@PartnerCode
	UPDATE DataUploadStatus SET Status = 'Complete', [UploadToProdDate] = getdate() WHERE DataUploadStatusID = @DataUploadStatusID

	UPDATE icrp_dataload.dbo.DataUploadStatus SET Status = 'Complete', [UploadToProdDate] = getdate()  WHERE DataUploadStatusID = @DataUploadStatusID
END

--select * from DataUploadStatus where DataUploadStatusID= 63
--select * from icrp_dataload.dbo.DataUploadStatus where DataUploadStatusID= 63


/***********************************************************************************************/
-- Import Data
/***********************************************************************************************/
PRINT '*******************************************************************************'
PRINT '***************************** Import Data  ************************************'
PRINT '******************************************************************************'



IF @HasParentRelationship = 1
BEGIN
	PRINT 'Select Parent Projects'
	SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook where Category='Parent'  -- CA
END 
ELSE
	PRINT 'No Parent Relationship - Uncomment out the line'
	--SELECT AwardCode, Childhood, AwardStartDate, AwardEndDate INTO #parentProjects from UploadWorkBook

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


DECLARE @seed INT
SELECT @seed=MAX(projectAbstractID)+1 FROM projectAbstract  -- 1246295, 1246328
PRINT @seed

CREATE TABLE #UploadAbstract (	
	ID INT NOT NULL IDENTITY(1246345,1),
	AwardCode NVARCHAR(50),
	Altid NVARCHAR(50),
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]

INSERT INTO #UploadAbstract (AwardCode, Altid, TechAbstract, PublicAbstract) SELECT DISTINCT AwardCode, Altid, TechAbstract, PublicAbstract FROM UploadWorkBook 

UPDATE #UploadAbstract SET PublicAbstract = NULL where PublicAbstract = '0' OR PublicAbstract = ''
UPDATE #UploadAbstract SET TechAbstract = '' where TechAbstract = '0' OR TechAbstract IS NULL

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO ProjectAbstract (ProjectAbstractID, TechAbstract, PublicAbstract) 
SELECT ID, TechAbstract, PublicAbstract FROM #UploadAbstract  WHERE AwardCode IS NOT NULL

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
JOIN #UploadAbstract a ON u.AwardCode = a.AwardCode AND u.AltId = a.Altid
JOIN Project p ON u.AwardCode = p.awardCode
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation

--DECLARE @total VARCHAR(10)
--SELECT @total = CAST(COUNT(*) AS varchar(10)) FROM Institution

--PRINT 'Total Imported Institutions = ' + @total
--GO

-- Correct ProjectBatract mapping if no TechAbstract
UPDATE ProjectFunding SET ProjectAbstractID=0
WHERE ProjectAbstractID IN (select ProjectAbstractID from ProjectAbstract where TechAbstract = '' AND PublicAbstract IS NULL) --or TechAbstract='No abstract available for this Project funding.'

DELETE ProjectAbstract where TechAbstract = ''

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
where o.SponsorCode = @PartnerCode and pi.ProjectFundingID is null

	
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
 
DECLARE @csocursor as CURSOR;

SET @csocursor = CURSOR FOR
SELECT ProjectFundingID, CSOCodes , CSORel FROM #list;
 
OPEN @csocursor;
FETCH NEXT FROM @csocursor INTO @projectFundingID, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @pcso SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoList)
 INSERT INTO @pcsorel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@csoRelList) 
 FETCH NEXT FROM @csocursor INTO @projectFundingID, @csolist, @csoRelList;
END
 
CLOSE @csocursor;
DEALLOCATE @csocursor;

INSERT INTO ProjectCSO SELECT c.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM @pcso c 
JOIN @pcsorel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq

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

DECLARE @siteList as NVARCHAR(50)
DECLARE @siteRelList as NVARCHAR(50)
 
DECLARE @ctcursor as CURSOR;

SET @ctcursor = CURSOR FOR
SELECT ProjectFundingID, SiteCodes , SiteRel FROM #list;
 
OPEN @ctcursor;
FETCH NEXT FROM @ctcursor INTO @projectFundingID, @siteList, @siteRelList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @psite SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteList)
 INSERT INTO @psiterel SELECT @projectFundingID, value FROM  dbo.ToStrTable(@siteRelList) 
 FETCH NEXT FROM @ctcursor INTO @projectFundingID, @siteList, @siteRelList;
END
 
CLOSE @ctcursor;
DEALLOCATE @ctcursor;

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT c.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM @psite c 
JOIN CancerType ct ON c.code = ct.ICRPCode
JOIN @psiterel r ON c.ProjectFundingID = r.ProjectFundingID AND c.Seq = r.Seq


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
 
DECLARE @ptcursor as CURSOR;

SET @ptcursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #list) p;
 
OPEN @ptcursor;
FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @ptype SELECT @projectID, value FROM  dbo.ToStrTable(@typeList) 
 FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;
END
 
CLOSE @ptcursor;
DEALLOCATE @ptcursor;

INSERT INTO Project_ProjectType (ProjectID, ProjectType)
SELECT ProjectID,
		CASE ProjectType
		  WHEN 'C' THEN 'Clinical Trial'
		  WHEN 'R' THEN 'Research'
		  WHEN 'T' THEN 'Training'
		END
FROM @ptype	


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

-- REBUILD All Abstract
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract FROM ProjectAbstract a
		JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
		GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

PRINT 'Total Imported ProjectSearch = ' + CAST(@@RowCount AS varchar(10))

-------------------------------------------------------------------------------------------
-- Insert DataUploadLog 
--------------------------------------------------------------------------------------------
PRINT 'INSERT DataUploadLog'

--DECLARE @DataUploadStatusID INT = 63
--select * from DataUploadStatus where PartnerCode='astro'
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

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearchTotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch s
JOIN Project p ON s.ProjectID = p.ProjectID 
JOIN ProjectFunding f ON p.ProjectID = f.ProjectID
WHERE f.dataUploadStatusID = @DataUploadStatusID

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

select * from datauploadlog where  DataUploadLogID =  @DataUploadLogID

--commit

rollback


--SET NOCOUNT OFF;  
--GO 

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

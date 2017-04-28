SET NOCOUNT ON;  
GO 

BEGIN TRANSACTION 

-----------------------------------
-- SET DataUpload Parameters
-----------------------------------
DECLARE @DataUploadStatusID INT
DECLARE @PartnerCode varchar(25) = 'PanCAN'
DECLARE @FundingYears VARCHAR(25) = '2015'
DECLARE @ImportNotes  VARCHAR(1000) = 'FY2015 Update'
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
IF @IsProd = 0  -- rollback
BEGIN  -- Staging

	INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type], [ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
	VALUES (@PartnerCode, @FundingYears, 'Staging', 'UPDATE', '4/10/2017', '4/26/2017', '4/26/2017',  '4/26/2017', NULL, @ImportNotes, getdate())
	
	select * from DataUploadStatus where PartnerCode=@PartnerCode

	SET @DataUploadStatusID = IDENT_CURRENT( 'DataUploadStatus' )  

	PRINT 'DataUploadStatusID = ' + CAST(@DataUploadStatusID AS varchar(10))

	INSERT INTO icrp_data.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status],[Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
	VALUES (@PartnerCode, @FundingYears, 'Staging', 'UPDATE', '4/10/2017', '4/26/2017', '4/26/2017',  '4/26/2017', NULL, @ImportNotes, getdate())

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

-----------------------------------
-- Update base Projects
-----------------------------------
PRINT 'Update base Projects'

UPDATE Project SET IsChildhood = 
	CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
ProjectStartDate = u.AwardStartDate, ProjectEndDate = u.AwardEndDate, UpdatedDate = getdate() FROM Project p
JOIN UploadWorkbook u ON p.AwardCode = u.AWardCode


select * from UploadWorkbook
PRINT 'Total updated base projects = ' + CAST(@@RowCount AS varchar(10))

-----------------------------------
-- Update Project Abstract
-----------------------------------
PRINT '-- Update Project Abstract'

UPDATE ProjectAbstract SET TechAbstract=u.TechAbstract, PublicAbstract=u.PublicAbstract
FROM ProjectAbstract a
	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	JOIN UploadWorkbook u ON u.AltID = f.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation	

PRINT 'Total Updated ProjectAbstract = ' + CAST(@@RowCount AS varchar(10))

-----------------------------------
-- Update ProjectFunding
-----------------------------------
PRINT 'Update ProjectFunding'

UPDATE ProjectFunding SET Title = u.AwardTitle, DataUploadStatusID =  @DataUploadStatusID, Category = u.Category, Source_ID = u.SourceID, MechanismCode = u.FundingMechanismCode, MechanismTitle = u.FundingMechanism, FundingContact = u.FundingContact,
							IsAnnualized = CASE ISNULL(u.IsAnnualized, '') WHEN 'y' THEN 1 ELSE 0 END, Amount  = u.AwardFunding, BudgetStartDate = u.BudgetStartDate, BudgetEndDate = u.BudgetEndDate, UpdatedDate = getdate()
FROM ProjectFunding f 
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	JOIN UploadWorkbook u ON u.AltID = f.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation	

PRINT 'Total updated project funding = ' + CAST(@@RowCount AS varchar(10))

-----------------------------------
-- Update ProjectFundingInvestigator
-----------------------------------
PRINT '-- Import ProjectFundingInvestigator'

UPDATE ProjectFundingInvestigator SET LastName = u.PILastName, FirstName = u.PIFirstName, ORC_ID = u.ORCID, OtherResearch_ID= u.OtherResearcherID, OtherResearch_Type = u.OtherResearcherIDType, IsPrivateInvestigator= 1, 
										InstitutionID = ISNULL(i.InstitutionID,1), InstitutionNameSubmitted = u.SubmittedInstitution, UpdatedDate = getdate()
FROM UploadWorkbook u 
	LEFT JOIN (SELECT f.ProjectFundingID, f.AltAWardCode, o.Abbreviation FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) pf ON u.AltID = pf.AltAwardCode AND u.FundingOrgAbbr = pf.Abbreviation	
	--LEFT JOIN ProjectFundingInvestigator pi ON pi.ProjectFundingID = pi.ProjectFundingID	
	LEFT JOIN Institution i ON i.Name = u.InstitutionICRP AND i.City = i.City

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
-- Update ProjectCSO
-----------------------------------
PRINT 'Update ProjectCSO'


SELECT pf.projectID, pf.ProjectFundingID, pf.AltAwardCode, u.CSOCodes, u.CSORel, u.SiteCodes, u.SiteRel, AwardType INTO #list
FROM UploadWorkBook u
	JOIN (SELECT f.ProjectID, f.ProjectFundingID, f.AltAWardCode, o.Abbreviation FROM ProjectFunding f JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID) pf ON u.AltID = pf.AltAwardCode AND u.FundingOrgAbbr = pf.Abbreviation

DELETE ProjectCSO WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #list)

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

DELETE ProjectCancerType WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #list)

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

DELETE  Project_ProjectType WHERE ProjectID IN (SELECT ProjectID FROM #list)

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
DELETE ProjectFundingExt WHERE ProjectFundingID IN (SELECT ProjectFundingID FROM #list)
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

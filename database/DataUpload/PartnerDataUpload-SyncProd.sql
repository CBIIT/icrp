use icrp_data
GO

-----------------------------------
-- Retrieve DataUploadStatusID and Seed Info
-----------------------------------
DECLARE @DataUploadStatusID INT
DECLARE @DataUploadStatusID_dataload INT
DECLARE @PartnerCode VARCHAR(25) = 'ASTRO'

SELECT @DataUploadStatusID = MAX(DataUploadStatusID) FROM DataUploadStatus WHERE PartnerCode = @PartnerCode
SELECT @DataUploadStatusID_dataload = MAX(DataUploadStatusID) FROM icrp_dataload.dbo.DataUploadStatus WHERE PartnerCode = @PartnerCode

DECLARE @seed INT
SELECT @seed=MAX(projectAbstractID)+1 FROM projectAbstract  -- 1246295, 1246328

PRINT 'ProjectAbstract Seed = ' + CAST(@seed AS varchar(25))
PRINT 'icrp_data DataUploadStatusID = ' + CAST(@DataUploadStatusID AS varchar(25))
PRINT 'icrp_dataload DataUploadStatusID = ' + CAST(@DataUploadStatusID_dataload AS varchar(25))


BEGIN TRANSACTION

/***********************************************************************************************/
-- Import Data
/***********************************************************************************************/
PRINT '*******************************************************************************'
PRINT '***************************** Import Data  ************************************'
PRINT '******************************************************************************'

-----------------------------------
-- Import Project
-----------------------------------
PRINT '-- Import Project'

INSERT INTO project ([IsChildhood],	[AwardCode],[ProjectStartDate],	[ProjectEndDate],[CreatedDate],	[UpdatedDate])
SELECT [IsChildhood],[AwardCode],[ProjectStartDate],[ProjectEndDate], getdate(),getdate()
FROM icrp_dataload.dbo.Project p
JOIN icrp_dataload.dbo.projectfunding pf ON p.ProjectID =  pf.projectID  WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

-----------------------------------
-- Import Project Abstract
-----------------------------------
PRINT '-- Import Project Abstract'

CREATE TABLE #DataLoadUploadAbstract (	
	ID INT NOT NULL IDENTITY(1246262,1),
	ProjectFundindID INT,	
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]


INSERT INTO #DataLoadUploadAbstract
SELECT pf.projectFundingID, a.[TechAbstract], a.[PublicAbstract]
FROM icrp_dataload.dbo.projectAbstract a
JOIN icrp_dataload.dbo.projectfunding pf ON a.projectAbstractID =  pf.projectAbstractID  WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

SET IDENTITY_INSERT projectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO projectAbstract ([projectAbstractID], [TechAbstract], [PublicAbstract],[CreatedDate],[UpdatedDate])
SELECT ID, [TechAbstract], [PublicAbstract],getdate(),getdate()
FROM #DataLoadUploadAbstract 

SET IDENTITY_INSERT projectAbstract OFF;  -- SET IDENTITY_INSERT to ON. 

-----------------------------------
-- Import ProjectFunding
-----------------------------------
PRINT '-- Import ProjectFunding'

INSERT INTO projectfunding ([Title],[ProjectID],[FundingOrgID],	[FundingDivisionID],[ProjectAbstractID],[DataUploadStatusID],[Category],[AltAwardCode],[Source_ID],
	[MechanismCode],[MechanismTitle],[FundingContact],[IsAnnualized],[Amount],[BudgetStartDate],[BudgetEndDate],[CreatedDate],[UpdatedDate])
SELECT [Title], newp.[ProjectID],[FundingOrgID],	[FundingDivisionID],a.ID,@DataUploadStatusID,[Category],[AltAwardCode],[Source_ID],
	[MechanismCode],[MechanismTitle],[FundingContact],[IsAnnualized],[Amount],[BudgetStartDate],[BudgetEndDate],getdate(),getdate()
FROM icrp_dataload.dbo.ProjectFunding pf
JOIN icrp_dataload.dbo.Project p ON pf.projectid = p.ProjectID
JOIN Project newp ON newp.AwardCode = p.AwardCode
JOIN #DataLoadUploadAbstract a ON pf.ProjectFundingID = a.ProjectFundindID
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload




-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
PRINT '-- Import ProjectFundingInvestigator'

INSERT INTO ProjectFundingInvestigator
SELECT newpf.ProjectFundingID, pi.LastName, pi.FirstName, pi.ORC_ID, pi.OtherResearch_ID, pi.OtherResearch_Type, pi.IsPrivateInvestigator, ISNULL(newi.InstitutionID,1), InstitutionNameSubmitted, getdate(),getdate()
FROM icrp_dataload.dbo.ProjectFundingInvestigator pi
JOIN icrp_dataload.dbo.projectfunding pf ON pi.ProjectFundingID =  pf.ProjectFundingID  
JOIN projectfunding newpf ON newpf.AltAwardCode =  pf.AltAwardCode  
JOIN icrp_dataload.dbo.Institution i ON pi.institutionID = i.institutionID
LEFT JOIN Institution newi ON newi.Name = i.Name AND newi.City = i.City
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

----------------------------------------------------
-- Post Import Checking
----------------------------------------------------
PRINT '-- Post Import Checking'

select f.altawardcode into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID		
	where f.DataUploadStatusID = @DataUploadStatusID_dataload and pi.InstitutionID = 1

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
	where f.DataUploadStatusID = @DataUploadStatusID_dataload
	group by f.projectfundingid, f.AltAwardCode having count(*) > 1

	
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

			
-----------------------------------
-- Import ProjectCSO
-----------------------------------
PRINT '-- Import ProjectCSO'

INSERT INTO ProjectCSO
SELECT new.ProjectFundingID, cso.CSOCode, cso.Relevance, cso.RelSource, getdate(),getdate()
FROM icrp_dataload.dbo.ProjectCSO cso
JOIN icrp_dataload.dbo.projectfunding pf ON cso.ProjectFundingID =  pf.ProjectFundingID  
JOIN projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

-----------------------------------
-- Import ProjectCancerType
-----------------------------------
PRINT '-- Import ProjectCancerType'

INSERT INTO ProjectCancerType
SELECT new.ProjectFundingID, ct.CancerTypeID, ct.Relevance, ct.RelSource, getdate(),getdate(), ct.EnterBy
FROM icrp_dataload.dbo.ProjectCancerType ct
JOIN icrp_dataload.dbo.projectfunding pf ON ct.ProjectFundingID =  pf.ProjectFundingID  
JOIN projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

-----------------------------------
-- Import Project_ProjectTye
-----------------------------------
PRINT '-- Import Project_ProjectTye'

INSERT INTO Project_ProjectType
SELECT DISTINCT np.ProjectID, pt.ProjectType, getdate(),getdate()
FROM icrp_dataload.dbo.Project_ProjectType pt
	JOIN icrp_dataload.dbo.Project p ON pt.ProjectID = p.ProjectID
	JOIN Project np ON p.AwardCode = np.AwardCode
	JOIN icrp_dataload.dbo.projectfunding pf ON pt.ProjectID =  pf.ProjectID
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

-----------------------------------
-- Import ProjectFundingExt
-----------------------------------
PRINT '-- Import ProjectFundingExt'

INSERT INTO ProjectFundingExt
SELECT new.ProjectFundingID, ex.CalendarYear, ex.CalendarAmount, getdate(),getdate()
FROM icrp_dataload.dbo.ProjectFundingExt ex
JOIN icrp_dataload.dbo.projectfunding pf ON ex.ProjectFundingID =  pf.ProjectFundingID  
JOIN projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_dataload

-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
PRINT 'Rebuild [ProjectSearch]'

DELETE FROM ProjectSearch

DBCC CHECKIDENT ('[ProjectSearch]', RESEED, 0)

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
PRINT 'INSERT DataUploadLog'

DECLARE @DataUploadLogID INT
--DECLARE @DataUploadStatusID INT  = 63

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

select * from icrp_dataload.dbo.datauploadlog
select * from datauploadlog

-------------------------------------------------------------------------------------------
-- Update FundingOrg LastImpoet Date/Desc
--------------------------------------------------------------------------------------------
UPDATE fundingorg SET LastImportDate=getdate(), LastImportDesc = d.Note
FROM DataUploadStatus d WHERE DataUploadStatusID = @DataUploadStatusID
 
-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE DataUploadStatus SET Status = 'Complete', [UploadToProdDate] = getdate() WHERE DataUploadStatusID = @DataUploadStatusID
UPDATE icrp_dataload.dbo.DataUploadStatus SET Status = 'Complete', [UploadToProdDate] = getdate()  WHERE DataUploadStatusID = @DataUploadStatusID_dataload

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


--COMMIT

ROLLBACK


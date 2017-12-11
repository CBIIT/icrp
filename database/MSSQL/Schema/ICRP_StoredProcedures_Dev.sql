


/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/****** Object:  StoredProcedure [dbo].[ImportInstitutions]    Script Date: 12/14/2016 4:21:37 PM ******/
/*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ImportInstitutions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ImportInstitutions]
GO 

CREATE PROCEDURE [dbo].[ImportInstitutions] 
  
AS

BEGIN TRY     	

	IF object_id('tmp_LoadInstitutions') is null
	BEGIN
		   RAISERROR ('Table tmp_LoadInstitutions not found', 16, 1)
	END

	-- replace city with accent names
	update tmp_LoadInstitutions set city ='Montréal' where city='Montreal'
	update tmp_LoadInstitutions set city ='Québec' where city='Quebec'
	update tmp_LoadInstitutions set city ='Zürich' where city='Zurich'
	update tmp_LoadInstitutions set city ='Pierre-Bénite' where city='Pierre-Benite'
	update tmp_LoadInstitutions set city ='Umeå' where city='Umea'
	update tmp_LoadInstitutions set city ='Münster' where city='Munster'	

	UPDATE tmp_LoadInstitutions set city = NULL where city='' OR city='NULL'
	UPDATE tmp_LoadInstitutions set State = NULL where State='' OR State='NULL'
	UPDATE tmp_LoadInstitutions set Country = NULL where Country='' OR Country='NULL'
	UPDATE tmp_LoadInstitutions set Latitude = NULL where Latitude=0
	UPDATE tmp_LoadInstitutions set Longitude = NULL where Longitude=0

	-- Data Check - Required Field Missing
	SELECT Name, City, Latitude, Longitude
		INTO #missingReqFields FROM tmp_LoadInstitutions WHERE ISNULL(NAME , '') = '' OR ISNULL(City , '') = '' OR ISNULL(Latitude , 0) = 0 OR ISNULL(Longitude , 0) = 0

	IF EXISTS (SELECT 1 FROM #missingReqFields)
	BEGIN		
		
		SELECT 'Required Field Missing' AS [Data Issue], * FROM #missingReqFields
		RETURN
	END	

	-- Data Check - Invalid Country Code
	SELECT Name, City, Country
		INTO #invalidCountry FROM tmp_LoadInstitutions WHERE Country NOT IN (SELECT Abbreviation FROM Country)

	IF EXISTS (SELECT 1 FROM #invalidCountry)
	BEGIN		
		
		SELECT 'Invalid Country Code' AS [Data Issue], * FROM #invalidCountry
		RETURN
	END	


	-- Data Check - Invalid Coordinates
	SELECT Name, City, Country, latitude, longitude
		INTO #invalidCoodinates FROM tmp_LoadInstitutions WHERE (latitude < -90 or latitude > 90) OR (longitude < -180 or longitude > 180)

	IF EXISTS (SELECT 1 FROM #invalidCoodinates)
	BEGIN		
		
		SELECT 'Invalid Coordinates' AS [Data Issue], * FROM #invalidCoodinates
		RETURN
	END	

	-- Data Check - Existing Institutions
	SELECT Name, City, MAX([State]) AS [State], MAX([Country]) AS [Country], MAX([Postal]) AS [Postal], MAX([Longitude]) AS [Longitude], MAX([Latitude]) AS [Latitude], MAX([GRID]) AS Grid 
	INTO #unique FROM tmp_LoadInstitutions GROUP BY Name, City

	SELECT DISTINCT CONCAT(u.Name, '/', u.City) AS [Institution/City], CONCAT(u.State, ' ', u.Country) AS [Imported location], CONCAT(i.State, ' ', i.Country) AS [Existing location]
	INTO #exist FROM #unique u 
	JOIN Institution i ON u.Name = i.Name AND u.City = i.City	

	IF EXISTS (SELECT 1 FROM #exist)
	BEGIN		
		
		SELECT 'Institution Already exists' AS [Data Issue], * FROM #exist
		RETURN
	END	

	-- Data Check - Potential Duplicates
	SELECT DISTINCT CONCAT(t.Name, '/', t.City) AS [Imported Institution/City], CONCAT(m.[NewName], '/', m.[NewCity] ) AS [Existing Institution/City]
	INTO #dup FROM tmp_LoadInstitutions t
	JOIN InstitutionMapping m ON m.OldName = t.Name AND m.OldCity = t.City	

	IF EXISTS (SELECT 1 FROM #exist)
	BEGIN		
		
		SELECT 'Potential Duplicates' AS [Data Issue], * FROM #dup
		RETURN
	END	
		
	BEGIN TRANSACTION;
	
	-- Insert into icrp_data: DO NOT insert the institutions which already exist in the Institutions lookup 
	INSERT INTO Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
		SELECT [Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID] FROM #unique 		

	-- Insert into icrp_dataload: Only insert the institutions which not exist in the Institutions lookup 		
	INSERT INTO icrp_datloada_dev.dbo.Institution ([Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID]) 
		SELECT [Name], [City], [State], [Country], [Postal], [Longitude], [Latitude], [GRID] FROM #unique			

	-- Insert City coordinates into lu_city if they don't exist in lu_City
	INSERT INTO lu_City (Name, State, Country, Latitude, Longitude)	
	SELECT i.City, i.State, i.Country, i.Latitude, i.Longitude
	FROM (SELECT City, State, Country, MIN(Latitude) AS Latitude,  MIN(Longitude) AS Longitude FROM Institution GROUP BY City, State, Country) i
		LEFT JOIN lu_City c ON i.City=c.Name AND ISNULL(i.State, '') = ISNULL(c.State, '') AND i.Country = c.Country		
	WHERE i.City <> 'Missing' AND c.Name IS NULL AND i.Latitude IS NOT NULL AND i.Longitude IS NOT NULL

	-- return already exist institutions not being inserted 
	SELECT * FROM #exist

	IF object_id('tmp_LoadInstitutions') is not null
		DROP TABLE tmp_LoadInstitutions

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO


/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_ImportNew]    Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_ImportNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_ImportNew]
GO 

CREATE PROCEDURE [dbo].[DataUpload_ImportNew] 
@PartnerCode varchar(25),
@FundingYears VARCHAR(25),
@ImportNotes  VARCHAR(1000),
@ReceivedDate  datetime
  
AS

DECLARE @Type varchar(25) = 'NEW'

SET NOCOUNT ON

BEGIN TRANSACTION;

BEGIN TRY     

--IF @ImportNotes = 'error'
--	RAISERROR ('Simulated Error for testing...', 16, 1);

-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')

UPDATE UploadWorkbook SET AwardTitle = SUBSTRING(AwardTitle, 2, LEN(AwardTitle)-2)
where LEFT(AwardTitle, 1) = '"' AND RIGHT(AwardTitle, 1) = '"' 

UPDATE UploadWorkbook SET techabstract = SUBSTRING(techabstract, 2, LEN(techabstract)-2)
where LEFT(techabstract, 1) = '"' AND RIGHT(techabstract, 1) = '"'

-------------------------------------------------------------------------------------------
-- Insert Missing  Institutions
--------------------------------------------------------------------------------------------

-----------------------------------
-- Insert Data Upload Status
-----------------------------------
DECLARE @DataUploadStatusID_stage INT
DECLARE @DataUploadStatusID_prod INT

INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())
	
SET @DataUploadStatusID_stage = IDENT_CURRENT( 'DataUploadStatus' )  
	
-- also insert a DataUploadStatus record in icrp_data
INSERT INTO icrp_data_dev.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())

SET @DataUploadStatusID_prod = IDENT_CURRENT( 'icrp_data_dev.dbo.DataUploadStatus' )  

/***********************************************************************************************/
--  New AwardCodes for imported partner
/***********************************************************************************************/
SELECT Distinct CAST('New' AS VARCHAR(25)) AS Type, CAST(NULL AS INT) AS ProjectID, CAST(NULL AS INT) AS FundingOrgID, AwardCode INTO #awardCodes FROM UploadWorkBook

UPDATE #awardCodes SET Type='Existing', ProjectID=pp.ProjectID, FundingOrgID = pp.FundingOrgID
FROM #awardCodes a 
JOIN (SELECT o.FundingOrgID, p.* FROM Project p 
		JOIN ProjectFunding f ON p.ProjectID = f.ProjectID 
		JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID 
	  WHERE o.SponsorCode = @PartnerCode) pp ON a.AwardCode = pp.AwardCode	

SELECT u.AwardCode, MIN(u.Childhood) AS Childhood, MIN(u.AwardStartDate) AS AwardStartDate, MIN(u.AwardEndDate) AS AwardEndDate, MIN(u.AwardType) AS AwardType INTO #newParentProjects 
from UploadWorkBook u
JOIN (SELECT * FROM #awardCodes WHERE Type='New') n ON u.AwardCode = n.AwardCode
GROUP BY u.AwardCode

-----------------------------------
-- Import base Projects
-----------------------------------
INSERT INTO Project (IsChildhood, AwardCode, ProjectStartDate, ProjectEndDate, DataUploadStatusID, CreatedDate, UpdatedDate)
SELECT CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
		AwardCode, AwardStartDate, AwardEndDate, @DataUploadStatusID_stage, getdate(), getdate()
FROM #newParentProjects

-----------------------------------
-- Import Project Abstract
-----------------------------------
DECLARE @seed INT
SELECT @seed=MAX(projectAbstractID)+1 FROM projectAbstract 

CREATE TABLE UploadAbstractTemp (	
	ID INT NOT NULL IDENTITY(1,1),
	AwardCode NVARCHAR(50),
	Altid NVARCHAR(50),
	TechAbstract NVARCHAR (MAX) NULL,
	PublicAbstract NVARCHAR (MAX) NULL
) ON [PRIMARY]

DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed) WITH NO_INFOMSGS

INSERT INTO UploadAbstractTemp (AwardCode, Altid, TechAbstract, PublicAbstract) SELECT DISTINCT AwardCode, Altid, TechAbstract, PublicAbstract FROM UploadWorkBook 

UPDATE UploadAbstractTemp SET PublicAbstract = NULL where PublicAbstract = '0' OR PublicAbstract = ''
UPDATE UploadAbstractTemp SET TechAbstract = '' where TechAbstract = '0' OR TechAbstract IS NULL

SET IDENTITY_INSERT ProjectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

INSERT INTO ProjectAbstract (ProjectAbstractID, TechAbstract, PublicAbstract) 
SELECT ID, TechAbstract, PublicAbstract FROM UploadAbstractTemp  WHERE AwardCode IS NOT NULL

SET IDENTITY_INSERT ProjectAbstract OFF;  -- SET IDENTITY_INSERT to OFF. 

-----------------------------------
-- Import ProjectFunding 
-----------------------------------
INSERT INTO ProjectFunding ([Title],[ProjectID],[FundingOrgID],	[FundingDivisionID], [ProjectAbstractID], [DataUploadStatusID],	[Category], [AltAwardCode], [Source_ID], [MechanismCode], 
	[MechanismTitle], [FundingContact], [IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], [CreatedDate], [UpdatedDate])
SELECT u.AwardTitle, p.ProjectID, o.FundingOrgID, d.FundingDivisionID, a.ID, @DataUploadStatusID_stage,
	u.Category, u.AltId, u.SourceId, u.FundingMechanismCode, u.FundingMechanism, u.FundingContact, 
	CASE ISNULL(u.IsAnnualized, '') WHEN 'A' THEN 1 ELSE 0 END AS IsAnnualized, 
	u.AwardFunding, 
	u.BudgetStartDate, u.BudgetEndDate, getdate(), getdate()
FROM UploadWorkBook u
JOIN UploadAbstractTemp a ON u.AwardCode = a.AwardCode AND u.AltId = a.Altid
JOIN (select distinct p.ProjectID, p.AWardCode from project p  --75035
	left join projectfunding f on p.projectid = f.projectid
	left join fundingorg o on o.FundingOrgID = f.fundingorgid
	where (o.sponsorcode IS NULL) OR (o.Sponsorcode = @PartnerCode)) p ON u.AwardCode = p.awardCode
JOIN FundingOrg o ON u.FundingOrgAbbr = o.Abbreviation AND o.SponsorCode = @PartnerCode
LEFT JOIN FundingDivision d ON u.FundingDivAbbr = d.Abbreviation

-----------------------------------
-- Import ProjectFundingInvestigator
-----------------------------------
INSERT INTO ProjectFundingInvestigator ([ProjectFundingID], [LastName],	[FirstName],[ORC_ID],[OtherResearch_ID],[OtherResearch_Type],[IsPrincipalInvestigator],[InstitutionID],[InstitutionNameSubmitted])
SELECT DISTINCT f.ProjectFundingID, u.PILastName, u.PIFirstName, u.ORCID, u.OtherResearcherID, u.OtherResearcherIDType, 1 AS isPI, ISNULL(i.InstitutionID,1) AS InstitutionID, u.SubmittedInstitution
FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	LEFT JOIN Institution i ON u.InstitutionICRP = i.Name AND u.City = i.City
	
-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null
BEGIN

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_pcsoRel	
	
	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	SELECT AltID AS AltAwardCode, CSOCodes, CSORel INTO #clist FROM UploadWorkBook 

	CREATE TABLE tmp_pcso
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		CSO VARCHAR(50)	
	)

	CREATE TABLE tmp_pcsorel 
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Rel Decimal (18, 2)
	)

	DECLARE @AltAwardCode as VARCHAR(50)
	DECLARE @csoList as NVARCHAR(50)
	DECLARE @csoRelList as NVARCHAR(50)
 
	DECLARE @csocursor as CURSOR;

	SET @csocursor = CURSOR FOR
	SELECT AltAwardCode, CSOCodes , CSORel FROM #clist;
 
	OPEN @csocursor;
	FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN

	 INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
	 INSERT INTO tmp_pcsorel SELECT @AltAwardCode, CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		FROM  dbo.ToStrTable(@csoRelList) 

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
	END
 
	CLOSE @csocursor;
	DEALLOCATE @csocursor;

	UPDATE tmp_pcso SET CSO = LTRIM(RTRIM(CSO))	

END

-----------------------------------
-- Import ProjectCSO
-----------------------------------
INSERT INTO ProjectCSO SELECT f.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM tmp_pcso c 
	JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode


-----------------------------------
-- Import ProjectCancerType
-----------------------------------

-----------------------------------------------------------------
-- Rebuild Site temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_psite') is null OR object_id('tmp_psiterel') is null
BEGIN

	IF object_id('tmp_psite') is NOT null
		drop table tmp_psite
	IF object_id('tmp_psiterel') is NOT null
		drop table tmp_psiterel	

	SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, u.SiteCodes, u.SiteRel INTO #slist
	FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltId = f.AltAwardCode

	CREATE TABLE tmp_psite
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Code VARCHAR(50)	
	)

	CREATE TABLE tmp_psiterel
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),	
		Rel Decimal (18, 2)
	)
	
	DECLARE @sAltAwardCode as VARCHAR(50)
	DECLARE @siteList as NVARCHAR(2000)
	DECLARE @siteRelList as NVARCHAR(2000)
 
	DECLARE @ctcursor as CURSOR;

	SET @ctcursor = CURSOR FOR
	SELECT AltAwardCode, SiteCodes , SiteRel FROM #slist;
 
	OPEN @ctcursor;
	FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN
 
	 INSERT INTO tmp_psite SELECT @sAltAwardCode, value FROM  dbo.ToStrTable(@siteList)
	 INSERT INTO tmp_psiterel SELECT @sAltAwardCode, 
		 CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		 FROM  dbo.ToStrTable(@siteRelList) 
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;
	END
 
	CLOSE @ctcursor;
	DEALLOCATE @ctcursor;

	UPDATE tmp_psite SET code = LTRIM(RTRIM(code))	
END

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT f.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM tmp_psite c 
	JOIN tmp_psiterel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN CancerType ct ON c.code = ct.ICRPCode
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode

-----------------------------------
-- Import Project_ProjectTye (only the new AwardCode)
-----------------------------------
SELECT p.ProjectID, p.AwardCode, b.AwardType INTO #plist FROM #newParentProjects b
JOIN (SELECT * FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_stage) p ON p.AwardCode = b.AwardCode

	
DECLARE @ptype TABLE
(	
	ProjectID INT,	
	ProjectType VARCHAR(15)
)

DECLARE @projectID as INT
DECLARE @typeList as NVARCHAR(50)
 
DECLARE @ptcursor as CURSOR;

SET @ptcursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #plist) p;
 
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


----------------------------------------------------
-- Post Import Checking
----------------------------------------------------
-------------------------------------------------------------------------------------------
---- checking Imported Award Sponsor
-------------------------------------------------------------------------------------------	
select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
	from projectfunding f 
		join FundingOrg o on o.FundingOrgID = f.FundingOrgID
	where f.DataUploadStatusID = @DataUploadStatusID_stage and o.SponsorCode <> @PartnerCode

IF EXISTS (select * from #postSponsor)
	 RAISERROR ('Post Import Check Error - Mis-matched Sponsor Code not match', 16, 1);

-------------------------------------------------------------------------------------------
---- checking Missing PI
-------------------------------------------------------------------------------------------	
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
	RAISERROR ('Post Import Check Error - Non-mapped Instititutions Mapping', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking Duplicate PI
-------------------------------------------------------------------------------------------	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)	
	RAISERROR ('Post Import Check Error - duplicate PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing PI
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingPI from projectfunding f
left join (SELECT projectFundingID, InstitutionID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator =1) pi on f.projectfundingid = pi.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)	
	RAISERROR ('Post Import Check Error - Missing PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing CSO
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingCSO from projectfunding f
left join ProjectCSO pc on f.projectfundingid = pc.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pc.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CSO', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking missing CancerType
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingSite from projectfunding f
left join ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and ct.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CancerType', 16, 1);	

-----------------------------------
-- Import ProjectFundingExt
-----------------------------------
-- call php code to calculate and populate calendar amounts


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract 
	FROM ProjectAbstract a
	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	WHERE f.DataUploadStatusID = @DataUploadStatusID_stage
	GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

-------------------------------------------------------------------------------------------
-- Insert DataUploadLog 
--------------------------------------------------------------------------------------------
DECLARE @DataUploadLogID INT

INSERT INTO DataUploadLog (DataUploadStatusID, [CreatedDate])
VALUES (@DataUploadStatusID_stage, getdate())

SET @DataUploadLogID = IDENT_CURRENT( 'DataUploadLog' )  

DECLARE @Count INT

-- Insert Project Count
SELECT @Count=COUNT(*) FROM Project WHERE dataUploadStatusID = @DataUploadStatusID_stage
UPDATE DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectAbstractCount
SELECT @Count=COUNT(*) FROM ProjectAbstract a
JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCSOCount
SELECT @Count=COUNT(*) FROM ProjectCSO c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCancerTypeCount Count
SELECT @Count=COUNT(*) FROM ProjectCancerType c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert Project_ProjectType Count
SELECT @Count=COUNT(*) FROM 
(SELECT DISTINCT t.ProjectID, t.ProjectType FROM Project_ProjectType t
JOIN #plist p ON t.ProjectID = p.ProjectID
) pt

UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingCount
SELECT @Count=COUNT(*) FROM ProjectFunding 
WHERE dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingInvestigatorCount Count
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearch TotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

INSERT INTO icrp_data_dev.dbo.DataUploadLog ([DataUploadStatusID], [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate]) 
	SELECT @DataUploadStatusID_prod, [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate] 
	FROM icrp_dataload_dev.dbo.DataUploadLog where DataUploadStatusID=@DataUploadStatusID_stage

-- return dataupload counts
SELECT  [DataUploadLogID],[DataUploadStatusID],[ProjectCount],[ProjectFundingCount],[ProjectFundingInvestigatorCount],[ProjectCSOCount],
		[ProjectCancerTypeCount],[Project_ProjectTypeCount],[ProjectAbstractCount],[ProjectSearchCount]
FROM DataUploadLog where DataUploadLogID=@DataUploadLogID

-----------------------------------------------------------------
-- Drop temp table
-----------------------------------------------------------------
IF object_id('UploadAbstractTemp') is NOT null
	drop table UploadAbstractTemp
IF object_id('tmp_pcso') is NOT null
	drop table tmp_pcso
IF object_id('tmp_pcsoRel') is NOT null
	drop table tmp_pcsoRel
IF object_id('tmp_psite') is NOT null
	drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
	drop table tmp_psiterel
IF object_id('tmp_awardType') is NOT null
	drop table tmp_awardType


COMMIT TRANSACTION

END TRY

BEGIN CATCH
      IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_ImportUpdate]																													*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_ImportUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_ImportUpdate]
GO 

CREATE PROCEDURE [dbo].[DataUpload_ImportUpdate] 
@PartnerCode varchar(25),
@FundingYears VARCHAR(25),
@ImportNotes  VARCHAR(1000),
@ReceivedDate  datetime
  
AS

SET NOCOUNT ON;  

BEGIN TRANSACTION;

BEGIN TRY     

DECLARE @Type varchar(15) = 'UPDATE'

--IF @ImportNotes = 'error'
--	RAISERROR ('Simulated Error for testing...', 16, 1);

-------------------------------------------------------------------------------------------
-- Replace open/closing double quotes
--------------------------------------------------------------------------------------------
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET AwardTitle = REPLACE(AwardTitle, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')
UPDATE UploadWorkbook SET techabstract = REPLACE(techabstract, '""', '"')

UPDATE UploadWorkbook SET AwardTitle = SUBSTRING(AwardTitle, 2, LEN(AwardTitle)-2)
where LEFT(AwardTitle, 1) = '"' AND RIGHT(AwardTitle, 1) = '"' 

UPDATE UploadWorkbook SET techabstract = SUBSTRING(techabstract, 2, LEN(techabstract)-2)
where LEFT(techabstract, 1) = '"' AND RIGHT(techabstract, 1) = '"'

-- replace city with accent names
update UploadWorkbook set city ='Montréal' where city='Montreal'
update UploadWorkbook set city ='Québec' where city='Quebec'
update UploadWorkbook set city ='Zürich' where city='Zurich'
update UploadWorkbook set city ='Pierre-Bénite' where city='Pierre-Benite'
update UploadWorkbook set city ='Umeå' where city='Umea'

-----------------------------------
-- Insert Data Upload Status
-----------------------------------
DECLARE @DataUploadStatusID_stage INT
DECLARE @DataUploadStatusID_prod INT

INSERT INTO DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())
	
SET @DataUploadStatusID_stage = IDENT_CURRENT( 'DataUploadStatus' )  
	
-- also insert a DataUploadStatus record in icrp_data
INSERT INTO icrp_data_dev.dbo.DataUploadStatus ([PartnerCode],[FundingYear],[Status], [Type],[ReceivedDate],[ValidationDate],[UploadToDevDate],[UploadToStageDate],[UploadToProdDate],[Note],[CreatedDate])
VALUES (@PartnerCode, @FundingYears, 'Staging', @Type, @ReceivedDate, getdate(), getdate(), getdate(),  NULL, @ImportNotes, getdate())

SET @DataUploadStatusID_prod = IDENT_CURRENT( 'icrp_data_dev.dbo.DataUploadStatus' )  


/***********************************************************************************************/
-- Archive to-be updated Project Funding records
/***********************************************************************************************/
INSERT INTO ProjectFundingArchive ([ProjectFundingID], FundingOrgID, FundingDivisionID, ProjectAbstractID, [Title], [Category], [AltAwardCode], [Source_ID], [MechanismCode], [MechanismTitle], [FundingContact],			
		[IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], DataUploadStatusID, ArchivedDate)
SELECT DISTINCT f.[ProjectFundingID], f.FundingOrgID, f.FundingDivisionID, f.ProjectAbstractID, f.[Title], f.[Category], f.[AltAwardCode], f.[Source_ID], f.[MechanismCode], f.[MechanismTitle], f.[FundingContact],			
		f.[IsAnnualized], f.[Amount], f.[BudgetStartDate], f.[BudgetEndDate], @DataUploadStatusID_stage, getdate() 
FROM UploadWorkbook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode

/***********************************************************************************************/
-- Start Import Data
/***********************************************************************************************/
-------------------------------------------------------
-- Update base Projects - Childhood, ProjectDates
------------------------------------------------------
UPDATE Project SET IsChildhood = 
	CASE ISNULL(Childhood, '') WHEN 'y' THEN 1 ELSE 0 END, 
ProjectStartDate = u.AwardStartDate, ProjectEndDate = u.AwardEndDate, UpdatedDate = getdate(), DataUploadStatusID = @DataUploadStatusID_stage
FROM Project p
	JOIN UploadWorkbook u ON p.AwardCode = u.AWardCode

-----------------------------------
-- Update Project Abstract
-----------------------------------
UPDATE ProjectAbstract SET TechAbstract=u.TechAbstract, PublicAbstract=u.PublicAbstract
FROM UploadWorkbook u
	JOIN ProjectFunding f ON u.AltID = f.AltAwardCode
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID AND u.FundingOrgAbbr = o.Abbreviation	
	JOIN ProjectAbstract a ON a.ProjectAbstractID = f.ProjectAbstractID	

--------------------------------------------------------------------------------------------------------------------------------------------
-- Update ProjectFunding - AwardAmount, Title, Category, AwardDates, Source_ID, Mechanism, FundingContact,IsAnnualized
--------------------------------------------------------------------------------------------------------------------------------------------
UPDATE ProjectFunding SET AltAwardCode = CASE WHEN ISNULL(u.NewAltId, '') = '' THEN u.AltID ELSE u.NewAltID END,
							Title = u.AwardTitle, Category = u.Category, Source_ID = u.SourceID, 
							MechanismCode = u.FundingMechanismCode, MechanismTitle = u.FundingMechanism, FundingContact = u.FundingContact,
							IsAnnualized = 
								CASE ISNULL(u.IsAnnualized, '') 
								WHEN 'y' THEN 1 ELSE 0 END,
						 Amount  = u.AwardFunding, BudgetStartDate = u.BudgetStartDate, BudgetEndDate = u.BudgetEndDate, UpdatedDate = getdate(),
						 DataUploadStatusID =  @DataUploadStatusID_stage
FROM ProjectFunding f 	
	JOIN FundingOrg o ON f.FundingOrgID = o.FundingOrgID
	JOIN UploadWorkbook u ON u.AltID = f.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation	

--------------------------------------------------------------------------------------------------------------------------------------------
-- Update ProjectFundingInvestigator  - PI name, ORCiD, Institution, OtherResearcherID, OtherResearcherIDType
--------------------------------------------------------------------------------------------------------------------------------------------
UPDATE ProjectFundingInvestigator SET LastName = u.PILastName, FirstName = u.PIFirstName, ORC_ID = u.ORCID, OtherResearch_ID= u.OtherResearcherID, OtherResearch_Type = u.OtherResearcherIDType, 
										InstitutionID = ISNULL(i.InstitutionID,1), InstitutionNameSubmitted = u.SubmittedInstitution, UpdatedDate = getdate()
FROM ProjectFundingInvestigator pi	
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON fa.ProjectFundingID = pi.ProjectFundingID
	JOIN FundingOrg o ON fa.FundingOrgID = o.FundingOrgID 
	JOIN UploadWorkbook u ON u.AltID = fa.AltAwardCode AND u.FundingOrgAbbr = o.Abbreviation		
	LEFT JOIN Institution i ON i.Name = u.InstitutionICRP AND i.City = i.City

	
-----------------------------------------------------------------
-- Rebuild CSO temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_pcso') is null OR object_id('tmp_pcsoRel') is null
BEGIN

	IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
	IF object_id('tmp_pcsoRel') is NOT null
		drop table tmp_pcsoRel	
	
	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	SELECT AltID AS AltAwardCode, CSOCodes, CSORel INTO #clist FROM UploadWorkBook 

	CREATE TABLE tmp_pcso
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		CSO VARCHAR(50)	
	)

	CREATE TABLE tmp_pcsorel 
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Rel Decimal (18, 2)
	)

	DECLARE @AltAwardCode as VARCHAR(50)
	DECLARE @csoList as NVARCHAR(50)
	DECLARE @csoRelList as NVARCHAR(50)
 
	DECLARE @csocursor as CURSOR;

	SET @csocursor = CURSOR FOR
	SELECT AltAwardCode, CSOCodes , CSORel FROM #clist;
 
	OPEN @csocursor;
	FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN

	 INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
	 INSERT INTO tmp_pcsorel SELECT @AltAwardCode, CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		FROM  dbo.ToStrTable(@csoRelList) 

	 DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
	END
 
	CLOSE @csocursor;
	DEALLOCATE @csocursor;

	UPDATE tmp_pcso SET CSO = LTRIM(RTRIM(CSO))	

END

----------------------------------------------------------------------
-- ProjectCSO - delete old then insert new
----------------------------------------------------------------------
DELETE ProjectCSO WHERE ProjectFundingID IN
	(SELECT ProjectFundingID FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadStatusID_stage)
	
INSERT INTO ProjectCSO SELECT fa.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM tmp_pcso c 
	JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON c.AltAwardCode = fa.AltAwardCode

----------------------------------------------------------------------
-- ProjectCancerType - delete old then insert new
----------------------------------------------------------------------

-----------------------------------------------------------------
-- Rebuild Site temp table if not exist
-----------------------------------------------------------------
IF object_id('tmp_psite') is null OR object_id('tmp_psiterel') is null
BEGIN

	IF object_id('tmp_psite') is NOT null
		drop table tmp_psite
	IF object_id('tmp_psiterel') is NOT null
		drop table tmp_psiterel	

	SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, u.SiteCodes, u.SiteRel INTO #slist
	FROM UploadWorkBook u
	JOIN ProjectFunding f ON u.AltId = f.AltAwardCode

	CREATE TABLE tmp_psite
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),
		Code VARCHAR(50)	
	)

	CREATE TABLE tmp_psiterel
	(
		Seq INT NOT NULL IDENTITY (1,1),
		AltAwardCode VARCHAR(50),	
		Rel Decimal (18, 2)
	)
	
	DECLARE @sAltAwardCode as VARCHAR(50)
	DECLARE @siteList as NVARCHAR(2000)
	DECLARE @siteRelList as NVARCHAR(2000)
 
	DECLARE @ctcursor as CURSOR;

	SET @ctcursor = CURSOR FOR
	SELECT AltAwardCode, SiteCodes , SiteRel FROM #slist;
 
	OPEN @ctcursor;
	FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;

	WHILE @@FETCH_STATUS = 0
	BEGIN
 
	 INSERT INTO tmp_psite SELECT @sAltAwardCode, value FROM  dbo.ToStrTable(@siteList)
	 INSERT INTO tmp_psiterel SELECT @sAltAwardCode, 
		 CASE LTRIM(RTRIM(value))
			WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END 
		 FROM  dbo.ToStrTable(@siteRelList) 
 
	 DBCC CHECKIDENT ('tmp_psite', RESEED, 0) WITH NO_INFOMSGS
	 DBCC CHECKIDENT ('tmp_psiterel', RESEED, 0) WITH NO_INFOMSGS

	 FETCH NEXT FROM @ctcursor INTO @sAltAwardCode, @siteList, @siteRelList;
	END
 
	CLOSE @ctcursor;
	DEALLOCATE @ctcursor;

	UPDATE tmp_psite SET code = LTRIM(RTRIM(code))	
END


-----------------------------------
-- Update ProjectCancerType
-----------------------------------
DELETE ProjectCancerType WHERE ProjectFundingID IN
	(SELECT ProjectFundingID FROM ProjectFunding WHERE DataUploadStatusID = @DataUploadStatusID_stage)

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT fa.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM tmp_psite c 
	JOIN tmp_psiterel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN CancerType ct ON c.code = ct.ICRPCode
	JOIN (SELECT * FROM ProjectFundingArchive WHERE DataUploadStatusID = @DataUploadStatusID_stage) fa ON c.AltAwardCode = fa.AltAwardCode

----------------------------------------------------------------------
-- Import Project_ProjectTye (only the new AwardCode)
----------------------------------------------------------------------
SELECT p.ProjectID, p.AwardCode, b.AwardType INTO #plist 
FROM (SELECT AwardCode, MAX(AWardType) AS AwardType FROM UploadWorkbook GROUP BY AwardCode) b
JOIN (SELECT * FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_stage) p ON p.AwardCode = b.AwardCode
	
DECLARE @ptype TABLE
(	
	ProjectID INT,	
	ProjectType VARCHAR(15)
)

DECLARE @projectID as INT
DECLARE @typeList as NVARCHAR(50)
 
DECLARE @ptcursor as CURSOR;

SET @ptcursor = CURSOR FOR
SELECT ProjectID, AwardType FROM (SELECT DISTINCT ProjectID, AWardType FROM #plist) p;
 
OPEN @ptcursor;
FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;

WHILE @@FETCH_STATUS = 0
BEGIN
 INSERT INTO @ptype SELECT @projectID, value FROM  dbo.ToStrTable(@typeList) 
 FETCH NEXT FROM @ptcursor INTO @projectID, @typeList;
END
 
CLOSE @ptcursor;
DEALLOCATE @ptcursor;

----------------------------------------------------------------------
-- Award Type/ProjectType - - delete old then insert new
----------------------------------------------------------------------
DELETE Project_ProjectType WHERE ProjectID IN
	(SELECT ProjectID FROM Project WHERE DataUploadStatusID = @DataUploadStatusID_stage)

INSERT INTO Project_ProjectType (ProjectID, ProjectType)
SELECT ProjectID,
		CASE ProjectType
		  WHEN 'C' THEN 'Clinical Trial'
		  WHEN 'R' THEN 'Research'
		  WHEN 'T' THEN 'Training'
		END
FROM @ptype	


----------------------------------------------------
-- Post Import Checking
----------------------------------------------------
-------------------------------------------------------------------------------------------
---- checking Imported Award Sponsor
-------------------------------------------------------------------------------------------	
select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
	from projectfunding f 
		join FundingOrg o on o.FundingOrgID = f.FundingOrgID
	where f.DataUploadStatusID = @DataUploadStatusID_stage and o.SponsorCode <> @PartnerCode

IF EXISTS (select * from #postSponsor)
	 RAISERROR ('Post Import Check Error - Mis-matched Sponsor Code not match', 16, 1);

-------------------------------------------------------------------------------------------
---- checking Missing PI
-------------------------------------------------------------------------------------------	
select f.altawardcode, u.SubmittedInstitution , u.institutionICRP, u.city into #postNotmappedInst 
	from ProjectFundingInvestigator pi 
		join projectfunding f on pi.ProjectFundingID = f.ProjectFundingID					
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.InstitutionID = 1

IF EXISTS (select * from #postNotmappedInst)
	RAISERROR ('Post Import Check Error - Non-mapped Instititutions Mapping', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking Duplicate PI
-------------------------------------------------------------------------------------------	
select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
	from projectfunding f
		join projectfundinginvestigator i on f.projectfundingid = i.projectfundingid	
		join UploadWorkBook u ON f.AltAwardCode = u.AltId
	where f.DataUploadStatusID = @DataUploadStatusID_stage AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1

	
IF EXISTS (select * FROM #postdupPI)	
	RAISERROR ('Post Import Check Error - duplicate PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing PI
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingPI from projectfunding f
left join (SELECT projectFundingID, InstitutionID FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator =1) pi on f.projectfundingid = pi.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pi.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingPI)	
	RAISERROR ('Post Import Check Error - Missing PIs', 16, 1);	
	
-------------------------------------------------------------------------------------------
---- checking missing CSO
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingCSO from projectfunding f
left join ProjectCSO pc on f.projectfundingid = pc.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and pc.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CSO', 16, 1);	

-------------------------------------------------------------------------------------------
---- checking missing CancerType
-------------------------------------------------------------------------------------------
select f.ProjectFundingID into #postMissingSite from projectfunding f
left join ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
where f.DataUploadStatusID = @DataUploadStatusID_stage and ct.ProjectFundingID is null

	
IF EXISTS (select * FROM #postMissingCSO)	
	RAISERROR ('Post Import Check Error - Missing CancerType', 16, 1);	


-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
INSERT INTO ProjectSearch (ProjectID, [Content])
SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract 
	FROM ProjectAbstract a
	JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	WHERE f.DataUploadStatusID = @DataUploadStatusID_stage
	GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma

-------------------------------------------------------------------------------------------
-- Insert DataUploadLog 
--------------------------------------------------------------------------------------------
DECLARE @DataUploadLogID INT

INSERT INTO DataUploadLog (DataUploadStatusID, [CreatedDate])
VALUES (@DataUploadStatusID_stage, getdate())

SET @DataUploadLogID = IDENT_CURRENT( 'DataUploadLog' )  

DECLARE @Count INT

-- Insert Project Count
SELECT @Count=COUNT(*) FROM Project WHERE dataUploadStatusID = @DataUploadStatusID_stage
UPDATE DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectAbstractCount
SELECT @Count=COUNT(*) FROM ProjectAbstract a
JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCSOCount
SELECT @Count=COUNT(*) FROM ProjectCSO c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectCancerTypeCount Count
SELECT @Count=COUNT(*) FROM ProjectCancerType c 
JOIN ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert Project_ProjectType Count
SELECT @Count=COUNT(*) FROM 
(SELECT DISTINCT t.ProjectID, t.ProjectType FROM Project_ProjectType t
JOIN #plist p ON t.ProjectID = p.ProjectID
) pt

UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingCount
SELECT @Count=COUNT(*) FROM ProjectFunding 
WHERE dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectFundingInvestigatorCount Count
SELECT @Count=COUNT(*) FROM ProjectFundingInvestigator pi
JOIN ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
WHERE f.dataUploadStatusID = @DataUploadStatusID_stage

UPDATE DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

-- Insert ProjectSearch TotalCount
SELECT @Count=COUNT(*) FROM ProjectSearch

UPDATE DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

INSERT INTO icrp_data_dev.dbo.DataUploadLog ([DataUploadStatusID], [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate]) 
	SELECT @DataUploadStatusID_prod, [ProjectCount], [ProjectFundingCount], [ProjectFundingInvestigatorCount], [ProjectCSOCount], [ProjectCancerTypeCount], [Project_ProjectTypeCount], [ProjectAbstractCount], [ProjectSearchCount], [CreatedDate] 
	FROM icrp_dataload_dev.dbo.DataUploadLog where DataUploadStatusID=@DataUploadStatusID_stage


-- return dataupload counts
SELECT  [DataUploadLogID],[DataUploadStatusID],[ProjectCount],[ProjectFundingCount],[ProjectFundingInvestigatorCount],[ProjectCSOCount],
		[ProjectCancerTypeCount],[Project_ProjectTypeCount],[ProjectAbstractCount],[ProjectSearchCount]
FROM DataUploadLog where DataUploadLogID=@DataUploadLogID

-----------------------------------------------------------------
-- Drop temp table
-----------------------------------------------------------------
IF object_id('UploadAbstractTemp') is NOT null
	drop table UploadAbstractTemp
IF object_id('tmp_pcso') is NOT null
	drop table tmp_pcso
IF object_id('tmp_pcsoRel') is NOT null
	drop table tmp_pcsoRel
IF object_id('tmp_psite') is NOT null
	drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
	drop table tmp_psiterel
IF object_id('tmp_awardType') is NOT null
	drop table tmp_awardType


COMMIT TRANSACTION

END TRY

BEGIN CATCH
      IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*																																														*/
/****** Object:  StoredProcedure [dbo].[DataUpload_SyncProd]     Script Date: 12/14/2016 4:21:37 PM																					*****/
/*																																														*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_SyncProd]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_SyncProd] 
GO 

CREATE PROCEDURE [dbo].[DataUpload_SyncProd]    

@DataUploadID INT

AS

SET NOCOUNT ON

-------------------------------------------------
-- Retrieve DataUploadStatusID and Seed Info
------------------------------------------------
declare @DataUploadStatusID_Stage INT
declare @DataUploadStatusID_Prod INT
declare @PartnerCode VARCHAR(25)
declare @Type VARCHAR(25)

SET @DataUploadStatusID_Stage = @DataUploadID

BEGIN TRANSACTION;

BEGIN TRY 

	IF ((SELECT COUNT(*) FROM (SELECT * FROM icrp_data_dev.dbo.DataUploadStatus WHERE Status = 'Staging') p
		JOIN (SELECT * FROM icrp_dataload_dev.dbo.DataUploadStatus WHERE Status = 'Staging') s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type WHERE s.DataUploadStatusID = @DataUploadStatusID_Stage) = 1)
	BEGIN
		SELECT @DataUploadStatusID_Prod = p.DataUploadStatusID, @Type = p.[Type], @PartnerCode=p.PartnerCode 

		FROM (SELECT * FROM icrp_data_dev.dbo.DataUploadStatus WHERE Status = 'Staging') p
			JOIN (SELECT * FROM icrp_dataload_dev.dbo.DataUploadStatus WHERE Status = 'Staging') s ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type
		WHERE s.DataUploadStatusID = @DataUploadStatusID_Stage
	END
	ELSE
	BEGIN			  
      RAISERROR ('Failed to retrieve Prod DataUploadStatusID', 16, 1)
	END
	
	/***********************************************************************************************/
	-- Archive Project Funding records those will be updated
	/***********************************************************************************************/
	IF @Type = 'Update'
	BEGIN
		INSERT INTO icrp_data_dev.dbo.ProjectFundingArchive ([ProjectFundingID], FundingOrgID, FundingDivisionID, ProjectAbstractID, [Title], [Category], [AltAwardCode], [Source_ID], [MechanismCode], [MechanismTitle], [FundingContact],			
												 		[IsAnnualized], [Amount], [BudgetStartDate], [BudgetEndDate], DataUploadStatusID, ArchivedDate)
			SELECT DISTINCT f.[ProjectFundingID], f.FundingOrgID, f.FundingDivisionID, f.ProjectAbstractID, f.[Title], f.[Category], f.[AltAwardCode], f.[Source_ID], f.[MechanismCode], f.[MechanismTitle], f.[FundingContact],			
					f.[IsAnnualized], f.[Amount], f.[BudgetStartDate], f.[BudgetEndDate], @DataUploadStatusID_Prod, getdate() 
			FROM icrp_dataload_dev.dbo.ProjectFundingArchive fa
				JOIN icrp_data_dev.dbo.ProjectFunding f ON fa.[AltAwardCode] = f.[AltAwardCode]
			WHERE fa.DataUploadStatusID = @DataUploadStatusID_Stage
	END

	/***********************************************************************************************/
	-- Import Data
	/***********************************************************************************************/
	-----------------------------------
	-- Import Project
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		INSERT INTO icrp_data_dev.dbo.project ([IsChildhood], [AwardCode], [ProjectStartDate], [ProjectEndDate], [DataUploadStatusID], [CreatedDate], [UpdatedDate])
		SELECT [IsChildhood],[AwardCode],[ProjectStartDate],[ProjectEndDate], @DataUploadStatusID_Prod, getdate(),getdate()
		FROM icrp_dataload_dev.dbo.Project WHERE [DataUploadStatusID] = @DataUploadStatusID_Stage	
	END
	ELSE  -- Update base projects
	BEGIN

		UPDATE icrp_data_dev.dbo.Project SET IsChildhood = lp.IsChildhood, ProjectStartDate= lp.ProjectStartDate, ProjectEndDate= lp.ProjectEndDate, DataUploadStatusID=@DataUploadStatusID_Prod, UpdatedDate = getdate()
		FROM icrp_data_dev.dbo.Project p
			JOIN icrp_dataload_dev.dbo.Project lp ON p.AwardCode = lp.AwardCode
		WHERE lp.DataUploadStatusID = @DataUploadStatusID_Stage

	END

	-----------------------------------
	-- Import Project Abstract
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		DECLARE @seed INT
		SELECT @seed=MAX(projectAbstractID)+1 FROM icrp_data_dev.dbo.projectAbstract 
	
		CREATE TABLE UploadAbstractTemp (	
			ID INT NOT NULL IDENTITY(1,1),
			ProjectFundindID INT,	
			TechAbstract NVARCHAR (MAX) NULL,
			PublicAbstract NVARCHAR (MAX) NULL
		) ON [PRIMARY]

		DBCC CHECKIDENT ('[UploadAbstractTemp]', RESEED, @seed) WITH NO_INFOMSGS

		INSERT INTO UploadAbstractTemp (ProjectFundindID, TechAbstract,	PublicAbstract) SELECT pf.projectFundingID, a.[TechAbstract], a.[PublicAbstract]
			FROM icrp_dataload_dev.dbo.projectAbstract a
			JOIN icrp_dataload_dev.dbo.projectfunding pf ON a.projectAbstractID =  pf.projectAbstractID  WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

		SET IDENTITY_INSERT icrp_data_dev.dbo.projectAbstract ON;  -- SET IDENTITY_INSERT to ON. 

		INSERT INTO icrp_data_dev.dbo.ProjectAbstract ([projectAbstractID], [TechAbstract], [PublicAbstract],[CreatedDate],[UpdatedDate])
		SELECT ID, [TechAbstract], [PublicAbstract],getdate(),getdate()
		FROM UploadAbstractTemp 

		SET IDENTITY_INSERT icrp_data_dev.dbo.projectAbstract OFF;  -- SET IDENTITY_INSERT to ON. 
	END
	ELSE  -- Update 
	BEGIN
		UPDATE icrp_data_dev.dbo.ProjectAbstract SET TechAbstract = la.TechAbstract, PublicAbstract=la.PublicAbstract, UpdatedDate = getdate()
		FROM icrp_data_dev.dbo.ProjectAbstract a
			JOIN icrp_data_dev.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
			JOIN icrp_dataload_dev.dbo.ProjectFundingArchive laf ON f.AltAwardCode = laf.AltAwardCode  -- use the archived AltAwardCode 
			JOIN icrp_dataload_dev.dbo.ProjectAbstract la ON a.ProjectAbstractID = laf.ProjectAbstractID
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Stage
	END

	-----------------------------------
	-- Import ProjectFunding
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		INSERT INTO icrp_data_dev.dbo.projectfunding ([Title],[ProjectID],[FundingOrgID],	[FundingDivisionID],[ProjectAbstractID],[DataUploadStatusID],[Category],[AltAwardCode],[Source_ID],
			[MechanismCode],[MechanismTitle],[FundingContact],[IsAnnualized],[Amount],[BudgetStartDate],[BudgetEndDate],[CreatedDate],[UpdatedDate])
	
		SELECT pf.[Title], newp.[ProjectID], prodo.[FundingOrgID], proddiv.[FundingDivisionID], a.ID, @DataUploadStatusID_Prod, pf.[Category], pf.[AltAwardCode], pf.[Source_ID],
			pf.[MechanismCode],pf.[MechanismTitle],pf.[FundingContact],pf.[IsAnnualized],pf.[Amount],pf.[BudgetStartDate],pf.[BudgetEndDate],getdate(),getdate()	
	
		FROM icrp_dataload_dev.dbo.ProjectFunding pf 
			JOIN icrp_dataload_dev.dbo.Project p ON pf.projectid = p.ProjectID
			JOIN icrp_dataload_dev.dbo.FundingOrg o ON pf.fundingorgID = o.FundingOrgID
			JOIN icrp_data_dev.dbo.fundingorg prodo ON prodo.Abbreviation = o.Abbreviation AND prodo.sponsorcode = o.sponsorcode	
			LEFT JOIN icrp_dataload_dev.dbo.FundingDivision d ON pf.FundingDivisionID = d.FundingDivisionID		
			LEFT JOIN icrp_data_dev.dbo.FundingDivision proddiv ON proddiv.Abbreviation= o.Abbreviation
			LEFT JOIN  (
					select distinct p.ProjectID, p.AWardCode from icrp_data_dev.dbo.project p  --75035
						left join icrp_data_dev.dbo.projectfunding f on p.projectid = f.projectid
						left join icrp_data_dev.dbo.fundingorg o on o.FundingOrgID = f.fundingorgid
					where (o.sponsorcode IS NULL) OR (o.Sponsorcode = @PartnerCode)

				) newp ON newp.AwardCode = p.AwardCode

			JOIN UploadAbstractTemp a ON pf.ProjectFundingID = a.ProjectFundindID		

		WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage	
	END
	ELSE  -- Update 
	BEGIN
		UPDATE icrp_data_dev.dbo.ProjectFunding SET AltAwardCode = lf.AltAwardCode, Category = lf.Category, Source_ID = lf.Source_ID, Amount = lf.Amount, BudgetStartDate = lf.BudgetStartDate, BudgetEndDate = lf.BudgetEndDate, 
				IsAnnualized = lf.IsAnnualized, DataUploadStatusID=@DataUploadStatusID_Prod, UpdatedDate = getdate()
		FROM icrp_data_dev.dbo.ProjectFunding f
			JOIN (SELECT * FROM icrp_dataload_dev.dbo.ProjectFundingArchive WHERE DataUploadStatusID=@DataUploadStatusID_Stage) laf ON f.AltAwardCode = laf.AltAwardCode  -- use the archived AltAwardCode 
			JOIN icrp_dataload_dev.dbo.ProjectFunding lf ON laf.ProjectFundingID = lf.ProjectFundingID
		WHERE lf.DataUploadStatusID = @DataUploadStatusID_Stage
	END

	----------------------------------------------------------------------
	-- For Update - some records can be wiped out old and then re-imported 
	----------------------------------------------------------------------
	IF @Type = 'Update'
	BEGIN
		DELETE icrp_data_dev.dbo.Project_ProjectType 
		FROM icrp_data_dev.dbo.Project_ProjectType pt
			JOIN icrp_data_dev.dbo.Project p ON pt.ProjectID = p.ProjectID			
		WHERE p.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data_dev.dbo.ProjectCSO 
		FROM icrp_data_dev.dbo.ProjectCSO cso
			JOIN icrp_data_dev.dbo.ProjectFunding f ON cso.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data_dev.dbo.ProjectCancerType 
		FROM icrp_data_dev.dbo.ProjectCancerType ct
			JOIN icrp_data_dev.dbo.ProjectFunding f ON ct.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod

		DELETE icrp_data_dev.dbo.ProjectFundingExt
		FROM icrp_data_dev.dbo.ProjectFundingExt ext
			JOIN icrp_data_dev.dbo.ProjectFunding f ON ext.ProjectFundingID = f.ProjectFundingID			
		WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod
	
	END

	-----------------------------------
	-- Import ProjectFundingInvestigator
	-----------------------------------
	IF @Type = 'New'
	BEGIN
		INSERT INTO icrp_data_dev.dbo.ProjectFundingInvestigator
		SELECT f.ProjectFundingID, pi.LastName, pi.FirstName, pi.ORC_ID, pi.OtherResearch_ID, pi.OtherResearch_Type, pi.IsPrincipalInvestigator, ISNULL(newi.InstitutionID,1), InstitutionNameSubmitted, getdate(),getdate()
		FROM icrp_dataload_dev.dbo.ProjectFundingInvestigator pi
			JOIN icrp_dataload_dev.dbo.projectfunding lf ON pi.ProjectFundingID =  lf.ProjectFundingID  
			JOIN icrp_data_dev.dbo.projectfunding f ON f.AltAwardCode =  lf.AltAwardCode  
			JOIN icrp_dataload_dev.dbo.Institution i ON pi.institutionID = i.institutionID
			LEFT JOIN icrp_data_dev.dbo.Institution newi ON newi.Name = i.Name AND newi.City = i.City
		WHERE lf.[DataUploadStatusID] = @DataUploadStatusID_Stage
	END
	ELSE  -- Update 
	BEGIN
		UPDATE icrp_data_dev.dbo.ProjectFundingInvestigator SET LastName = lpi.LastName, FirstName = lpi.FirstName, ORC_ID = lpi.ORC_ID, OtherResearch_ID= lpi.OtherResearch_ID, OtherResearch_Type = lpi.OtherResearch_Type, 
										InstitutionID = ISNULL(i.InstitutionID,1), InstitutionNameSubmitted = lpi.InstitutionNameSubmitted, UpdatedDate = getdate()
		FROM (SELECT * FROM icrp_data_dev.dbo.ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) pi
			JOIN icrp_data_dev.dbo.ProjectFunding f ON pi.projectfundingid = f.ProjectFundingID
			JOIN icrp_dataload_dev.dbo.ProjectFunding lf ON f.AltAwardCode = lf.AltAwardCode		
			JOIN (SELECT * FROM icrp_dataload_dev.dbo.ProjectFundingInvestigator WHERE IsPrincipalInvestigator = 1) lpi ON lf.ProjectFundingID = lpi.ProjectFundingID
			JOIN icrp_dataload_dev.dbo.Institution li ON li.InstitutionID = lpi.InstitutionID
			LEFT JOIN icrp_data_dev.dbo.Institution i ON i.Name = li.Name AND i.City = li.City
	END
				
	-----------------------------------
	-- Import ProjectCSO
	-----------------------------------
	INSERT INTO icrp_data_dev.dbo.ProjectCSO
	SELECT f.ProjectFundingID, cso.CSOCode, cso.Relevance, cso.RelSource, getdate(),getdate()
	FROM icrp_dataload_dev.dbo.ProjectCSO cso
		JOIN icrp_dataload_dev.dbo.projectfunding lf ON cso.ProjectFundingID =  lf.ProjectFundingID  
		JOIN icrp_data_dev.dbo.projectfunding f ON f.AltAwardCode =  lf.AltAwardCode  
	WHERE lf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import ProjectCancerType
	-----------------------------------
	INSERT INTO icrp_data_dev.dbo.ProjectCancerType
	SELECT new.ProjectFundingID, ct.CancerTypeID, ct.Relevance, ct.RelSource, getdate(),getdate(), ct.EnterBy
	FROM icrp_dataload_dev.dbo.ProjectCancerType ct
	JOIN icrp_dataload_dev.dbo.projectfunding pf ON ct.ProjectFundingID =  pf.ProjectFundingID  
	JOIN icrp_data_dev.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import Project_ProjectTye
	-----------------------------------
	INSERT INTO icrp_data_dev.dbo.Project_ProjectType
	SELECT DISTINCT np.ProjectID, pt.ProjectType, getdate(),getdate()
	FROM icrp_dataload_dev.dbo.Project_ProjectType pt
		JOIN icrp_dataload_dev.dbo.Project p ON pt.ProjectID = p.ProjectID
		JOIN (SELECT * FROM icrp_data_dev.dbo.Project WHERE DataUploadStatusID = @DataUploadStatusID_Prod) np ON p.AwardCode = np.AwardCode	
	WHERE p.[DataUploadStatusID] = @DataUploadStatusID_Stage

	-----------------------------------
	-- Import ProjectFundingExt
	-----------------------------------
	INSERT INTO icrp_data_dev.dbo.ProjectFundingExt
	SELECT new.ProjectFundingID, ex.CalendarYear, ex.CalendarAmount, getdate(),getdate()
	FROM icrp_dataload_dev.dbo.ProjectFundingExt ex
		JOIN icrp_dataload_dev.dbo.projectfunding pf ON ex.ProjectFundingID =  pf.ProjectFundingID  
		JOIN icrp_data_dev.dbo.projectfunding new ON new.AltAwardCode =  pf.AltAwardCode  
	WHERE pf.[DataUploadStatusID] = @DataUploadStatusID_Stage

	
	----------------------------------------------------
	-- Post Import Checking
	----------------------------------------------------
	-------------------------------------------------------------------------------------------
	---- checking Imported Award Sponsor
	-------------------------------------------------------------------------------------------	
	select f.altawardcode, o.SponsorCode, o.Name AS FundingOrg into #postSponsor
		from icrp_data_dev.dbo.projectfunding f 
			join icrp_data_dev.dbo.FundingOrg o on o.FundingOrgID = f.FundingOrgID
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and o.SponsorCode <> @PartnerCode

	IF EXISTS (select * from #postSponsor)
	BEGIN		
		RAISERROR ('Post Prod Sync  Check - Sponsor Code - Failed', 16, 1)
	END

	-------------------------------------------------------------------------------------------
	---- checking Missing PI
	-------------------------------------------------------------------------------------------	
	select f.altawardcode into #postNotmappedInst 
		from icrp_data_dev.dbo.ProjectFundingInvestigator pi 
			join icrp_data_dev.dbo.projectfunding f on pi.ProjectFundingID = f.ProjectFundingID			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.InstitutionID = 1

	IF EXISTS (select * from #postNotmappedInst)
	BEGIN		
		RAISERROR ('Post Prod Sync  Check - Instititutions Mapping - Failed', 16, 1)
	END		

	-------------------------------------------------------------------------------------------
	---- checking Duplicate PI
	-------------------------------------------------------------------------------------------	
	select f.projectfundingid, f.AltAwardCode, count(*) AS Count into #postdupPI 
		from icrp_data_dev.dbo.projectfunding f
			join icrp_data_dev.dbo.projectfundinginvestigator i on f.projectfundingid = i.projectfundingid			
		where f.DataUploadStatusID = @DataUploadStatusID_Prod AND i.IsPrincipalInvestigator=1
	group by f.projectfundingid,f.AltAwardCode having count(*) > 1
	
	IF EXISTS (select * FROM #postdupPI)		
	BEGIN		
		RAISERROR ('Post-Checking duplicate PIs ==> Failed', 16, 1)
	END	
	
	-------------------------------------------------------------------------------------------
	---- checking missing PI
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingPI from icrp_data_dev.dbo.projectfunding f
	left join icrp_data_dev.dbo.ProjectFundingInvestigator pi on f.projectfundingid = pi.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pi.ProjectFundingID is null
		
	IF EXISTS (select * FROM #postMissingPI)	
	BEGIN		
		RAISERROR ('Pre-Checking Missing PIs ==> Failed', 16, 1)
	END	
	
	-------------------------------------------------------------------------------------------
	---- checking missing CSO
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingCSO from icrp_data_dev.dbo.projectfunding f
	left join icrp_data_dev.dbo.ProjectCSO pc on f.projectfundingid = pc.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and pc.ProjectFundingID is null
	
	IF EXISTS (select * FROM #postMissingCSO)
	BEGIN
		RAISERROR ('Pre-Checking Missing CSO ==> Failed', 16, 1)
	END		

	-------------------------------------------------------------------------------------------
	---- checking missing CancerType
	-------------------------------------------------------------------------------------------
	select f.ProjectFundingID into #postMissingSite from icrp_data_dev.dbo.projectfunding f
	left join icrp_data_dev.dbo.ProjectCancerType ct on f.projectfundingid = ct.projectfundingid
	where f.DataUploadStatusID = @DataUploadStatusID_Prod and ct.ProjectFundingID is null

	
	IF EXISTS (select * FROM #postMissingCSO)			
	BEGIN		
		RAISERROR ('Pre-Checking Missing CancerType ==> Failed', 16, 1)
	END	

-------------------------------------------------------------------------------------------
-- Rebuild ProjectSearch   -- 75608 ~ 2.20 mins)
--------------------------------------------------------------------------------------------
	INSERT INTO ProjectSearch (ProjectID, [Content])
	SELECT ma.ProjectID, '<Title>'+ ma.Title+'</Title><FundingContact>'+ ISNULL(ma.fundingContact, '')+ '</FundingContact><TechAbstract>' + ma.TechAbstract  + '</TechAbstract><PublicAbstract>'+ ISNULL(ma.PublicAbstract,'') +'<PublicAbstract>' 
	FROM (SELECT MAX(f.ProjectID) AS ProjectID, f.Title, f.FundingContact, a.TechAbstract,a.PublicAbstract 
			FROM ProjectAbstract a
			JOIN ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
			WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod
			GROUP BY f.Title, a.TechAbstract, a.PublicAbstract,  f.FundingContact) ma	
				
	-------------------------------------------------------------------------------------------
	-- Insert DataUploadLog 
	--------------------------------------------------------------------------------------------	
	DECLARE @DataUploadLogID INT

	SELECT @DataUploadLogID = DataUploadLogID FROM icrp_data_dev.dbo.DataUploadLog WHERE DataUploadStatusID = @DataUploadStatusID_Prod	
		
	DECLARE @Count INT

	-- Insert Project Count
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.Project	
	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectAbstractCount
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.ProjectAbstract a
		JOIN icrp_data_dev.dbo.ProjectFunding f ON a.ProjectAbstractID = f.ProjectAbstractID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE DataUploadLog SET ProjectAbstractCount = @count WHERE DataUploadLogID =	@DataUploadLogID

	-- Insert ProjectCSOCount
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.ProjectCSO c 
		JOIN icrp_data_dev.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectCSOCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectCancerTypeCount Count
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.ProjectCancerType c 
		JOIN icrp_data_dev.dbo.ProjectFunding f ON c.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectCancerTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert Project_ProjectType Count
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.Project_ProjectType t
		JOIN icrp_data_dev.dbo.Project p ON t.ProjectID = p.ProjectID	
	WHERE p.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE DataUploadLog SET Project_ProjectTypeCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectFundingCount
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.ProjectFunding 
	WHERE dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectFundingCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectFundingInvestigatorCount Count
	SELECT @Count=COUNT(*) FROM icrp_data_dev.dbo.ProjectFundingInvestigator pi
		JOIN icrp_data_dev.dbo.ProjectFunding f ON pi.ProjectFundingID = f.ProjectFundingID
	WHERE f.dataUploadStatusID = @DataUploadStatusID_Prod

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectFundingInvestigatorCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-- Insert ProjectSearch TotalCount
	SELECT @Count=COUNT(*) FROM ProjectSearch

	UPDATE icrp_data_dev.dbo.DataUploadLog SET ProjectSearchCount = @Count WHERE DataUploadLogID = @DataUploadLogID

	-------------------------------------------------------------------------------------------
	-- Update FundingOrg LastImpoet Date/Desc
	--------------------------------------------------------------------------------------------
	UPDATE icrp_data_dev.dbo.fundingorg SET LastImportDate=getdate(), LastImportDesc = i.Note
	FROM icrp_data_dev.dbo.fundingorg o 
		JOIN (SELECT DISTINCT FundingOrgID, d.Note FROM icrp_data_dev.dbo.ProjectFunding f
				JOIN icrp_data_dev.dbo.DataUploadStatus d ON f.DataUploadStatusID = d.DataUploadStatusID
				WHERE f.DataUploadStatusID = @DataUploadStatusID_Prod) i  ON o.FundingOrgID = i.FundingOrgID
				
	-------------------------------------------------------------------------------------------
	-- Mark DataUpload Completed
	--------------------------------------------------------------------------------------------
	UPDATE icrp_data_dev.dbo.DataUploadStatus SET Status = 'Completed', [UploadToProdDate] = getdate() WHERE DataUploadStatusID = @DataUploadStatusID_Prod
	UPDATE icrp_dataload_dev.dbo.DataUploadStatus SET Status = 'Completed', [UploadToProdDate] = getdate()  WHERE DataUploadStatusID = @DataUploadStatusID_Stage
	
	-----------------------------------------------------------------
	-- Drop temp table
	-----------------------------------------------------------------
	IF object_id('UploadAbstractTemp') is NOT null
		drop table UploadAbstractTemp
			
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      --IF @@trancount > 0 	  
		ROLLBACK TRANSACTION
	        
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO



----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddPartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddPartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddPartner]
GO 

CREATE  PROCEDURE [dbo].[AddPartner]	
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6) 
AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	SET NOCOUNT ON;

	IF EXISTS (SELECT 1 FROM Partner WHERE SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	INSERT INTO Partner ([Name],[Description], [SponsorCode], [Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate], [Latitude], [Longitude], [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Description, @SponsorCode, @Email, @IsDSASigned,@Country, @Website,	@LogoFile, @Note,@JoinedDate, @Latitude, @Longitude, GETDATE(), GETDATE())
		
	-- Also insert the new partner into the PartnerOrg table
	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
	SELECT @Name, @SponsorCode, 'Partner', 1 

	-- Also Insert the newly inserted partner into the icrp_dataload database
	INSERT INTO icrp_dataload_dev.dbo.Partner ([Name], [Description],[SponsorCode],[Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate], [Latitude], [Longitude], [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Description, @SponsorCode, @Email, @IsDSASigned,@Country, @Website,	@LogoFile, @Note,@JoinedDate, @Latitude, @Longitude, GETDATE(), GETDATE())

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdatePartner]    Script Date: 12/14/2016 4:21:37 PM ******/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdatePartner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdatePartner]
GO 

CREATE  PROCEDURE [dbo].[UpdatePartner]
	@PartnerID INT,
	@Name [varchar](100),
	@Description [varchar](max),
	@SponsorCode [varchar](50),
	@Email [varchar](75),
	@IsDSASigned [bit],
	@Country [varchar](100),
	@Website [varchar](200),
	@LogoFile [varchar](100),
	@Note [varchar](8000),
	@JoinedDate [datetime],
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6) 
AS   

BEGIN TRANSACTION;
BEGIN TRY    	

	DECLARE @OrgSponsorCode [varchar](50)
	SELECT @OrgSponsorCode = SponsorCode FROM Partner WHERE PartnerID =  @PartnerID

	IF EXISTS (SELECT 1 FROM Partner WHERE PartnerID <> @PartnerID AND SponsorCode = @SponsorCode)
	BEGIN
		   RAISERROR ('Sponsor Code already existed', 16, 1)
	END

	UPDATE Partner SET [Name] = @Name,
		[Description]  = @Description,
		[SponsorCode]  = @SponsorCode,
		[Email]  = @Email,
		[IsDSASigned] = @IsDSASigned,
		[Country] = @Country,
		[Website] = @Website,
		[LogoFile] = @LogoFile,
		[Note]  = @Note,
		[JoinedDate]  = @JoinedDate,	
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE PartnerID =  @PartnerID

	-- Also update icrp_dataload database
	UPDATE icrp_dataload_dev.dbo.Partner SET [Name] = @Name,
		[Description]  = @Description,
		[SponsorCode]  = @SponsorCode,
		[Email]  = @Email,
		[IsDSASigned] = @IsDSASigned,
		[Country] = @Country,
		[Website] = @Website,
		[LogoFile] = @LogoFile,
		[Note]  = @Note,
		[JoinedDate]  = @JoinedDate,	
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE [SponsorCode] =  @OrgSponsorCode

	-- Also update other tables if the SponsorCode is changed
	IF (@SponsorCode <> @OrgSponsorCode)
	BEGIN
		UPDATE FundingOrg SET SponsorCode = @SponsorCode WHERE SponsorCode=@OrgSponsorCode
		UPDATE PartnerOrg SET SponsorCode = @SponsorCode WHERE SponsorCode=@OrgSponsorCode
	END

	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO


----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[AddFundingOrg]								****************/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AddFundingOrg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[AddFundingOrg]
GO 

CREATE  PROCEDURE [dbo].[AddFundingOrg]	
	@PartnerID INT,
	@Name [varchar](100),
	@Abbreviation [varchar](15),
	@Type [varchar](25),
	@Country [varchar](3),
	@Currency [varchar](3),	
	@MemberType [varchar](25),
	@MemberStatus [nchar](10),
	@IsAnnualized [bit],
	@Note [varchar](8000),
	@Website [varchar](200) ,
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6)	
AS   


BEGIN TRANSACTION;
BEGIN TRY    	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Return error if the  abbreviation already exist within the same sponsorcode
	DECLARE @SponsorCode [varchar](50)
	SELECT @SponsorCode = SponsorCode FROM Partner WHERE PartnerID =  @PartnerID

	IF EXISTS (SELECT 1 FROM FundingOrg WHERE SponsorCode = @SponsorCode AND Abbreviation = @Abbreviation)
	BEGIN
		   RAISERROR ('Funding Org Abbreviation already existed for the partner.', 16, 1)
	END

	INSERT INTO FundingOrg ([Name], Abbreviation, [Type],[Country], [Currency], [SponsorCode], 	[MemberType], [MemberStatus], [IsAnnualized],[Note], [Website],	[Latitude],	[Longitude],[CreatedDate], [UpdatedDate])
	VALUES (@Name, @Abbreviation, @Type, @Country, @Currency, @SponsorCode, @MemberType, @MemberStatus,	@IsAnnualized, @Note, @Website, @Latitude, @Longitude, GETDATE(), GETDATE())
	

	-- Also Insert the new fundingorg into the PartnerOrg table
	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
	VALUES (@Name, @SponsorCode, 'Associate', 1)

	-- Also insert the new fundingorg into the icrp_dataload database
	INSERT INTO icrp_dataload_dev.dbo.FundingOrg ([Name], Abbreviation, [Type],[Country], [Currency], [SponsorCode], 	[MemberType], [MemberStatus], [IsAnnualized],[Note], [Website],	[Latitude],	[Longitude], [CreatedDate], [UpdatedDate])
	VALUES (@Name, @Abbreviation, @Type, @Country, @Currency, @SponsorCode, @MemberType, @MemberStatus,	@IsAnnualized, @Note, @Website, @Latitude, @Longitude, GETDATE(), GETDATE())
	
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO

----------------------------------------------------------------------------------------------------------
/****** Object:  StoredProcedure [dbo].[UpdateFundingOrg]								****************/
----------------------------------------------------------------------------------------------------------
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateFundingOrg]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateFundingOrg]
GO 

CREATE  PROCEDURE [dbo].[UpdateFundingOrg]
	@FundingOrgID INT,
	@Name [varchar](100),
	@Abbreviation [varchar](15),
	@Type [varchar](25),
	@Country [varchar](3),
	@Currency [varchar](3),	
	@MemberType [varchar](25),
	@MemberStatus [nchar](10),
	@IsAnnualized [bit],
	@Note [varchar](8000),
	@Website [varchar](200) ,
	@Longitude [decimal](9, 6),
	@Latitude [decimal](9, 6)	
AS   


BEGIN TRANSACTION;
BEGIN TRY    	

	DECLARE @OrgAbbrev [varchar](50)
	DECLARE @SponsorCode [varchar](50)
	SELECT @OrgAbbrev = Abbreviation, @SponsorCode = SponsorCode FROM FundingOrg WHERE FundingOrgID =  @FundingOrgID

	-- Return error if the  abbreviation already exist within the same sponsorcode
	IF EXISTS (SELECT 1 FROM FundingOrg WHERE FundingOrgID <> @FundingOrgID AND SponsorCode = @SponsorCode AND Abbreviation = @Abbreviation)
	BEGIN
		   RAISERROR ('Funding Org Abbreviation already existed for the partner.', 16, 1)
	END

	UPDATE FundingOrg SET [Name] = @Name,		
		Abbreviation  = @Abbreviation,		
		[Type] = @Type,
		[Country] = @Country,
		[Currency] = @Currency,
		[MemberType] = @MemberType,
		[MemberStatus] = @MemberStatus,
		[IsAnnualized] = @IsAnnualized,		
		[Note]  = @Note,
		[Website] = @Website,		
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE FundingOrgID =  @FundingOrgID

	-- Also update the icrp_dataload database
	UPDATE icrp_dataload_dev.dbo.FundingOrg SET [Name] = @Name,		
		Abbreviation  = @Abbreviation,		
		[Type] = @Type,
		[Country] = @Country,
		[Currency] = @Currency,
		[MemberType] = @MemberType,
		[MemberStatus] = @MemberStatus,
		[IsAnnualized] = @IsAnnualized,		
		[Note]  = @Note,
		[Website] = @Website,		
		[Longitude]  = @Longitude,
		[Latitude] = @Latitude,
		[UpdatedDate] = getdate()
	WHERE SponsorCode = @SponsorCode AND Abbreviation = @OrgAbbrev

	-- Also update PartnerOrg	
	UPDATE PartnerOrg SET Name = @Name, IsActive = 
	CASE @MemberStatus
		WHEN 'Current' THEN '1'  -- Current Member
		ELSE '0' END             -- Inactive Member
	WHERE SponsorCode=@SponsorCode AND Name = @OrgAbbrev
	
	COMMIT TRANSACTION

END TRY

BEGIN CATCH
      -- IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  

GO
-------------------------------------------------------------------------------------------
-- Triggers
--------------------------------------------------------------------------------------------

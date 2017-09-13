--drop table #slist
--drop table #sites
--GO
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #sites (	
	[AltID] [varchar](50) NOT NULL,
	[sitecodes] [varchar](500) NOT NULL,
	[siterels] [varchar](500) NULL
)

GO

BULK INSERT #sites
FROM 'C:\ICRP\database\Cleanup\NCI_Data_Submission_Dup_Site.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #sites

IF object_id('tmp_psite') is NOT null
		drop table tmp_psite
IF object_id('tmp_psiterel') is NOT null
		drop table tmp_psiterel	

	SELECT f.projectID, f.ProjectFundingID, f.AltAwardCode, s.SiteCodes, s.SiteRels INTO #slist
	FROM #sites s
	JOIN ProjectFunding f ON s.AltId = f.AltAwardCode

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
	SELECT AltAwardCode, SiteCodes , SiteRels FROM #slist;
 
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


	--select * from tmp_psite where AltAwardCode = '3P30CA043703-24S3'
	--select * from tmp_psiterel where AltAwardCode = '3P30CA043703-24S3'

	--select * from #sites where altid= '3P30CA043703-24S3'

BEGIN TRANSACTION

DELETE ProjectCancerType 
FROM ProjectCancerType pc
	JOIN ProjectFUnding pf ON pc.ProjectFundingID = pf.ProjectFundingID
	JOIN #sites t ON t.AltID = pf.AltAwardCode

INSERT INTO ProjectCancerType (ProjectFundingID, CancerTypeID, Relevance, RelSource, EnterBy)
SELECT f.ProjectFundingID, ct.CancerTypeID, r.Rel, 'S', 'S'
FROM tmp_psite c 
	JOIN tmp_psiterel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN CancerType ct ON c.code = ct.ICRPCode
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode

--COMMIT
ROLLBACK




--drop table #cso
--GO
drop table #clist
go
-----------------------------------------
-- Insert New Host Institutions
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #cso (	
	[AltID] [varchar](50) NOT NULL,
	[csocodes] [varchar](500) NOT NULL,
	[csorels] [varchar](500) NULL
)

GO

BULK INSERT #cso
FROM 'C:\icrp\database\Cleanup\NCI_Data_Submission_Dup_CSO.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #cso

IF object_id('tmp_pcso') is NOT null
		drop table tmp_pcso
IF object_id('tmp_pcsoRel') is NOT null
	drop table tmp_pcsoRel	
	
-----------------------------------
-- Import ProjectCSO
-----------------------------------
SELECT AltID AS AltAwardCode, [csocodes], [csorels]  INTO #clist FROM #cso 

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
SELECT AltAwardCode, CSOCodes , [csorels] FROM #clist;
 
OPEN @csocursor;
FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csoList, @csoRelList;

WHILE @@FETCH_STATUS = 0
BEGIN	
	
	INSERT INTO tmp_pcso SELECT @AltAwardCode, value FROM  dbo.ToStrTable(@csoList)
	INSERT INTO tmp_pcsorel SELECT @AltAwardCode, 
	 CASE LTRIM(RTRIM(value))
		 WHEN '' THEN 0.00 ELSE CAST(value AS decimal(18,2)) END  
	 FROM  dbo.ToStrTable(@csoRelList) 	

	DBCC CHECKIDENT ('tmp_pcso', RESEED, 0) WITH NO_INFOMSGS
	DBCC CHECKIDENT ('tmp_pcsorel', RESEED, 0) WITH NO_INFOMSGS

	FETCH NEXT FROM @csocursor INTO @AltAwardCode, @csolist, @csoRelList;
END
 
CLOSE @csocursor;
DEALLOCATE @csocursor;

UPDATE tmp_pcso SET CSO = LTRIM(RTRIM(CSO))	

select * from tmp_pcso
select * from tmp_pcsorel

-----------------------------------
-- Import ProjectCSO
-----------------------------------
BEGIN TRANSACTION

DELETE ProjectCSO 
FROM ProjectCSO pc
JOIN ProjectFUnding pf ON pc.ProjectFundingID = pf.ProjectFundingID
JOIN #cso t ON t.AltID = pf.AltAwardCode

INSERT INTO ProjectCSO SELECT f.ProjectFundingID, c.CSO, r.Rel, 'S', getdate(), getdate()
FROM tmp_pcso c 
	JOIN tmp_pcsorel r ON c.AltAwardCode = r.AltAwardCode AND c.Seq = r.Seq
	JOIN ProjectFunding f ON c.AltAwardCode = f.AltAwardCode

--COMMIT
ROLLBACK
--drop table #FundingOrg
--go
-----------------------------------------
-- Insert New Funding Orgs
----------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

DECLARE @Country varchar (3) = 'US'
DECLARE @Currency varchar (3) = 'USD'
DECLARE @SponsorCode varchar (25) = 'CAC2'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #FundingOrg (	
	[Name] [varchar](100) NOT NULL,
	[OldAbbr] [varchar](15) NOT NULL,
	[NewAbbr] [varchar](15) NOT NULL,
	[OrgType] [varchar](25) NULL,
	[website] [varchar](100) NULL,
	[IsAnnualized] [bit] NULL,
	[Type] [varchar](15) NULL,
	[Note] [varchar](1000) NULL
)

GO

BULK INSERT #FundingOrg
FROM 'C:\icrp\database\DataUpload\ICRPDataSubmission_CAC2_FundingOrg.csv'  
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

Select * from #FundingOrg

DECLARE @Country varchar (3) = 'US'
DECLARE @Currency varchar (3) = 'USD'
DECLARE @SponsorCode varchar (25) = 'CAC2'

--select * from fundingorg where sponsorcode=@SponsorCode

-- Checking
IF EXISTS (SELECT * FROM #FundingOrg n JOIN FundingOrg o ON n.NewAbbr = o.Abbreviation WHERE n.Type='New')
BEGIN
	PRINT 'Checking Duplicate Funding Orgs   ==> ERROR'
	SELECT * FROM #FundingOrg n JOIN FundingOrg o ON n.NewAbbr = o.Abbreviation WHERE n.Type='New'
END
ELSE
	PRINT 'Checking Duplicate Funding Orgs   ==> Pass'

IF EXISTS (SELECT * FROM #FundingOrg n LEFT JOIN FundingOrg o ON n.OldAbbr = o.Abbreviation WHERE n.Type IN ('Change', 'Merge') AND o.FundingOrgID IS NULL)
BEGIN
	PRINT 'Checking Not Existing Funding Orgs   ==> ERROR'
	SELECT * FROM #FundingOrg n LEFT JOIN FundingOrg o ON n.OldAbbr = o.Abbreviation WHERE n.Type IN ('Change', 'Merge') AND o.FundingOrgID IS NULL
END
ELSE
	PRINT 'Checking Not Existing  Funding Orgs   ==> Pass'	

BEGIN TRANSACTION

	-- 
	INSERT INTO FundingOrg ([Name], [Abbreviation], [Type],	[Country], [Currency], [SponsorCode], [MemberType], [MemberStatus], [website],
		[IsAnnualized], Note) 
	--SELECT 	[Name], [NewAbbr], [OrgType],'UK', 'GBP', 'NCRI', 'Associate', 'Current', website, [IsAnnualized], Note
	SELECT 	[Name], [NewAbbr], [OrgType], @Country, @Currency, @SponsorCode, 'Associate', 'Current', website, [IsAnnualized], Note
		 FROM #FundingOrg WHERE Type='New'

	--Update
	UPDATE FundingOrg SET [Name] = u.[Name], [Abbreviation] = u.NewAbbr, [IsAnnualized]=u.[IsAnnualized], [Website]=u.website, Note=u.Note, [UpdatedDate]=getdate()
	FROM FundingOrg o JOIN #FundingOrg u ON u.OldAbbr = o.Abbreviation WHERE u.Type='Change'

	----Merge
	UPDATE FundingOrg SET [MemberStatus] = 'Merged', Note= u.Note, [UpdatedDate]=getdate()
	FROM FundingOrg o JOIN #FundingOrg u ON u.OldAbbr = o.Abbreviation WHERE u.Type='Merge'

--commit

rollback

--select * from FundingOrg where memberstatus='merged'
--select * from FundingOrg where LastImportDate is null

--select IsAnnualized,* from FundingOrg where sponsorcode='ncri' order by name
--select * from FundingOrg where Abbreviation in ('Breakthrough','Breast Can Cam', 'LRF')
--update FundingOrg set IsAnnualized= 0 where Abbreviation in ('WCR', 'BLDWISE', 'PCRF', 'HCRW' )

--select * from FundingOrg where Abbreviation in ('WCR', 'BLDWISE', 'PCRF', 'HCRW' )
--delete FundingOrg where Abbreviation in ('BLDWISE', 'PCRF', 'BCN' )
--update FundingOrg set Abbreviation= 'AICR' where FundingOrgID= 8
--update FundingOrg set Abbreviation= 'WAL' where FundingOrgID= 7

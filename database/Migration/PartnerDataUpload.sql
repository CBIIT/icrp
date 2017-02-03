
----------------------------
-- Load Workbook 
-----------------------------
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
	Institution VARCHAR(250),
	City VARCHAR(50),
	State VARCHAR(3),
	Country VARCHAR(3),
	PostalZipCode VARCHAR(15),
	Latitute decimal(9,6),
	Longitute decimal(9,6),
	GRID VARCHAR(50),
	TechAbstract NVARCHAR(max),
	LayAbstract NVARCHAR(max),
	RelatedAwardCode VARCHAR(50),
	RelationshipType VARCHAR(25),
	ORCID VARCHAR(19),
	OtherResearcherID VARCHAR(25),
	OtherResearcherIDType VARCHAR(250)
)
GO

BULK INSERT UploadWorkBook
FROM 'C:\icrp\database\Migration\ICRP_DataSubmissionWorkbook_UK.csv'
WITH
(
	FIRSTROW = 2,
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO

UPDATE CancerType Set [Description] = t.[Description], [ICD10CodeInfo]=t.[ICD10CodeInfo]
FROM CancerType c
JOIN #CancerType t ON c.ICRPCode = CAST(t.[ICRPCode] AS INT)



----------------------------
-- Load Workbook 
-----------------------------
CREATE TABLE #workbook (		
	AwardCode VARCHAR(50),
	AwardStartDate Date,
	AwardEndDate date,
	SourceId VARCHAR(50),
	AltId VARCHAR(50),
	AwardTitle VARCHAR(50),
	Category VARCHAR(50),
	AwardType VARCHAR(50),
	Childhood VARCHAR(5),
	BudgetStartDate date,
	BudgetEndDate date,
	CSOCodes VARCHAR(500),
	CSORel VARCHAR(500),
	SiteCodes VARCHAR(500),
	SiteRel VARCHAR(500),
	AwardFunding
	IsAnnualized
	FundingMechanismCode
	FundingMechanism
	FundingOrg
	FundingDiv
	FundingDivAbbr
	FundingContact
	PILastName
	PIFirstName
	Institution
	City
	State
	Country
	PostalZipCode
	Latitute
	Longitute
	GRID
	TechAbstract
	LayAbstract
	RelatedAwardCode
	RelationshipType
	ORCID
	OtherResearcherID
	OtherResearcherIDType
)
GO

BULK INSERT #CancerType
FROM 'C:\icrp\database\Migration\CancerType.csv'
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


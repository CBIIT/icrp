-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjectCores
-- -----------------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS vwProjectCores;

CREATE VIEW vwProjectCores AS
SELECT
  p.`ProjectID`,
  p.`IsChildhood`,
  p.`AwardCode`,
  CONVERT(GROUP_CONCAT(CONVERT(pt.`ProjectType` using utf8)) using ucs2) AS ProjectType,
  GREATEST(p.`UpdatedDate`,MAX(pt.`UpdatedDate`)) AS LastUpdated
FROM `Project` p
  JOIN `Project_ProjectType` pt ON pt.`ProjectID` = p.`ProjectID`
GROUP BY p.`ProjectID`;

-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjectFundings
-- -----------------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS vwProjectFundings;

CREATE VIEW vwProjectFundings AS
SELECT DISTINCT
  p.`ProjectID`,
  p.`AwardCode`,
  p.`IsChildhood`,
  pf.`ProjectFundingID`,
  pf.`Title`,
  pf.`FundingContact`,
  fi.`LastName` AS `piLastName`,
  fi.`FirstName` AS `piFirstName`,
  fi.`ORC_ID` AS `piORCiD`,
  i.`Name` AS `Institution`,
  pf.`BudgetStartDate`,
  pf.`BudgetEndDate`,
  pf.`Amount`,
  i.`City`,
  i.`State`,
  i.`Country`,
  pf.`FundingOrgID`,
  o.`Name` AS `FundingOrg`,
  o.`Abbreviation` AS `FundingOrgShort`,
  o.`Type` AS `FundingOrgType`
FROM `Project` p
  JOIN `ProjectFunding` pf ON p.`ProjectID` = pf.`ProjectID`
  JOIN `ProjectFundingInvestigator` fi ON fi.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `Institution` i ON i.`InstitutionID` = fi.`InstitutionID`
  JOIN `FundingOrg` o ON o.`FundingOrgID` = pf.`FundingOrgID`;

-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjectExtensions
-- -----------------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS vwProjectExtensions;

CREATE VIEW vwProjectExtensions AS
SELECT
	`ProjectID`, pf.`ProjectFundingID`, `Title`, `FundingContact`, `BudgetStartDate`, `BudgetEndDate`, `Amount`, pf.`FundingOrgID`,
	`LastName` AS `piLastName`, `FirstName` AS `piFirstName`, `ORC_ID` AS `piORCiD`,
	i.`Name` AS `Institution`, `City`, `State`, i.`Country`,
	o.`Name` AS `FundingOrg`, o.`Abbreviation` AS `FundingOrgShort`, o.`Type` AS `FundingOrgType`,
	c.`CancerTypeID`, c.`Name` AS `CancerType`,
	GROUP_CONCAT(DISTINCT ext.CalendarYear) AS CalendarYears,
	GROUP_CONCAT(DISTINCT cso.CSOCode) AS CSOCodes
FROM `ProjectFunding` pf
  JOIN `ProjectFundingInvestigator` fi ON fi.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `Institution` i ON i.`InstitutionID` = fi.`InstitutionID`
  JOIN `FundingOrg` o ON o.`FundingOrgID` = pf.`FundingOrgID`
  JOIN `ProjectCancerType` ct ON ct.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `CancerType` c ON c.`CancerTypeID` = ct.`CancerTypeID`
  JOIN `ProjectFundingExt` ext ON ext.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `ProjectCSO` cso ON cso.`ProjectFundingID` = pf.`ProjectFundingID`
GROUP BY pf.`ProjectFundingID`, c.`CancerTypeID`
ORDER BY `ProjectID`, pf.`ProjectFundingID`, c.`CancerTypeID`;

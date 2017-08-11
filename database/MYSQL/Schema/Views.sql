-- -----------------------------------------------------------------------------------------------------------------------------------
<<<<<<< Updated upstream
--  VIEW - vwProjects
-- -----------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS vwProjects;

CREATE VIEW vwProjects AS
SELECT DISTINCT
  p.`ProjectID`,
  pf.`ProjectFundingID`,
  p.`AwardCode`,
  p.`IsChildhood`,
  fi.`LastName`  AS piLastName,
  fi.`FirstName` AS piFirstName,
  fi.`ORC_ID` AS piORCiD,
  i.`Name` AS institution,
  i.`City`,
  i.`State`,
  i.`Country`,
  fo.`FundingOrgID` AS FundingOrgID,
  fo.`Abbreviation` AS FundingOrg,
  fo.`Type` AS FundingOrgType,
  pt.`ProjectType`,
  ct.`CancerTypeID`,
  c.`Name` AS CancerType,
  cso.`CSOCode`,
  ext.`CalendarYear`,
  s.`Content` AS ProjectContent
FROM `Project` p
  JOIN `ProjectFunding` pf ON p.`ProjectID` = pf.`ProjectID`
  JOIN `ProjectFundingExt` ext ON pf.`ProjectFundingID` = ext.`ProjectFundingID`
  JOIN `ProjectFundingInvestigator` fi ON fi.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `Institution` i ON i.`InstitutionID` = fi.`InstitutionID`
  JOIN `FundingOrg` fo ON fo.`FundingOrgID` = pf.`FundingOrgID`
  JOIN `Project_ProjectType` pt ON p.`ProjectID` = pt.`ProjectID`
  JOIN `ProjectCancerType` ct ON pf.`ProjectFundingID` = ct.`ProjectFundingID`
  JOIN `CancerType` c ON c.`CancerTypeID` = ct.`CancerTypeID`
  JOIN `ProjectCSO` cso ON pf.`ProjectFundingID` = cso.`ProjectFundingID`
  JOIN `ProjectSearch` s ON s.`ProjectID` = p.`ProjectID`;
=======
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
>>>>>>> Stashed changes

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
  o.`Type` AS `FundingOrgType`,
  GREATEST(p.`UpdatedDate`, pf.`UpdatedDate`, fi.`UpdatedDate`, i.`UpdatedDate`, o.`UpdatedDate`) AS LatestUpdate
FROM `Project` p
  JOIN `ProjectFunding` pf ON p.`ProjectID` = pf.`ProjectID`
  JOIN `ProjectFundingInvestigator` fi ON fi.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `Institution` i ON i.`InstitutionID` = fi.`InstitutionID`
<<<<<<< Updated upstream
  JOIN `FundingOrg` o ON pf.`FundingOrgID` = o.`FundingOrgID`;
=======
  JOIN `FundingOrg` o ON o.`FundingOrgID` = pf.`FundingOrgID`;

-- -----------------------------------------------------------------------------------------------------------------------------------
--  VIEW - vwProjectExtensions
-- -----------------------------------------------------------------------------------------------------------------------------------
DROP VIEW IF EXISTS vwProjectExtensions;

CREATE VIEW vwProjectExtensions AS
SELECT DISTINCT
  pf.`ProjectID`,
  pf.`ProjectFundingID`,
  pf.`piLastName`,
  pf.`piFirstName`,
  pf.`piORCiD`,
  pf.`Institution`,
  pf.`City`,
  pf.`State`,
  pf.`Country`,
  pf.`FundingOrgID`,
  pf.`FundingOrgShort` AS FundingOrg,
  pf.`FundingOrgType`,
  ct.`CancerTypeID`,
  CONVERT(GROUP_CONCAT(CONVERT(c.`Name` USING utf8)) USING ucs2) AS CancerType,
  cso.`CSOCode`,
  ext.`CalendarYear`,
  GREATEST(pf.`LatestUpdate`, ext.`UpdatedDate`, ct.`UpdatedDate`, c.`UpdatedDate`, cso.`UpdatedDate`) AS LatestUpdate
FROM `vwProjectFundings` pf
  JOIN `ProjectFundingExt` ext ON ext.`ProjectFundingID` = pf.`ProjectFundingID`
  JOIN `ProjectCancerType` ct ON ct.`ProjectFundingID` = ext.`ProjectFundingID`
  JOIN `CancerType` c ON c.`CancerTypeID` = ct.`CancerTypeID`
  JOIN `ProjectCSO` cso ON cso.`ProjectFundingID` = ext.`ProjectFundingID`
GROUP BY pf.`ProjectID`, cso.`CSOCode`, ext.`CalendarYear`
ORDER BY GREATEST(pf.`LatestUpdate`, ext.`UpdatedDate`, ct.`UpdatedDate`, c.`UpdatedDate`, cso.`UpdatedDate`);
>>>>>>> Stashed changes

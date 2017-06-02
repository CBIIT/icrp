DELIMITER //


CREATE PROCEDURE `DeleteOldSearchResults`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DROP TEMPORARY TABLE IF EXISTS old_emails;
	
	CREATE TEMPORARY TABLE IF NOT EXISTS old_emails AS (
		SELECT c.SearchCriteriaID
		FROM SearchResult r
			INNER JOIN SearchCriteria c ON r.SearchCriteriaID = c.SearchCriteriaID
		WHERE IFNULL(r.IsEmailSent, 0) = 0
			AND DATEDIFF(CURDATE(),c.SearchDate) > 30
	);
	
	DELETE FROM SearchResult
	WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM old_emails);
	
	DELETE FROM SearchCriteria
	WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM old_emails);
	
	DROP TEMPORARY TABLE IF EXISTS old_emails;
END//


CREATE PROCEDURE `UpdateSearchResultMarkEmailSent`(
	IN `@SearchID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
UPDATE `SearchResult` SET
  `IsEmailSent` = 1
WHERE `SearchCriteriaID` = `@SearchID`//


CREATE PROCEDURE `GetPartners`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
  `Name`,
  `SponsorCode`,
  `Description`,
  `Country`,
  `Website`,
  CAST(`JoinedDate` AS DATE) AS JoinDate
FROM `Partner`
ORDER BY `Country`, `Name`//


CREATE DEFINER=`t3chn0shaman`@`%` PROCEDURE `GetFundingOrgs`(
	IN `@type` VARCHAR(15)
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
   IF `@type` IS NULL THEN
		SET `@type` = 'funding';
	END IF;
	SELECT
		FundingOrgID,
		Name,
		Abbreviation,
		CONCAT(SponsorCode,' - ',Name) AS DisplayName,
		Type,
		MemberType,
		MemberStatus,
		Country,
		Currency, 
		SponsorCode,
		IsAnnualized,
		Note,
    LastImportDate,
    LastImportDesc
	FROM FundingOrg
	WHERE (`@type` = 'funding') OR (`@type` = 'Search' AND LastImportDate IS NOT NULL)
	ORDER BY SponsorCode, Name;
END//


CREATE DEFINER=`t3chn0shaman`@`%` PROCEDURE `GetPartnerOrgs`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT PartnerOrgID AS ID, CONCAT(SponsorCode,' - ',Name) AS Name , IsActive FROM PartnerOrg ORDER BY SponsorCode, Name//


CREATE PROCEDURE `GetLibraries`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT 
	l.`FileName`,
	`ThumbnailFilename`,
	l.`Title`,
	l.`Description`,
	f.`Name` AS Folder,
	l.`isPublic`,
	CASE IFNULL(l.ArchivedDate,'') WHEN '' THEN 0 ELSE 1 END AS IsFileArchived
FROM `Library` l
	JOIN `LibraryFolder` f ON l.LibraryFolderID = f.LibraryFolderID
	JOIN `LibraryFolder` p ON f.ParentFolderID= p.LibraryFolderID//


CREATE PROCEDURE `GetLibraryFolders`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	f.`Name` AS Folder,
	p.`Name` AS ParentFolder,
	f.`isPublic`
FROM `LibraryFolder` f 
JOIN `LibraryFolder` p ON f.`ParentFolderID` = p.`LibraryFolderID`//


CREATE PROCEDURE `GetLatestNewsletter`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	l.`Filename`,
	l.`ThumbnailFilename`,
	`Title`,
	`Description`
FROM `Library` l
	JOIN `LibraryFolder` f ON l.`LibraryFolderID` = f.`LibraryFolderID`
WHERE f.`Name` = 'Newsletters'
ORDER BY l.`CreatedDate` DESC
LIMIT 1//


CREATE PROCEDURE `GetProjectDetail`(
	IN `@ProjectID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
-- Get the project's most recent funding - max ProjectID
SELECT
	f.`Title`,
	mf.`ProjectFundingID` AS LastProjectFundingID,
	p.`AwardCode`,
	p.`ProjectStartDate`,
	p.`ProjectEndDate`,
	p.`IsChildhood`,
	a.`TechAbstract` AS TechAbstract,
	a.`PublicAbstract` AS PublicAbstract,
	CONCAT(f.`MechanismCode`,' - ',f.`MechanismTitle`) AS FundingMechanism
FROM `Project` p
	JOIN (
		SELECT
			`ProjectID`,
			MAX(`ProjectFundingID`) AS ProjectFundingID
		FROM `ProjectFunding`
		GROUP BY `ProjectID`
	) mf ON p.`ProjectID` = mf.`ProjectID`
	JOIN `ProjectFunding` f ON f.`ProjectFundingID` = mf.`ProjectFundingID`
	LEFT JOIN `ProjectAbstract` a ON f.`ProjectAbstractID` = a.`ProjectAbstractID`
WHERE p.`ProjectID` = `@ProjectID`//


CREATE PROCEDURE `GetProjectCSO`(
	IN `@ProjectFundingID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	pc.`CSOCode`,
	c.`CategoryName`,
	c.`Name` AS CSOName,
	c.`ShortName`
FROM `ProjectFunding` f
	JOIN `ProjectCSO` pc ON f.`ProjectFundingID` = pc.`ProjectFundingID`
	JOIN `CSO` c ON pc.`CSOCode` = c.`Code`
WHERE f.`ProjectFundingID` = `@ProjectFundingID`
ORDER BY c.`Name`//


CREATE PROCEDURE `GetProjectCancerType`(
	IN `@ProjectFundingID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	t.`Name` AS CancerType,
	t.`Description`,
	t.`ICRPCode`,
	t.`ICD10CodeInfo`
FROM `ProjectFunding` f
	JOIN `ProjectCancerType` ct ON f.`ProjectFundingID` = ct.`ProjectFundingID`
	JOIN `CancerType` t ON ct.`CancerTypeID` = t.`CancerTypeID`
WHERE f.`ProjectFundingID` = `@ProjectFundingID` AND IFNULL(ct.`RelSource`,'') = 'S'  -- only return 'S' relSource
ORDER BY t.`Name`//


CREATE PROCEDURE `GetProjectFunding`(
	IN `@ProjectID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	pf.`ProjectFundingID`,
	pf.`title`,
	fi.`LastName` AS piLastName,
	fi.`FirstName` AS piFirstName,
	fi.`ORC_ID`,
	i.`Name` AS Institution,
	i.`City`,
	i.`State`,
	i.`Country`,
	pf.`Category`,
	pf.`ALtAwardCode` AS AltAwardCode,
	o.`Abbreviation` AS FundingOrganization,
	pf.`BudgetStartDate`,
	pf.`BudgetEndDate`
FROM `Project` p
	JOIN `ProjectFunding` pf ON p.`ProjectID` = pf.`ProjectID`
	JOIN `ProjectFundingInvestigator` fi ON pf.`ProjectFundingID` = fi.`ProjectFundingID`
	JOIN `Institution` i ON i.`InstitutionID` = fi.`InstitutionID`
	JOIN `FundingOrg` o ON o.`FundingOrgID` = pf.`FundingOrgID`
WHERE p.`ProjectID` = 30000
ORDER BY pf.`BudgetStartDate` DESC, p.`ProjectID` DESC//


CREATE PROCEDURE `GetProjectFundingDetail`(
	IN `@ProjectFundingID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	f.`Title`,
	f.`AltAwardCode`,
	f.`Source_ID`,
	f.`BudgetStartDate`,
	f.`BudgetEndDate`,
	o.`Name` AS FundingOrg,
	f.`Amount`,
	o.`currency`,
	f.`MechanismCode`,
	f.`MechanismTitle`,
	CONCAT(IFNULL(f.`MechanismCode`,''),' - ',IFNULL(f.`MechanismTitle`,'')) AS FundingMechanism,
	f.`FundingContact`,
	CONCAT(pi.`LastName`,', ',pi.`FirstName`) AS piName,
	pi.`ORC_ID`,
	i.`Name` AS Institution,
	i.`City`,
	i.`State`,
	i.`Country`,
	a.`TechAbstract` AS TechAbstract,
	a.`PublicAbstract` AS PublicAbstract
FROM `ProjectFunding` f	
	JOIN `FundingOrg` o ON o.`FundingOrgID` = f.`FundingOrgID`
	JOIN `ProjectFundingInvestigator` pi ON pi.`ProjectFundingID` = f.`ProjectFundingID`
	JOIN `Institution` i ON i.`InstitutionID` = pi.`InstitutionID`
	JOIN `ProjectAbstract` a ON f.`ProjectAbstractID` = a.`ProjectAbstractID`
WHERE f.`ProjectFundingID` = `@ProjectFundingID`//


CREATE PROCEDURE `GetCancerTypeLookUp`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	`CancerTypeID`,
	`Name`,
	`ICRPCode`,
	`ICD10CodeInfo`
FROM `CancerType`
ORDER BY `Name`//


CREATE PROCEDURE `GetCountryCodeLookup`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	`Abbreviation` AS Code,
	`Name` AS Country
FROM `Country`
ORDER BY `Code`//


CREATE PROCEDURE `GetCSOLookup`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	`CategoryName`,
	`Code`,
	`Name`,
	CONCAT(`Code`,'  ',`Name`) AS DisplayName
FROM `CSO`
WHERE `IsActive` = 1
ORDER BY `Code`//


CREATE PROCEDURE `GetCurrencyRateLookup`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	`Year`,
	`FromCurrency`,
	`FromCurrencyRate`,
	`ToCurrency`,
	`ToCurrencyRate`
FROM `CurrencyRate`
ORDER BY `Year` DESC, `FromCurrency`, `ToCurrency`//


CREATE PROCEDURE `GetInstitutionLookup`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT
	`Name`,
	`City`,
	`State`,
	`Country`,
	`Postal`,
	`Longitude`,
	`Latitude`,
	`GRID`
FROM `Institution`
WHERE `Name` <> 'Missing'
ORDER BY `Name`//


CREATE PROCEDURE `GetProjectTypeStatsBySearchID`(
	IN `@SearchID` INT,
	IN `@Year` INT,
	IN `@Type` VARCHAR(25),
	OUT `@ResultCount` INT,
	OUT `@ResultAmount` FLOAT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE `@ResultList` LONGTEXT DEFAULT '';
	SELECT @ResultList := `Results` FROM `SearchResult` WHERE `SearchCriteriaID` = `@SearchID`;
	CALL ToIntTable(@ResultList);
	
	DROP TEMPORARY TABLE IF EXISTS `stats`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `stats` (
		`ProjectType` VARCHAR(15),
		`Count` INT,
		`USDAmount` DOUBLE
	);
	
	
	-- -------------------------------		
	--   Find all related projects 
	-- -------------------------------
	INSERT INTO stats
	SELECT
		`ProjectType`,
		COUNT(*) AS Count,
		SUM(`USDAmount`) AS USDAmount
	FROM (
		SELECT
			pt.`ProjectType`,
			(f.`Amount` * IFNULL(cr.`ToCurrencyRate`,1)) AS USDAmount
		FROM `ToIntTable` r
			JOIN `ProjectFunding` f ON f.`ProjectID` = r.`VALUE`
			JOIN `Project_ProjectType` pt ON pt.`ProjectID` = r.`VALUE`
			JOIN `FundingOrg` o ON f.`FundingOrgID` = o.`FundingOrgID`
			LEFT JOIN (
				SELECT *
				FROM `CurrencyRate`
				WHERE `ToCurrency` = 'USD' AND `Year`=`@Year`
			) cr ON cr.FromCurrency = o.Currency
	) r
	GROUP BY ProjectType;

	SELECT @ResultCount := SUM(`Count`) FROM `stats`;
	SELECT @ResultAmount := SUM(`USDAmount`) FROM `stats`;
	
	IF `@Type` = 'Amount' THEN
		SELECT * FROM `stats` ORDER BY `USDAmount` Desc;
	ELSE
		SELECT * FROM `stats` ORDER BY `Count` Desc;
	END IF;

	DROP TEMPORARY TABLE IF EXISTS `stats`;
END

DELIMITER //
DELIMITER ;

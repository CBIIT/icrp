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


CREATE PROCEDURE `GetFundingOrgs`(
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


CREATE PROCEDURE `GetPartnerOrgs`()
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

	SELECT SUM(`Count`) INTO `@ResultCount` FROM `stats`;
	SELECT SUM(`USDAmount`) INTO `@ResultAmount` FROM `stats`;

	IF `@Type` = 'Amount' THEN
		SELECT * FROM `stats` ORDER BY `USDAmount` Desc;
	ELSE
		SELECT * FROM `stats` ORDER BY `Count` Desc;
	END IF;

	DROP TEMPORARY TABLE IF EXISTS `stats`;
END//


CREATE PROCEDURE `GetProjectCancerTypeStatsBySearchID`(
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
	-- ---------------------------------------------------
	-- Get saved search results by searchID
	-- ---------------------------------------------------
	DECLARE `@ProjectIDs` LONGTEXT DEFAULT CONVERT('' USING ucs2);
	SELECT @ProjectIDs := `Results` FROM `SearchResult` WHERE `SearchCriteriaID` = `@SearchID`;
	CALL ToIntTable(@ProjectIDs);

	DROP TEMPORARY TABLE IF EXISTS `stats`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `stats` (
		`CancerType` VARCHAR(100),
		`Relevance` DECIMAL(16,2),
		`USDAmount` DOUBLE,
		`ProjectCount` INT
	);

	-- -------------------------------
	--   Find all related projects
	-- -------------------------------
	INSERT INTO stats
	SELECT
		`CancerType`,
		IFNULL(CAST(SUM(`Relevance`)/100 AS DECIMAL(16,2)),0) AS Relevance,
		SUM(`USDAmount`) AS USDAmount,
		Count(*) AS ProjectCount
	FROM (
		SELECT
			c.`Name` AS CancerType,
			`Relevance`,
			(f.`Amount` * IFNULL(cr.`ToCurrencyRate`,1)) AS USDAmount
		FROM `ToIntTable` r
			JOIN `ProjectFunding` f ON r.`Value` = f.`ProjectID`
			JOIN `ProjectCancerType` pc ON f.`projectFundingID` = pc.`projectFundingID`
			JOIN `CancerType` c ON c.`CancerTypeID` = pc.`CancerTypeID`
			JOIN `FundingOrg` o ON f.`FundingOrgID` = o.`FundingOrgID`
			LEFT JOIN (
				SELECT *
				FROM `CurrencyRate`
				WHERE `ToCurrency` = 'USD' AND `Year`=`@Year`
			) cr ON cr.`FromCurrency` = o.`Currency`
	) r
	GROUP BY `CancerType`;

	SELECT SUM(`Relevance`) INTO `@ResultCount` FROM `stats`;
	SELECT SUM(`USDAmount`) INTO `@ResultAmount` FROM `stats`;

	IF `@Type` = 'Amount' THEN
		SELECT * FROM `stats` ORDER BY `USDAmount` Desc;
	ELSE
		SELECT * FROM `stats` ORDER BY `Relevance` Desc;
	END IF;

	DROP TEMPORARY TABLE IF EXISTS `stats`;
END//


CREATE PROCEDURE `GetProjectCountryStatsBySearchID`(
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
	-- ---------------------------------------------------
	-- Get saved search results by searchID
	-- ---------------------------------------------------
	DECLARE `@ProjectIDs` LONGTEXT DEFAULT CONVERT('' USING ucs2);
	SELECT @ProjectIDs := `Results` FROM `SearchResult` WHERE `SearchCriteriaID` = `@SearchID`;
	CALL ToIntTable(@ProjectIDs);

	DROP TEMPORARY TABLE IF EXISTS `stats`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `stats` (
		`CancerType` VARCHAR(3),
		`Count` INT,
		`USDAmount` DOUBLE
	);

	-- -------------------------------
	--   Find all related projects
	-- -------------------------------
	INSERT INTO stats
	SELECT
		`country`,
		COUNT(*) AS Count,
		SUM(`USDAmount`) AS USDAmount
	FROM (
		SELECT
			i.`country`,
			(f.`Amount` * IFNULL(cr.`ToCurrencyRate`, 1)) AS USDAmount
		FROM `ToIntTable` r
			JOIN `ProjectFunding` f ON r.`Value` = f.`ProjectID`
			JOIN `ProjectFundingInvestigator` pi ON f.`projectFundingID` = pi.`projectFundingID`
			JOIN `Institution` i ON i.`InstitutionID` = pi.`InstitutionID`
			JOIN `FundingOrg` o ON f.`FundingOrgID` = o.`FundingOrgID`
			LEFT JOIN (
				SELECT *
				FROM `CurrencyRate`
				WHERE `ToCurrency` = 'USD' AND `Year`=`@Year`
			) cr ON cr.`FromCurrency` = o.`Currency`
	) r
	GROUP BY `country`;

	SELECT SUM(`Count`) INTO `@ResultCount` FROM stats;
	SELECT SUM(`USDAmount`) INTO `@ResultAmount` FROM stats;

	IF `@Type` = 'Amount' THEN
		SELECT * FROM `stats` ORDER BY `USDAmount` Desc;
	ELSE
		SELECT * FROM `stats` ORDER BY `Count` Desc;
	END IF;
END//


CREATE PROCEDURE `GetProjectCSOStatsBySearchID`(
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
	-- ---------------------------------------------------
	-- Get saved search results by searchID
	-- ---------------------------------------------------
	DECLARE `@ProjectIDs` LONGTEXT DEFAULT CONVERT('' USING ucs2);
	SELECT @ProjectIDs := `Results` FROM `SearchResult` WHERE `SearchCriteriaID` = `@SearchID`;
	CALL ToIntTable(@ProjectIDs);

	DROP TEMPORARY TABLE IF EXISTS `stats`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `stats` (
		`CancerType` VARCHAR(100),
		`Relevance` DECIMAL(16,2),
		`USDAmount` DOUBLE,
		`ProjectCount` INT
	);

	-- -------------------------------
	--   Find all related projects
	-- -------------------------------
	INSERT INTO stats
	SELECT
		`categoryName`,
		CAST(SUM(`Relevance`)/100 AS DECIMAL(16,2)) AS Relevance,
		SUM(`USDAmount`) AS USDAmount,
		count(*) AS ProjectCount
	FROM (
		SELECT
			c.`categoryName`,
			`Relevance`,
			(f.`Amount` * IFNULL(cr.`ToCurrencyRate`, 1)) AS USDAmount
		FROM `ToIntTable` r
			JOIN `ProjectFunding` f ON r.`Value` = f.`ProjectID`
			JOIN (SELECT * FROM `ProjectCSO` WHERE ifnull(`Relevance`,0) <> 0) pc ON f.`projectFundingID` = pc.`projectFundingID`
			JOIN `CSO` c ON c.`code` = pc.`csocode`
			JOIN `FundingOrg` o ON f.`FundingOrgID` = o.`FundingOrgID`
			LEFT JOIN (
				SELECT *
				FROM `CurrencyRate`
				WHERE `ToCurrency` = 'USD' AND `Year`=`@Year`
			) cr ON cr.`FromCurrency` = o.`Currency`
	) r
	GROUP BY `categoryName`;

	SELECT SUM(`Relevance`) INTO `@ResultCount` FROM stats;
	SELECT SUM(`USDAmount`) INTO `@ResultAmount` FROM stats;

	IF `@Type` = 'Amount' THEN
		SELECT * FROM `stats` ORDER BY `USDAmount` Desc;
	ELSE
		SELECT * FROM `stats` ORDER BY `Relevance` DESC;
	END IF;
END//


CREATE PROCEDURE `GetProjectAwardStatsBySearchID`(
	IN `@SearchID` INT,
	IN `@Year` INT,
	OUT `@ResultCount` INT,
	OUT `@ResultAmount` FLOAT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
  	-- ---------------------------------------------------
	-- Get saved search results by searchID
	-- ---------------------------------------------------
	DECLARE `@ProjectIDs` LONGTEXT DEFAULT CONVERT('' USING ucs2);
	SELECT @ProjectIDs := `Results` FROM `SearchResult` WHERE `SearchCriteriaID` = `@SearchID`;
	CALL ToIntTable(@ProjectIDs);

	DROP TEMPORARY TABLE IF EXISTS `stats`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `stats` (
		`ProjectID` INT,
		`Year` VARCHAR(100),
		`CalendarAmount` DOUBLE,
		`USDAmount` DECIMAL(16,2),
		`ToCurrencyRate` DOUBLE
	);

	-- -----------------------------------------------------------------
	--   Find all related projects and convert to USD dollars
	-- -----------------------------------------------------------------
	INSERT INTO `stats`
	SELECT
		r.`Value` AS ProjectID,
		ext.`CalendarYear` AS Year,
		ext.`CalendarAmount`,
		(ext.`CalendarAmount`*IFNULL(cr.`ToCurrencyRate`,1)) AS USDAmount,
		IFNULL(cr.`ToCurrencyRate`,1) AS ToCurrencyRate
	FROM `ToIntTable` r
		JOIN `ProjectFunding` f ON r.`Value` = f.`ProjectID`
		JOIN `ProjectFundingExt` ext ON ext.`ProjectFundingID` = f.`ProjectFundingID`
		JOIN `FundingOrg` o ON f.`FundingOrgID` = o.`FundingOrgID`
		LEFT JOIN (
			SELECT *
			FROM `CurrencyRate`
			WHERE `ToCurrency` = 'USD' AND `Year`=`@Year`
		) cr ON cr.`FromCurrency` = o.`Currency`;

	SELECT COUNT(*) INTO `@ResultCount` FROM `stats`;
	SELECT SUM(USDAmount) INTO `@ResultAmount` FROM `stats`;

	SELECT `Year`, `@ResultCount` AS Count, `@ResultAmount` AS amount FROM `stats` GROUP BY `Year` ORDER BY `Year`;
END//


CREATE PROCEDURE `GetDataUploadInStaging`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT `DataUploadStatusID` AS DataUploadID, `Type`, `PartnerCode` AS SponsorCode, `FundingYear`, `ReceivedDate`, `Note`
FROM `DataUploadStatus`
WHERE `Status` = 'Staging'
ORDER BY `ReceivedDate` DESC//


CREATE PROCEDURE `GetDataUploadStatus`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT `PartnerCode` AS Partner,`FundingYear`,`Status`,`ReceivedDate`,`ValidationDate`,`UploadToDevDate`, `UploadToStageDate`,`UploadToProdDate`,`Type`,l.ProjectFundingCount AS Count, `Note`
FROM `DataUploadStatus` u
LEFT JOIN `DataUploadLog` l ON u.`DataUploadStatusID` = l.`DataUploadStatusID`
ORDER BY `ReceivedDate` DESC//


CREATE PROCEDURE `GetDataUploadSummary`(
  IN `@DataUploadID` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
SELECT *
FROM `DataUploadLog`
WHERE `DataUploadStatusID`=`@DataUploadID`//


CREATE PROCEDURE `GetProjectsByDataUploadID`(
  IN `@PageSize` INT,
  IN `@PageNumber` INT,
  IN `@SortCol` VARCHAR(7),
  IN `@SortDirection` VARCHAR(4),
  IN `@DataUploadID` INT,
  OUT `@SearchCriteriaID` INT,
  OUT `@ResultCount` INT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
  DECLARE `@LastBudgetYear` INT DEFAULT 0;
  DECLARE `@PageOffset` INT DEFAULT 0;
  DECLARE `@ProjectIDList` LONGTEXT DEFAULT CONVERT('' USING ucs2);
  DECLARE `@TotalRelatedProjectCount` INT DEFAULT 0;

  SET SESSION group_concat_max_len = 18446744073709551615;
  SET `@PageSize` = IFNULL(`@PageSize`,50);
  SET `@PageOffset` = (IFNULL(`@PageNumber`,1)-1)*`@PageSize`;

  DROP TEMPORARY TABLE IF EXISTS `import`;
  CREATE TEMPORARY TABLE IF NOT EXISTS `import` (
    `ProjectID` INT,
    `ProjectFundingID` INT,
    `BudgetEndDate` DATE
  );

  INSERT INTO `import`
  SELECT `ProjectID`, `ProjectFundingID`, `BudgetEndDate`
  FROM `ProjectFunding`
  WHERE `DataUploadStatusID` = `@DataUploadID`;

  SELECT COUNT(*), YEAR(MAX(BudgetEndDate))
  INTO `@TotalRelatedProjectCount`, `@LastBudgetYear`
  FROM `import`;

  -- ---------------------------------------------------
  -- Get all imported projects/projectfunding by DataUploadStatusID
  -- ---------------------------------------------------
  DROP TEMPORARY TABLE IF EXISTS `base`;
	CREATE TEMPORARY TABLE IF NOT EXISTS `base` (
		`ProjectID` INT,
		`ProjectFundingID` INT
  );
  
  INSERT INTO `base`
  SELECT ProjectID, MAX(ProjectFundingID) AS ProjectFundingID
  FROM `import`
  GROUP BY ProjectID;
  SELECT COUNT(*) INTO `@ResultCount` FROM `base`;

  -- -------------------------------
  -- Save search criteria
  -- -------------------------------
  SELECT GROUP_CONCAT(CAST(ProjectID AS CHAR(20) CHARACTER SET ucs2)) INTO `@ProjectIDList` FROM `base`;
  INSERT INTO SearchCriteria (SearchDate) VALUES (NOW());

  SELECT LAST_INSERT_ID() INTO `@SearchCriteriaID`;
  INSERT INTO SearchResult
    (SearchCriteriaID, Results, ResultCount, TotalRelatedProjectCount, LastBudgetYear, IsEmailSent)
  VALUES
    (`@SearchCriteriaID`, `@ProjectIDList`, `@ResultCount`, `@TotalRelatedProjectCount`, `@LastBudgetYear`, 0);

  SELECT
    r.`ProjectID`,
    p.`AwardCode`,
    r.`ProjectFundingID` AS LastProjectFundingID,
    f.`Title`,
    pi.`LastName` AS piLastName,
    pi.`FirstName` AS piFirstName,
    pi.`ORC_ID` AS piORCiD,
    i.`Name` AS institution,
    f.`Amount`,
    i.`City`,
    i.`State`,
    i.`country`,
    o.`FundingOrgID`,
    o.`Name` AS FundingOrg,
    o.`Abbreviation` AS FundingOrgShort
  FROM `base` r
    JOIN `Project` p ON r.`ProjectID` = p.`ProjectID`
    JOIN `ProjectFunding` f ON r.`ProjectFundingID` = f.`ProjectFundingID`
    JOIN `ProjectFundingInvestigator` pi ON f.`ProjectFundingID` = pi.`ProjectFundingID`
    JOIN `Institution` i ON i.`InstitutionID` = pi.`InstitutionID`
    JOIN `FundingOrg` o ON o.`FundingOrgID` = f.`FundingOrgID`
  ORDER BY
	 CASE WHEN `@SortDirection` = 'ASC' THEN 
	   CASE
	     WHEN `@SortCol` = 'code' THEN p.`AwardCode`
	     WHEN `@SortCol` = 'pi' THEN CONCAT(pi.`LastName`, ' ', pi.`FirstName`)
		  WHEN `@SortCol` = 'Inst' THEN i.`Name`
		  WHEN `@SortCol` = 'city' THEN i.`City`
		  WHEN `@SortCol` = 'state' THEN i.`State`
		  WHEN `@SortCol` = 'country' THEN i.`Country`
		  WHEN `@SortCol` = 'FO' THEN o.`Abbreviation`
		  ELSE f.`Title`
		END
	END ASC,
	CASE WHEN `@SortDirection` = 'DESC' THEN 
	   CASE
	     WHEN `@SortCol` = 'code' THEN p.`AwardCode`
	     WHEN `@SortCol` = 'pi' THEN CONCAT(pi.`LastName`, ' ', pi.`FirstName`)
		  WHEN `@SortCol` = 'Inst' THEN i.`Name`
		  WHEN `@SortCol` = 'city' THEN i.`City`
		  WHEN `@SortCol` = 'state' THEN i.`State`
		  WHEN `@SortCol` = 'country' THEN i.`Country`
		  WHEN `@SortCol` = 'FO' THEN o.`Abbreviation`
		  ELSE f.`Title`
		END
	END DESC
  LIMIT `@PageSize`
  OFFSET `@PageOffset`;
END//


DELIMITER //


DELIMITER ;

-- --------------------------------------------------------
-- Host:                         52.207.102.31
-- Server version:               5.6.35 - MySQL Community Server (GPL)
-- Server OS:                    Linux
-- HeidiSQL Version:             9.4.0.5125
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for icrp_data
CREATE DATABASE IF NOT EXISTS `icrp_data` /*!40100 DEFAULT CHARACTER SET ucs2 */;
USE `icrp_data`;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.CancerType
CREATE TABLE IF NOT EXISTS `CancerType` (
  `CancerTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `ICRPCode` int(11) NOT NULL,
  `ICD10CodeInfo` varchar(250) DEFAULT NULL,
  `IsCommon` tinyint(4) NOT NULL,
  `IsArchived` tinyint(4) NOT NULL,
  `SortOrder` int(11) NOT NULL DEFAULT '1',
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CancerTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.CancerTypeRollUp
CREATE TABLE IF NOT EXISTS `CancerTypeRollUp` (
  `CancerTypeRollUpID` int(11) NOT NULL,
  `CancerTypeID` int(11) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Country
CREATE TABLE IF NOT EXISTS `Country` (
  `CountryID` int(11) NOT NULL AUTO_INCREMENT,
  `Abbreviation` varchar(3) NOT NULL,
  `Name` varchar(75) NOT NULL,
  `IncomeBand` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`Abbreviation`),
  UNIQUE KEY `UNIQUE` (`CountryID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.CSO
CREATE TABLE IF NOT EXISTS `CSO` (
  `CSOID` int(11) NOT NULL AUTO_INCREMENT,
  `Code` varchar(20) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `ShortName` varchar(100) NOT NULL,
  `CategoryName` varchar(100) NOT NULL,
  `WeightName` decimal(1,0) NOT NULL,
  `SortOrder` int(11) NOT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT '1',
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Code`),
  UNIQUE KEY `UNIQUE` (`CSOID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.CSOCategory
CREATE TABLE IF NOT EXISTS `CSOCategory` (
  `CSOCategoryID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Code` int(11) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Name`),
  UNIQUE KEY `UNIQUE` (`CSOCategoryID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Currency
CREATE TABLE IF NOT EXISTS `Currency` (
  `CurrencyID` int(11) NOT NULL AUTO_INCREMENT,
  `Code` varchar(3) NOT NULL,
  `Description` varchar(100) NOT NULL,
  `SortOrder` int(11) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`Code`),
  UNIQUE KEY `UNIQUE` (`CurrencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.CurrencyRate
CREATE TABLE IF NOT EXISTS `CurrencyRate` (
  `CurrencyRateID` int(11) NOT NULL AUTO_INCREMENT,
  `YearOld` varchar(4) DEFAULT NULL,
  `FromCurrency` varchar(3) NOT NULL,
  `FromCurrencyRate` double NOT NULL,
  `ToCurrency` varchar(3) NOT NULL,
  `ToCurrencyRate` double NOT NULL,
  `Year` smallint(6) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UPdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CurrencyRateID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.DataUploadLog
CREATE TABLE IF NOT EXISTS `DataUploadLog` (
  `DataUploadLogID` int(11) NOT NULL AUTO_INCREMENT,
  `DataUploadStatusID` int(11) NOT NULL,
  `ProjectCount` int(11) DEFAULT NULL,
  `ProjectFundingCount` int(11) DEFAULT NULL,
  `ProjectFundingInvestigatorCount` int(11) DEFAULT NULL,
  `ProjectCSOCount` int(11) DEFAULT NULL,
  `ProjectCancerTypeCount` int(11) DEFAULT NULL,
  `Project_ProjectTypeCount` int(11) DEFAULT NULL,
  `ProjectAbstractCount` int(11) DEFAULT NULL,
  `ProjectSearchCount` int(11) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`DataUploadLogID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.DataUploadStatus
CREATE TABLE IF NOT EXISTS `DataUploadStatus` (
  `DataUploadStatusID` int(11) NOT NULL AUTO_INCREMENT,
  `PartnerCode` varchar(100) DEFAULT NULL,
  `FundingYear` varchar(50) DEFAULT NULL,
  `Status` longtext,
  `ReceivedDate` date DEFAULT NULL,
  `ValidationDate` date DEFAULT NULL,
  `UploadToDevDate` date DEFAULT NULL,
  `UploadToStageDate` date DEFAULT NULL,
  `UploadToProdDate` date DEFAULT NULL,
  `Note` longtext,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DataUploadStatusID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.FundingDivision
CREATE TABLE IF NOT EXISTS `FundingDivision` (
  `FundingDivisionID` int(11) NOT NULL AUTO_INCREMENT,
  `FundingOrgID` int(11) NOT NULL,
  `Name` varchar(75) NOT NULL,
  `Abbreviation` varchar(50) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`FundingDivisionID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.FundingOrg
CREATE TABLE IF NOT EXISTS `FundingOrg` (
  `FundingOrgID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Abbreviation` varchar(15) NOT NULL,
  `Type` varchar(25) DEFAULT NULL,
  `Country` varchar(3) NOT NULL,
  `Currency` varchar(3) NOT NULL,
  `SponsorCode` varchar(50) NOT NULL,
  `MemberType` varchar(25) NOT NULL,
  `MemberStatus` varchar(10) DEFAULT NULL,
  `IsAnnualized` tinyint(4) NOT NULL,
  `Note` varchar(8000) DEFAULT NULL,
  `LastImportDate` datetime DEFAULT NULL,
  `LastImportDesc` varchar(1000) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`FundingOrgID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Institution
CREATE TABLE IF NOT EXISTS `Institution` (
  `InstitutionID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(250) NOT NULL,
  `Type` varchar(25) DEFAULT NULL,
  `Longitude` decimal(9,6) DEFAULT NULL,
  `Latitude` decimal(9,6) DEFAULT NULL,
  `Postal` varchar(15) DEFAULT NULL,
  `City` varchar(50) NOT NULL,
  `State` varchar(3) DEFAULT NULL,
  `Country` varchar(3) DEFAULT NULL,
  `GRID` varchar(250) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`InstitutionID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.InstitutionMapping
CREATE TABLE IF NOT EXISTS `InstitutionMapping` (
  `InstitutionMappingID` int(11) NOT NULL AUTO_INCREMENT,
  `OldName` varchar(250) NOT NULL,
  `OldCity` varchar(50) DEFAULT NULL,
  `NewName` varchar(250) NOT NULL,
  `NewCity` varchar(50) NOT NULL,
  PRIMARY KEY (`InstitutionMappingID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Library
CREATE TABLE IF NOT EXISTS `Library` (
  `LibraryID` int(11) NOT NULL AUTO_INCREMENT,
  `LibraryFolderID` int(11) DEFAULT NULL,
  `Filename` varchar(150) DEFAULT NULL,
  `ThumbnailFilename` varchar(150) DEFAULT NULL,
  `Title` varchar(150) DEFAULT NULL,
  `Description` varchar(1000) DEFAULT NULL,
  `IsPublic` tinyint(4) NOT NULL DEFAULT '0',
  `ArchivedDate` datetime DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `DisplayName` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`LibraryID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.LibraryFolder
CREATE TABLE IF NOT EXISTS `LibraryFolder` (
  `LibraryFolderID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(200) NOT NULL,
  `ParentFolderID` int(11) DEFAULT NULL,
  `IsPublic` tinyint(4) NOT NULL DEFAULT '0',
  `ArchivedDate` datetime DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`LibraryFolderID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.lu_FundingOrgType
CREATE TABLE IF NOT EXISTS `lu_FundingOrgType` (
  `FundingOrgTypeID` int(11) NOT NULL,
  `FundingOrgType` varchar(50) NOT NULL,
  PRIMARY KEY (`FundingOrgTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Migration_Project
CREATE TABLE IF NOT EXISTS `Migration_Project` (
  `OldProjectID` int(11) NOT NULL,
  `SponsorCode` varchar(255) NOT NULL,
  `Code` varchar(255) NOT NULL,
  `altid` varchar(50) DEFAULT NULL,
  `SOURCE_ID` varchar(50) DEFAULT NULL,
  `INTERNALCODE` varchar(2000) DEFAULT NULL,
  `FundingOrgID` int(11) DEFAULT NULL,
  `IsActive` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Migration_ProjectFunding
CREATE TABLE IF NOT EXISTS `Migration_ProjectFunding` (
  `ProjectFundingID` int(11) NOT NULL AUTO_INCREMENT,
  `NewProjectID` int(11) NOT NULL,
  `OldProjectID` int(11) NOT NULL,
  `AbstractID` int(11) NOT NULL,
  `Title` varchar(1000) DEFAULT NULL,
  `Institution` varchar(250) DEFAULT NULL,
  `city` varchar(250) DEFAULT NULL,
  `NewInstitution` varchar(250) DEFAULT NULL,
  `NewCity` varchar(250) DEFAULT NULL,
  `state` varchar(250) DEFAULT NULL,
  `country` varchar(250) DEFAULT NULL,
  `piLastName` varchar(250) DEFAULT NULL,
  `piFirstName` varchar(250) DEFAULT NULL,
  `piORC_ID` varchar(250) DEFAULT NULL,
  `OtherResearch_ID` int(11) DEFAULT NULL,
  `OtherResearch_Type` varchar(50) DEFAULT NULL,
  `FundingOrgID` int(11) NOT NULL,
  `FundingDivisionID` int(11) DEFAULT NULL,
  `Category` varchar(50) DEFAULT NULL,
  `SponsorCode` varchar(100) NOT NULL,
  `AwardCode` varchar(500) NOT NULL,
  `AltAwardCode` varchar(500) NOT NULL,
  `Source_ID` varchar(50) DEFAULT NULL,
  `MechanismCode` varchar(30) DEFAULT NULL,
  `MechanismTitle` varchar(200) DEFAULT NULL,
  `FundingContact` varchar(75) DEFAULT NULL,
  `Amount` double DEFAULT NULL,
  `IsAnnualized` tinyint(4) NOT NULL,
  `BudgetStartDate` date DEFAULT NULL,
  `BudgetEndDate` date DEFAULT NULL,
  `CreatedDate` datetime NOT NULL,
  `UpdatedDate` datetime NOT NULL,
  PRIMARY KEY (`ProjectFundingID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Migration_Project_Base
CREATE TABLE IF NOT EXISTS `Migration_Project_Base` (
  `NewProjectID` int(11) NOT NULL AUTO_INCREMENT,
  `OldProjectID` int(11) NOT NULL,
  `SponsorCode` varchar(255) NOT NULL,
  `AwardCode` varchar(255) NOT NULL,
  PRIMARY KEY (`NewProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Partner
CREATE TABLE IF NOT EXISTS `Partner` (
  `PartnerID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Description` longtext NOT NULL,
  `SponsorCode` varchar(50) NOT NULL,
  `Email` varchar(75) DEFAULT NULL,
  `IsDSASigned` tinyint(4) DEFAULT NULL,
  `Country` varchar(100) DEFAULT NULL,
  `Website` varchar(200) DEFAULT NULL,
  `LogoFile` varchar(100) DEFAULT NULL,
  `MapCoords` varchar(50) DEFAULT NULL,
  `Note` varchar(8000) DEFAULT NULL,
  `JoinedDate` datetime DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PartnerID`),
  UNIQUE KEY `UX_Partner_SponsorCode` (`SponsorCode`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.PartnerApplication
CREATE TABLE IF NOT EXISTS `PartnerApplication` (
  `PartnerApplicationID` int(11) NOT NULL AUTO_INCREMENT,
  `ApplicationStatus` varchar(25) DEFAULT NULL,
  `OrgName` varchar(100) DEFAULT NULL,
  `OrgAddr1` varchar(100) DEFAULT NULL,
  `OrgAddr2` varchar(100) DEFAULT NULL,
  `OrgCity` varchar(50) DEFAULT NULL,
  `OrgState` varchar(25) DEFAULT NULL,
  `OrgCountry` varchar(255) DEFAULT NULL,
  `OrgZip` varchar(25) DEFAULT NULL,
  `OrgEDPCName` varchar(50) DEFAULT NULL,
  `OrgEDPCPosition` varchar(50) DEFAULT NULL,
  `OrgEDPCPhone` varchar(50) DEFAULT NULL,
  `OrgEDPCEmail` varchar(50) DEFAULT NULL,
  `OrgMissionDesc` longtext,
  `OrgProfileDesc` longtext,
  `OrgInitYear` varchar(4) DEFAULT NULL,
  `BudgetCurrInvestment` varchar(20) DEFAULT NULL,
  `BudgetReportPeriod` varchar(20) DEFAULT NULL,
  `BudgetCurrOperating` varchar(20) DEFAULT NULL,
  `BudgetNumProjects` smallint(6) DEFAULT NULL,
  `BudgetTier` smallint(6) DEFAULT NULL,
  `MemberPaymentMonth` int(11) DEFAULT NULL,
  `ContactName` varchar(50) DEFAULT NULL,
  `ContactPosition` varchar(50) DEFAULT NULL,
  `ContactPhone` varchar(50) DEFAULT NULL,
  `ContactEmail` varchar(50) DEFAULT NULL,
  `ContactAddr1` varchar(50) DEFAULT NULL,
  `ContactAddr2` varchar(50) DEFAULT NULL,
  `ContactCity` varchar(50) DEFAULT NULL,
  `ContactState` varchar(50) DEFAULT NULL,
  `ContactCountry` varchar(255) DEFAULT NULL,
  `ContactZip` varchar(25) DEFAULT NULL,
  `ICRPTerm1` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm2` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm3` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm4` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm5` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm6` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm7` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm8` tinyint(3) unsigned DEFAULT NULL,
  `ICRPTerm9` tinyint(3) unsigned DEFAULT NULL,
  `SupplLetterFile` varchar(100) DEFAULT NULL,
  `SupplDocFile` varchar(100) DEFAULT NULL,
  `IsCompleted` tinyint(4) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PartnerApplicationID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.PartnerOrg
CREATE TABLE IF NOT EXISTS `PartnerOrg` (
  `PartnerOrgID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `SponsorCode` varchar(50) NOT NULL,
  `MemberType` varchar(25) NOT NULL,
  `IsActive` tinyint(4) NOT NULL DEFAULT '1',
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PartnerOrgID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Project
CREATE TABLE IF NOT EXISTS `Project` (
  `ProjectID` int(11) NOT NULL AUTO_INCREMENT,
  `IsChildhood` tinyint(4) DEFAULT NULL,
  `AwardCode` varchar(50) NOT NULL,
  `ProjectStartDate` date DEFAULT NULL,
  `ProjectEndDate` date DEFAULT NULL,
  `CreatedDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectAbstract
CREATE TABLE IF NOT EXISTS `ProjectAbstract` (
  `ProjectAbstractID` int(11) NOT NULL,
  `TechAbstract` longtext NOT NULL,
  `PublicAbstract` longtext,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectAbstractID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectCancerType
CREATE TABLE IF NOT EXISTS `ProjectCancerType` (
  `ProjectCancerTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectFundingID` int(11) NOT NULL,
  `CancerTypeID` int(11) NOT NULL,
  `Relevance` double DEFAULT NULL,
  `RelSource` varchar(1) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `EnterBy` varchar(1) NOT NULL,
  PRIMARY KEY (`ProjectCancerTypeID`),
  KEY `IX_ProjectCancerType_ProjectFundingID` (`ProjectFundingID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectCSO
CREATE TABLE IF NOT EXISTS `ProjectCSO` (
  `ProjectCSOID` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectFundingID` int(11) NOT NULL,
  `CSOCode` varchar(20) NOT NULL,
  `Relevance` double DEFAULT NULL,
  `RelSource` varchar(1) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectCSOID`),
  KEY `IX_ProjectCancerType_ProjectFundingID` (`ProjectFundingID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectFunding
CREATE TABLE IF NOT EXISTS `ProjectFunding` (
  `ProjectFundingID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(1000) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `FundingOrgID` int(11) NOT NULL,
  `FundingDivisionID` int(11) DEFAULT NULL,
  `ProjectAbstractID` int(11) NOT NULL,
  `DataUploadStatusID` int(11) DEFAULT NULL,
  `Category` varchar(25) DEFAULT NULL,
  `AltAwardCode` varchar(50) NOT NULL,
  `Source_ID` varchar(50) DEFAULT NULL,
  `MechanismCode` varchar(30) DEFAULT NULL,
  `MechanismTitle` varchar(200) DEFAULT NULL,
  `FundingContact` varchar(200) DEFAULT NULL,
  `IsAnnualized` tinyint(4) NOT NULL,
  `Amount` double DEFAULT NULL,
  `BudgetStartDate` date DEFAULT NULL,
  `BudgetEndDate` date DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectFundingID`),
  KEY `IX_ProjectFunding_ProjectID` (`ProjectID`),
  KEY `IX_ProjectFunding_FundingOrgID` (`FundingOrgID`),
  KEY `IX_ProjectFunding_ProjectAbstractID` (`ProjectAbstractID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectFundingExt
CREATE TABLE IF NOT EXISTS `ProjectFundingExt` (
  `ProjectFundingExtID` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectFundingID` int(11) NOT NULL,
  `CalendarYear` smallint(6) NOT NULL,
  `CalendarAmount` double DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectFundingExtID`),
  KEY `IX_ProjectFundingExt_ProjectFundingID` (`ProjectFundingID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectFundingInvestigator
CREATE TABLE IF NOT EXISTS `ProjectFundingInvestigator` (
  `ProjectFundingID` int(11) NOT NULL,
  `LastName` varchar(50) NOT NULL,
  `FirstName` varchar(50) DEFAULT NULL,
  `ORC_ID` varchar(19) DEFAULT NULL,
  `OtherResearch_ID` int(11) DEFAULT NULL,
  `OtherResearch_Type` varchar(50) DEFAULT NULL,
  `IsPrivateInvestigator` tinyint(4) NOT NULL,
  `InstitutionID` int(11) NOT NULL,
  `InstitutionNameSubmitted` varchar(250) DEFAULT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectFundingID`,`InstitutionID`),
  KEY `IX_ProjectFundingInvestigator_ProjectFundingID` (`ProjectFundingID`),
  KEY `IX_ProjectFundingInvestigator_InstitutionID` (`InstitutionID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectSearch
CREATE TABLE IF NOT EXISTS `ProjectSearch` (
  `ProjectSearchID` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectID` int(11) NOT NULL,
  `Content` longtext NOT NULL,
  PRIMARY KEY (`ProjectSearchID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.ProjectType
CREATE TABLE IF NOT EXISTS `ProjectType` (
  `ProjectTypeID` int(11) NOT NULL AUTO_INCREMENT,
  `ProjectType` varchar(15) NOT NULL,
  `IsShownOnMap` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`ProjectType`),
  UNIQUE KEY `UNIQUE` (`ProjectTypeID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.Project_ProjectType
CREATE TABLE IF NOT EXISTS `Project_ProjectType` (
  `ProjectID` int(11) NOT NULL,
  `ProjectType` varchar(15) NOT NULL,
  `CreatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ProjectID`,`ProjectType`),
  KEY `IX_Project_ProjectType_ProjectID` (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.SearchCriteria
CREATE TABLE IF NOT EXISTS `SearchCriteria` (
  `SearchCriteriaID` int(11) NOT NULL AUTO_INCREMENT,
  `TermSearchType` varchar(25) DEFAULT NULL,
  `Terms` varchar(1000) DEFAULT NULL,
  `Institution` varchar(250) DEFAULT NULL,
  `piLastName` varchar(50) DEFAULT NULL,
  `piFirstName` varchar(50) DEFAULT NULL,
  `piORCiD` varchar(50) DEFAULT NULL,
  `AwardCode` varchar(50) DEFAULT NULL,
  `YearList` varchar(1000) DEFAULT NULL,
  `CityList` varchar(1000) DEFAULT NULL,
  `StateList` varchar(1000) DEFAULT NULL,
  `CountryList` varchar(1000) DEFAULT NULL,
  `FundingOrgList` varchar(1000) DEFAULT NULL,
  `CancerTypeList` varchar(1000) DEFAULT NULL,
  `ProjectTypeList` varchar(1000) DEFAULT NULL,
  `CSOList` varchar(500) DEFAULT NULL,
  `SearchByUserName` varchar(100) DEFAULT NULL,
  `SearchDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `FundingOrgTypeList` varchar(250) DEFAULT NULL,
  `IsChildhood` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`SearchCriteriaID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.SearchResult
CREATE TABLE IF NOT EXISTS `SearchResult` (
  `SearchCriteriaID` int(11) NOT NULL,
  `Results` longtext DEFAULT NULL,
  `ResultCount` int(11) DEFAULT NULL,
	`TotalRelatedProjectCount` int(11) DEFAULT NULL,
	`LastBudgetYear` year DEFAULT NULL,
  `IsEmailSent` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`SearchCriteriaID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.State
CREATE TABLE IF NOT EXISTS `State` (
  `StateID` int(11) NOT NULL AUTO_INCREMENT,
  `Abbreviation` varchar(3) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Country` varchar(3) NOT NULL,
  PRIMARY KEY (`StateID`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.sysdiagrams
CREATE TABLE IF NOT EXISTS `sysdiagrams` (
  `name` varchar(128) NOT NULL,
  `principal_id` int(11) NOT NULL,
  `diagram_id` int(11) NOT NULL AUTO_INCREMENT,
  `version` int(11) DEFAULT NULL,
  `definition` longblob,
  PRIMARY KEY (`diagram_id`),
  UNIQUE KEY `UNIQUE` (`principal_id`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
-- Dumping structure for table icrp_data.UploadWorkBook
CREATE TABLE IF NOT EXISTS `UploadWorkBook` (
  `AwardCode` varchar(50) DEFAULT NULL,
  `AwardStartDate` date DEFAULT NULL,
  `AwardEndDate` date DEFAULT NULL,
  `SourceId` varchar(50) DEFAULT NULL,
  `AltId` varchar(50) DEFAULT NULL,
  `AwardTitle` varchar(1000) DEFAULT NULL,
  `Category` varchar(25) DEFAULT NULL,
  `AwardType` varchar(50) DEFAULT NULL,
  `Childhood` varchar(5) DEFAULT NULL,
  `BudgetStartDate` date DEFAULT NULL,
  `BudgetEndDate` date DEFAULT NULL,
  `CSOCodes` varchar(500) DEFAULT NULL,
  `CSORel` varchar(500) DEFAULT NULL,
  `SiteCodes` varchar(500) DEFAULT NULL,
  `SiteRel` varchar(500) DEFAULT NULL,
  `AwardFunding` double DEFAULT NULL,
  `IsAnnualized` varchar(1) DEFAULT NULL,
  `FundingMechanismCode` varchar(30) DEFAULT NULL,
  `FundingMechanism` varchar(200) DEFAULT NULL,
  `FundingOrgAbbr` varchar(50) DEFAULT NULL,
  `FundingDiv` varchar(50) DEFAULT NULL,
  `FundingDivAbbr` varchar(50) DEFAULT NULL,
  `FundingContact` varchar(50) DEFAULT NULL,
  `PILastName` varchar(50) DEFAULT NULL,
  `PIFirstName` varchar(50) DEFAULT NULL,
  `SubmittedInstitution` varchar(250) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(3) DEFAULT NULL,
  `Country` varchar(3) DEFAULT NULL,
  `PostalZipCode` varchar(15) DEFAULT NULL,
  `InstitutionICRP` varchar(4000) DEFAULT NULL,
  `Latitute` decimal(9,6) DEFAULT NULL,
  `Longitute` decimal(9,6) DEFAULT NULL,
  `GRID` varchar(50) DEFAULT NULL,
  `RelatedAwardCode` varchar(200) DEFAULT NULL,
  `RelationshipType` varchar(200) DEFAULT NULL,
  `ORCID` varchar(25) DEFAULT NULL,
  `OtherResearcherID` int(11) DEFAULT NULL,
  `OtherResearcherIDType` varchar(1000) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=ucs2;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

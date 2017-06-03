ALTER TABLE `CSO`
    ADD CONSTRAINT `FK_CSO_CSOCategory` FOREIGN KEY (`CategoryName`) REFERENCES `CSOCategory` (`Name`);
ALTER TABLE `CurrencyRate`
	ADD CONSTRAINT `FK_CurrencyRate_Currency` FOREIGN KEY (`FromCurrency`) REFERENCES `Currency` (`Code`);
ALTER TABLE `CurrencyRate`
	ADD CONSTRAINT `FK_CurrencyRate_Currency1` FOREIGN KEY (`ToCurrency`) REFERENCES `Currency` (`Code`);
ALTER TABLE `FundingDivision`
	ADD CONSTRAINT `FK_FundingDivision_FundingOrg` FOREIGN KEY (`FundingOrgID`) REFERENCES `FundingOrg` (`FundingOrgID`);
ALTER TABLE `FundingOrg`
	ADD CONSTRAINT `FK_FundingOrg_Currency` FOREIGN KEY (`Currency`) REFERENCES `Currency` (`Code`);
ALTER TABLE `FundingOrg`
	ADD CONSTRAINT `FK_FundingOrg_Country` FOREIGN KEY (`Country`) REFERENCES `Country` (`Abbreviation`);
ALTER TABLE `FundingOrg`
	ADD CONSTRAINT `FK_FundingOrg_Partner` FOREIGN KEY (`SponsorCode`) REFERENCES `Partner` (`SponsorCode`);
ALTER TABLE `Project_ProjectType`
	ADD CONSTRAINT `FK_Project_ProjectType_Project` FOREIGN KEY (`ProjectID`) REFERENCES `Project` (`ProjectID`);
ALTER TABLE `Project_ProjectType`
	ADD CONSTRAINT `FK_Project_ProjectType_ProjectType` FOREIGN KEY (`ProjectType`) REFERENCES `ProjectType` (`ProjectType`);
ALTER TABLE `ProjectCancerType`
	ADD CONSTRAINT `FK_ProjectCancerType_CancerType` FOREIGN KEY (`CancerTypeID`) REFERENCES `CancerType` (`CancerTypeID`);
ALTER TABLE `ProjectCancerType`
	ADD CONSTRAINT `FK_ProjectCancerType_ProjectFunding` FOREIGN KEY (`ProjectFundingID`) REFERENCES `ProjectFunding` (`ProjectFundingID`);
ALTER TABLE `ProjectFunding`
	ADD CONSTRAINT `FK_ProjectFunding_FundingOrg` FOREIGN KEY (`FundingOrgID`) REFERENCES `FundingOrg` (`FundingOrgID`);
ALTER TABLE `ProjectFunding`
	ADD CONSTRAINT `FK_ProjectFunding_Project` FOREIGN KEY (`ProjectID`) REFERENCES `Project` (`ProjectID`);
ALTER TABLE `ProjectFunding`
	ADD CONSTRAINT `FK_ProjectFunding_ProjectAbstract` FOREIGN KEY (`ProjectAbstractID`) REFERENCES `ProjectAbstract` (`ProjectAbstractID`);
ALTER TABLE `ProjectFundingInvestigator`
	ADD CONSTRAINT `FK_ProjectFundingInvestigator_ProjectFunding` FOREIGN KEY (`ProjectFundingID`) REFERENCES `ProjectFunding` (`ProjectFundingID`);
ALTER TABLE `ProjectFundingInvestigator`
	ADD CONSTRAINT `FK_ProjectFundingInvestigator_Institution` FOREIGN KEY (`InstitutionID`) REFERENCES `Institution` (`InstitutionID`);
ALTER TABLE `ProjectFundingExt`
	ADD CONSTRAINT `FK_ProjectFundingExt_ProjectFunding` FOREIGN KEY (`ProjectFundingID`) REFERENCES `ProjectFunding` (`ProjectFundingID`);
ALTER TABLE `ProjectCSO`
	ADD CONSTRAINT `FK_ProjectCSO_CSO` FOREIGN KEY (`CSOCode`) REFERENCES `CSO` (`Code`);
ALTER TABLE `ProjectCSO`
	ADD CONSTRAINT `FK_ProjectCSO_ProjectFunding` FOREIGN KEY (`ProjectFundingID`) REFERENCES `ProjectFunding` (`ProjectFundingID`);
ALTER TABLE `Library`
	ADD CONSTRAINT `FK_Library_LibraryFolder` FOREIGN KEY (`LibraryFolderID`) REFERENCES `LibraryFolder` (`LibraryFolderID`);
ALTER TABLE `State`
	ADD CONSTRAINT `FK_State_Country` FOREIGN KEY (`Country`) REFERENCES `Country` (`Abbreviation`);

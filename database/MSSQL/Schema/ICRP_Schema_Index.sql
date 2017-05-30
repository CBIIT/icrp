/*************************************************************************************/
--  Create index key for the ProjectFunding table
/*************************************************************************************/
BEGIN TRANSACTION

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFunding_ProjectID')   
    DROP INDEX IX_ProjectFunding_ProjectID ON ProjectFunding;   
GO  

CREATE NONCLUSTERED INDEX IX_ProjectFunding_ProjectID   
    ON ProjectFunding (ProjectID);   
GO  

	-- Find an existing index named IX_ProductVendor_VendorID and delete it if found.   
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFunding_FundingOrgID')   
    DROP INDEX IX_ProjectFunding_FundingOrgID ON ProjectFunding;   
GO  

CREATE NONCLUSTERED INDEX IX_ProjectFunding_FundingOrgID   
    ON ProjectFunding (FundingOrgID);   
GO  


IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFunding_ProjectAbstractID')   
    DROP INDEX IX_ProjectFunding_ProjectAbstractID ON ProjectFunding;   
GO  
  
CREATE NONCLUSTERED INDEX IX_ProjectFunding_ProjectAbstractID   
    ON ProjectFunding (ProjectAbstractID);   
GO  

/*************************************************************************************/
--  Create index key for the ProjectFundingInvestigator table
/*************************************************************************************/

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFundingInvestigator_ProjectFundingID')   
    DROP INDEX IX_ProjectFundingInvestigator_ProjectFundingID ON ProjectFundingInvestigator;   
GO  

CREATE NONCLUSTERED INDEX IX_ProjectFundingInvestigator_ProjectFundingID   
    ON ProjectFundingInvestigator (ProjectFundingID);   
GO  

IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFundingInvestigator_InstitutionID')   
    DROP INDEX IX_ProjectFundingInvestigator_InstitutionID ON ProjectFundingInvestigator;   
GO  
 
CREATE NONCLUSTERED INDEX IX_ProjectFundingInvestigator_InstitutionID   
    ON ProjectFundingInvestigator (InstitutionID);   
GO  

/*************************************************************************************/
--  Create index key for the ProjectCSO table
/*************************************************************************************/
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectCSO_ProjectFundingID')   
    DROP INDEX IX_ProjectCSO_ProjectFundingID ON ProjectCSO;   
GO  

CREATE NONCLUSTERED INDEX IX_ProjectCSO_ProjectFundingID   
    ON ProjectCSO (ProjectFundingID);   
GO  

/*************************************************************************************/
--  Create index key for the ProjectCancerType table
/*************************************************************************************/
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectCancerType_ProjectFundingID')   
    DROP INDEX IX_ProjectCancerType_ProjectFundingID ON ProjectCancerType;   
GO  
  
CREATE NONCLUSTERED INDEX IX_ProjectCancerType_ProjectFundingID   
    ON ProjectCancerType (ProjectFundingID);   
GO  


/*************************************************************************************/
--  Create index key for the ProjectFundingExt table
/*************************************************************************************/
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_ProjectFundingExt_ProjectFundingID')   
    DROP INDEX IX_ProjectFundingExt_ProjectFundingID ON ProjectFundingExt;   
GO  
  
CREATE NONCLUSTERED INDEX IX_ProjectFundingExt_ProjectFundingID   
    ON ProjectFundingExt (ProjectFundingID);   
GO  


/*************************************************************************************/
--  Create index key for the Project_ProjectType table
/*************************************************************************************/
IF EXISTS (SELECT name FROM sys.indexes  
            WHERE name = N'IX_Project_ProjectType_ProjectID')   
    DROP INDEX IX_Project_ProjectType_ProjectID ON Project_ProjectType;   
GO  
  
CREATE NONCLUSTERED INDEX IX_Project_ProjectType_ProjectID   
    ON Project_ProjectType (ProjectID);   
GO  

COMMIT
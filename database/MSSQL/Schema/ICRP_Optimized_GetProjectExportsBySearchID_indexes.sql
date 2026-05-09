SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
  Supporting indexes for GetProjectExportsBySearchID filter/pivot path.
  Safe to run repeatedly: each index is created only if missing.
*/

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_ProjectFundingExt_ProjectFundingID_CalendarYear'
    AND object_id = OBJECT_ID('dbo.ProjectFundingExt')
)
CREATE NONCLUSTERED INDEX IX_ProjectFundingExt_ProjectFundingID_CalendarYear
ON dbo.ProjectFundingExt (ProjectFundingID, CalendarYear)
INCLUDE (CalendarAmount);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_ProjectFundingInvestigator_ProjectFundingID_IsPI_InstitutionID'
    AND object_id = OBJECT_ID('dbo.ProjectFundingInvestigator')
)
CREATE NONCLUSTERED INDEX IX_ProjectFundingInvestigator_ProjectFundingID_IsPI_InstitutionID
ON dbo.ProjectFundingInvestigator (ProjectFundingID, IsPrincipalInvestigator, InstitutionID)
INCLUDE (LastName, FirstName, ORC_ID);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_ProjectCSO_ProjectFundingID_CSOCode'
    AND object_id = OBJECT_ID('dbo.ProjectCSO')
)
CREATE NONCLUSTERED INDEX IX_ProjectCSO_ProjectFundingID_CSOCode
ON dbo.ProjectCSO (ProjectFundingID, CSOCode);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_ProjectCancerType_ProjectFundingID_CancerTypeID'
    AND object_id = OBJECT_ID('dbo.ProjectCancerType')
)
CREATE NONCLUSTERED INDEX IX_ProjectCancerType_ProjectFundingID_CancerTypeID
ON dbo.ProjectCancerType (ProjectFundingID, CancerTypeID);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_CountryMapLayer_Country_Value'
    AND object_id = OBJECT_ID('dbo.CountryMapLayer')
)
CREATE NONCLUSTERED INDEX IX_CountryMapLayer_Country_Value
ON dbo.CountryMapLayer (Country, [Value]);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_Institution_Country_City_State'
    AND object_id = OBJECT_ID('dbo.Institution')
)
CREATE NONCLUSTERED INDEX IX_Institution_Country_City_State
ON dbo.Institution (Country, City, State)
INCLUDE (Name);
GO

IF NOT EXISTS (
  SELECT 1
  FROM sys.indexes
  WHERE name = 'IX_CurrencyRate_ToCurrency_Year_FromCurrency'
    AND object_id = OBJECT_ID('dbo.CurrencyRate')
)
CREATE NONCLUSTERED INDEX IX_CurrencyRate_ToCurrency_Year_FromCurrency
ON dbo.CurrencyRate (ToCurrency, [Year], FromCurrency)
INCLUDE (ToCurrencyRate);
GO

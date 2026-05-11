------------------
--- run this script for DataUpload_DeleteDataImportFromStaging
------------------

USE [icrp_dataload]
GO
/****** Object:  StoredProcedure [dbo].[DataUpload_DeleteDataImportFromStaging]    Script Date: 2/27/2026 7:30:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataUpload_DeleteDataImportFromStaging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[DataUpload_DeleteDataImportFromStaging]
GO

CREATE PROCEDURE [dbo].[DataUpload_DeleteDataImportFromStaging] 

@DataUploadStatusID INT
  
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRANSACTION

BEGIN TRY     

declare @DataUploadLogID INT
declare @DataUploadStatusID_Prod INT

SELECT @DataUploadLogID = DataUploadLogID from DataUploadLog where DataUploadStatusID = @DataUploadStatusID

SELECT @DataUploadStatusID_Prod = p.DataUploadStatusID
	FROM (SELECT * FROM icrp_data.dbo.DataUploadStatus WHERE Status = 'Staging') p
	JOIN (SELECT * FROM icrp_dataload.dbo.DataUploadStatus WHERE Status = 'Staging' and DataUploadStatusID = @DataUploadStatusID) s 
		ON p.PartnerCode = s.PartnerCode AND p.FundingYear = s.FundingYear AND p.Type = s.Type AND p.Note = s.Note
		
print @DataUploadStatusID 
print @DataUploadLogID 
print @DataUploadStatusID_Prod 

delete ProjectSearch from ProjectSearch ps
join project p on p.ProjectID = ps.ProjectID where p.datauploadstatusid = @DataUploadStatusID --5

delete ProjectFundingExt from ProjectFundingExt ext
join projectfunding f on f.ProjectFundingID = ext.ProjectFundingID where f.datauploadstatusid = @DataUploadStatusID


delete Project_ProjectType  from Project_ProjectType pt 
join project p on p.ProjectID = pt.ProjectID where p.datauploadstatusid = @DataUploadStatusID

delete ProjectCancerType from ProjectCancerType ct 
join projectfunding f on f.ProjectFundingID = ct.ProjectFundingID where f.datauploadstatusid = @DataUploadStatusID

delete ProjectCSO from ProjectCSO cso 
join projectfunding f on f.ProjectFundingID = cso.ProjectFundingID where f.datauploadstatusid = @DataUploadStatusID

delete ProjectFundingInvestigator from ProjectFundingInvestigator pi 
join projectfunding f on f.ProjectFundingID =pi.ProjectFundingID where f.datauploadstatusid = @DataUploadStatusID

delete ProjectFunding where datauploadstatusid = @DataUploadStatusID

delete ProjectAbstract from ProjectAbstract a 
join projectfunding f on f.ProjectAbstractID = a.ProjectAbstractID where f.datauploadstatusid = @DataUploadStatusID

delete Project where datauploadstatusid = @DataUploadStatusID

-- delete dataupload records from icrp-dataload (staging)
delete DataUploadLog where DataUploadLogID = @DataUploadLogID
delete DataUploadStatus where DataUploadStatusID = @DataUploadStatusID

-- delete dataupload records from icrp-data (prod)
delete icrp_data.dbo.DataUploadLog where DataUploadStatusID = @DataUploadStatusID_Prod
delete icrp_data.dbo.DataUploadStatus where DataUploadStatusID = @DataUploadStatusID_Prod		

COMMIT TRANSACTION

END TRY

BEGIN CATCH
      IF @@trancount > 0 
		ROLLBACK TRANSACTION
      
	  DECLARE @msg nvarchar(2048) = error_message()  
      RAISERROR (@msg, 16, 1)
	        
END CATCH  
END

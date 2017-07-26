/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

------------------------------------------------------------------
-- Insert [lu_DataUploadIntegrityCheckRules] Data
------------------------------------------------------------------
UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CSO Codes', Category='CSO', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 26
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (27, 'Place Holder', 'CSO', 1, 0, getdate(), getdate())

UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CancerType Codes', Category='Cancer Type', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 35
INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (36, 'Place Holder', 'Cancer Type', 1, 0, getdate(), getdate())


/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

/*************************************************/
/******					Data				******/
/*************************************************/

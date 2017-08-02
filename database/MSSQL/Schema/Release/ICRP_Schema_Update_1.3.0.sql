/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

------------------------------------------------------------------
-- Insert [lu_DataUploadIntegrityCheckRules] Data
------------------------------------------------------------------
UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CSO Codes', Category='CSO', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 26
IF NOT EXISTS (SELECT * FROM [lu_DataUploadIntegrityCheckRules] WHERE lu_DataUploadIntegrityCheckRules_ID= 27)
	INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (27, 'Place Holder', 'CSO', 1, 0, getdate(), getdate())

UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CancerType Codes', Category='Cancer Type', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 35
IF NOT EXISTS (SELECT * FROM [lu_DataUploadIntegrityCheckRules] WHERE lu_DataUploadIntegrityCheckRules_ID= 36)
	INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (36, 'Place Holder', 'Cancer Type', 1, 0, getdate(), getdate())

UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Category='Organization' WHERE Category='Funding Org / Institution'
UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Missing Host Institutions' WHERE Name='Missing Institution'
UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Missing Funding Organizations' WHERE Name='Missing Funding Org'
UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Missing Funding Organization Divs' WHERE Name='Missing Funding Org Div'


/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

/*************************************************/
/******					Data				******/
/*************************************************/

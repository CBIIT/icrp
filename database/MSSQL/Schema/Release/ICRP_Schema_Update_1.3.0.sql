/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

------------------------------------------------------------------
-- Insert [lu_DataUploadIntegrityCheckRules] Data
------------------------------------------------------------------
DELETE [lu_DataUploadIntegrityCheckRules] WHERE Name = 'Place Holder'

IF NOT EXISTS (SELECT * FROM [lu_DataUploadIntegrityCheckRules] WHERE lu_DataUploadIntegrityCheckRules_ID= 26)
	INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (26, 'Duplicate CSO Codes', 'CSO', 1, 1, getdate(), getdate())
ELSE
	UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CSO Codes', Category='CSO', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 26

IF NOT EXISTS (SELECT * FROM [lu_DataUploadIntegrityCheckRules] WHERE lu_DataUploadIntegrityCheckRules_ID= 35)
	INSERT INTO [dbo].[lu_DataUploadIntegrityCheckRules] VALUES (35, 'Duplicate CancerType Codes', 'Cancer Type', 1, 1, getdate(), getdate())
ELSE
	UPDATE [dbo].[lu_DataUploadIntegrityCheckRules] SET Name='Duplicate CancerType Codes', Category='Cancer Type', IsActive=1 WHERE lu_DataUploadIntegrityCheckRules_ID= 35

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

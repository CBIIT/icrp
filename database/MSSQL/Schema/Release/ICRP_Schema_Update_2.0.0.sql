/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Country]') AND name = 'Region')
	ALTER TABLE Country ADD Region VARCHAR(100) NULL

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFundingInvestigator]') AND name = 'LastName')
	ALTER TABLE ProjectFundingInvestigator ALTER COLUMN LastName VARCHAR(100) NULL

/*************************************************/
/******					Data				******/
/*************************************************/


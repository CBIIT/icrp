
/*************************************************/
/******	NEW Column            				******/
/*************************************************/ 
IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'IncomeGroupList')
	ALTER TABLE SearchCriteria ADD IncomeGroupList VARCHAR(1000) NULL
GO

/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CountryMapLayer]') AND name = 'CreatedDate')
	ALTER TABLE CountryMapLayer ADD CreatedDate DateTime NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CountryMapLayer]') AND name = 'UpdatedDate')
	ALTER TABLE CountryMapLayer ADD UpdatedDate DateTime NULL
GO

/*************************************************/
/******					Data				******/
/*************************************************/

	
/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 Obsolete SPs						******/
/*************************************************/


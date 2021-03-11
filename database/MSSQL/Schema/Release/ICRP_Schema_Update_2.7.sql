/*************************************************/
/******	NEW TABLE            				******/
/*************************************************/ 
/****** Object:  Table [dbo].[lu_ChildhoodCancer]    Script Date: 4/21/2017 9:30:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF object_id('lu_ChildhoodCancer') is not null
DROP TABLE lu_ChildhoodCancer
GO 

CREATE TABLE [dbo].[lu_ChildhoodCancer](
	[ChildhoodCancerID] [int] NOT NULL,
	[ChildhoodCancerType] [varchar](25) NOT NULL 
)

GO


/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[ProjectFunding]') AND name = 'IsChildhood')
	ALTER TABLE ProjectFunding ADD IsChildhood INT NULL
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'ChildhoodCancerList')
	ALTER TABLE SearchCriteria ADD ChildhoodCancerList VARCHAR(1000) NULL
GO


/*************************************************/
/******					Data				******/
/*************************************************/
Update projectfunding set IsChildhood = p.IsChildhood
From projectfunding pf
join (select IsChildhood, projectid from project) p on pf.projectid = p.projectid
	
Update SearchCriteria set ChildhoodCancerList = s2.ChildhoodCancerList
From SearchCriteria s
join (SELECT searchCriteriaID, CAST(IsChildhood as varchar(10)) as ChildhoodCancerList FROM SearchCriteria) s2 on s.searchCriteriaID = s2.searchCriteriaID
	
INSERT INTO lu_ChildhoodCancer VALUES (0, 'Not Childhood')
INSERT INTO lu_ChildhoodCancer VALUES (1, 'Childhood')
INSERT INTO lu_ChildhoodCancer VALUES (2, 'Partially Childhood')

/*************************************************/
/******		UPDATE TABLE        			******/
/*************************************************/

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[Project]') AND name = 'IsChildhood')
	ALTER TABLE Project DROP COLUMN IsChildhood
GO

IF EXISTS (SELECT * FROM sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[SearchCriteria]') AND name = 'IsChildhood')
	ALTER TABLE SearchCriteria DROP COLUMN IsChildhood
GO
/*************************************************/
/******					Keys				******/
/*************************************************/


/*************************************************/
/******	 SPs						******/
/*************************************************/


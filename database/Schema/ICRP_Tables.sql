
/****** Object:  Table [dbo].[Archive-2015-08-18_CSO_ver_1]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Archive-2015-08-18_CSO_ver_1](
	[id] [int] NOT NULL,
	[code] [varchar](20) NULL,
	[name] [varchar](100) NULL,
	[category] [varchar](100) NULL,
	[categoryCode] [int] NULL,
	[sortOrder] [int] NULL,
	[WeightName] [numeric](1, 0) NULL,
	[ShortName] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Archive-2015-08-18_ProjectCSO_ver_1]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Archive-2015-08-18_ProjectCSO_ver_1](
	[ProjectID] [int] NOT NULL,
	[CSOID] [int] NOT NULL,
	[Relevance] [float] NULL,
	[RelSource] [char](1) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CancerType]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CancerType](
	[CancerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Mapped_ID] [int] NOT NULL,
	[SiteURL] [varchar](150) NULL,
	[IsCommon] [bit] NOT NULL,
	[IsArchived] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CancerType] PRIMARY KEY CLUSTERED 
(
	[CancerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Country]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Abbreviation] [varchar](3) NOT NULL,
	[Name] [varchar](75) NOT NULL,
	[IncomeBand] [varchar](25) NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[Abbreviation] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CSO]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSO](
	[CSOID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](20) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[ShortName] [varchar](100) NOT NULL,
	[CategoryName] [varchar](100) NOT NULL,
	[WeightName] [numeric](1, 0) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CSO] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CSOCategory]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CSOCategory](
	[CSOCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Code] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CSOCategory] PRIMARY KEY CLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Currency]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[CurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](3) NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[SortOrder] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CurrencyRate]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrencyRate](
	[CurrencyRateID] [int] IDENTITY(1,1) NOT NULL,
	[YearOld] [char](4) NULL,
	[FromCurrency] [varchar](3) NOT NULL,
	[FromCurrencyRate] [float] NOT NULL,
	[ToCurrency] [varchar](3) NOT NULL,
	[ToCurrencyRate] [float] NOT NULL,
	[Year] [smallint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UPdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CurrencyRate] PRIMARY KEY CLUSTERED 
(
	[CurrencyRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FundingDivision]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FundingDivision](
	[FundingDivisionID] [int] IDENTITY(1,1) NOT NULL,
	[FundingOrgID] [int] NOT NULL,
	[Name] [varchar](75) NOT NULL,
	[Abbreviation] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FundingDivision] PRIMARY KEY CLUSTERED 
(
	[FundingDivisionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FundingMechanism]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FundingMechanism](
	[FundingMechanismID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [varchar](200) NULL,
	[DisplayName] [varchar](200) NULL,
	[SponsorCode] [varchar](50) NULL,
	[SponsorMechanism] [varchar](30) NULL,
	[SortOrder] [smallint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FundingMechanism] PRIMARY KEY CLUSTERED 
(
	[FundingMechanismID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FundingOrg]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FundingOrg](
	[FundingOrgID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Abbreviation] [varchar](15) NOT NULL,
	[Country] [varchar](3) NOT NULL,
	[Currency] [varchar](3) NOT NULL,
	[SponsorCode] [varchar](50) NOT NULL,
	[SortOrder] [smallint] NOT NULL,
	[IsAnnualized] [bit] NOT NULL,
	[IsUseLatestFundingAmount] [bit] NOT NULL,
	[LastImportDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FundingOrg] PRIMARY KEY CLUSTERED 
(
	[FundingOrgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Institution]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Institution](
	[InstitutionID] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionType] [varchar](50) NULL,
	[Name] [varchar](250) NOT NULL,
	[Abbreviation] [varchar](3) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](3) NULL,
	[Country] [varchar](3) NULL,
	[GRID] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Institution] PRIMARY KEY CLUSTERED 
(
	[InstitutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InstitutionType]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstitutionType](
	[InstitutionTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_InstitutionType] PRIMARY KEY CLUSTERED 
(
	[Type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[ProjectID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectGroupID] [int] NULL,		
	[AwardCode] [nvarchar](50) NOT NULL,	
	[FundingMechanismID] [int] NULL,
	[IsFunded] [bit] NOT NULL,
	[ProjectStartDate] [date] NULL,
	[ProjectEndDate] [date] NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Project_ProjectType]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project_ProjectType](
	[ProjectID] [int] NOT NULL,
	[ProjectType] [varchar](15) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Project_ProjectType_1] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC,
	[ProjectType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectAbstract]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectAbstract](
	[ProjectAbstractID] [int] IDENTITY(1,1) NOT NULL,
	[TechTitle] [nvarchar](max) NOT NULL,
	[TechAbstract] [nvarchar](max) NOT NULL,
	[PublicTitle] [nvarchar](max) NULL,
	[PublicAbstract] [nvarchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectAbstract] PRIMARY KEY CLUSTERED 
(
	[ProjectAbstractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectCancerType]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectCancerType](
	[ProjectCancerTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectFundingID] [int] NOT NULL,
	[CancerTypeID] [int] NOT NULL,
	[Relvance] [float] NULL,
	[RelSource] [char](1) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
	[EnterBy] [char](1) NOT NULL,
 CONSTRAINT [PK_ProjectCancerType] PRIMARY KEY CLUSTERED 
(
	[ProjectCancerTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX IX_ProjectCancerType_ProjectFundingID
ON ProjectCancerType (ProjectFundingID)
INCLUDE (CancerTypeID);
GO

GO
/****** Object:  Table [dbo].[ProjectCSO]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectCSO](
	[ProjectCSOID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectFundingID] [int] NOT NULL,
	[CSOCode] [varchar](20) NOT NULL,
	[Relvance] [float] NULL,
	[RelSource] [char](1) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectCSO] PRIMARY KEY CLUSTERED 
(
	[ProjectCSOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectDocument]    Script Date: 12/13/2016 6:23:53 PM ******/
CREATE TABLE [dbo].[ProjectDocument](
	[ProjectID] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ProjectDocument] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;  
--GO  

--CREATE FULLTEXT INDEX ON [dbo].[ProjectDocument](Content) KEY INDEX [PK_ProjectDocument];
--GO


/****** Object:  Table [dbo].[ProjectDocument_JP]    Script Date: 12/13/2016 6:23:53 PM ******/
CREATE TABLE [dbo].[ProjectDocument_JP](
	[ProjectID] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ProjectDocument_JP] PRIMARY KEY CLUSTERED 
(
	[ProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

--CREATE FULLTEXT CATALOG ftCatalog AS DEFAULT;  
--GO  

--CREATE FULLTEXT INDEX ON [dbo].[ProjectDocument](Content) KEY INDEX [PK_ProjectDocument_JP];
--GO

/****** Object:  Table [dbo].[ProjectFunding]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectFunding](
	[ProjectFundingID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](1000) NOT NULL,	
	[ProjectID] [int] NOT NULL,
	[FundingOrgID] [int] NOT NULL,
	[FundingDivisionID] [int] NULL,
	[ProjectAbstractID] [int] NOT NULL,	
	[AltAwardCode] [varchar](500) NOT NULL,
	[Source_ID] [varchar](50) NULL,
	[IsAnnualized] [bit] NOT NULL,  -- 1 for Annualized, 0 for Lifetime
	[Amount] [float] NULL,
	[BudgetStartDate] [date] NULL,
	[BudgetEndDate] [date] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectFunding] PRIMARY KEY CLUSTERED 
(
	[ProjectFundingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[ProjectFundingExt]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectFundingExt](
	[ProjectFundingExtID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[AncestorProjectID] [int] NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarAmount] [float] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectFundingExt] PRIMARY KEY CLUSTERED 
(
	[ProjectFundingExtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ProjectFundingExt] ADD  CONSTRAINT [DF_ProjectFundingExt_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[ProjectFundingExt] ADD  CONSTRAINT [DF_ProjectFundingExt_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO


ALTER TABLE [dbo].[ProjectFundingExt]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFundingExt_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO

ALTER TABLE [dbo].[ProjectFundingExt] CHECK CONSTRAINT [FK_ProjectFundingExt_Project]
GO



/****** Object:  Table [dbo].[ProjectFundingInvestigator]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectFundingInvestigator](
	[ProjectFundingID] [int] NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[ORC_ID] [varchar](19) NULL,
	[IsPrivateInvestigator] [bit] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[InstitutionNameSubmitted] [varbinary](250) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectFundingInvestigator] PRIMARY KEY CLUSTERED 
(
	[ProjectFundingID] ASC,
	[InstitutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectGroup]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectGroup](
	[ProjectGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Group] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectGroup] PRIMARY KEY CLUSTERED 
(
	[ProjectGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectType]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectType](
	[ProjectTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectType] [varchar](15) NOT NULL,
	[IsShownOnMap] [bit] NOT NULL,
 CONSTRAINT [PK_ProjectType] PRIMARY KEY CLUSTERED 
(
	[ProjectType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RelatedProjects]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedProjects](
	[ProjectID] [int] NOT NULL,
	[RelatedProjectID] [int] NULL,
	[Relationship] [varchar](50) NOT NULL,
	[GroupID] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RelatedSites]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RelatedSites](
	[GeneralSiteID] [int] NOT NULL,
	[SpecificSiteID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[SearchCriteria]    Script Date: 12/29/2016 9:41:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchCriteria](
	[SearchCriteriaID] [int] IDENTITY(1,1) NOT NULL,
	[TermSearchType] [varchar](25) NULL,
	[Terms] [varchar](1000) NULL,
	[Institution] [varchar](250) NULL,
	[piLastName] [varchar](50) NULL,
	[piFirstName] [varchar](50) NULL,
	[piORCiD] [varchar](50) NULL,
	[AwardCode] [varchar](50) NULL,
	[YearList] [varchar](1000) NULL,
	[CityList] [varchar](1000) NULL,
	[StateList] [varchar](1000) NULL,
	[CountryList] [varchar](1000) NULL,
	[FundingOrgList] [varchar](1000) NULL,
	[CancerTypeList] [varchar](1000) NULL,
	[ProjectTypeList] [varchar](1000) NULL,
	[CSOList] [varchar](500) NULL,	
	[SearchByUserName] [varchar](100) NULL,
	[SearchDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SearchCriteria] PRIMARY KEY CLUSTERED 
(
	[SearchCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[SearchCriteria] ADD  CONSTRAINT [DF_SearchCriteria_CreatedDate]  DEFAULT (getdate()) FOR [SearchDate]
GO


/****** Object:  Table [dbo].[SearchResult]    Script Date: 1/6/2017 3:27:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SearchResult](
	[SearchCriteriaID] [int] NOT NULL,
	[Results] [varchar](max) NULL,
	[ResultCount] [int] NULL,
 CONSTRAINT [PK_SearchResult] PRIMARY KEY CLUSTERED 
(
	[SearchCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


/****** Object:  Table [dbo].[Sponsor]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sponsor](
	[SponsorID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Country] [varchar](3) NOT NULL,
	[Email] [varchar](75) NULL,
	[DisplayAltID] [smallint] NULL,
	[AltIDName] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Sponsor] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[State]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[StateID] [int] IDENTITY(1,1) NOT NULL,
	[Abbreviation] [varchar](3) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Country] [varchar](3) NOT NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


ALTER TABLE [dbo].[CancerType] ADD  CONSTRAINT [DF_CancerType_SortOrder]  DEFAULT ((1)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[CancerType] ADD  CONSTRAINT [DF_CancerType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CancerType] ADD  CONSTRAINT [DF_CancerType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[CSO] ADD  CONSTRAINT [DF_CSO_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CSO] ADD  CONSTRAINT [DF_CSO_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[CSOCategory] ADD  CONSTRAINT [DF_CSOCategory_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CSOCategory] ADD  CONSTRAINT [DF_CSOCategory_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Currency] ADD  CONSTRAINT [DF_Currency_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[CurrencyRate] ADD  CONSTRAINT [DF_CurrencyRate_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CurrencyRate] ADD  CONSTRAINT [DF_CurrencyRate_UPdatedDate]  DEFAULT (getdate()) FOR [UPdatedDate]
GO
ALTER TABLE [dbo].[FundingDivision] ADD  CONSTRAINT [DF_FundingDivision_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FundingDivision] ADD  CONSTRAINT [DF_FundingDivision_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[FundingMechanism] ADD  CONSTRAINT [DF_FundingMechanism_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FundingMechanism] ADD  CONSTRAINT [DF_FundingMechanism_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[FundingOrg] ADD  CONSTRAINT [DF_FundingOrg_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FundingOrg] ADD  CONSTRAINT [DF_FundingOrg_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Institution] ADD  CONSTRAINT [DF_Institution_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Institution] ADD  CONSTRAINT [DF_Institution_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[InstitutionType] ADD  CONSTRAINT [DF_InstitutionType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[InstitutionType] ADD  CONSTRAINT [DF_InstitutionType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Project] ADD  CONSTRAINT [DF_Project_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Project] ADD  CONSTRAINT [DF_Project_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[Project_ProjectType] ADD  CONSTRAINT [DF_Project_ProjectType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Project_ProjectType] ADD  CONSTRAINT [DF_Project_ProjectType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectAbstract] ADD  CONSTRAINT [DF_ProjectAbstract_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectAbstract] ADD  CONSTRAINT [DF_ProjectAbstract_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectCancerType] ADD  CONSTRAINT [DF_ProjectCancerType_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectCancerType] ADD  CONSTRAINT [DF_ProjectCancerType_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectCSO] ADD  CONSTRAINT [DF_ProjectCSO_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectCSO] ADD  CONSTRAINT [DF_ProjectCSO_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectFunding] ADD  CONSTRAINT [DF_ProjectFunding_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectFunding] ADD  CONSTRAINT [DF_ProjectFunding_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator] ADD  CONSTRAINT [DF_ProjectPrivateInvestigator_IsPrivateInvestigator]  DEFAULT ((0)) FOR [IsPrivateInvestigator]
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator] ADD  CONSTRAINT [DF_ProjectFundingInvestigator_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator] ADD  CONSTRAINT [DF_ProjectFundingInvestigator_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectGroup] ADD  CONSTRAINT [DF_ProjectGroup_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ProjectGroup] ADD  CONSTRAINT [DF_ProjectGroup_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[ProjectType] ADD  CONSTRAINT [DF_ProjectType_IsShownOnMap]  DEFAULT ((1)) FOR [IsShownOnMap]
GO
ALTER TABLE [dbo].[Sponsor] ADD  CONSTRAINT [DF_Sponsor_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Sponsor] ADD  CONSTRAINT [DF_Sponsor_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[CSO]  WITH CHECK ADD  CONSTRAINT [FK_CSO_CSOCategory] FOREIGN KEY([CategoryName])
REFERENCES [dbo].[CSOCategory] ([Name])
GO
ALTER TABLE [dbo].[CSO] CHECK CONSTRAINT [FK_CSO_CSOCategory]
GO
ALTER TABLE [dbo].[CurrencyRate]  WITH CHECK ADD  CONSTRAINT [FK_CurrencyRate_Currency] FOREIGN KEY([FromCurrency])
REFERENCES [dbo].[Currency] ([Code])
GO
ALTER TABLE [dbo].[CurrencyRate] CHECK CONSTRAINT [FK_CurrencyRate_Currency]
GO
ALTER TABLE [dbo].[CurrencyRate]  WITH CHECK ADD  CONSTRAINT [FK_CurrencyRate_Currency1] FOREIGN KEY([ToCurrency])
REFERENCES [dbo].[Currency] ([Code])
GO
ALTER TABLE [dbo].[CurrencyRate] CHECK CONSTRAINT [FK_CurrencyRate_Currency1]
GO
ALTER TABLE [dbo].[FundingDivision]  WITH CHECK ADD  CONSTRAINT [FK_FundingDivision_FundingOrg] FOREIGN KEY([FundingOrgID])
REFERENCES [dbo].[FundingOrg] ([FundingOrgID])
GO
ALTER TABLE [dbo].[FundingDivision] CHECK CONSTRAINT [FK_FundingDivision_FundingOrg]
GO
ALTER TABLE [dbo].[FundingOrg]  WITH CHECK ADD  CONSTRAINT [FK_FundingOrg_Country] FOREIGN KEY([Country])
REFERENCES [dbo].[Country] ([Abbreviation])
GO
ALTER TABLE [dbo].[FundingOrg] CHECK CONSTRAINT [FK_FundingOrg_Country]
GO
ALTER TABLE [dbo].[FundingOrg]  WITH CHECK ADD  CONSTRAINT [FK_FundingOrg_Currency] FOREIGN KEY([Currency])
REFERENCES [dbo].[Currency] ([Code])
GO
ALTER TABLE [dbo].[FundingOrg] CHECK CONSTRAINT [FK_FundingOrg_Currency]
GO
ALTER TABLE [dbo].[FundingOrg]  WITH CHECK ADD  CONSTRAINT [FK_FundingOrg_Sponsor] FOREIGN KEY([SponsorCode])
REFERENCES [dbo].[Sponsor] ([Code])
GO
ALTER TABLE [dbo].[FundingOrg] CHECK CONSTRAINT [FK_FundingOrg_Sponsor]
GO
ALTER TABLE [dbo].[Institution]  WITH CHECK ADD  CONSTRAINT [FK_Institution_InstitutionType] FOREIGN KEY([InstitutionType])
REFERENCES [dbo].[InstitutionType] ([Type])
GO
ALTER TABLE [dbo].[Institution] CHECK CONSTRAINT [FK_Institution_InstitutionType]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_FundingMechanism] FOREIGN KEY([FundingMechanismID])
REFERENCES [dbo].[FundingMechanism] ([FundingMechanismID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_FundingMechanism]
GO

ALTER TABLE [dbo].[ProjectDocument]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDocument_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[ProjectDocument] CHECK CONSTRAINT [FK_ProjectDocument_Project]
GO

ALTER TABLE [dbo].[ProjectDocument_JP]  WITH CHECK ADD  CONSTRAINT [FK_ProjectDocument_JP_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[ProjectDocument_JP] CHECK CONSTRAINT [FK_ProjectDocument_JP_Project]
GO
ALTER TABLE [dbo].[ProjectFunding]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFunding_ProjectAbstract] FOREIGN KEY([ProjectAbstractID])
REFERENCES [dbo].[ProjectAbstract] ([ProjectAbstractID])
GO
ALTER TABLE [dbo].[ProjectFunding] CHECK CONSTRAINT [FK_ProjectFunding_ProjectAbstract]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectGroup] FOREIGN KEY([ProjectGroupID])
REFERENCES [dbo].[ProjectGroup] ([ProjectGroupID])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_ProjectGroup]
GO
ALTER TABLE [dbo].[Project_ProjectType]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectType_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[Project_ProjectType] CHECK CONSTRAINT [FK_Project_ProjectType_Project]
GO
ALTER TABLE [dbo].[Project_ProjectType]  WITH CHECK ADD  CONSTRAINT [FK_Project_ProjectType_ProjectType] FOREIGN KEY([ProjectType])
REFERENCES [dbo].[ProjectType] ([ProjectType])
GO
ALTER TABLE [dbo].[Project_ProjectType] CHECK CONSTRAINT [FK_Project_ProjectType_ProjectType]
GO
ALTER TABLE [dbo].[ProjectCancerType]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCancerType_CancerType] FOREIGN KEY([CancerTypeID])
REFERENCES [dbo].[CancerType] ([CancerTypeID])
GO
ALTER TABLE [dbo].[ProjectCancerType] CHECK CONSTRAINT [FK_ProjectCancerType_CancerType]
GO
ALTER TABLE [dbo].[ProjectCancerType]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCancerType_ProjectFunding] FOREIGN KEY([ProjectFundingID])
REFERENCES [dbo].[ProjectFunding] ([ProjectFundingID])
GO
ALTER TABLE [dbo].[ProjectCancerType] CHECK CONSTRAINT [FK_ProjectCancerType_ProjectFunding]
GO
ALTER TABLE [dbo].[ProjectCSO]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCSO_CSO] FOREIGN KEY([CSOCode])
REFERENCES [dbo].[CSO] ([Code])
GO
ALTER TABLE [dbo].[ProjectCSO] CHECK CONSTRAINT [FK_ProjectCSO_CSO]
GO
ALTER TABLE [dbo].[ProjectCSO]  WITH CHECK ADD  CONSTRAINT [FK_ProjectCSO_ProjectFunding] FOREIGN KEY([ProjectFundingID])
REFERENCES [dbo].[ProjectFunding] ([ProjectFundingID])
GO
ALTER TABLE [dbo].[ProjectCSO] CHECK CONSTRAINT [FK_ProjectCSO_ProjectFunding]
GO
ALTER TABLE [dbo].[ProjectFunding]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFunding_FundingOrg] FOREIGN KEY([FundingOrgID])
REFERENCES [dbo].[FundingOrg] ([FundingOrgID])
GO
ALTER TABLE [dbo].[ProjectFunding] CHECK CONSTRAINT [FK_ProjectFunding_FundingOrg]
GO
ALTER TABLE [dbo].[ProjectFunding]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFunding_Project] FOREIGN KEY([ProjectID])
REFERENCES [dbo].[Project] ([ProjectID])
GO
ALTER TABLE [dbo].[ProjectFunding] CHECK CONSTRAINT [FK_ProjectFunding_Project]
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFundingInvestigator_Institution] FOREIGN KEY([InstitutionID])
REFERENCES [dbo].[Institution] ([InstitutionID])
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator] CHECK CONSTRAINT [FK_ProjectFundingInvestigator_Institution]
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFundingInvestigator_ProjectFunding] FOREIGN KEY([ProjectFundingID])
REFERENCES [dbo].[ProjectFunding] ([ProjectFundingID])
GO
ALTER TABLE [dbo].[ProjectFundingInvestigator] CHECK CONSTRAINT [FK_ProjectFundingInvestigator_ProjectFunding]
GO


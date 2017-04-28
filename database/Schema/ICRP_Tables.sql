
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
	[Description] [varchar](1000) NULL,
	[ICRPCode] [int] NOT NULL,
	[ICD10CodeInfo] [varchar](250) NULL,	
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


/****** Object:  Table [dbo].[CancerTypeRollUp]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CancerTypeRollUp](
	[CancerTypeRollUpID] [int] NOT NULL,
	[CancerTypeID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CancerTypeRollUp] ADD  CONSTRAINT [DF_CancerTypeRollUp_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[CancerTypeRollUp] ADD  CONSTRAINT [DF_CancerTypeRollUp_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

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
	[IsActive] [bit] NOT NULL, 
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CSO] PRIMARY KEY CLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[CSO] ADD  CONSTRAINT [DF_CSO_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

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

/****** Object:  Table [dbo].[FundingOrg]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FundingOrg](
	[FundingOrgID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Abbreviation] [varchar](15) NOT NULL,
	[Type] [varchar](25) NULL,
	[Country] [varchar](3) NOT NULL,
	[Currency] [varchar](3) NOT NULL,
	[SponsorCode] [varchar](50) NOT NULL,
	[MemberType] [varchar](25) NOT NULL,
	[MemberStatus] [nchar](10) NULL,
	[IsAnnualized] [bit] NOT NULL,	
	[Note] [varchar](8000) NULL,
	[LastImportDate] [datetime] NULL,
	[LastImportDesc] [varchar](1000) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_FundingOrg] PRIMARY KEY CLUSTERED 
(
	[FundingOrgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[PartnerOrg]    Script Date: 3/10/2017 1:39:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PartnerOrg](
	[PartnerOrgID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[SponsorCode] [varchar](50) NOT NULL,
	[MemberType] [varchar](25) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PartnerOrg] PRIMARY KEY CLUSTERED 
(
	[PartnerOrgID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[PartnerOrg] ADD  CONSTRAINT [DF_PartnerOrg_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO

ALTER TABLE [dbo].[PartnerOrg] ADD  CONSTRAINT [DF_PartnerOrg_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PartnerOrg] ADD  CONSTRAINT [DF_PartnerOrg_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO



/****** Object:  Table [dbo].[Institution]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Institution](
	[InstitutionID] [int] IDENTITY(1,1) NOT NULL,	
	[Name] [varchar](250) NOT NULL,		
	[Type] [varchar](25) NULL,  -- Academic, Government, Non-profit, Industry, Other
	[Longitude] [decimal](9, 6) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Postal] [varchar](15) NULL,
	[City] [varchar](50) NOT NULL,
	[State] [varchar](3) NULL,
	[Country] [varchar](3) NULL,
	[GRID] [varchar](250) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Institution] PRIMARY KEY CLUSTERED 
(
	[InstitutionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[InstitutionMapping]    Script Date: 12/13/2016 6:23:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InstitutionMapping] (
	[InstitutionMappingID] [int] IDENTITY(1,1) NOT NULL,	
	[OldName] [varchar](250) NOT NULL,		
	[OldCity] [varchar](50) NULL,
	[NewName] [varchar](250) NOT NULL,		
	[NewCity] [varchar](50) NOT NULL,
 CONSTRAINT [PK_InstitutionMapping] PRIMARY KEY CLUSTERED 
(
	[InstitutionMappingID] ASC
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
	[IsChildhood] [bit] NULL,
	[AwardCode] [nvarchar](50) NOT NULL,		
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
	--[Code] [varchar](1) NOT NULL,
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
	[TechAbstract] [nvarchar](max) NOT NULL,	
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
	[Relevance] [float] NULL,
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
	[Relevance] [float] NULL,
	[RelSource] [char](1) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectCSO] PRIMARY KEY CLUSTERED 
(
	[ProjectCSOID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProjectSearch]    Script Date: 12/13/2016 6:23:53 PM ******/
CREATE TABLE [dbo].[ProjectSearch](
	[ProjectSearchID] [int] IDENTITY(1,1) NOT NULL,
	[ProjectID] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ProjectSearch] PRIMARY KEY CLUSTERED 
(
	[ProjectSearchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE FULLTEXT CATALOG ftCatalog_ProjectSearch AS DEFAULT;  
GO  
--CREATE FULLTEXT INDEX ON ProjectSearch.Content(Resume) 
--	KEY INDEX [PK_ProjectSearch];  
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
	[DataUploadStatusID] [int] NULL,
	[Category] [varchar](25) NULL,  -- Parent, Supplement, SubProject
	[AltAwardCode] [varchar](50) NOT NULL,
	[Source_ID] [varchar](50) NULL,
	[MechanismCode] [varchar](30) NULL,
	[MechanismTitle] [varchar](200) NULL,	
	[FundingContact] [varchar](200) NULL,	
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
	[ProjectFundingID] [int] NOT NULL,
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


ALTER TABLE [dbo].[ProjectFundingExt]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFundingExt_ProjectFunding] FOREIGN KEY([ProjectFundingID])
REFERENCES [dbo].[ProjectFunding] ([ProjectFundingID])
GO

ALTER TABLE [dbo].[ProjectFundingExt] CHECK CONSTRAINT [FK_ProjectFundingExt_ProjectFunding]
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
	[OtherResearch_ID] [int] NULL,
	[OtherResearch_Type] [varchar] (50) NULL,
	[IsPrivateInvestigator] [bit] NOT NULL,
	[InstitutionID] [int] NOT NULL,
	[InstitutionNameSubmitted] [varchar](250) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_ProjectFundingInvestigator] PRIMARY KEY CLUSTERED 
(
	[ProjectFundingID] ASC,
	[InstitutionID] ASC
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
	[IsEmailSent] [bit] NULL,
 CONSTRAINT [PK_SearchResult] PRIMARY KEY CLUSTERED 
(
	[SearchCriteriaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

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


ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK_State_Country] FOREIGN KEY([Country])
REFERENCES [dbo].[Country] ([Abbreviation])
GO

ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK_State_Country]
GO

/************************************************************************************/
/*  PartnerApplication Tables																	*/
/************************************************************************************/

/****** Object:  Table [dbo].[PartnerApplication]    Script Date: 1/25/2017 5:45:49 PM ******/
CREATE TABLE [dbo].[PartnerApplication](
	[PartnerApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationStatus] [varchar](25) NULL,
	[OrgName] [varchar](100) NULL,
	[OrgAddr1] [varchar](100) NULL,
	[OrgAddr2] [varchar](100) NULL,
	[OrgCity] [varchar](50) NULL,
	[OrgState] [varchar](25) NULL,
	[OrgCountry] [varchar](255) NULL,
	[OrgZip] [varchar](25) NULL,
	[OrgEDPCName] [varchar](50) NULL,
	[OrgEDPCPosition] [varchar](50) NULL,
	[OrgEDPCPhone] [varchar](50) NULL,
	[OrgEDPCEmail] [varchar](50) NULL,
	[OrgMissionDesc] [varchar](max) NULL,
	[OrgProfileDesc] [varchar](max) NULL,
	[OrgInitYear] [varchar](4) NULL,
	[BudgetCurrInvestment] [varchar](20) NULL,
	[BudgetReportPeriod] [varchar](20) NULL,
	[BudgetCurrOperating] [varchar](20) NULL,
	[BudgetNumProjects] [smallint] NULL,
	[BudgetTier] [smallint] NULL,
	[MemberPaymentMonth] [int] NULL,
	[ContactName] [varchar](50) NULL,
	[ContactPosition] [varchar](50) NULL,
	[ContactPhone] [varchar](50) NULL,
	[ContactEmail] [varchar](50) NULL,
	[ContactAddr1] [varchar](50) NULL,
	[ContactAddr2] [varchar](50) NULL,
	[ContactCity] [varchar](50) NULL,
	[ContactState] [varchar](50) NULL,
	[ContactCountry] [varchar](255) NULL,
	[ContactZip] [varchar](25) NULL,
	[ICRPTerm1] [tinyint] NULL,
	[ICRPTerm2] [tinyint] NULL,
	[ICRPTerm3] [tinyint] NULL,
	[ICRPTerm4] [tinyint] NULL,
	[ICRPTerm5] [tinyint] NULL,
	[ICRPTerm6] [tinyint] NULL,
	[ICRPTerm7] [tinyint] NULL,
	[ICRPTerm8] [tinyint] NULL,
	[ICRPTerm9] [tinyint] NULL,
	[SupplLetterFile] [varchar](100) NULL,
	[SupplDocFile] [varchar](100) NULL,
	[IsCompleted] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_PartnerApplication] PRIMARY KEY CLUSTERED 
(
	[PartnerApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[PartnerApplication] ADD  CONSTRAINT [DF_PartnerApplication_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[PartnerApplication] ADD  CONSTRAINT [DF_PartnerApplication_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

/****** Object:  Table [dbo].[Partner]    Script Date: 1/25/2017 5:45:49 PM ******/
CREATE TABLE [dbo].[Partner](
	[PartnerID] [int] IDENTITY(1,1) NOT NULL,	
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[SponsorCode] [varchar](50) NOT NULL,
	[Email] [varchar](75) NULL,
	[IsDSASigned] [bit] NULL,
	[Country] [varchar](100) NULL,
	[Website] [varchar](200) NULL,
	[LogoFile] [varchar](100) NULL,
	[MapCoords] [varchar](50) NULL,
	[Note] [varchar](8000) NULL,
	[JoinedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Partner] PRIMARY KEY CLUSTERED 
(
	[PartnerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UX_Partner_SponsorCode] UNIQUE NONCLUSTERED 
(
	[SponsorCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[Partner] ADD  CONSTRAINT [DF_Partner_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Partner] ADD  CONSTRAINT [DF_Partner_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

/****** Object:  Table [dbo].[DataUploadLog]    Script Date: 4/12/2017 2:01:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DataUploadLog](
	[DataUploadLogID] [int] IDENTITY(1,1) NOT NULL,
	[DataUploadStatusID] [int] NOT NULL,
	[ProjectCount] [int] NULL,
	[ProjectFundingCount] [int] NULL,
	[ProjectFundingInvestigatorCount] [int] NULL,
	[ProjectCSOCount] [int] NULL,
	[ProjectCancerTypeCount] [int] NULL,
	[Project_ProjectTypeCount] [int] NULL,
	[ProjectAbstractCount] [int] NULL,
	[ProjectSearchCount] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DataUploadLog] PRIMARY KEY CLUSTERED 
(
	[DataUploadLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[DataUploadLog] ADD  CONSTRAINT [DF_DataUploadLog_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


/************************************************************************************/
/*  Library Tables																	*/
/************************************************************************************/

/****** Object:  Table [dbo].[Library]    Script Date: 1/30/2017 11:22:17 AM ******/
CREATE TABLE [dbo].[Library](
	[LibraryID] [int] IDENTITY(1,1) NOT NULL,
	[LibraryFolderID] [int] NULL,
	[Filename] [varchar](150) NULL,
	[ThumbnailFilename] [varchar](150) NULL,
	[DisplayName] [varchar](150) NULL,
	[Title] [varchar](150) NULL,
	[Description] [varchar](1000) NULL,	
	[IsPublic] bit NOT NULL,
	[ArchivedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Library] PRIMARY KEY CLUSTERED 
(
	[LibraryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[LibraryFolder](
	[LibraryFolderID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](200) NOT NULL,
	[ParentFolderID] [int] NULL,
	[IsPublic] bit NOT NULL,	
	[ArchivedDate] [datetime] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_LibraryFolder] PRIMARY KEY CLUSTERED 
(
	[LibraryFolderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


/************************************************************************************/
/*  DataUploadStatus																	*/
/************************************************************************************/
CREATE TABLE [dbo].[DataUploadStatus](
	[DataUploadStatusID] [int] IDENTITY(1,1) NOT NULL,
	[PartnerCode] [varchar](100) NULL,
	[FundingYear] [varchar](50) NULL,
	[Type] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[ReceivedDate] [date] NULL,
	[ValidationDate] [date] NULL,
	[UploadToDevDate] [date] NULL,
	[UploadToStageDate] [date] NULL,
	[UploadToProdDate] [date] NULL,
	[Note] [varchar](max) NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DataUploadStatus] PRIMARY KEY CLUSTERED 
(
	[DataUploadStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[DataUploadStatus] ADD  CONSTRAINT [DF_DataUploadStatus_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO


/****** Object:  Table [dbo].[lu_FundingOrgType]    Script Date: 4/21/2017 9:30:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[lu_FundingOrgType](
	[FundingOrgTypeID] [int] NOT NULL,
	[FundingOrgType] [varchar](50) NOT NULL	
 CONSTRAINT [PK_FundingOrgType] PRIMARY KEY CLUSTERED 
(
	[FundingOrgTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




/****** Object:  Table [dbo].[ProjectDetails]    Script Date: 1/10/2017 5:08:05 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--CREATE TABLE [dbo].[ProjectDetails] (
--	ProjectID INT NULL, 
--	AwardCode [varchar](50) NULL, 
--	ProjectFundingID INT NULL,
--	Title [varchar](1000) NULL,
--	piLastName [varchar](50) NULL, 
--	piFirstName [varchar](50) NULL,
--	piORCiD [varchar](50) NULL,
--	Institution [varchar](250) NULL,
--	Amount float,
--	City [varchar](100) NULL,
--	State [varchar](3) NULL, 
--	Country [varchar](3) NULL,
--	FundingOrgID INT NULL,
--	FundingOrg [varchar](100) NULL,
--	ProjectType [varchar](50) NULL,
--	CancerTypeID INT NULL,
--	CancerType [varchar](100) NULL,
--	CSOCode [varchar](50) NULL,
--	CalendarYear INT NULL
--	) 


/****** Relationships ******/
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
ALTER TABLE [dbo].[Institution] ADD  CONSTRAINT [DF_Institution_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Institution] ADD  CONSTRAINT [DF_Institution_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
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
ALTER TABLE [dbo].[ProjectType] ADD  CONSTRAINT [DF_ProjectType_IsShownOnMap]  DEFAULT ((1)) FOR [IsShownOnMap]
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

ALTER TABLE [dbo].[ProjectFunding]  WITH CHECK ADD  CONSTRAINT [FK_ProjectFunding_ProjectAbstract] FOREIGN KEY([ProjectAbstractID])
REFERENCES [dbo].[ProjectAbstract] ([ProjectAbstractID])
GO
ALTER TABLE [dbo].[ProjectFunding] CHECK CONSTRAINT [FK_ProjectFunding_ProjectAbstract]
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

ALTER TABLE [dbo].[FundingOrg] ADD  CONSTRAINT [DF_FundingOrg_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[FundingOrg] ADD  CONSTRAINT [DF_FundingOrg_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
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

ALTER TABLE [dbo].[FundingOrg]  WITH CHECK ADD  CONSTRAINT [FK_FundingOrg_FundingOrg] FOREIGN KEY([SponsorCode])
REFERENCES [dbo].[Partner] ([SponsorCode])
GO

ALTER TABLE [dbo].[FundingOrg] CHECK CONSTRAINT [FK_FundingOrg_FundingOrg]
GO

ALTER TABLE [dbo].[LibraryFolder] ADD  CONSTRAINT [DF_LibraryFolder_IsPublic]  DEFAULT ((0)) FOR [IsPublic]
GO

ALTER TABLE [dbo].[LibraryFolder] ADD  CONSTRAINT [DF_LibraryFolder_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[LibraryFolder] ADD  CONSTRAINT [DF_LibraryFolder_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO


ALTER TABLE [dbo].[Library] ADD  CONSTRAINT [DF_Library_IsPublic]  DEFAULT ((0)) FOR [IsPublic]
GO

ALTER TABLE [dbo].[Library] ADD  CONSTRAINT [DF_Library_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Library] ADD  CONSTRAINT [DF_Library_UpdatedDate]  DEFAULT (getdate()) FOR [UpdatedDate]
GO

ALTER TABLE [dbo].[Library]  WITH CHECK ADD  CONSTRAINT [FK_Library_LibraryFolder] FOREIGN KEY([LibraryFolderID])
REFERENCES [dbo].[LibraryFolder] ([LibraryFolderID])
GO

ALTER TABLE [dbo].[Library] CHECK CONSTRAINT [FK_Library_LibraryFolder]
GO

/************************************************************************************/
/*  Fulltext Index Catelog   */
/************************************************************************************/
--DROP FULLTEXT INDEX ON   --dropping the existing full-text index
--GO

--CREATE FULLTEXT INDEX on ProjectDocument
--(Content) KEY index primarykey ON catalog_ProjectDocument_Content

--CREATE FULLTEXT INDEX on ProjectDocument_JP
--(Content) KEY index primarykey ON catalog_ProjectDocumentJP_Content

sp_configure 'show advanced options', 1;  
RECONFIGURE;  
GO  
sp_configure 'transform noise words', 1;  
RECONFIGURE;  
GO  

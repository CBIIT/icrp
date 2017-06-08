----------------------------
-- REstart - del all temp tables 
-----------------------------
--drop table UploadWorkBook
-- go

----------------------------
-- Load Workbook 
-----------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE UploadWorkBook (	
	AwardCode NVARCHAR(50),
	AwardStartDate Date,
	AwardEndDate date,
	SourceId VARCHAR(50),
	AltId VARCHAR(50),
	AwardTitle VARCHAR(1000),
	Category VARCHAR(25),
	AwardType VARCHAR(50),
	Childhood VARCHAR(5),
	BudgetStartDate date,
	BudgetEndDate date,
	CSOCodes VARCHAR(500),
	CSORel VARCHAR(500),
	SiteCodes VARCHAR(500),
	SiteRel VARCHAR(500),
	AwardFunding float,
	IsAnnualized VARCHAR(1),
	FundingMechanismCode VARCHAR(30),
	FundingMechanism VARCHAR(200),
	FundingOrgAbbr VARCHAR(50),
	FundingDiv VARCHAR(75),
	FundingDivAbbr VARCHAR(50),
	FundingContact VARCHAR(50),
	PILastName VARCHAR(50),
	PIFirstName VARCHAR(50),
	SubmittedInstitution VARCHAR(250),
	City VARCHAR(50),
	State VARCHAR(3),
	Country VARCHAR(3),
	PostalZipCode VARCHAR(15),
	InstitutionICRP VARCHAR(4000),
	Latitute decimal(9,6),
	Longitute decimal(9,6),
	GRID VARCHAR(50),
	TechAbstract NVARCHAR(max),
	PublicAbstract NVARCHAR(max),
	RelatedAwardCode VARCHAR(200),
	RelationshipType VARCHAR(200),
	ORCID VARCHAR(25),
	OtherResearcherID INT,
	OtherResearcherIDType VARCHAR(1000),
	InternalUseOnly  NVARCHAR(MAX)
)

GO

BULK INSERT UploadWorkBook
FROM 'C:\icrp\database\DataUpload\ICRPDataSubmission_New_NCI_20170608.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from UploadWorkBook
-----------------------------------
-- Workbook Datafix - Institution  -- KOMEN
-----------------------------------
--begin transaction
--update uploadworkbook set city ='Amherst Center' where InstitutionICRP='University of Massachusetts Amherst'
--update uploadworkbook set city ='Stanford' where InstitutionICRP='Stanford University'
--commit

-----------------------------------
-- Workbook Datafix -- CCRA
-----------------------------------
--UPDATE UploadWorkBook SET TechAbstract = 'I propose to develop statistical methods to (1) assess the performance of diagnostic tests and prognostic scores and (2) estimate risk (cumulative incidence) functions and, from them, individualized ''what if'' probabilities of benefit if a specific medical or lifestyle intervention is selected. In aim (1) the primary focus will be on the ''c'' statistic derived from multiple logistic regression. The initial biostatistical use of c was as the area under the roc curve (auc), to measure the discriminant ability of imaging tests (interpreted on a rating scale) and laboratory tests (measured on an interval scale). However, the index is also standard output from the SAS (multiple) LOGISTIC procedure and is increasingly used to assess the ability of diagnostic and prognostic scoring systems derived from a vector of predictors. If calculated from the same data from which the model is fitted, the statistic overestimates the true performance of the system. Indeed, by construction, the c statistic calculated from PROC LOGISTIC cannot be less than the null 0.5. Several authors (from Cornfield and Lachenbruch several decades ago, to Copas, Rockette, and Pinsky recently) have studied the factors that determine the magnitude of this bias. I propose to develop a simple ''adjusted-c'' statistic, similar to the adjusted-r-squared statistic. I expect that the needed attenuation/shrinkage will be a function of the numbers of cases and non-cases, and the numbers of useful - and useless - candidate predictor variables. A secondary focus will be on simplified lower confidence bound for the true auc when - in the simple imaging or laboratory test situations - the observed auc is unity. Obuchowshi has provided limits for this situation, but unfortunately they are too distribution-specific to be of general use. My plan is to draw on the simplicity and closed-form formulae based on overlapping exponential distributions, and on the insights on the var(auc) structure in our paper in Academic Radiology in 1997. Aim (2) has two parts. The first is to develop guidelines for a novel way (developed with my colleague Miettinen) to fit smooth-in-time hazard functions to survival-type data, where the event E=1 represents an undesirable outcome. The purpose is to estimate cumulative incidence as a function of a vector of patient characteristics and lifestyle/medical management options. The approach is based on sampling the person-moments; the main unknown is the choice of the sampling approach that gives the most stable estimate of the individualized cumulative incidence. The second aim is to derive an interval estimate for the probability of benefit within a time horizon T, for an individual with a personal profile vector x, and contemplated medical/behavioral Action (A=1) or not (A=0), i.e. the difference Prob[E=1 | x, T, A=0] - Prob[E=1 | x, T,A=1]. The hope is to have the individualized interval be test-based, so that it can be calculated from the information usually contained in study reports. We focus on individualized risk differences as a response to the inordinate emphasis on the ''average'' patient and on hazard ratios rather than what matters to an individual: for individuals such as I, with profile x, what is the difference in the probability of E over a time-horizon T if I choose one action over another? As an example, consider the 2005 NEJM report on an RCT which documented the extent to which radical prostatectomy reduces the risk of death from prostate cancer: the ''average'' prostate cancer case-fatality rate within 10 years was 15% for those randomized to watchful waiting and 10% for those randomized to surgery; the hazard ratio was 0.55. The report contained no useful information for men with a patient/tumour profile (age at diagnosis, Gleason score, pre-treatment PSA level) that was more/less favourable than the ''average'' profile to which the summary results presumably apply. With methods that are aimed at individualized risk, and that do not rely on the non-smooth estimates obtained from Cox''s proportional hazards model, we plan to change the contemporary culture of statistical reporting to be more responsive to individual ''clients''.'
--WHERE AltId = '10769_1'

--UPDATE UploadWorkBook SET TechAbstract = 'The program of research addressing five research aims, was undertaken by a research team (organized into the Evidence Expert Panel, Best Practices Expert Panel and the main Scientific Office): Research Aims: 1. Using existing KT resources, to identify and analyze high quality systematic reviews and guidelines (e.g. Cochrane Review) in the published literature evaluating the effectiveness of interventions directed to change behaviour across stakeholder groups. A measurement tool to operationalize the degree of KT intervention effectiveness was developed. 2. Using a targeted review, to analyze selected frameworks, models and theories that may be useful in directing KT strategy, planning, and practice to improve quality in cancer control. 3. Using key informant interviews and questionnaire methodologies, to identify best Canadian KT practices in use, being tested or targeted to improve cancer control. A tool to operationalize the concept of ‘best practices’ was developed. 4. Using consensus methodology, findings from Aims 1 to 3 will be integrated to identify gaps and priorities in the KT research field as it relates to improving cancer control. 5. The planning and implementation of a strategy to facilitate the use and application of the findings using integrated- and end-of-grant KT principles. Final Reports: 1. Knowledge Translation for Cancer Control in Canada: A Casebook. 2. Knowledge translation to improve quality of cancer control in Canada: What we know and what is next. Publication: Brouwers MC, Makarski J, Garcia K, Bouseh S, Hafid T. Improving cancer control in Canada one case at a time: the "Knowledge Translation in Cancer" casebook. Curr Oncol. 2011;18(2):76-83. PubMed PMID: 21505598; PubMed Central PMCID: PMC3070706 PDF | APPENDIX A | APPENDIX B | HTML Brouwers MC; Garcia K; Makarski J; Daraz L; of the Evidence Expert Panel and of the KT for Cancer Control in Canada Project Research Team. The landscape of knowledge translation interventions in cancer control: What do we know and where to next? A review of systematic reviews. Implementation Science 2011, 6, 130. doi:10.1186/1748-5908-6-130 PDF | HTML'
--WHERE AltId = '18497_1'

-------------------------------------------------------------------
-- Insert New Institutions if Any -- KOMEN
-------------------------------------------------------------------
--IF NOT EXISTS (SELECT * FROM Institution WHERE Name = 'Martin Luther University Halle-Wittenberg' AND City='Halle')
--	INSERT INTO Institution VALUES('Martin Luther University Halle-Wittenberg', NULL, 51.486389, 11.968889,NULL, 'Halle', NULL, 'DE','grid.9018.0', getdate(), getdate())

-------------------------------------------------------------------
-- Insert New Funding Organizations if any
-------------------------------------------------------------------


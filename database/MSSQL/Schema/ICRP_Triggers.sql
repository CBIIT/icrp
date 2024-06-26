-- Moved the triggered action to the [AddPartner] SP

IF OBJECT_ID(N'Trigger_Add_Partner', N'TR') IS NOT NULL  
    DROP TRIGGER Trigger_Add_Partner;  
GO 

--CREATE TRIGGER Trigger_Add_Partner
--ON Partner 
--AFTER INSERT
--AS  
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--	-- Insert the newly inserted partner into the PartnerOrg table
--	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
--	SELECT [Name], [SponsorCode], 'Partner', 1 FROM INSERTED

--	-- Insert the newly inserted partner into the icrp_dataload database
--	INSERT INTO icrp_dataload.dbo.Partner ([Name], [Description],[SponsorCode],[Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate],[Latitude], [Longitude])
--	SELECT [Name], [Description],[SponsorCode],[Email], [IsDSASigned], [Country], [Website], [LogoFile], [Note], [JoinedDate], Latitude, Longitude FROM INSERTED

--GO  

-- Moved the triggered action to the [AddFundingOrg] SP

IF OBJECT_ID(N'Trigger_Add_FundingOrg', N'TR') IS NOT NULL  
    DROP TRIGGER Trigger_Add_FundingOrg;  
GO 

--CREATE TRIGGER Trigger_Add_FundingOrg
--ON FundingOrg 
--AFTER INSERT
--AS  
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--	-- Insert the newly inserted fundingorg into the PartnerOrg table
--	INSERT INTO PartnerOrg ([Name], [SponsorCode], [MemberType], [IsActive])
--	SELECT [Name], [SponsorCode], 'Associate', 1 FROM INSERTED WHERE MemberStatus = 'Current' AND MemberType = 'Associate'

--	-- Insert the newly inserted fundingorg into the icrp_dataload database
--	INSERT INTO icrp_dataload.dbo.FundingOrg ([Name],[Abbreviation],[Type],[Country],[Currency],[SponsorCode],[MemberType],[MemberStatus],[IsAnnualized],[Note],[LastImportDate],[LastImportDesc],[CreatedDate],[UpdatedDate],[Website],[Latitude], [Longitude])
--	SELECT [Name],[Abbreviation],[Type],[Country],[Currency],[SponsorCode],[MemberType],[MemberStatus],[IsAnnualized],[Note],[LastImportDate],[LastImportDesc],[CreatedDate],[UpdatedDate],[Website], Latitude, Longitude FROM INSERTED
--GO  
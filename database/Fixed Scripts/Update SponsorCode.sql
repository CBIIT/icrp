select * from FundingOrg where name = 'Oncology Nursing Society Foundation' 
select * from FundingOrg where sponsorcode = 'ONS' 

begin transaction
ALTER TABLE dbo.[FundingOrg]   
DROP CONSTRAINT [FK_FundingOrg_FundingOrg];   
GO  

update FundingOrg set sponsorcode='ONSF' where sponsorcode='ONS'
update Partner set sponsorcode='ONSF' where sponsorcode='ONS'
update PartnerOrg set sponsorcode='ONSF' where sponsorcode='ONS'
update DataUploadStatus set partnercode='ONSF' where partnercode='ONS'

ALTER TABLE [dbo].[FundingOrg]  WITH CHECK ADD  CONSTRAINT [FK_FundingOrg_Partner] FOREIGN KEY([SponsorCode])
REFERENCES [dbo].[Partner] ([SponsorCode])
GO

ALTER TABLE [dbo].[FundingOrg] CHECK CONSTRAINT [FK_FundingOrg_Partner]
GO

--commit
rollback
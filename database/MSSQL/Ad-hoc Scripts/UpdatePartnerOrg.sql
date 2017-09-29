-- 9/28/2017
-- Update Partner
Select * from Partner
select * from partnerorg where membertype='partner'

SELECT * FROM Partner WHERE SponsorCode='AVONFDN'
SELECT * FROM Partner WHERE SponsorCode='KWF'
SELECT * FROM Partner WHERE SponsorCode='INCa'

SELECT * FROM PartnerOrg WHERE SponsorCode='AVONFDN'
SELECT * FROM PartnerOrg WHERE SponsorCode='KWF'
SELECT * FROM PartnerOrg WHERE SponsorCode='INCa'

SELECT * FROM icrp_data_dev.dbo.PartnerOrg WHERE SponsorCode='AVONFDN'
SELECT * FROM icrp_data_dev.dbo.PartnerOrg WHERE SponsorCode='KWF'
SELECT * FROM icrp_data_dev.dbo.PartnerOrg WHERE SponsorCode='INCa'

BEGIN TRANSACTION

UPDATE Partner SET Name = 'AVON Breast Cancer Crusade' WHERE SponsorCode='AVONFDN'
UPDATE Partner SET Name = 'Dutch Cancer Society (KWF)' WHERE SponsorCode='KWF'
UPDATE Partner SET Name = 'French National Cancer Institute (INCa)' WHERE SponsorCode='INCa'

UPDATE PartnerOrg SET Name = 'AVON Breast Cancer Crusade' WHERE SponsorCode='AVONFDN' AND MemberType = 'Partner' 
UPDATE PartnerOrg SET Name = 'Dutch Cancer Society (KWF)' WHERE SponsorCode='KWF' AND MemberType = 'Partner' 
UPDATE PartnerOrg SET Name = 'French National Cancer Institute (INCa)' WHERE SponsorCode='INCa' AND MemberType = 'Partner' 

COMMIT

BEGIN TRANSACTION
UPDATE Partner SET JoinedDate = '1/1/2000' WHERE SponsorCode IN ('ACS', 'CBCRP','CDMRP','KOMEN','NCRI','NIH','ONSF')
COMMIT


-- Update FundingOrg
Select * from FundingOrg WHERE Abbreviation IN ('AVONFDN', 'AT')
select * from partnerorg where membertype='Associate' and SponsorCode IN ('NIH', 'AVONFDN')

BEGIN TRANSACTION
UPDATE FundingOrg SET Name = 'AVON Breast Cancer Crusade' WHERE SponsorCode='AVONFDN' AND Abbreviation = 'AVONFDN'
UPDATE FundingOrg SET Name = 'National Center for Complementary and Integrative Health' WHERE SponsorCode='NIH' AND Abbreviation = 'AT'


UPDATE PartnerOrg SET Name = 'AVON Breast Cancer Crusade' WHERE Name ='Avon Foundation for Women' AND MemberType = 'Associate'
UPDATE PartnerOrg SET Name = 'National Center for Complementary and Integrative Health' WHERE Name ='National Center for Complementary and Alternative Medicine' AND MemberType = 'Associate'

COMMIT






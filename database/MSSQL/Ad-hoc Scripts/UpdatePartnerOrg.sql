  insert into PartnerOrg VALUES ('A Kids'' Brain Tumor Cure Foundation', 'CAC2', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('Be Strong, Fight On!', 'CAC2', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('Bear Necessities Pediatric Cancer Foundation', 'CAC2', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('Elaine Roberts Foundation', 'CAC2', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('Flashes of Hope', 'CAC2', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('I Care I Cure', 'CAC2', 'Associate', 1, getdate(), getdate())
  update PartnerOrg SET Name='Noah�s Light Foundation' WHERE PartnerOrgID=11

  insert into PartnerOrg VALUES ('Pancreatic Cancer Research Fund', 'NCRI', 'Associate', 1, getdate(), getdate())
  insert into PartnerOrg VALUES ('Breast Cancer Now', 'NCRI', 'Associate', 1, getdate(), getdate())
  update PartnerOrg SET Name='Alberta Innovates' WHERE PartnerOrgID=20
  update PartnerOrg SET Name='Fondation du cancer du sein du Qu�bec / Quebec Breast Cancer Foundation' WHERE PartnerOrgID=38
  update PartnerOrg SET Name='Bloodwise' WHERE PartnerOrgID=81
  update PartnerOrg SET Name='Worldwide Cancer Research' WHERE PartnerOrgID=73
  update PartnerOrg SET Name='Health and Care Research Wales' WHERE PartnerOrgID=92

  update PartnerOrg SET IsActive= 0 WHERE PartnerOrgID=75
  update PartnerOrg SET IsActive= 0 WHERE PartnerOrgID=76

--  select * from PartnerOrg where SponsorCode='ncri'
-- Data Fix for icrp 2.0 
begin transaction
update institutionmapping set newname = 'Ontario Institute for Cancer Research (OICR)' where oldname like 'Ontario%' AND newname='University Health Network'
update institutionmapping set newname = 'Princess Margaret Cancer Centre - University Health Network' where oldname like 'Princess Margaret %' AND newname='University Health Network'
update institutionmapping set newname = 'University Health Network' where oldname like 'Toronto %' AND newname='University Health Network'
update institutionmapping set newname = 'University Health Network' where oldname like 'University  %' AND newname='University Health Network'
update institutionmapping set newname = 'Ontario Institute for Cancer Research (OICR)' where oldname = 'University Health Network, Ontario Cancer Institute' AND newname='University Health Network'
update institutionmapping set newname = 'Princess Margaret Cancer Centre - University Health Network' where oldname = 'University Health Network, PMH/OCI, UofToronto' AND newname='University Health Network'
update institutionmapping set newname = 'Princess Margaret Cancer Centre - University Health Network' where oldname = 'University Health Network Princess Margaret Hospital' AND newname='University Health Network'

delete institutionmapping where oldname=newname and oldcity=newcity

commit


begin transaction
update institution set latitude=53.370429, longitude=-3.094562, grid='grid.449813.3' where name ='Wirral University Teaching Hospital NHS Foundation Trust'
commit


select * from institution where name like 'Centre Georges%' 
select * from institution where name like 'Helmholtz Zentrum%' 
select * from institution where name like 'Institut Catal%' and city ='Barcelona'
select * from institution where name like 'Institut Hospital del Mar%' and city ='Barcelona'  -- Institut Hospital del Mar d'Investigacions MÃ¨diques


-- fixed encoding errors - done in prod
begin transaction
update institution set name ='Centre Georges François Leclerc' where name like 'Centre Georges%' 
update institution set name ='Helmholtz Zentrum München (HZ)' where name like 'Helmholtz Zentrum%' 
update institution set name ='Institut Català d''Oncologia' where name like 'Institut Catal%' and city ='Barcelona'
update institution set name ='Institut Hospital del Mar d''Investigacions Mèdiques' where name like 'Institut Hospital del Mar%' and city ='Barcelona'

commit


-- delete institutions
begin transaction
select * from institution where name like 'yale%'  -- keep 4185, delete 4184  
update ProjectFundingInvestigator set institutionid= 4185 where institutionid =4184
delete institution where institutionid =4184

select * from institution where name in ('Vivonetics', 'VIVONETICS, INC.')  -- keep 3829, delete 4181
update ProjectFundingInvestigator set institutionid= 3829 where institutionid =4181
delete institution where institutionid =4181

select * from institution where name like 'UNIVERSITY OF UTAH%'   -- keep 4176, delete 4175
update ProjectFundingInvestigator set institutionid= 4176 where institutionid =4175
delete institution where institutionid =4175

select * from institution where name like 'University of Michigan%'   -- keep 4167, delete 4166
update ProjectFundingInvestigator set institutionid= 4167 where institutionid =4166
delete institution where institutionid =4166

select * from institution where name like 'University of Michigan%'   -- keep 4167, delete 4166
update ProjectFundingInvestigator set institutionid= 4167 where institutionid =4166
delete institution where institutionid =4166

select * from institution where name in ('REGENTS OF THE UNIVERSITY OF CALIFORNIA,',	'University of California, Davis')  -- keep 3453, delete 4103
update ProjectFundingInvestigator set institutionid= 3453 where institutionid =4103
delete institution where institutionid =4103

select * from institution where name in ('Regents of the University of Minnesota',	'University of Minnesota')  -- keep 3569, delete 4104
update ProjectFundingInvestigator set institutionid= 3569 where institutionid =4104
delete institution where institutionid =4104

select * from institution where name in ('PUBLIC HEALTH, CONNECTICUT DEP', 'PUBLIC HEALTH, CONNECTICUT DEPARTMENT OF', 'Connecticut Department of Public Health')  -- keep 868, delete 4100,4101
update ProjectFundingInvestigator set institutionid= 868 where institutionid IN (4100,4101)
delete institution where institutionid IN (4100,4101)

select * from institution where name in ('NORTH AMERICAN ASSOC OF CENTRAL CANCER R', 'North American Association of Central Cancer Regis', 'North American Association of Central Cancer Registries')  -- keep 2386, delete 4086,4087
update ProjectFundingInvestigator set institutionid= 2386 where institutionid IN (4086,4087)
delete institution where institutionid IN (4086,4087)
	
select * from institution where name in ('NANOMEDICON, LLC','Medicon (United States)')  -- keep 2035, delete 2225
update ProjectFundingInvestigator set institutionid= 2035 where institutionid =2225
delete institution where institutionid =2225

select * from institution where name in ('Memorial Sloan-Kettering Cancer Center (South San Francisco)', 'Memorial Sloan Kettering Cancer Center')  -- keep 2053, delete 2054
update ProjectFundingInvestigator set institutionid= 2053 where institutionid =2054
delete institution where institutionid =2054

select * from institution where name in ('MEDICAL UNIVERSITY OF OHIO', 'Medical University of Ohio at Toledo')  -- keep 4067, delete 4066
update ProjectFundingInvestigator set institutionid= 4067 where institutionid =4066
delete institution where institutionid =4066

select * from institution where name in ('Data Management Services (United States)', 'DATA MGMT SERVICES INC:1107862')  -- keep 944, delete 4013
update ProjectFundingInvestigator set institutionid= 944 where institutionid =4013
delete institution where institutionid =4013

select * from institution where name in ('ACORRN', 'Academic Clinical Oncology and Radiobiology Research Network (ACORRN)')  -- keep 4438, delete 37
update ProjectFundingInvestigator set institutionid= 4438 where institutionid =4013
delete institution where institutionid =37

select * from institution where name in ('SAN DIEGO CENTER FOR HEALTH INTERVENTION', 'San Diego Center for Health Interventions, LLC')  -- keep 4111, delete 2907
update ProjectFundingInvestigator set institutionid= 4111 where institutionid IN (2907)
delete institution where institutionid IN (2907)

select * from institution where name in ('Saskatchewan Cancer Agency/Foundation - Saskatoon Cancer Centre', 'Saskatchewan Cancer Center')  -- keep 2934, delete 4529
update ProjectFundingInvestigator set institutionid= 2934 where institutionid IN (4529)
delete institution where institutionid IN (4529)

UPDATE institution set nAME ='Scientific consulting group Inc.' where name = 'Scientific consulting group incn'
select * from institution where name in ('SCIENTIFIC CONSULTING GROUP INC THE', 'SCIENTIFIC CONSULTING GROUP INC:1108176', 'Scientific consulting group inc', 'SCIENTIFIC CONSULTING GROUP INCORPORATED', 'Scientific consulting group Inc.')  -- keep 4116, delete 4114,4115,4117
update ProjectFundingInvestigator set institutionid= 4116 where institutionid IN (4114,4115,4117)
delete institution where institutionid IN (4114,4115,4117)

select * from institution where name in ('SCRIPPS FLORIDA RESEARCH INSTITUTE', 'Scripps Research Institute - Florida','Scripps Research Institute, Florida')  -- keep 2955, delete 2956,4118
update ProjectFundingInvestigator set institutionid= 2955 where institutionid IN (2956,4118)
delete institution where institutionid IN (2956,4118)

select * from institution where name in ('Semba Biosciences, Inc.', 'SEMBA, INC.')  -- keep 4297, delete 2965
update ProjectFundingInvestigator set institutionid= 4297 where institutionid IN (2965)
delete institution where institutionid IN (2965)

select * from institution where name in ('SOUTHEAST TECHINVENTURES', 'SOUTHEAST TECHINVENTURES, INC.')  -- keep 4125, delete 4124
update ProjectFundingInvestigator set institutionid= 4125 where institutionid IN (4124)
delete institution where institutionid IN (4124)

select * from institution where name in ('Stella Therapeutics (United States)', 'STELLA THERAPEUTICS, LLC')  -- keep 3141, delete 4135
update ProjectFundingInvestigator set institutionid= 3141 where institutionid IN (4135)
delete institution where institutionid IN (4135)

select * from institution where name in ('TECHNICAL RESOURCES INC:1107821', 'TECHNICAL RESOURCES INTERNATIONAL INC')  -- keep 4141, delete 4140
update ProjectFundingInvestigator set institutionid= 4141 where institutionid IN (4140)
delete institution where institutionid IN (4140)

select * from institution where name in ('TEXAS AGRICULTURAL EXPERIMENT STATION', 'Texas Agrilife Research')  -- keep 3251, delete 3250
update ProjectFundingInvestigator set institutionid= 3251 where institutionid IN (3250)
delete institution where institutionid IN (3250)

select * from institution where name in ('Translite', 'Translite, LLC')  -- keep 3324, delete 4148
update ProjectFundingInvestigator set institutionid= 3324 where institutionid IN (4148)
delete institution where institutionid IN (4148)

UPDATE institution set nAME ='University of Kansas Center for Research' where name = 'Univ Of Kansas Center for Research, Inc.'
select * from institution where name in ('Univ Of Kansas Center for Research, Inc.', 'Univ of kansas center for research,inc', 'University of Kansas Center for Research')  -- keep 4153, delete 4154
update ProjectFundingInvestigator set institutionid= 4153 where institutionid IN (4154)
delete institution where institutionid IN (4154)

UPDATE institution set nAME ='University of Texas Southwestern Medical Center at Dallas' where name = 'Univ of Texas Southwestern Med. Ctr. at'
select * from institution where name in ('Univ of Texas Southwestern Med. Ctr. at', 'Univ of Texas Southwestern Med. Ctr. at Dallas', 'University of Texas Southwestern Medical Center at Dallas')  -- keep 4155, delete 4156
update ProjectFundingInvestigator set institutionid= 4155 where institutionid IN (4156)
delete institution where institutionid IN (4156)

select * from institution where name in ('Univ. of Kansas Medical Center Research', 'Univ. of Kansas Medical Center Research Institute', 'University of Kansas Medical Center Research Institute')  -- keep 4164, delete 4157,4158
update ProjectFundingInvestigator set institutionid= 4164 where institutionid IN (4157,4158)
delete institution where institutionid IN (4157,4158)

UPDATE institution set nAME ='University of Hawaii - Honolulu' where name = 'UNIVERSITY OF HAWAII SYSTEMS'
select * from institution where name in ('UNIVERSITY OF HAWAII SYSTEMS', 'UNIVERSITY OF HAWAII:1110364', 'University of Hawaii - Honolulu')  -- keep 4161, delete 4162
update ProjectFundingInvestigator set institutionid= 4161 where institutionid IN (4162)
delete institution where institutionid IN (4162)

select * from institution where name in ('Visen Medical', 'Visen Medical, Inc.')  -- keep 4180, delete 3817
update ProjectFundingInvestigator set institutionid= 4180 where institutionid IN (3817)
delete institution where institutionid IN (3817)

UPDATE institution set nAME ='Charles River Laboratories Inc. - Pathology Associates' where name = 'Pathology Associates, a Div. of Crl, Inc.'
select * from institution where name in ('Pathology Associates, a Div. of Crl, Inc.', 'Pathology Associates, A Division of Char', 'Charles River Laboratories Inc. - Pathology Associates')  -- keep 4093, delete 4094
update ProjectFundingInvestigator set institutionid= 4093 where institutionid IN (4094)
delete institution where institutionid IN (4094)

select * from institution where name in ('PENNSYLVANIA STATE UNIVERSITY, THE', 'PENNSYLVANIA STATE UNIVERSITY:1106920', 'Pennsylvania State University')  -- keep 2584, delete 4095,4096
update ProjectFundingInvestigator set institutionid= 2584 where institutionid IN (4095,4096)
delete institution where institutionid IN (4095,4096)

commit


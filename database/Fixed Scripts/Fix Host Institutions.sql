
select * from projectfunding f
left join ProjectFundingInvestigator pi on f.ProjectFundingID = pi.ProjectFundingID
where pi.ProjectFundingID is null

-------------------------------------
-- Correct institutions Country Codes
-------------------------------------
select * from institution where country = 'GM'
select * from institution where country = 'CH'
select * from country where Abbreviation in  ('CN', 'CH','SN')
select * from institution where name='University of Chile'
select * from institution where name='Fundacion Costarricense para la Docencia'
select * from institution where country = 'DA'
select * from institution where name='University of Tartu'
select * from institution where country = 'EN'
select * from institution where name='Masaryk University'
select * from institution where country = 'EZ'
select * from institution where name='U OF L LONDON SCH/HYGIENE & TROPICAL MED'
select * from institution where country = 'GB'
select * from institution where name='University of Guam'
select * from institution where name='University of Malawi'
select * from institution where country = 'IC'
select * from institution where name='Bar-Ilan University'
select * from institution where country = 'IS'
select * from institution where country = 'JA'
select * from institution where country = 'NI'
select * from institution where country = 'PO'
select * from institution where country = 'RQ'
select * from institution where country = 'KS'
select * from institution where country = 'RS'
select * from institution where country = 'SF'
select * from institution where country = 'SN' AND City='Singapore' 
select * from institution where country = 'SW'
select * from institution where country = 'SZ'
select * from institution where country = 'TU'


begin transaction
update institution set country = 'DE' where country = 'GM'  -- 23
update institution set country = 'GM' where name='Medical Research Council The Gambia Unit (MRC)'  -- 1
update institution set country = 'CN' where country = 'CH' --6
update institution set country = 'CL' where name='University of Chile'  -- 1
update institution set country = 'CR' where name='Fundacion Costarricense para la Docencia'  -- 1
update institution set country = 'DK' where country = 'DA'  -- 5
update institution set country = 'EE' where country = 'EN'  -- 2
update institution set country = 'CZ' where country = 'EZ'  -- 2
update institution set country = 'UK' where country = 'GB'  -- 1
update institution set country = 'GU' where country = 'GQ'  -- 1
update institution set country = 'MW' where country = 'MI'  -- 1
update institution set country = 'IL' where country = 'IS'  -- 9
update institution set country = 'IS' where country = 'IC'  -- 2
update institution set country = 'JP' where country = 'JA'  -- 30
update institution set country = 'NG' where country = 'NI'  -- 1
update institution set country = 'PT' where country = 'PO'  -- 4
update institution set country = 'PR' where country = 'RQ'  -- 6
update institution set country = 'KR' where country = 'KS'  -- 2
update institution set country = 'RU' where country = 'RS'  -- 2
update institution set country = 'ZA' where country = 'SF'  -- 5
update institution set country = 'SG' where country = 'SN' AND City='Singapore'  -- 3
update institution set country = 'SE' where country = 'SW'  -- 6
update institution set country = 'CH' where country = 'SZ'  -- 19
update institution set country = 'TR' where country = 'TU'  -- 1
update institution set name = 'Sabanci University' where name = 'Sabanc? University'  -- 1


commit


-------------------------------------
-- delete, merge institutions
-------------------------------------
select * from institution where name = 'Alderon Biosciences, Inc.' -- 112,113
select * from ProjectFundingInvestigator where institutionid in (112,113)

select * from institution where name = 'Almen Laboratories, Inc.' -- 128, 129
select * from ProjectFundingInvestigator where institutionid in (128,129)

select * from institution where name = 'AMC Cancer Research Center' -- 146, 147
select * from ProjectFundingInvestigator where institutionid in (146,147)

select * from institution where name like 'Battelle Memorial%' -- 3972
select * from ProjectFundingInvestigator where institutionid in (341, 342,3972)

select * from institution where name like 'Ben Venue Laboratories%' -- keep 364, delete 3973
select * from ProjectFundingInvestigator where institutionid in (364, 3973)

select * from institution where name like 'University of Sussex%' -- keep 3667, delete 3668
select * from ProjectFundingInvestigator where institutionid in (3667, 3668)

select * from institution where name like 'Medical Research Council The Gambia Unit (MRC)'

select * from institution where name like 'CALIFORNIA UNIV DAVIS%'
select * from institution where name like 'University of California, Davis%'  -- keep 3453, delete 3985
select * from ProjectFundingInvestigator where institutionid in (3453, 3985)

select * from institution where name like 'University of California Los Angeles%'
select * from institution where name like 'CALIFORNIA UNIV LOS ANGELES:1110328%'  -- keep 3448, delete 3986
select * from ProjectFundingInvestigator where institutionid in (3448, 3986)

select * from institution where name like 'University of California, Irvine%'
select * from institution where name like 'CALIFORNIA UNIVERSITY IRVINE:1110253%'  -- keep 3454, delete 3987
select * from ProjectFundingInvestigator where institutionid in (3448, 3986)

select * from institution where name like '%Chinese Acad%'  -- keep 3988, delete 3990
select * from institution where name like '%(CSIC)%'  --728

select * from institution where name like '%Charles River %'   -- keep 3998, delete 743
select * from institution where name like '%Cornell University' -- keep 884, delete 885

select * from institution where name like '%Fred Hutchinson%' -- keep 1192, delete 4028
select * from institution where name like '%la Recerca%' -- keep 1205, delete 1204
select * from institution where name like '%Fundacion Inciensa%' -- keep 4032, delete 1207
select * from institution where name like '%UCLA%' -- keep 1353, delete 1352
select * from institution where name like '%Mayo Clinic%' -- keep 1994, delete 4063
select * from institution where name like '%Southern Research Institute%' -- keep 3066, delete 4126
select * from institution where name like '%Synergene Therapeutics%' -- keep 3195, delete 3196
select * from institution where name like '%Toborg Associates%' -- keep 3294, delete 3295
select * from institution where name like '%Sloan%' -- keep 2053, delete 4121
select * from institution where name like '%Weill Cornell%' -- NEW
select * from institution where name like '%Moffitt%' -- kee4041 delete 2126,4040,4042,4077
select * from institution where name like '%Anderson%' -- keep 3689 delete 4146,4170,4171,4172,4173
select * from institution where name like '%Henry Ford%' -- keep 1388 delete 4046
select * from institution where name like '%Calibrant%' -- keep 536 delete 537,3984
select * from institution where name like '%Centre Européen de  de Résonance Magnétique Nucléaire à Très Hauts Champs de Lyon (CRMN Lyon)%' -- keep 674 delete 675
select * from institution where name like '%Milan%' -- only 1  : 4020
select * from institution where name like '%Foundation for the Children%' -- keep 1184, delete 1185
select * from institution where name like '%GEORGETOWN%' -- keep 1267, delete 4036
select * from institution where name like '%Expression Pathology%' -- keep 1124, delete 1123
select * from institution where name like '%Tumori%' -- keep 1704, delete 1705
select * from institution where name like '%University of Oxford%' -- keep 3614, delete 3613
select * from institution where name like '%Pan American%' -- keep 3692, delete 3693
select * from institution where name like '%San Marcos%' -- keep 3257, delete 3258


--select Latitude, Longitude from institution group by Latitude, Longitude having count(*) >1
select * from institution where name like '%University of Missouri%' -- keep 3576, delete 3577
select * from institution where name like '%University of Wisconsin%' -- keep 3730, delete 3733
select * from institution where name like '%Battelle%' -- keep 3972, delete 340
select * from institution where name like '%Bruyère Hospital%' -- keep 1055, delete 1054
select * from institution where name like '%McGill%' -- keep 2000, delete 2001
select * from institution where name like '%Biomédica%' -- keep 1630, delete 1571
select * from institution where name like '%University of New South Wales%' -- keep 3593, delete 3742
select * from institution where name like '%Mayo%' -- keep 1994, delete 4064
select * from institution where name like '%Advanced Digital Systems, Inc.%' -- keep 62, delete 2803


--Select projectfundingid, institutionid from ProjectFundingInvestigator where institutionid in (3258,3257) order by institutionid

--select projectfundingid, count(*) from ProjectFundingInvestigator where institutionid in (3258,3257)
-- group by projectfundingid having count(*) > 1
-- order by projectfundingid

-- check duplicate institutions
 select pi.ProjectFundingID, i.* from ProjectFundingInvestigator pi
 join (select projectfundingid from ProjectFundingInvestigator
 group by projectfundingid having count(*) > 1) d on pi.projectfundingid = d.projectfundingid
 join institution i on i.InstitutionID = pi.InstitutionID
 order by pi.ProjectFundingID, i.InstitutionID

 -- check missing institutions
 select * from ProjectFundingInvestigator where InstitutionID=1

 select * from projectfunding f
 left join ProjectFundingInvestigator i on f.ProjectFundingID = i.ProjectFundingID
 where i.ProjectFundingID is null



begin transaction
update ProjectFundingInvestigator set institutionid = 3576 where institutionid=3577  --3,1,1
delete institution where  institutionid=3577

update ProjectFundingInvestigator set institutionid = 3730 where institutionid=3733  --3,1,1
delete institution where  institutionid=3733

update ProjectFundingInvestigator set institutionid = 3972 where institutionid=340  --3,1,1
delete institution where  institutionid=340

update ProjectFundingInvestigator set institutionid = 1055 where institutionid=1054  --3,1,1
delete institution where  institutionid=1054

update ProjectFundingInvestigator set institutionid = 2000 where institutionid=2001  --3,1,1
delete institution where  institutionid=2001

update ProjectFundingInvestigator set institutionid = 1630 where institutionid=1571  --3,1,1
delete institution where  institutionid=1571

update ProjectFundingInvestigator set institutionid = 3593 where institutionid=3742  --3,1,1
delete institution where  institutionid=3742

update ProjectFundingInvestigator set institutionid = 1994 where institutionid=4064  --3,1,1
delete institution where  institutionid=4064

update ProjectFundingInvestigator set institutionid = 62 where institutionid=2803  --3,1,1
delete institution where  institutionid=2803

update ProjectFundingInvestigator set institutionid = 112 where institutionid=113  --3,1,1
delete institution where  institutionid=113
update institution set city = 'Beaufort' where institutionid=112

update ProjectFundingInvestigator set institutionid = 128 where institutionid=129 --3,1,1
delete institution where  institutionid=129
update institution set city = 'Vista' where institutionid=128

update ProjectFundingInvestigator set institutionid = 146 where institutionid=147 --10,1,1
delete institution where  institutionid=147
update institution set city = 'Denver' where institutionid=146

update institution set name='Battelle Memorial Institute',  longitude='-83.020699', Latitude= '39.991434', GRID='grid.27873.39' where institutionid=3972  --1

update ProjectFundingInvestigator set institutionid = 364 where institutionid=3973  --5,1
delete institution where  institutionid=3973

delete ProjectFundingInvestigator where projectfundingid=72355 and institutionid=3668  -- 1,1,1
update ProjectFundingInvestigator set institutionid = 3667 where institutionid=3668
delete institution where  institutionid=3668

update ProjectFundingInvestigator set institutionid = 3453 where institutionid=3985  -- 1,1
delete institution where  institutionid=3985

update ProjectFundingInvestigator set institutionid = 3448 where institutionid=3986  -- 1,1
delete institution where  institutionid=3986

update ProjectFundingInvestigator set institutionid = 3454 where institutionid=3987  -- 1,1
delete institution where  institutionid=3987

update ProjectFundingInvestigator set institutionid = 3988 where institutionid=3990  -- 1,1
delete institution where  institutionid=3990

update institution set name='Centro de Investigaciones Biologicas (CSIC)' where institutionid=728  --1

update ProjectFundingInvestigator set institutionid = 3998 where institutionid=743  -- 1,1
delete institution where  institutionid=743

delete ProjectFundingInvestigator where projectfundingid in (83245,83310,88428,94175) and institutionid=885
update ProjectFundingInvestigator set institutionid = 884 where institutionid=885  -- 1,1  rollback
delete institution where  institutionid=885

update ProjectFundingInvestigator set institutionid = 1192 where institutionid=4028  -- 1,1  rollback
delete institution where  institutionid=4028

update ProjectFundingInvestigator set institutionid = 1205 where institutionid=1204  -- 1,1  rollback
delete institution where  institutionid=1204

update ProjectFundingInvestigator set institutionid = 4032 where institutionid=1207  -- 1,1  rollback
delete institution where  institutionid=1207

update ProjectFundingInvestigator set institutionid = 1353 where institutionid=1352  -- 1,1  rollback
delete institution where  institutionid=1352

update ProjectFundingInvestigator set institutionid = 1994 where institutionid=4063  -- 1,1  rollback
delete institution where  institutionid=4063

update ProjectFundingInvestigator set institutionid = 3066 where institutionid=4126  -- 1,1  rollback
delete institution where  institutionid=4126
 
 delete ProjectFundingInvestigator where projectfundingid in (112274) and institutionid=3196
update ProjectFundingInvestigator set institutionid = 3195 where institutionid=3196  -- 1,1  rollback
delete institution where  institutionid=3196
update institution set city='Potomac' where InstitutionID=3195

 delete ProjectFundingInvestigator where projectfundingid in (79017,90074) and institutionid=3295
update ProjectFundingInvestigator set institutionid = 3294 where institutionid=3295  -- 1,1  rollback
delete institution where  institutionid=3295

update ProjectFundingInvestigator set institutionid = 2053 where institutionid=4121  -- 1,1  rollback
delete institution where  institutionid=4121

update ProjectFundingInvestigator set institutionid = 4041 where institutionid in (2126,4040,4042,4077)  -- 1,1  rollback
delete institution where  institutionid in (2126,4040,4042,4077)

update ProjectFundingInvestigator set institutionid = 3689 where institutionid in (4146,4170,4171,4172,4173)  -- 1,1  rollback
delete institution where  institutionid in (4146,4170,4171,4172,4173)

update ProjectFundingInvestigator set institutionid = 1388 where institutionid in (4046)  -- 1,1  rollback
delete institution where  institutionid in (4046)

update ProjectFundingInvestigator set institutionid = 536 where institutionid in (537,3984)  -- 1,1  rollback
delete institution where  institutionid in (537,3984)

update ProjectFundingInvestigator set institutionid = 674 where institutionid=675  -- 1,1  rollback
delete institution where  institutionid=675

delete ProjectFundingInvestigator where projectfundingid in (80081,93865) and institutionid=1185
update ProjectFundingInvestigator set institutionid = 1184 where institutionid=1185  -- 1,1  rollback
delete institution where  institutionid=1185

update ProjectFundingInvestigator set institutionid = 1267 where institutionid=4036  -- 1,1  rollback
delete institution where  institutionid=4036

update ProjectFundingInvestigator set institutionid = 1124 where institutionid=1123  -- 1,1  rollback
delete institution where  institutionid=1123
 
 update ProjectFundingInvestigator set institutionid = 1704 where institutionid=1705  -- 1,1  rollback
delete institution where  institutionid=1705

-- keep 3614, delete 3613
delete ProjectFundingInvestigator from ProjectFundingInvestigator pi
	JOIN (select projectfundingid from ProjectFundingInvestigator where institutionid in (3613,3614) group by projectfundingid having count(*) > 1 ) d ON pi.projectfundingid =d.projectfundingid
where pi.institutionid=3613

update ProjectFundingInvestigator set institutionid = 3614 where institutionid=3613  -- 1,1  rollback
delete institution where  institutionid=3613

update ProjectFundingInvestigator set institutionid = 3692 where institutionid=3693
delete institution where  institutionid=3693

update ProjectFundingInvestigator set institutionid = 3257 where institutionid=3258  --keep 3257, delete 3258
delete institution where  institutionid=3258

--begin transaction
rollback
--commit

-------------------------------------
-- Incorrect Mapping
-------------------------------------

select * from institution where name like '%LUDWIG%' -- InstitutionID:1906 /  ProjectFundingID=5391, 70345,73446,73447,73448,73449, 107979,107980,107981 / delete InstitutionID=1905  
select * from institution where name like '%Battelle Memorial Institute%' -- InstitutionID:3972 /  ProjectFundingID=15295 /delete InstitutionID=342   
select * from institution where name like '%ST. JOSEPH%'  -- InstitutionID:4130 /  ProjectFundingID=25928,25929,25930  / delete InstitutionID=3119  
select * from institution where name like '%RADIATION RESEARCH%'  -- InstitutionID:4130 /  ProjectFundingID=25928,25929,25930  / delete InstitutionID=3119  
select * from institution where name like '%MOLECULAR EXPRESS%'  -- InstitutionID:2130 /  ProjectFundingID=73529,73530,73531,96550,98972  / delete InstitutionID=2129  
select * from institution where name like '%Mount Sinai%'  -- InstitutionID:1483 /  ProjectFundingID=75495,76759,79213,80209,83167,85317,86642,87330,88359,88938,92151,92841,92895,96011,96858  / delete InstitutionID=2167  
select * from institution where name like '%Battelle Memorial Institute%'  -- InstitutionID:3972 /  ProjectFundingID=109781,109782,110720,113686,114399  / delete InstitutionID=342
select * from institution where name like '%Mayo%'  -- InstitutionID:4064 /  ProjectFundingID=110648,110649 / delete InstitutionID=1994,1995
select * from institution where name like '%SRI International%'  -- InstitutionID:3093 /  ProjectFundingID=101288,101290,101308,109943,109945,110696,110840,110841,97655,98882,98883,101155,101156 / delete InstitutionID=3092
select * from institution where name like '%Southern Research Institute%'  -- InstitutionID:3093 /  ProjectFundingID=101288,101290,101308,109943,109945,110696,110840,110841,97655,98882,98883,101155,101156 / delete InstitutionID=3092

begin transaction

delete ProjectFundingInvestigator where ProjectFundingID=5391 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=5391  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=70345 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=70345  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=73446 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=73446  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=73447 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=73447  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=73448 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=73448  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=73449 AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID=73449  -- delete InstitutionID=1905

delete ProjectFundingInvestigator where ProjectFundingID=15295 AND institutionid=342
update ProjectFundingInvestigator set institutionid = 3972 where ProjectFundingID=15295  -- delete InstitutionID=342

delete ProjectFundingInvestigator where ProjectFundingID=15296 AND institutionid=342
update ProjectFundingInvestigator set institutionid = 3972 where ProjectFundingID=15296  -- delete InstitutionID=342

delete ProjectFundingInvestigator where ProjectFundingID=25928 AND institutionid=3119
update ProjectFundingInvestigator set institutionid = 4130 where ProjectFundingID=25928  -- delete InstitutionID=3119

delete ProjectFundingInvestigator where ProjectFundingID=25929 AND institutionid=3119
update ProjectFundingInvestigator set institutionid = 4130 where ProjectFundingID=25929  -- delete InstitutionID=3119

delete ProjectFundingInvestigator where ProjectFundingID=25930 AND institutionid=3119
update ProjectFundingInvestigator set institutionid = 4130 where ProjectFundingID=25930  -- delete InstitutionID=3119

-- InstitutionID:2130 /  ProjectFundingID=73529,73530,73531  / delete InstitutionID=2129 
delete ProjectFundingInvestigator where ProjectFundingID=73529 AND institutionid=2129
update ProjectFundingInvestigator set institutionid = 2130 where ProjectFundingID=73529  -- delete InstitutionID=2129

delete ProjectFundingInvestigator where ProjectFundingID=73530 AND institutionid=2129
update ProjectFundingInvestigator set institutionid = 2130 where ProjectFundingID=73530  -- delete InstitutionID=2129

delete ProjectFundingInvestigator where ProjectFundingID=73531 AND institutionid=2129
update ProjectFundingInvestigator set institutionid = 2130 where ProjectFundingID=73531  -- delete InstitutionID=2129

--InstitutionID:1483 /  ProjectFundingID=75495,76759,79213,80209,83167,85317,86642,87330,88359,88938,92151,92841,92895,96011,96858  / delete InstitutionID=2167   
delete ProjectFundingInvestigator where ProjectFundingID IN (75495,76759,79213,80209,83167,85317,86642,87330,88359,88938,92151,92841,92895,96011,96858) AND institutionid=2167
update ProjectFundingInvestigator set institutionid = 1483 where ProjectFundingID IN (75495,76759,79213,80209,83167,85317,86642,87330,88359,88938,92151,92841,92895,96011,96858)  -- delete InstitutionID=2129

-- InstitutionID:3972 /  ProjectFundingID=109781,109782,110720,113686,114399  / delete InstitutionID=342 
delete ProjectFundingInvestigator where ProjectFundingID IN (109781,109782,110720,113686,114399) AND institutionid=342
update ProjectFundingInvestigator set institutionid = 3972 where ProjectFundingID IN (109781,109782,110720,113686,114399)-- delete InstitutionID=342

delete ProjectFundingInvestigator where ProjectFundingID IN (92980) AND institutionid=342
update ProjectFundingInvestigator set institutionid = 3972 where ProjectFundingID IN (92980)-- delete InstitutionID=342

-- InstitutionID:1906 /  ProjectFundingID=107979,107980,107981 / delete InstitutionID=1905  
delete ProjectFundingInvestigator where ProjectFundingID IN (107979,107980,107981) AND institutionid=1905
update ProjectFundingInvestigator set institutionid = 1906 where ProjectFundingID IN (107979,107980,107981)  -- delete InstitutionID=1905

-- InstitutionID:4064 /  ProjectFundingID=110648,110649 / delete InstitutionID=1994,1995
delete ProjectFundingInvestigator where ProjectFundingID IN (110648,110649) AND institutionid=1994
delete ProjectFundingInvestigator where ProjectFundingID IN (110648,110649) AND institutionid=1995
update ProjectFundingInvestigator set institutionid = 4064 where ProjectFundingID IN (110648,110649)  -- delete InstitutionID=1994

-- InstitutionID:2130 /  ProjectFundingID=96550,98972  / delete InstitutionID=2129 
delete ProjectFundingInvestigator where ProjectFundingID IN (96550,98972) AND institutionid=2129
update ProjectFundingInvestigator set institutionid = 2130 where ProjectFundingID IN (96550,98972)  -- delete InstitutionID=1905

-- InstitutionID:1483 /  ProjectFundingID=111507 / delete InstitutionID=2167  
delete ProjectFundingInvestigator where ProjectFundingID IN (111507) AND institutionid=2167
update ProjectFundingInvestigator set institutionid = 1483 where ProjectFundingID IN (111507)  -- delete InstitutionID=1905

-- InstitutionID:3093 /  ProjectFundingID=101288,101290,101308,109943,109945,110696,110840,110841,97655,98882,98883,101155,101156 / delete InstitutionID=3092
delete ProjectFundingInvestigator where ProjectFundingID IN (101288,101290,101308,109943,109945,110696,110840,110841,97655,98882,98883,101155,101156) AND institutionid=3092
delete ProjectFundingInvestigator where ProjectFundingID IN (110700,98847,101284,101285,101286,101287) AND institutionid=3092

delete ProjectFundingInvestigator where ProjectFundingID =129662 AND institutionid=2750
delete ProjectFundingInvestigator where ProjectFundingID =131190 AND institutionid=3742
delete ProjectFundingInvestigator where ProjectFundingID =133672 AND institutionid=1742
delete ProjectFundingInvestigator where ProjectFundingID =133960 AND institutionid=1742
delete ProjectFundingInvestigator where ProjectFundingID =133965 AND institutionid=1742
delete ProjectFundingInvestigator where ProjectFundingID =135903 AND institutionid=3742

delete ProjectFundingInvestigator where  projectfundingID IN (37048,37049,37050,37051) AND institutionid IN (2766,2767)
delete ProjectFundingInvestigator where  projectfundingID IN (98989) AND institutionid IN (3067)

rollback
--commit

--SELECT pi.ProjectFundingID, i.* FROM ProjectFundingInvestigator pi
--join institution i on i.InstitutionID = pi.InstitutionID
--where pi.ProjectFundingID IN (98989)
-------------------------------------
-- New Institution
-------------------------------------
begin transaction
INSERT INTO Institution VALUES ('Newcastle University', NULL, NULL, NULL, NULL, 'Callaghan', 'NSW', 'AU', NULL, getdate(), getdate())
INSERT INTO Institution VALUES ('Martin Luther University Halle-Wittenberg', NULL, '51.486389', '11.968889', NULL, 'Halle', NULL,'DE', 'grid.9018.0', getdate(), getdate())
INSERT INTO Institution VALUES ('Weill Cornell Graduate School of Medical Sciences', NULL, NULL, NULL, 'NY 10065', 'New York', 'NY','US', NULL, getdate(), getdate())

rollback
--commit
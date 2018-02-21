--1348  => 1269
select Name AS Institution, City, ISNULL(State, '') AS State, Country, ISNULL(grid, '') AS GRID, '' AS Latitude, '' AS Longitude from Institution where ISNULL(Latitude, 0) = 0  and name <> 'Missing' ORDER BY Name

 begin transaction 
 -- Update Institution
 SELECT * FROM institution  where name = 'Harvard University' AND City ='Cambridge'
 update institution set State = 'MA' where name = 'Harvard University' AND City ='Cambridge'

 SELECT * FROM institution  where name = 'American Physicians Scientists Association'
 update institution set City='Westford', State = 'MA', longitude=-71.42822, latitude=42.55974 where name = 'American Physicians Scientists Association'
 
 SELECT * FROM institution  where name = 'Translational Genomics Research Institute'
 update institution set State = 'AZ' where name = 'Translational Genomics Research Institute'
 
 -- Merge Institutions
 SELECT * FROM institution  where name = 'National Cancer Institute (NIH)' AND City ='Rockville'
 SELECT * FROM institution  where name = 'U.S. NATIONAL CANCER INSTITUTE' AND City ='Bethesda'
 SELECT * FROM ProjectFundingInvestigator WHERE InstitutionID IN (2248, 4152)
 SELECT * FROM InstitutionMapping where NewName = 'National Cancer Institute (NIH)' OR NewName='U.S. NATIONAL CANCER INSTITUTE'
 SELECT * FROM InstitutionMapping where OldName = 'National Cancer Institute (NIH)' OR OldName='U.S. NATIONAL CANCER INSTITUTE'

 update institution set City='Bethesda', longitude=-77.107583, latitude=38.999653 where institutionid = 2248 
 update ProjectFundingInvestigator set institutionid = 2248 where institutionid = 4152 
 delete institution where institutionid = 4152
 UPDATE InstitutionMapping SET NewCity='Bethesda' WHERE NewName='National Cancer Institute (NIH)' AND NewCity='Rockville'
 INSERT INTO InstitutionMapping VALUES ('U.S. NATIONAL CANCER INSTITUTE', 'Bethesda', 'National Cancer Institute (NIH)', 'Bethesda')

 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 SELECT * FROM institution  where name = 'U OF L LONDON SCH/HYGIENE & TROPICAL MED'
 SELECT * FROM institution  where name = 'London School of Hygiene & Tropical Medicine'
 SELECT * FROM ProjectFundingInvestigator WHERE InstitutionID IN (4150, 1878)
 SELECT * FROM InstitutionMapping where NewName = 'U OF L LONDON SCH/HYGIENE & TROPICAL MED' OR Oldname='U OF L LONDON SCH/HYGIENE & TROPICAL MED'
 SELECT * FROM InstitutionMapping where NewName = 'London School of Hygiene & Tropical Medicine' OR OldName='London School of Hygiene & Tropical Medicine'
  
 update ProjectFundingInvestigator set institutionid = 1878 where institutionid = 4150 
 delete institution where institutionid = 4150  
 INSERT INTO InstitutionMapping VALUES ('U OF L LONDON SCH/HYGIENE & TROPICAL MED', 'London', 'London School of Hygiene & Tropical Medicine', 'London')
 
 
 commit
 --rollback



--drop table #InstitutionCoordinates
-- drop table #CorrectInstitution
--GO
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #InstitutionCoordinates (	
	[Name] varchar(250) NULL,
	[City] varchar(50) NULL,
	[State] varchar(50) NULL,
	[Country] varchar(50) NULL,
	[Postal] varchar(50) NULL,	
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL,
	[Grid] varchar(50) NULL,
	[Note] varchar(500) NULL,
	[CorrectName] varchar(250) NULL,
	[CorrectCity] varchar(50) NULL,
	[CorrectState] varchar(50) NULL,
	[CorrectCountry] varchar(50) NULL
)

GO

BULK INSERT #InstitutionCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Coordinates\ICRPInstitutionCoordinates.csv'
WITH
(
	FIRSTROW = 3,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- remove empty rows
delete #InstitutionCoordinates where name is null

--select * from #InstitutionCoordinates where name like 'Roslin%'
--select * from institution where name like 'Roslin%'
--Board of Trustees of University of  Illi
--Board of Trustees of University of Illi

--select * from #InstitutionCoordinates

--select ic.*
--FROM #InstitutionCoordinates ic
--LEFT JOIN Institution i ON ic.Name = i.Name AND ic.City = i.City
--where i.name is null
--order by i.name

------------------------------------------------------
-- Correct Institutions
------------------------------------------------------
select distinct i.name, i.city, i.state, i.country, ic.CorrectName, ic.CorrectCity, ic.CorrectState, ic.CorrectCountry, ic.Note INTO #CorrectInstitution
FROM Institution i
JOIN #InstitutionCoordinates ic ON ic.Name = i.Name AND ic.City = i.City
where ic.CorrectName IS NOT NULL OR ic.CorrectCity IS NOT NULL  OR ic.CorrectCountry  IS NOT NULL OR ic.CorrectState IS NOT NULL
order by i.name

begin transaction

UPDATE Institution SET Country = ic.CorrectCountry
--select ic.*
FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name AND ic.City = i.City
where ic.CorrectCountry is not null

UPDATE Institution SET State = ic.CorrectState
--select ic.*
FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name AND ic.City = i.City
where ic.Correctstate is NOT null

UPDATE Institution SET City = ic.CorrectCity
--select ic.*
FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name AND ic.City = i.City
where ic.CorrectCity is NOT null

UPDATE Institution SET Name = ic.CorrectName
--select ic.*
FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name AND ic.City = i.City
where ic.CorrectName is NOT null

--rollback
commit

-- Update the input dataset
UPDATE #InstitutionCoordinates SET Name = CorrectName
where CorrectName is not null

UPDATE #InstitutionCoordinates SET City = CorrectCity
where CorrectCity is not null

UPDATE #InstitutionCoordinates SET State = CorrectState
where CorrectState is not null

UPDATE #InstitutionCoordinates SET Country = CorrectCountry
where CorrectCountry is not null

-- 13 not in the current lookup
select ic.*
FROM #InstitutionCoordinates ic
LEFT JOIN Institution i ON ic.Name = i.Name AND ic.City = i.City
where i.name is null
order by i.name

select count(*) from Institution  -- 4459
select count(*) from Institution where Latitude is not  null  -- 1812 populated
---------------------------

---------------------------
-- Import Coordinates
------------------------------------------------------
begin transaction  -- 538

UPDATE Institution SET [Latitude] = ic.[Latitude], [Longitude]= ic.[Longitude]
FROM Institution i
JOIN #InstitutionCoordinates ic ON ic.Name = i.Name AND ic.City = i.City

select count(*) from Institution where Latitude is not  null  -- 1812 populated  -- 2347 populated

-- manual fix
update Institution set latitude = 47.5716709, longitude=-52.74179379999998 where name ='Dr. H. Bliss Murphy Cancer Centre'

rollback
commit


select count(*) from Institution where Latitude is  null  -- 2112 missing

select * from Institution where name like 'Ministries of Health%'


select count(*) from Institution where Latitude is null  -- 2112
select count(*) from Institution where (grid is not null and grid <> '') and Latitude is null  --767
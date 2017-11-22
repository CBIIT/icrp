--drop table #InstitutionCoordinates
-- drop table #CorrectInstitution
-- drop table lu_InstitutionCoordsTmp
-- drop table lu_InstitutionLocationTmp
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


------------------------------------------------------------------------------------------------------------
-- Still have missing coordinates => Import Coordinates based on GRID 
------------------------------------------------------------------------------------------------------------
CREATE TABLE lu_InstitutionCoordsTmp (	
	[Grid] varchar(50) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO

BULK INSERT lu_InstitutionCoordsTmp
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Institutions\Inst_grid_coords.csv'
WITH
(
	FIRSTROW = 3,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

-- institutions with GRID: coordinates imported (351 imported)
select * FROM institution WHERE ISNULL(GRID,'') <> '' AND ISNULL(Latitude, 0) = 0

begin transaction

UPDATE Institution SET Latitude = t.latitude, Longitude = t.longitude
FROM institution i
JOIN (SELECT * FROM lu_InstitutionCoordsTmp WHERE Latitude IS NOT NULL) t ON t.GRID = i.GRID
WHERE ISNULL(i.GRID,'') <> '' AND ISNULL(i.Latitude, 0) = 0

commit

select * FROM institution WHERE ISNULL(GRID,'') <> '' AND ISNULL(Latitude, 0) = 0

--select count(*) from Institution where ISNULL(Latitude, 0) = 0  -- 1762 missing
------------------------------------------------------------------------------------------------------------
-- Still have missing coordinates => Import Coordinates based on Institution Name & City 
------------------------------------------------------------------------------------------------------------
CREATE TABLE lu_InstitutionLocationTmp (	
	[Grid] varchar(50) NULL,
	[Name] varchar(250) NULL,
	[City] varchar(50) NULL,
	[State] varchar(250) NULL,
	[Country] varchar(50) NULL	
)

GO

BULK INSERT lu_InstitutionLocationTmp
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Institutions\Inst_grid_location.csv'
WITH
(
	FIRSTROW = 3,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

--select distinct city from institution where country='CA'
UPDATE lu_InstitutionLocationTmp SET City = 'Montréal' WHERE city = 'Montreal' and country='Canada'

begin transaction  -- update 20 more
UPDATE institution SET  Latitude = t.latitude, Longitude = t.longitude
FROM institution i
JOIN (select l.Name, l.City, l.Country, c.Latitude, c.Longitude from lu_InstitutionLocationTmp l
		JOIN lu_InstitutionCoordsTmp c ON l.Grid = c.grid
		where c.Latitude IS NOT NULL) t ON i.Name = t.Name AND i.City = t.City
WHERE ISNULL(i.latitude,0) = 0

commit

--select count(*) from Institution where ISNULL(Latitude, 0) = 0  -- 1742 still missing

------------------------------------------------------------------------------------------------------------
-- ROund 3 - Still have missing coordinates => Import Coordinates based on Institution Name & City 
------------------------------------------------------------------------------------------------------------
--drop table lu_InstitutionMissingTmp3
--go

CREATE TABLE lu_InstitutionMissingTmp3 (	
	[Name] varchar(500) NULL,	
	[City] varchar(50) NULL,
	[State] varchar(250) NULL,
	[Country] varchar(50) NULL,
	[Grid] varchar(50) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO

BULK INSERT lu_InstitutionMissingTmp3
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Institutions\ICRPInsitutionMissingCoordinates-grid.csv'
WITH
(
	FIRSTROW = 3,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)

BULK INSERT lu_InstitutionMissingTmp3
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Institutions\ICRPInsitutionMissingCoordinates-no grid.csv'
WITH
(
	FIRSTROW = 3,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)

--select count(*) from Institution where ISNULL(Latitude, 0) = 0  -- 1742 still missing

begin transaction
UPDATE institution SET Latitude = t.[Latitude], [Longitude]= t.[Longitude]
--select i.* 
from
institution i 
join (select * from lu_InstitutionMissingTmp3 where latitude is not null) t on i.name = t.name and i.city = t.city

commit

--select count(*) from Institution where ISNULL(Latitude, 0) = 0  -- 1349 still missing
select Name AS Institution, City, ISNULL(State, ''), Country, ISNULL(grid, '') from Institution where ISNULL(Latitude, 0) = 0  and name <> 'Missing'

-- Manual fix
begin transaction
update institution set Latitude= 39.953187, Longitude= -75.174967  where Name = 'NRG Oncology Foundation, Inc.' and Latitude is null
update institution set latitude =27.967570, Longitude =-82.511962 where name = 'H. Lee Moffitt Cancer Center & Research Institute, Inc.' And city ='Tampa'
update institution set latitude = NULL, Longitude = NULL where latitude=0.0 and longitude = 0.0

commit

-- swap coordinates
begin transaction
select * from institution where country='us' and (latitude > 65 or latitude < 15) AND (longitude > -63 or longitude < -148)

update institution set latitude = us.longitude, longitude = us.latitude
from Institution i
join (select * from institution where country='us' and (latitude > 65 or latitude < 15) AND (longitude > -63 or longitude < -148)) us on i.institutionid =us.institutionid

select * from institution where country='us' and (latitude > 65 or latitude < 15) AND (longitude > -63 or longitude < -148)

commit
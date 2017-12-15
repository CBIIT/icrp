--drop table #CityCoordinates
--GO

-- truncate table lu_City
----------------------------------------------------------------------------------
-- Insert City Ccordinates based on City Coordinates dataset downloaded from internet
---------------------------------------------------------------------------------
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 

CREATE TABLE #CityCoordinates (		
	[Name] [varchar](100) NOT NULL,
	[Country] [varchar](2) NOT NULL,
	[State] [varchar](50) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO

BULK INSERT #CityCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\Cities\lu_City_Coordinates.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

UPDATE #CityCoordinates set state = NULL where state = 'NULL'
UPDATE #CityCoordinates set name = NULL where name = 'NULL'
UPDATE #CityCoordinates set country = NULL where country = 'NULL'

truncate table lu_City
go
select count(*) from #CityCoordinates 
select * from lu_City

IF NOT EXISTS (SELECT 1 FROM lu_City)
	INSERT INTO lu_City SELECT Name, Country, State, Latitude, Longitude FROM #CityCoordinates

UPDATE lu_City SET Name='Montréal' WHERE Country = 'CA' AND Name='montreal'
UPDATE lu_City SET Name='Québec' WHERE Country = 'CA' AND Name='Quebec'
UPDATE lu_City SET Name='Zürich' WHERE Country = 'CH' AND Name='Zurich'
UPDATE lu_City SET Name='Münster' WHERE Country = 'DE' AND Name='Munster'
UPDATE lu_City SET Name='Umeå' WHERE Name='Umea'
UPDATE lu_City SET Name='Pierre-Bénite' WHERE Country = 'FR' AND Name='Pierre-Benite'

-- update institution set Latitude=43.040770, Longitude=-87.904565, State='WI' WHERE Name ='International Societ for Quality of Life Research'  -- fixed in prod

-- check still missing? should be none
--begin transaction
--INSERT INTO lu_City 
--SELECT m.city, m.country, m.state, a1.region, a1.Latitude, a1.Longitude 
--FROM (select DISTINCT i.*, c.latitude, c.longitude  from lu_City c
--		RIGHT JOIN (select city, state, country from Institution group by  city, state, country) i ON i.city = c.name and i.country = c.country AND ISNULL(i.state, '') = ISNULL(c.state, '')
--		where c.Name is null) m
--	join (select city, country from icrp_data.dbo.lu_CityAll group by city, country having count(*) > 1) a on m.country = a.country and m.city = a.city --and (m.state is null OR m.state = a.region)
--	join icrp_data.dbo.lu_CityAll a1 on a1.country = a.country and a1.city = a.city --and (m.state is null OR m.state = a.region)
--	order by city, country, state

--commit

select DISTINCT i.*, c.latitude, c.longitude  from lu_City c
		RIGHT JOIN (select city, state, country from Institution group by  city, state, country) i ON i.city = c.name and i.country = c.country AND ISNULL(i.state, '') = ISNULL(c.state, '')
		where c.Name is null and c.name <> 'Missing'

-- Insert City coordinates into lu_city if they don't exist in lu_City
INSERT INTO lu_City (Name, State, Country, Latitude, Longitude)	
SELECT i.City, i.State, i.Country, i.Latitude, i.Longitude
FROM (SELECT City, State, Country, MIN(Latitude) AS Latitude,  MIN(Longitude) AS Longitude FROM Institution GROUP BY City, State, Country) i
	LEFT JOIN lu_City c ON i.City=c.Name AND ISNULL(i.State, '') = ISNULL(c.State, '') AND i.Country = c.Country		
WHERE i.City <> 'Missing' AND c.Name IS NULL AND i.Latitude IS NOT NULL AND i.Longitude IS NOT NULL

--select * from lu_city where name ='Burwood'
--select * from institution where city ='Burwood'
--select * from icrp_data.dbo.lu_CityAll where city ='Carmarthen'-- and region='ma'

--update institution set state = null where state = 'null'


--select count(*) from lu_city


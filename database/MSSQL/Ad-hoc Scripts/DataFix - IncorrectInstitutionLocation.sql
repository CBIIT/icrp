--drop table #CorrectInstitution
--GO
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #CorrectInstitution (	
	[Name] varchar(250) NULL,
	[City] varchar(50) NULL,
	[State] varchar(50) NULL,
	[Country] varchar(50) NULL,
	[CorrectName] varchar(250) NULL,
	[CorrectCity] varchar(50) NULL,
	[CorrectState] varchar(50) NULL,
	[CorrectCountry] varchar(50) NULL,
	[Note] varchar(500) NULL	
)

GO

BULK INSERT #CorrectInstitution
FROM 'C:\ICRP\database\DataImport\CurrentRelease\DataFix\IncorrectInstitutionlocation.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #CorrectInstitution

select distinct i.name, i.city, i.state, i.country, ic.CorrectName, ic.CorrectCity, ic.CorrectState, ic.CorrectCountry, ic.Note FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name AND ic.City = i.City
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
where ic.state is NOT null

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

UPDATE Institution SET State = 'CA'  where name = 'Areté Associates (United States)'

update institution set state='WI' WHERE city='Milwaukee' and country='us' and state='mi'

--Select * from Institution where name like  'University of Hawaii%'

UPDATE Institution SET Name = 'University of Hawaii – West O’ahu', City = 'Kapolei', State ='HI'  where name like  'University of Hawaii%West Oahu' -- prod updated already

select distinct i.name, i.city, i.state, i.country, ic.CorrectName, ic.CorrectCity, ic.CorrectState, ic.CorrectCountry, ic.Note FROM Institution i
JOIN #CorrectInstitution ic ON ic.Name = i.Name
order by i.name

select distinct *
FROM Institution where name ='InCytu, Inc.'

--rollback
commit

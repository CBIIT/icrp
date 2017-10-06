--drop table #InstitutionCoordinates
--GO
PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #InstitutionCoordinates (	
	[Name] varchar(250) NULL,
	[City] varchar(50) NULL,
	[Latitude] [decimal](9, 6) NULL,
	[Longitude] [decimal](9, 6) NULL
)

GO

BULK INSERT #InstitutionCoordinates
FROM 'C:\ICRP\database\DataImport\CurrentRelease\InstitutionCoordinates.csv'
WITH
(
	FIRSTROW = 2,
	DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

select * from #InstitutionCoordinates -- where country='uk'

select count(*) from #InstitutionCoordinates where [Longitude] is null
select count(*)  from Institution where [Longitude]is null

begin transaction

UPDATE Institution SET [Latitude] = ic.[Latitude], [Longitude]= ic.[Longitude]
FROM Institution i
JOIN #InstitutionCoordinates ic ON ic.Name = i.Name AND ic.City = i.City

rollback
commit
--select * from #CountryCoordinates where country = 'us'
--select * from country where [Longitude] is null

/********************************************************************************/
/*																				*/
/* Archive old dataset and create new tables									*/
/*																				*/
/********************************************************************************/
CREATE TABLE #CountryIncomeBand (	
	Code varchar(2) NULL,
	Country varchar(255) NULL,
	IncomeBand [varchar](50) NULL,
	DataSource [varchar](100) NULL
)

GO

BULK INSERT #CountryIncomeBand
FROM 'D:\ICRP\database\DataImport\IncomeBand\WorldBankIncomeByCountry_Missing.csv'
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n'
)

select * from #CountryIncomeBand

Update #CountryIncomeBand SET IncomeBand = 'Lower middle income' WHERE Code= 'PS'
Update #CountryIncomeBand SET IncomeBand = 'Lower middle income' WHERE Code= 'BO'
Update #CountryIncomeBand SET IncomeBand = 'Low income' WHERE Code= 'CD'
Update #CountryIncomeBand SET IncomeBand = 'Upper middle income' WHERE Code= 'SH'
Update #CountryIncomeBand SET IncomeBand = 'High Income' WHERE Code= 'BQ'

Update #CountryIncomeBand SET IncomeBand = 'ML' WHERE IncomeBand='Lower middle income'
Update #CountryIncomeBand SET IncomeBand = 'MU' WHERE IncomeBand='Upper middle income'
Update #CountryIncomeBand SET IncomeBand = 'H' WHERE IncomeBand='High income'
Update #CountryIncomeBand SET IncomeBand = 'L' WHERE IncomeBand='Low income'

select * from #CountryIncomeBand

BEGIN Transaction

Update [CountryMapLayer] set value= 'H', updateddate = getdate() where maplayerid=4 and country = 'AQ'
Update [CountryMapLayer] set value= 'H', updateddate = getdate() where maplayerid=4 and country = 'BV'

--select * from [CountryMapLayer] where maplayerid=4 and value is null

-- Update only countries with missing income band
UPDATE [CountryMapLayer] SET Value= tt.Incomeband, updateddate = getdate() 
FROM [CountryMapLayer] c
JOIN (select m.Country, t.Incomeband from #CountryIncomeBand t
      JOIN (SELECT * FROM [CountryMapLayer] where maplayerid=4 and value is null) m ON m.country = t.Code) tt
ON c.Country = tt.Country
WHERE maplayerid=4 and Value is null-- BV, AQ


select * from country
update country SET Incomeband = m.value
from country c
JOIN (SELECT * FROM [icrp_data].[dbo].[CountryMapLayer] where maplayerid=4) m on m.country = c.Abbreviation

--select * from country where Incomeband is null

commit

rollback




--drop table #DataCompleteness
--go

PRINT '******************************************************************************'
PRINT '***************************** Bulk Insert ************************************'
PRINT '******************************************************************************'

--SET NOCOUNT ON;  
--GO 
CREATE TABLE #DataCompleteness (	
	[FundingOrgName] [varchar](500) NOT NULL,
	[FundingOrgAbbrev] [varchar](100) NOT NULL,
	[FormerExclude] [varchar](10) NOT NULL,
	[CurrentExclude] [varchar](10) NOT NULL,
	[2000] [varchar](2) NULL,
	[2001] [varchar](2) NULL,
	[2002] [varchar](2) NULL,
	[2003] [varchar](2) NULL,
	[2004] [varchar](2) NULL,
	[2005] [varchar](2) NULL,
	[2006] [varchar](2) NULL,
	[2007] [varchar](2) NULL,
	[2008] [varchar](2) NULL,
	[2009] [varchar](2) NULL,
	[2010] [varchar](2) NULL,
	[2011] [varchar](2) NULL,
	[2012] [varchar](2) NULL,
	[2013] [varchar](2) NULL,
	[2014] [varchar](2) NULL,
	[2015] [varchar](2) NULL,
	[2016] [varchar](2) NULL,
	[2017] [varchar](2) NULL,
	[2018] [varchar](3) NULL
)

GO

BULK INSERT #DataCompleteness
FROM 'C:\ICRP\database\DataImport\CurrentRelease\ICRP_Web_Data_Status_File.csv'  
WITH
(
	FIRSTROW = 2,
	--DATAFILETYPE ='widechar',  -- unicode format
	FIELDTERMINATOR = '|',
	ROWTERMINATOR = '\n'
)
GO  

--Select * from #DataCompleteness where FundingOrgAbbrev = 'aa'
--Select * from DataUploadCompleteness where year >=2000 and year <=2018

UPDATE DataUploadCompleteness SET Status = NULL

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2000]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2		
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2000

UPDATE DataUploadCompleteness SET Status = 
CASE t.[2001]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2001

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2002]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2002

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2003]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2003

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2004]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2004

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2005]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2005

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2006]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2006

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2007]
	WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2007

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2008]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2008

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2009]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2009

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2010]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2010

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2011]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2011

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2012]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2012

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2013]
	WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2013

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2014]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2014

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2015]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2015

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2016]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2016

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2017]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2017

UPDATE DataUploadCompleteness SET Status = 
	CASE t.[2018]
		WHEN 'PU' THEN 1
		WHEN 'UC' THEN 2
		ELSE 0
	END
FROM DataUploadCompleteness d
JOIN #DataCompleteness t ON d.FundingOrgAbbrev = t.FundingOrgAbbrev
WHERE d.Year = 2018

-- Change Staus 0 (ND) to -1 (NA)
update DataUploadCompleteness set status=-1 where status=0
drop table #csotmp
go 

select f.ProjectFundingID, CAST(sum(cso.Relevance) AS decimal(18,2)) AS CSORelevance INTO #csotmp
from projectfunding f
join ProjectCSO cso ON f.ProjectFundingID = cso.ProjectFundingID
Group by f.projectfundingid 
HAVING CAST(SUM(ISNULL(cso.Relevance, 0)) AS decimal(18,2)) <> 100.00
--HAVING SUM(cso.Relevance) <> 100.00

select p.AwardCode, f.AltAwardCode, f.BudgetStartDate, f.BudgetEndDate, cso.CSOCode, cso.Relevance, t.CSORelevance AS TotalRelevance
from #csotmp t
join projectfunding f on t.ProjectFundingID = f.ProjectFundingID
join project p ON p.ProjectID = f.ProjectID
join ProjectCSO cso ON f.ProjectFundingID = cso.ProjectFundingID
where t.CSORelevance <> 99.99
order by t.CSORelevance, f.ProjectFundingID

-------------------------------------------------------------------

select f.ProjectFundingID, CAST(sum(ct.Relevance) AS decimal(18,2)) AS SiteRelevance INTO #cttmp
from projectfunding f
join ProjectCancerType ct ON ct.ProjectFundingID = f.ProjectFundingID
Group by f.projectfundingid 
HAVING CAST(SUM(ISNULL(ct.Relevance, 0)) AS decimal(18,2)) <> 100.00
--HAVING SUM(cso.Relevance) <> 100.00

select * from #cttmp

select p.AwardCode, f.AltAwardCode, f.BudgetStartDate, f.BudgetEndDate, c.ICRPCode, ct.Relevance, t.SiteRelevance AS TotalRelevance
from #cttmp t
join projectfunding f on t.ProjectFundingID = f.ProjectFundingID
join project p ON p.ProjectID = f.ProjectID
join ProjectCancerType ct ON f.ProjectFundingID = ct.ProjectFundingID
join CancerType c ON c.CancerTypeID = ct.CancerTypeID
where t.SiteRelevance <> 99.99
order by t.SiteRelevance, f.ProjectFundingID

---------------------------------------------------------------------


select f.ProjectFundingID, cso.CSOCode, cso.Relevance
from projectfunding f
join ProjectCSO cso ON f.ProjectFundingID = cso.ProjectFundingID
WHERE f.AltAwardCode = '5U54CA153604-04'
--WHERE f.projectfundingid = 29139


select f.ProjectFundingID, c.ICRPCode, ct.Relevance
from projectfunding f
join ProjectCancerType ct ON f.ProjectFundingID = ct.ProjectFundingID
join CancerType c ON c.CancerTypeID = ct.CancerTypeID
WHERE f.AltAwardCode = 'CP005779'
--WHERE f.projectfundingid in (22897, 23090)

select p.ProjectID, f.AltAwardCode, cso.CSOCode, cso.Relevance from projectfunding f
--join project p on p.projectid = f.projectid

print 14.26+14.29+14.29+14.29+14.29+14.29+14.29
--HAVING SUM(ISNULL(cso.Relevance, 0)) <> 100
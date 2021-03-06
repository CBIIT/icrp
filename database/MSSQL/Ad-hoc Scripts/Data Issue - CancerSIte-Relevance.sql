
select pf.projectfundingid, pf.altawardcode, SUM(ISNULL(Relevance, 0)) AS TotalRev INTO #tmp
from ProjectCancerType pct
JOIN projectfunding pf on pf.ProjectFundingID = pct.ProjectFundingID
group by pf.projectfundingid, pf.altawardcode
having SUM(ISNULL(Relevance, 0)) > 100.01  OR SUM(ISNULL(Relevance, 0)) < 99.9
ORDER BY SUM(ISNULL(Relevance, 0)) DESC

select t.ProjectFundingID, t.AltAwardCode, ct.Name AS CancerType, pct.Relevance, t.TotalRev from #tmp t
join ProjectCancerType pct on t.ProjectFundingID = pct.ProjectFundingID
JOIN CancerType ct on ct.CancerTypeID = pct.CancerTypeID
order by t.TotalRev desc
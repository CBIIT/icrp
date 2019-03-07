select pf.projectfundingid,  ct.name AS Site, pct.Relevance AS SiteRel, pc.CSOCode, pc.Relevance AS csoRel, 
fo.SponsorCode, fo.Name AS FundingOrg, fo.Type AS FundingOrgType, i.Name AS Institution, i.City, i.Country,
ext.CalendarYear, ext.CalendarAmount, ISNULL(ext.CalendarAmount, 0) * ISNuLL(pct.Relevance,0)/100 * ISNuLL(pc.Relevance,0)/100 AS ProportionAmount
INTO #tmp
FROM projectfunding pf
join FundingOrg fo on pf.FundingOrgID = fo.FundingOrgID
join (SELECT * FROM ProjectFundingInvestigator WHERE IsPrincipalInvestigator=1) pi on pf.ProjectFundingID = pi.ProjectFundingID
join institution i ON pi.InstitutionID = i.InstitutionID
join projectcancertype pct on pf.projectfundingid = pct.ProjectFundingID
join cancertype ct on ct.CancerTypeID = pct.CancerTypeID
join projectcso pc on pf.projectfundingid = pc.ProjectFundingID
join ProjectFundingExt ext on pf.ProjectFundingID = ext.ProjectFundingID
where ext.CalendarYear >=2005 and CalendarYear <=2015
order by pf.projectfundingid, ct.name, pc.CSOCode, fo.SponsorCode, fo.Name, fo.Type

select Site, CSOCode, SponsorCode, FundingOrg, FundingOrgType, Institution, City, Country,
CalendarYear, CAST(SUM(CalendarAmount) AS DECIMAL(18, 2))AS CalendarTotalAMount, CAST(SUM(ProportionAmount) AS Decimal(18,2)) AS ProportionAmount
FROM #tmp 
GROUP BY Site, CSOCode, SponsorCode, FundingOrg, FundingOrgType, Institution, City, Country, CalendarYear


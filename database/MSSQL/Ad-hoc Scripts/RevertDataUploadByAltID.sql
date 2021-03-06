select projectid, projectfundingid, AltAwardCode, DataUploadStatusid into #tmp from projectfunding 
where AltAwardCode in ('10918_2',
'15317_1',
'16666_1',
'16851_1',
'17024_2D',
'17213_1',
'17825_1',
'17918_1',
'17923_1',
'18176_1',
'18183_1',
'18264_1',
'18458_1',
'19346_1',
'19362_1',
'19820_1',
'20250_1',
'20252_1',
'20332_1',
'20620_1',
'20660_1',
'20755_1',
'20762_2',
'20786_2',
'20920_1',
'20924_1',
'20925_1',
'8096_3') order by AltAwardCode


select f.projectid, count(*) from #tmp t
join projectfunding f on t.projectid=f.projectid
group by f.projectid having count(*) > 1

select * from #tmp tselect * from #tmp t
join project p on t.projectid = p.ProjectID by

select * from projectfunding where projectid=61737

select * from projectfunding where projectid=66419



BEGIN TRANSACTION  -- rollback

delete ProjectSearch 
--select t.*,s.* 
from ProjectSearch s 
join #tmp t on t.projectid=s.ProjectID
where s.projectid<>61737

select * from ProjectSearch where projectid=61737


-- delete Project_ProjectType
PRINT '-- delete Project_ProjectType'
--select * from Project_ProjectType where projectid=66419
delete Project_ProjectType 
--select * 
from Project_ProjectType at
join #tmp t on t.ProjectID = at.ProjectID
where at.projectid<>61737

-- delete ProjectCancerType
PRINT '-- delete ProjectCancerType'

delete ProjectCancerType 
--select * 
from ProjectCancerType ct 
join #tmp t on t.ProjectFundingID = ct.ProjectFundingID


-- delete ProjectCSO
PRINT '-- delete ProjectCSO'

delete ProjectCSO 
from ProjectCSO c 
join #tmp t on t.ProjectFundingID = c.ProjectFundingID


-- delete ProjectFundingInvestigator
PRINT '-- delete ProjectFundingInvestigator'

delete ProjectFundingInvestigator 
from ProjectFundingInvestigator pi
join #tmp t on t.ProjectFundingID = pi.ProjectFundingID


-- delete ProjectFundingExt
PRINT '-- delete ProjectFundingExt'

DELETE ProjectFundingExt
from ProjectFundingExt e 
JOIN #tmp t ON t.ProjectFundingID = e.ProjectFundingID


-- delete ProjectFunding
PRINT '-- delete ProjectFunding'

delete ProjectFunding 
from ProjectFunding f
JOIN #tmp t ON t.ProjectFundingID = f.ProjectFundingID


select projectabstractid into #ProjectAbstractID from projectfunding 
where projectfundingid in (select projectfundingid from #tmp)

--select * from #ProjectAbstractID

-- delete Project
PRINT '-- delete Project'

DELETE Project
where ProjectID IN (SELECT ProjectID FROM #tmp where projectid<>61737 )


-- delete ProjectAbstract
PRINT '-- delete ProjectAbstract'

delete ProjectAbstract 
where ProjectAbstractID IN (SELECT ProjectAbstractID FROM #ProjectAbstractID)


--Commit
Rollback


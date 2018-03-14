select top 5 * from datauploadstatus order by datauploadstatusid desc
select top 5 * from icrp_data.dbo.datauploadstatus order by datauploadstatusid desc
select top 5 * from datauploadlog order by datauploadstatusid desc
select top 5 * from icrp_data.dbo.datauploadlog order by datauploadstatusid desc

BEGIN TRANSACTION

DECLARE @datauploadstatusid INT = 94
DECLARE @datauploadstatusid_prod INT = 94

-- delete ProjectSearch
PRINT '-- delete ProjectSearch'

delete ProjectSearch 
from projectfunding f
join project p on p.projectid = f.projectid
join ProjectSearch s on p.projectid=s.ProjectID
where f.datauploadstatusid=@datauploadstatusid


-- delete Project_ProjectType
PRINT '-- delete Project_ProjectType'

delete Project_ProjectType 
from project p 
join Project_ProjectType at on p.ProjectID = at.ProjectID
--join ProjectSearch s on p.projectid=s.ProjectID
where p.datauploadstatusid=@datauploadstatusid

-- delete ProjectCancerType
PRINT '-- delete ProjectCancerType'

delete ProjectCancerType 
from  projectfunding f
join ProjectCancerType ct on f.ProjectFundingID = ct.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid

-- delete ProjectCSO
PRINT '-- delete ProjectCSO'

delete ProjectCSO 
from  projectfunding f
join ProjectCSO c on f.ProjectFundingID = c.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid


-- delete ProjectFundingInvestigator
PRINT '-- delete ProjectFundingInvestigator'

delete ProjectFundingInvestigator 
from  projectfunding f
join ProjectFundingInvestigator pi on f.ProjectFundingID = pi.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid


-- delete ProjectFundingExt
PRINT '-- delete ProjectFundingExt'

DELETE ProjectFundingExt
from  projectfunding f
join ProjectFundingExt e ON f.ProjectFundingID = e.ProjectFundingID
where f.datauploadstatusid=@datauploadstatusid


-- keep a copy of projectID / ProjectAbstractID
PRINT '-- keep a copy of projectID / ProjectAbstractID'

SELECT ProjectID INTO #ProjectID
from  project
where datauploadstatusid=@datauploadstatusid

SELECT ProjectAbstractID INTO #ProjectAbstractID
from  projectfunding
where datauploadstatusid=@datauploadstatusid


-- delete ProjectFunding
PRINT '-- delete ProjectFunding'

delete ProjectFunding 
where datauploadstatusid=@datauploadstatusid

-- delete Project
PRINT '-- delete Project'

DELETE Project
where ProjectID IN (SELECT ProjectID FROM #ProjectID)


-- delete ProjectAbstract
PRINT '-- delete ProjectAbstract'

delete ProjectAbstract 
where ProjectAbstractID IN (SELECT ProjectAbstractID FROM #ProjectAbstractID)


-- delete RelatedProjects
-- Placeholder

-- delete RelatedSites
-- Placeholder



-- delete DataUploadStatus
Delete DataUploadLog WHERE DataUploadStatusID=@datauploadstatusid
Delete icrp_data.dbo.DataUploadLog WHERE DataUploadStatusID=@datauploadstatusid_prod

Delete DataUploadStatus WHERE DataUploadStatusID=@datauploadstatusid
Delete icrp_data.dbo.DataUploadStatus WHERE DataUploadStatusID=@datauploadstatusid_prod

--Commit
Rollback


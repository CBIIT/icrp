--drop table #ncriFunding 
--go
-- 
--drop table #Abstract 
--go

DECLARE @partnerCode varchar(50) = 'NCRI'

select DISTINCT f.ProjectID, f.ProjectFundingID, f.FundingOrgID INTO #ncriFunding
from projectfunding f
	join fundingorg o ON f.fundingorgid = o.FundingOrgID
where o.SponsorCode = @partnerCode

SELECT DISTINCT projectfundingID, ProjectAbstractID INTO #Abstract FROM ProjectFunding WHERE projectfundingID IN (SELECT DISTINCT projectfundingID FROM #ncriFunding) AND ProjectAbstractID <> 0

BEGIN TRANSACTION
	delete projectcancertype where projectfundingID IN (SELECT projectfundingID FROM #ncriFunding)   --21048
	delete projectCSO where projectfundingID IN (SELECT projectfundingID FROM #ncriFunding)  -- 15161
	delete projectFundingInvestigator where projectfundingID IN (SELECT projectfundingID FROM #ncriFunding)  -- 9899
	delete projectFundingExt where projectfundingID IN (SELECT projectfundingID FROM #ncriFunding)  -- 34980
	delete projectFunding where projectfundingID IN (SELECT projectfundingID FROM #ncriFunding)	-- 9899
	delete ProjectAbstract where ProjectAbstractID IN (SELECT ProjectAbstractID FROM #Abstract) -- 9832
	delete Project_ProjectType where projectID IN (SELECT DISTINCT projectID FROM #ncriFunding)	--9898
	delete Project where projectID IN (SELECT DISTINCT projectID FROM #ncriFunding)  -- 9898
--COMMIT
Rollback


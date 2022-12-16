PRINT '******************************************************************************'
PRINT '***************************** Delete ProjectFunding **************************'
PRINT '******************************************************************************'

DECLARE @altID varchar(50) = 'xxxxxx'
DECLARE @ProjectID INT
DECLARE @ProjectFundingID INT

SELECT @ProjectFundingID = ProjectFundingID, @ProjectID = ProjectID FROM ProjectFunding where altawardcode = @altID

PRINT @ProjectFundingID
PRINT @ProjectID

BEGIN TRANSACTION

-- delete projectcso
delete from projectcso where ProjectFundingID = @ProjectFundingID

-- delete projectcancertype
delete from projectcancertype where ProjectFundingID = @ProjectFundingID

-- delete projectfundinginvestigator
delete from projectfundinginvestigator where ProjectFundingID = @ProjectFundingID

-- delete projectfundingext
delete from projectfundingext where ProjectFundingID = @ProjectFundingID


--SELECT pf.ProjectAbstractID INTO #projAbst
--From ProjectFunding pf
--JOIN #delProjFunding dp ON pf.ProjectFundingID = dp.ProjectFundingID
--WHERE pf.ProjectAbstractID <> 0

--select * from #projAbst


-- archive to be deleted project funding records
INSERT INTO ProjectFundingArchive ( [ProjectFundingID]
      ,[FundingOrgID]
      ,[FundingDivisionID]
      ,[ProjectAbstractID]
      ,[Title]
      ,[Category]
      ,[AltAwardCode]
      ,[Source_ID]
      ,[MechanismCode]
      ,[MechanismTitle]
      ,[FundingContact]
      ,[IsAnnualized]
      ,[Amount]
      ,[BudgetStartDate]
      ,[BudgetEndDate]
      ,[DataUploadStatusID]
      ,[ArchivedDate])-- SELECT * FROM 
	SELECT [ProjectFundingID]
      ,[FundingOrgID]
      ,[FundingDivisionID]
      ,[ProjectAbstractID]
      ,[Title]
      ,[Category]
      ,[AltAwardCode]
      ,[Source_ID]
      ,[MechanismCode]
      ,[MechanismTitle]
      ,[FundingContact]
      ,[IsAnnualized]
      ,[Amount]
      ,[BudgetStartDate]
      ,[BudgetEndDate]
      ,[DataUploadStatusID]
      ,getdate() 
from projectfunding where ProjectFundingID = @ProjectFundingID

-- delete projectfunding
delete from projectfunding where ProjectFundingID = @ProjectFundingID

-- delete ProjectAbstract WHERE ProjectAbstractID IN (SELECT DISTINCT ProjectAbstractID From #projAbst)
select ProjectID, ProjectFundingID from projectfunding where projectID = @projectID
-- checking if the parent project has other pfunding records ...
IF NOT EXISTS (select ProjectID, ProjectFundingID from projectfunding where projectID = @projectID)
BEGIN
    -- if return empty project fundings above, delete the Project_ProjectType mapping
	print 'no children'
    delete from Project_ProjectType where ProjectID = @ProjectID

    --delete ProjectSearch
    --from ProjectSearch ps
    --JOIN #delProj f on f.ProjectID = ps.ProjectID

    delete from Project where ProjectID = @ProjectID
END 

SELECT * FROM ProjectFundingArchive where altawardcode = @altID
SELECT * FROM ProjectFunding where altawardcode = @altID
SELECT * FROM Project where projectID = @projectID


COMMIT
--ROLLBACK

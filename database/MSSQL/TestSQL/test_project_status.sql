/*******************************************************************************************/
/******  Test: project Active/Inactive status (epic NCIATWP-11791, technical story)   ******/
/*******************************************************************************************/
-- Run on a LOCAL copy of icrp_data only, never on a shared tier, after applying
-- ../Schema/Release/ICRP_Schema_Update_ProjectStatus.sql and ..._Procedures.sql.
-- Everything runs inside one transaction that is rolled back at the end, so no data changes.
-- Prints PASS/FAIL per check and a summary line.

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @failures INT = 0, @checks INT = 0;
DECLARE @r TABLE (ProjectsUpdated INT, SubProjectsUpdated INT);
DECLARE @pid INT, @subs INT, @pfid INT, @n INT;

BEGIN TRANSACTION;

-- 1. The six columns exist and every row starts Active
SET @checks += 1;
SELECT @n = COUNT(*) FROM sys.columns
	WHERE object_id IN (OBJECT_ID(N'[dbo].[Project]'), OBJECT_ID(N'[dbo].[ProjectFunding]'))
	AND name IN ('IsActive', 'StatusUpdatedBy', 'StatusUpdatedDate');
IF @n = 6 PRINT 'PASS 1: the six status columns exist'
ELSE BEGIN SET @failures += 1; PRINT CONCAT('FAIL 1: expected 6 status columns, found ', @n); END

-- A parent project with at least two sub-projects, all currently Active
SELECT TOP 1 @pid = f.ProjectID, @subs = COUNT(*)
FROM dbo.ProjectFunding f JOIN dbo.Project p ON p.ProjectID = f.ProjectID
WHERE p.IsActive = 1
GROUP BY f.ProjectID
HAVING COUNT(*) >= 2 AND MIN(CAST(f.IsActive AS INT)) = 1
ORDER BY f.ProjectID;
PRINT CONCAT('     (using ProjectID ', @pid, ' with ', @subs, ' sub-projects)');

-- 2. Inactivating a parent inactivates it and all its sub-projects, recording who and when
SET @checks += 1;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectStatus @ProjectIDs = @pid, @IsActive = 0, @ChangedBy = N'test.manager';
IF (SELECT ProjectsUpdated FROM @r) = 1 AND (SELECT SubProjectsUpdated FROM @r) = @subs
	AND (SELECT IsActive FROM dbo.Project WHERE ProjectID = @pid) = 0
	AND NOT EXISTS (SELECT * FROM dbo.ProjectFunding WHERE ProjectID = @pid AND IsActive = 1)
	AND NOT EXISTS (SELECT * FROM dbo.ProjectFunding WHERE ProjectID = @pid AND (StatusUpdatedBy <> N'test.manager' OR StatusUpdatedDate IS NULL))
	AND (SELECT StatusUpdatedBy FROM dbo.Project WHERE ProjectID = @pid) = N'test.manager'
	PRINT 'PASS 2: inactivating a parent inactivates all its sub-projects and records who/when'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 2: parent inactivation'; END

-- 3. Repeating the same request changes nothing and keeps the original who/when
SET @checks += 1;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectStatus @ProjectIDs = @pid, @IsActive = 0, @ChangedBy = N'someone.else';
IF (SELECT ProjectsUpdated + SubProjectsUpdated FROM @r) = 0
	AND (SELECT StatusUpdatedBy FROM dbo.Project WHERE ProjectID = @pid) = N'test.manager'
	PRINT 'PASS 3: repeating a request is a no-op'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 3: repeated request changed rows'; END

-- 4. A sub-project of an Inactive parent can't be reactivated on its own
SET @checks += 1;
SELECT TOP 1 @pfid = ProjectFundingID FROM dbo.ProjectFunding WHERE ProjectID = @pid ORDER BY ProjectFundingID;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectFundingStatus @ProjectFundingIDs = @pfid, @IsActive = 1, @ChangedBy = N'test.manager';
IF (SELECT SubProjectsUpdated FROM @r) = 0 AND (SELECT IsActive FROM dbo.ProjectFunding WHERE ProjectFundingID = @pfid) = 0
	PRINT 'PASS 4: sub-projects of an Inactive parent stay Inactive'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 4: a sub-project of an Inactive parent was reactivated'; END

-- 5. Reactivating a parent reactivates all its sub-projects
SET @checks += 1;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectStatus @ProjectIDs = @pid, @IsActive = 1, @ChangedBy = N'test.manager';
IF (SELECT ProjectsUpdated FROM @r) = 1 AND (SELECT SubProjectsUpdated FROM @r) = @subs
	AND (SELECT IsActive FROM dbo.Project WHERE ProjectID = @pid) = 1
	AND NOT EXISTS (SELECT * FROM dbo.ProjectFunding WHERE ProjectID = @pid AND IsActive = 0)
	PRINT 'PASS 5: reactivating a parent reactivates all its sub-projects'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 5: parent reactivation'; END

-- 6. Inactivating one sub-project leaves the parent and its other sub-projects Active
SET @checks += 1;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectFundingStatus @ProjectFundingIDs = @pfid, @IsActive = 0, @ChangedBy = N'test.manager';
IF (SELECT SubProjectsUpdated FROM @r) = 1
	AND (SELECT IsActive FROM dbo.ProjectFunding WHERE ProjectFundingID = @pfid) = 0
	AND (SELECT IsActive FROM dbo.Project WHERE ProjectID = @pid) = 1
	AND (SELECT COUNT(*) FROM dbo.ProjectFunding WHERE ProjectID = @pid AND IsActive = 1) = @subs - 1
	PRINT 'PASS 6: one sub-project inactivated; parent and siblings stay Active'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 6: single sub-project inactivation'; END

-- 7. Unknown IDs and empty lists are ignored
SET @checks += 1;
DELETE FROM @r;
INSERT INTO @r EXEC dbo.SetProjectStatus @ProjectIDs = '0,-5,2147483647', @IsActive = 0, @ChangedBy = N'test.manager';
INSERT INTO @r EXEC dbo.SetProjectFundingStatus @ProjectFundingIDs = '', @IsActive = 0, @ChangedBy = N'test.manager';
IF (SELECT SUM(ProjectsUpdated + SubProjectsUpdated) FROM @r) = 0
	PRINT 'PASS 7: unknown IDs and empty lists change nothing'
ELSE BEGIN SET @failures += 1; PRINT 'FAIL 7: unknown IDs changed rows'; END

-- 8. Who made the change is required
SET @checks += 1;
BEGIN TRY
	EXEC dbo.SetProjectStatus @ProjectIDs = @pid, @IsActive = 0, @ChangedBy = N' ';
	SET @failures += 1; PRINT 'FAIL 8: a blank @ChangedBy was accepted';
END TRY
BEGIN CATCH
	PRINT 'PASS 8: a blank @ChangedBy is rejected';
END CATCH

-- 9. Data uploads never touch the status columns (they list their columns explicitly)
SET @checks += 1;
SELECT @n = COUNT(*) FROM sys.sql_modules
	WHERE object_id IN (OBJECT_ID(N'dbo.DataUpload_ImportNew'), OBJECT_ID(N'dbo.DataUpload_ImportUpdate'), OBJECT_ID(N'dbo.DataUpload_SyncProd'))
	AND (definition LIKE '%IsActive%' OR definition LIKE '%StatusUpdated%');
IF @n = 0 PRINT 'PASS 9: upload procedures leave the status columns alone'
ELSE BEGIN SET @failures += 1; PRINT CONCAT('FAIL 9: ', @n, ' upload procedure(s) reference the status columns'); END

-- 8 can doom the transaction under XACT_ABORT; roll back whatever state it's in
IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

PRINT '';
IF @failures = 0 PRINT CONCAT('ALL ', @checks, ' CHECKS PASSED (all changes rolled back)')
ELSE PRINT CONCAT(@failures, ' OF ', @checks, ' CHECKS FAILED (all changes rolled back)');

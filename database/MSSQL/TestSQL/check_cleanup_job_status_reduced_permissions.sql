-- Alternative job status check with reduced permission requirements
-- This script uses stored procedures and functions that may be accessible with lower privileges

USE msdb;
GO

-- Method 1: Try using stored procedures (often have fewer permission restrictions)
PRINT '=== Checking Job Status Using Stored Procedures ===';

-- Check if job exists using sp_help_job
EXEC sp_help_job @job_name = N'Cleanup Old Search Results';

-- Method 2: Alternative query with error handling
PRINT '=== Alternative Job Information Query ===';

BEGIN TRY
    -- Try to get basic job info (this might work with lower permissions)
    SELECT 
        j.job_id,
        j.name AS job_name,
        j.enabled,
        j.date_created,
        j.date_modified,
        j.description
    FROM msdb.dbo.sysjobs j
    WHERE j.name = N'Cleanup Old Search Results';
END TRY
BEGIN CATCH
    PRINT 'Error accessing sysjobs table: ' + ERROR_MESSAGE();
END CATCH

-- Method 3: Try to get job steps with error handling
PRINT '=== Job Steps Information ===';

BEGIN TRY
    SELECT 
        js.step_id,
        js.step_name,
        js.subsystem,
        js.database_name,
        LEFT(js.command, 200) + '...' AS command_preview,  -- Show first 200 chars
        js.retry_attempts,
        js.retry_interval
    FROM msdb.dbo.sysjobsteps js
    INNER JOIN msdb.dbo.sysjobs j ON js.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results'
    ORDER BY js.step_id;
END TRY
BEGIN CATCH
    PRINT 'Error accessing job steps: ' + ERROR_MESSAGE();
END CATCH

-- Method 4: Try alternative schedule check using sp_help_jobschedule
PRINT '=== Job Schedule Using Stored Procedure ===';

BEGIN TRY
    EXEC sp_help_jobschedule @job_name = N'Cleanup Old Search Results';
END TRY
BEGIN CATCH
    PRINT 'Error getting job schedule via stored procedure: ' + ERROR_MESSAGE();
END CATCH

-- Method 5: Try job history with reduced columns
PRINT '=== Recent Job History (Limited Info) ===';

BEGIN TRY
    SELECT TOP 5
        jh.run_date,
        jh.run_time,
        jh.step_id,
        jh.step_name,
        CASE jh.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In Progress'
        END AS run_status,
        jh.run_duration
    FROM msdb.dbo.sysjobhistory jh
    INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results'
    ORDER BY jh.run_date DESC, jh.run_time DESC;
END TRY
BEGIN CATCH
    PRINT 'Error accessing job history: ' + ERROR_MESSAGE();
END CATCH

-- Method 6: Check your current permissions
PRINT '=== Your Current Permissions ===';

SELECT 
    'Current User' AS info_type,
    SUSER_NAME() AS login_name,
    USER_NAME() AS database_user;

-- Check if you're in SQL Agent operator roles
SELECT 
    'Role Membership' AS info_type,
    dp.name AS role_name,
    'Member' AS status
FROM sys.database_role_members rm
INNER JOIN sys.database_principals dp ON rm.role_principal_id = dp.principal_id
INNER JOIN sys.database_principals up ON rm.member_principal_id = up.principal_id
WHERE up.name = USER_NAME()
    AND dp.name IN ('SQLAgentUserRole', 'SQLAgentReaderRole', 'SQLAgentOperatorRole');

PRINT '=== Suggestions ===';
PRINT 'If you continue to have permission issues, you may need:';
PRINT '1. SQLAgentReaderRole membership in msdb database';
PRINT '2. SQLAgentOperatorRole membership for full access';  
PRINT '3. Or ask your DBA to grant specific permissions';
PRINT '4. Alternatively, use SQL Server Management Studio''s Object Explorer to view jobs';

GO
-- Diagnostic script to troubleshoot why cleanup job didn't run for icrp_data
-- This script helps identify issues with job execution

USE msdb;
GO

PRINT '=== Cleanup Job Troubleshooting ===';
PRINT 'Current Time: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '';

-- Method 1: Check if job exists and is enabled
PRINT '=== Job Status Check ===';
BEGIN TRY
    EXEC sp_help_job @job_name = N'Cleanup Old Search Results';
END TRY
BEGIN CATCH
    PRINT 'Job may not exist or access denied: ' + ERROR_MESSAGE();
END CATCH

-- Method 2: Check recent job execution history with more details
PRINT '=== Recent Job Execution History ===';
BEGIN TRY
    SELECT TOP 10
        CONVERT(VARCHAR, MSDB.dbo.agent_datetime(jh.run_date, jh.run_time), 120) AS execution_time,
        jh.step_id,
        jh.step_name,
        CASE jh.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In Progress'
        END AS run_status,
        jh.run_duration,
        LEFT(jh.message, 500) AS message_preview
    FROM msdb.dbo.sysjobhistory jh
    INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results'
    ORDER BY jh.run_date DESC, jh.run_time DESC;
END TRY
BEGIN CATCH
    PRINT 'Cannot access job history: ' + ERROR_MESSAGE();
END CATCH

-- Method 3: Check if SQL Server Agent is running
PRINT '=== SQL Server Agent Status ===';
BEGIN TRY
    SELECT 
        servicename,
        status_desc,
        startup_type_desc,
        last_startup_time
    FROM sys.dm_server_services 
    WHERE servicename LIKE '%Agent%';
END TRY
BEGIN CATCH
    PRINT 'Cannot check SQL Server Agent status: ' + ERROR_MESSAGE();
END CATCH

-- Method 4: Check job schedule details
PRINT '=== Job Schedule Details ===';
BEGIN TRY
    EXEC sp_help_jobschedule @job_name = N'Cleanup Old Search Results';
END TRY
BEGIN CATCH
    PRINT 'Cannot access job schedule: ' + ERROR_MESSAGE();
END CATCH

-- Method 5: Manual check - Test if the tables exist and have data
PRINT '=== Database and Table Existence Check ===';

-- Check icrp_dataload
PRINT 'Checking icrp_dataload database...';
BEGIN TRY
    EXEC('USE icrp_dataload; SELECT DB_NAME() as current_db, COUNT(*) as total_records FROM SearchResultProject;');
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_dataload.SearchResultProject: ' + ERROR_MESSAGE();
END CATCH

-- Check icrp_data
PRINT 'Checking icrp_data database...';
BEGIN TRY
    EXEC('USE icrp_data; SELECT DB_NAME() as current_db, COUNT(*) as total_records FROM SearchResultProject;');
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_data.SearchResultProject: ' + ERROR_MESSAGE();
END CATCH

-- Method 6: Check for old records that should be cleaned up
PRINT '=== Records Older Than 1 Day Check ===';

-- Check old records in icrp_dataload
PRINT 'Checking old records in icrp_dataload...';
BEGIN TRY
    EXEC('USE icrp_dataload; SELECT DB_NAME() as database_name, COUNT(*) as old_records_count FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());');
END TRY
BEGIN CATCH
    PRINT 'Cannot check old records in icrp_dataload: ' + ERROR_MESSAGE();
END CATCH

-- Check old records in icrp_data
PRINT 'Checking old records in icrp_data...';
BEGIN TRY
    EXEC('USE icrp_data; SELECT DB_NAME() as database_name, COUNT(*) as old_records_count FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());');
END TRY
BEGIN CATCH
    PRINT 'Cannot check old records in icrp_data: ' + ERROR_MESSAGE();
END CATCH

-- Method 7: Manual execution test for icrp_data step
PRINT '=== Manual Test Execution for icrp_data Step ===';
PRINT 'You can manually run this to test the icrp_data cleanup:';
PRINT '';
PRINT 'USE icrp_data;';
PRINT 'SELECT COUNT(*) as records_before_cleanup FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());';
PRINT 'DELETE FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());';
PRINT 'SELECT @@ROWCOUNT as rows_deleted;';
PRINT '';

-- Method 8: Check job step failures specifically
PRINT '=== Job Step Failure Analysis ===';
BEGIN TRY
    SELECT 
        CONVERT(VARCHAR, MSDB.dbo.agent_datetime(jh.run_date, jh.run_time), 120) AS execution_time,
        jh.step_id,
        jh.step_name,
        CASE jh.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In Progress'
        END AS run_status,
        jh.message
    FROM msdb.dbo.sysjobhistory jh
    INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results'
        AND jh.step_name LIKE '%icrp_data%'
        AND jh.run_status <> 1  -- Not successful
    ORDER BY jh.run_date DESC, jh.run_time DESC;
END TRY
BEGIN CATCH
    PRINT 'Cannot analyze job step failures: ' + ERROR_MESSAGE();
END CATCH

PRINT '=== Troubleshooting Complete ===';
GO
-- Check status of both separate cleanup jobs
-- Use this script to monitor both icrp_dataload and icrp_data cleanup jobs

USE msdb;
GO

PRINT '=== Status Check for Separate Cleanup Jobs ===';
PRINT 'Current Time: ' + CONVERT(VARCHAR, GETDATE(), 120);
PRINT '';

-- Check both jobs exist
PRINT '=== Job Existence Check ===';
BEGIN TRY
    EXEC sp_help_job @job_name = N'Cleanup Old Search Results - icrp_dataload';
    PRINT 'icrp_dataload job found.';
END TRY
BEGIN CATCH
    PRINT 'icrp_dataload job not found or access denied: ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    EXEC sp_help_job @job_name = N'Cleanup Old Search Results - icrp_data';
    PRINT 'icrp_data job found.';
END TRY
BEGIN CATCH
    PRINT 'icrp_data job not found or access denied: ' + ERROR_MESSAGE();
END CATCH

-- Check schedules for both jobs
PRINT '';
PRINT '=== Job Schedules ===';
BEGIN TRY
    PRINT 'icrp_dataload job schedule:';
    EXEC sp_help_jobschedule @job_name = N'Cleanup Old Search Results - icrp_dataload';
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_dataload job schedule: ' + ERROR_MESSAGE();
END CATCH

BEGIN TRY
    PRINT 'icrp_data job schedule:';
    EXEC sp_help_jobschedule @job_name = N'Cleanup Old Search Results - icrp_data';
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_data job schedule: ' + ERROR_MESSAGE();
END CATCH

-- Check recent execution history for both jobs
PRINT '';
PRINT '=== Recent Execution History ===';

-- icrp_dataload job history
PRINT 'icrp_dataload job history (last 5 runs):';
BEGIN TRY
    SELECT TOP 5
        CONVERT(VARCHAR, MSDB.dbo.agent_datetime(jh.run_date, jh.run_time), 120) AS execution_time,
        jh.step_name,
        CASE jh.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In Progress'
        END AS run_status,
        jh.run_duration,
        LEFT(jh.message, 200) AS message_preview
    FROM msdb.dbo.sysjobhistory jh
    INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results - icrp_dataload'
    ORDER BY jh.run_date DESC, jh.run_time DESC;
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_dataload job history: ' + ERROR_MESSAGE();
END CATCH

-- icrp_data job history
PRINT 'icrp_data job history (last 5 runs):';
BEGIN TRY
    SELECT TOP 5
        CONVERT(VARCHAR, MSDB.dbo.agent_datetime(jh.run_date, jh.run_time), 120) AS execution_time,
        jh.step_name,
        CASE jh.run_status
            WHEN 0 THEN 'Failed'
            WHEN 1 THEN 'Succeeded'
            WHEN 2 THEN 'Retry'
            WHEN 3 THEN 'Canceled'
            WHEN 4 THEN 'In Progress'
        END AS run_status,
        jh.run_duration,
        LEFT(jh.message, 200) AS message_preview
    FROM msdb.dbo.sysjobhistory jh
    INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results - icrp_data'
    ORDER BY jh.run_date DESC, jh.run_time DESC;
END TRY
BEGIN CATCH
    PRINT 'Cannot access icrp_data job history: ' + ERROR_MESSAGE();
END CATCH

-- Manual test queries
PRINT '';
PRINT '=== Manual Test Queries ===';
PRINT 'To manually test cleanup, run these queries:';
PRINT '';
PRINT '-- Test icrp_dataload:';
PRINT 'USE icrp_dataload;';
PRINT 'SELECT COUNT(*) as old_records FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());';
PRINT '';
PRINT '-- Test icrp_data:';
PRINT 'USE icrp_data;';
PRINT 'SELECT COUNT(*) as old_records FROM SearchResultProject WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());';
PRINT '';

GO
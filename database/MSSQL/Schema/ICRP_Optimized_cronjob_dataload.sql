-- SQL Server Agent Job to cleanup old SearchResultProject records in icrp_dataload database
-- Run this script to create a daily cleanup job for icrp_dataload
-- This script is idempotent - safe to run multiple times

USE msdb;
GO

-- Remove existing job if it exists
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Cleanup Old Search Results - icrp_dataload')
BEGIN
    PRINT 'Removing existing job: Cleanup Old Search Results - icrp_dataload';
    EXEC msdb.dbo.sp_delete_job @job_name = N'Cleanup Old Search Results - icrp_dataload', @delete_unused_schedule = 1;
    PRINT 'Existing job removed successfully.';
END

-- Create the job for icrp_dataload
EXEC dbo.sp_add_job
    @job_name = N'Cleanup Old Search Results - icrp_dataload',
    @description = N'Daily cleanup of old SearchResultProject records in icrp_dataload database';

-- Add job step for icrp_dataload database
EXEC sp_add_jobstep
    @job_name = N'Cleanup Old Search Results - icrp_dataload',
    @step_name = N'Delete Old Records - icrp_dataload',
    @subsystem = N'TSQL',
    @database_name = N'icrp_dataload',
    @command = N'
        -- Delete rows older than 1 day
        DELETE FROM SearchResultProject 
        WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());
        
        -- Log the cleanup
        PRINT ''[icrp_dataload] Cleanup completed at '' + CONVERT(VARCHAR, GETDATE(), 120);
        PRINT ''[icrp_dataload] Rows deleted: '' + CAST(@@ROWCOUNT AS VARCHAR);
    ',
    @retry_attempts = 3,
    @retry_interval = 5;

-- Create a schedule for icrp_dataload (daily at 7:35 AM)
EXEC dbo.sp_add_schedule
    @schedule_name = N'icrp_dataload Cleanup Schedule',
    @freq_type = 4,        -- Daily
    @freq_interval = 1,    -- Every 1 day
    @active_start_time = 073500; -- 7:35 AM

-- Attach the schedule to the job
EXEC sp_attach_schedule
    @job_name = N'Cleanup Old Search Results - icrp_dataload',
    @schedule_name = N'icrp_dataload Cleanup Schedule';

-- Add the job to the SQL Server Agent
EXEC dbo.sp_add_jobserver
    @job_name = N'Cleanup Old Search Results - icrp_dataload';

GO

PRINT 'Job created successfully for icrp_dataload. The cleanup will run daily at 7:35 AM.';
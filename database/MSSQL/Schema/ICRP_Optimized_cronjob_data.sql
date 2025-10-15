-- SQL Server Agent Job to cleanup old SearchResultProject records in icrp_data database
-- Run this script to create a daily cleanup job for icrp_data
-- This script is idempotent - safe to run multiple times

USE msdb;
GO

-- Remove existing job if it exists
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Cleanup Old Search Results - icrp_data')
BEGIN
    PRINT 'Removing existing job: Cleanup Old Search Results - icrp_data';
    EXEC msdb.dbo.sp_delete_job @job_name = N'Cleanup Old Search Results - icrp_data', @delete_unused_schedule = 1;
    PRINT 'Existing job removed successfully.';
END

-- Create the job for icrp_data
EXEC dbo.sp_add_job
    @job_name = N'Cleanup Old Search Results - icrp_data',
    @description = N'Daily cleanup of old SearchResultProject records in icrp_data database';

-- Add job step for icrp_data database
EXEC sp_add_jobstep
    @job_name = N'Cleanup Old Search Results - icrp_data',
    @step_name = N'Delete Old Records - icrp_data',
    @subsystem = N'TSQL',
    @database_name = N'icrp_data',
    @command = N'
        -- Delete rows older than 1 day
        DELETE FROM SearchResultProject 
        WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());
        
        -- Log the cleanup
        PRINT ''[icrp_data] Cleanup completed at '' + CONVERT(VARCHAR, GETDATE(), 120);
        PRINT ''[icrp_data] Rows deleted: '' + CAST(@@ROWCOUNT AS VARCHAR);
    ',
    @retry_attempts = 3,
    @retry_interval = 5;

-- Create a schedule for icrp_data (daily at 7:15 AM )
EXEC dbo.sp_add_schedule
    @schedule_name = N'icrp_data Cleanup Schedule',
    @freq_type = 4,        -- Daily
    @freq_interval = 1,    -- Every 1 day
    @active_start_time = 071500; -- 7:15 AM

-- Attach the schedule to the job
EXEC sp_attach_schedule
    @job_name = N'Cleanup Old Search Results - icrp_data',
    @schedule_name = N'icrp_data Cleanup Schedule';

-- Add the job to the SQL Server Agent
EXEC dbo.sp_add_jobserver
    @job_name = N'Cleanup Old Search Results - icrp_data';

GO

PRINT 'Job created successfully for icrp_data. The cleanup will run daily at 7:15 AM.';
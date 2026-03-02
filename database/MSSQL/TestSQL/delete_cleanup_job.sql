-- Delete the existing SQL Server Agent job "Cleanup Old Search Results"
-- This script safely removes the job and its associated schedules

USE msdb;
GO

-- Check if the job exists before attempting to delete
IF EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Cleanup Old Search Results')
BEGIN
    PRINT 'Found job "Cleanup Old Search Results". Proceeding with deletion...';
    
    -- Show job details before deletion (for confirmation)
    SELECT 
        j.job_id,
        j.name AS job_name,
        j.enabled,
        j.date_created,
        j.date_modified,
        j.description
    FROM msdb.dbo.sysjobs j
    WHERE j.name = N'Cleanup Old Search Results';
    
    -- Show associated schedules before deletion
    PRINT 'Associated schedules that will be removed:';
    SELECT 
        s.schedule_id,
        s.name AS schedule_name,
        s.enabled,
        CASE 
            WHEN s.active_start_time >= 100000 THEN 
                SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 1, 2) + ':' + 
                SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 3, 2) + ':' + 
                SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 5, 2)
            ELSE 
                '0' + SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 1, 1) + ':' + 
                SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 2, 2) + ':' + 
                SUBSTRING(CAST(s.active_start_time AS VARCHAR(6)), 4, 2)
        END AS start_time_formatted
    FROM msdb.dbo.sysschedules s
    INNER JOIN msdb.dbo.sysjobschedules js ON s.schedule_id = js.schedule_id
    INNER JOIN msdb.dbo.sysjobs j ON js.job_id = j.job_id
    WHERE j.name = N'Cleanup Old Search Results';
    
    -- Delete the job (this will also remove job steps and detach schedules)
    -- @delete_unused_schedule = 1 means it will also delete schedules that are not used by other jobs
    EXEC msdb.dbo.sp_delete_job 
        @job_name = N'Cleanup Old Search Results', 
        @delete_unused_schedule = 1;
    
    PRINT 'Successfully deleted job "Cleanup Old Search Results" and its unused schedules.';
    PRINT 'Job deletion completed at: ' + CONVERT(VARCHAR, GETDATE(), 120);
END
ELSE
BEGIN
    PRINT 'Job "Cleanup Old Search Results" does not exist. Nothing to delete.';
END

-- Verify deletion by checking if the job still exists
IF NOT EXISTS (SELECT job_id FROM msdb.dbo.sysjobs WHERE name = N'Cleanup Old Search Results')
BEGIN
    PRINT 'Verification: Job "Cleanup Old Search Results" has been successfully removed.';
END
ELSE
BEGIN
    PRINT 'WARNING: Job "Cleanup Old Search Results" still exists after deletion attempt.';
END

-- Optional: Show all remaining jobs with similar names (for reference)
PRINT 'Other cleanup-related jobs in the system:';
SELECT 
    j.name AS job_name,
    j.enabled,
    j.date_created
FROM msdb.dbo.sysjobs j
WHERE j.name LIKE '%cleanup%' OR j.name LIKE '%Cleanup%'
ORDER BY j.name;

GO
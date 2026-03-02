-- Check if the Cleanup Old Search Results job exists and its current status
USE msdb;
GO

-- Check if the job exists
SELECT 
    j.job_id,
    j.name AS job_name,
    j.enabled,
    j.date_created,
    j.date_modified,
    j.description
FROM msdb.dbo.sysjobs j
WHERE j.name = N'Cleanup Old Search Results';

-- Check job steps
SELECT 
    js.step_id,
    js.step_name,
    js.subsystem,
    js.database_name,
    js.command,
    js.retry_attempts,
    js.retry_interval
FROM msdb.dbo.sysjobsteps js
INNER JOIN msdb.dbo.sysjobs j ON js.job_id = j.job_id
WHERE j.name = N'Cleanup Old Search Results'
ORDER BY js.step_id;

-- Check job schedule
SELECT 
    s.schedule_id,
    s.name AS schedule_name,
    s.enabled,
    s.freq_type,
    s.freq_interval,
    s.active_start_time,
    CASE 
        WHEN s.freq_type = 4 THEN 'Daily'
        WHEN s.freq_type = 8 THEN 'Weekly'
        WHEN s.freq_type = 16 THEN 'Monthly'
        ELSE 'Other'
    END AS frequency_description,
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

-- Check recent job execution history
SELECT TOP 10
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
    jh.run_duration,
    jh.message
FROM msdb.dbo.sysjobhistory jh
INNER JOIN msdb.dbo.sysjobs j ON jh.job_id = j.job_id
WHERE j.name = N'Cleanup Old Search Results'
ORDER BY jh.run_date DESC, jh.run_time DESC;

-- Check current agent job activity
SELECT 
    ja.session_id,
    j.name AS job_name,
    ja.run_requested_date,
    ja.run_requested_source,
    CASE ja.job_state
        WHEN 1 THEN 'Executing'
        WHEN 2 THEN 'Waiting For Thread'
        WHEN 3 THEN 'Between Retries'
        WHEN 4 THEN 'Idle'
        WHEN 5 THEN 'Suspended'
        WHEN 7 THEN 'Performing Completion Actions'
    END AS current_state
FROM msdb.dbo.sysjobactivity ja
INNER JOIN msdb.dbo.sysjobs j ON ja.job_id = j.job_id
WHERE j.name = N'Cleanup Old Search Results'
AND ja.session_id = (SELECT MAX(session_id) FROM msdb.dbo.sysjobactivity);
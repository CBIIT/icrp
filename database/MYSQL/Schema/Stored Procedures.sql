CREATE PROCEDURE `DeleteOldSearchResults`()
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DROP TEMPORARY TABLE IF EXISTS old_emails;
	
	CREATE TEMPORARY TABLE IF NOT EXISTS old_emails AS (
		SELECT c.SearchCriteriaID
		FROM SearchResult r
			INNER JOIN SearchCriteria c ON r.SearchCriteriaID = c.SearchCriteriaID
		WHERE IFNULL(r.IsEmailSent, 0) = 0
			AND DATEDIFF(CURDATE(),c.SearchDate) > 30
	);
	
	DELETE FROM SearchResult
	WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM old_emails);
	
	DELETE FROM SearchCriteria
	WHERE  SearchCriteriaID IN (SELECT SearchCriteriaID FROM old_emails);
	
	DROP TEMPORARY TABLE IF EXISTS old_emails;
END


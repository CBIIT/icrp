DELIMITER //

DROP PROCEDURE IF EXISTS `ToIntTable`//

CREATE PROCEDURE `ToIntTable`(
	IN `@input` LONGTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE `@sql` LONGTEXT DEFAULT '';
    
    DROP TEMPORARY TABLE IF EXISTS ToIntTable;
	CREATE TEMPORARY TABLE IF NOT EXISTS ToIntTable (
		VALUE INT
	);
	
	-- SET group_concat_max_len=100000 
	IF `@input` IS NOT NULL THEN
	
	drop temporary table if exists temp;

		create temporary table temp( val INT );
		
		set @sql = concat("insert into temp (val) values (", 
							replace((select group_concat(`@input`) as data from t), ",", "),("),
							");"                            
						 );
		
		prepare stmt1 from @sql;
		execute stmt1;
		insert into ToIntTable select distinct(val) from temp;

	END IF;
END//


DROP PROCEDURE IF EXISTS `ToStrTable`//

CREATE PROCEDURE `ToStrTable`(
	IN `@input` LONGTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE `@sql` LONGTEXT DEFAULT '';
    
	DROP TEMPORARY TABLE IF EXISTS ToStrTable;
	CREATE TEMPORARY TABLE IF NOT EXISTS ToStrTable (
		VALUE VARCHAR(50)
	);
    
    -- SET group_concat_max_len=100000 
	IF `@input` IS NOT NULL THEN
	
	drop temporary table if exists temp;

		create temporary table temp( val VARCHAR(50) );
		
		set @sql = concat("insert into temp (val) values ('", 
							replace((select group_concat(`@input`) as data from t), ",", "'),('"),
							"');"                            
						 );
		
		prepare stmt1 from @sql;
		execute stmt1;
		insert into ToStrTable select distinct(val) from temp;

	END IF;
END//


DELIMITER ;

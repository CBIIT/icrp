DELIMITER //


CREATE PROCEDURE `ToIntTable`(
	IN `@input` LONGTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE `@Value` INT DEFAULT 0;
	DECLARE `@ind` INT DEFAULT 0;

	DROP TEMPORARY TABLE IF EXISTS ToIntTable;
	CREATE TEMPORARY TABLE IF NOT EXISTS ToIntTable (
		VALUE INT
	);
	
	IF `@input` IS NOT NULL THEN
	   SET `@ind` = INSTR(@input,',');
	   WHILE `@ind` > 0 DO
	      SET `@Value` = CAST(SUBSTRING(`@input`,1,`@ind`-1) AS SIGNED);
	      SET `@input` = SUBSTRING(`@input`,`@ind`+1);
	      INSERT INTO ToIntTable VALUES (`@Value`);
	      SET `@ind` = INSTR(`@input`,',');
	   END WHILE;
	   SET `@Value` = CAST(`@input` AS SIGNED);
	   INSERT INTO ToIntTable VALUES (`@Value`);
	END IF;
END//


CREATE PROCEDURE `ToStrTable`(
	IN `@input` LONGTEXT
)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	DECLARE `@str` VARCHAR(20) DEFAULT '';
	DECLARE `@ind` INT DEFAULT 0;

	DROP TEMPORARY TABLE IF EXISTS ToStrTable;
	CREATE TEMPORARY TABLE IF NOT EXISTS ToStrTable (
		VALUE INT
	);

	IF `@input` IS NOT NULL THEN
	   SET `@ind` = INSTR(@input,',');
	   WHILE `@ind` > 0 DO
	      SET `@str` = SUBSTRING(`@input`,1,`@ind`-1);
	      SET `@input` = SUBSTRING(`@input`,`@ind`+1);
	      INSERT INTO ToStrTable VALUES (`@str`);
	      SET `@ind` = INSTR(`@input`,',');
	   END WHILE;
	   INSERT INTO ToStrTable VALUES (`@input`);
	END IF;
END//


DELIMITER ;

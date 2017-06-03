USE icrp_data;
ALTER TABLE `ProjectAbstract`
	CHANGE COLUMN `ProjectAbstractID` `ProjectAbstractID` INT(11) NOT NULL AUTO_INCREMENT FIRST;
UPDATE `ProjectAbstract` SET
  `ProjectAbstractID` = 0
  WHERE `ProjectAbstractID` = 1;

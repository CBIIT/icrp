
-- **********************************************************************************************************************
-- Table `users`
-- **********************************************************************************************************************

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES 
	(2,'d0a023c5-407b-46bf-93bc-b1a567673455','en'),
	(3,'3e91906e-63c0-4232-9ac1-30bdb052b317','en'),
	(4,'d54cab98-baf9-4c85-a870-8881ed091541','en');	
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;


-- **********************************************************************************************************************
-- Table `user__roles`
-- **********************************************************************************************************************
LOCK TABLES `user__roles` WRITE;
/*!40000 ALTER TABLE `user__roles` DISABLE KEYS */;
INSERT INTO `user__roles` VALUES 	
	('user',0,2,2,'en',0,'manager'),
	('user',0,3,3,'en',0,'partner'),
	('user',0,4,4,'en',0,'partner');	
/*!40000 ALTER TABLE `user__roles` ENABLE KEYS */;
UNLOCK TABLES;


-- **********************************************************************************************************************
-- Table `users_data`
-- **********************************************************************************************************************   
LOCK TABLES `users_data` WRITE;
/*!40000 ALTER TABLE `users_data` DISABLE KEYS */;
INSERT INTO `users_data` VALUES 
    (2,'autologout','enabled','',0),
    (2,'autologout','timeout','',0),
    (2,'contact','enabled','1',0),  
    (3,'autologout','enabled','',0),
    (3,'autologout','timeout','',0),
    (3,'contact','enabled','1',0), 
    (4,'contact','enabled','0',0),
    (4,'autologout','enabled','',0),
    (4,'autologout','timeout','N;',1);  
/*!40000 ALTER TABLE `users_data` ENABLE KEYS */;
UNLOCK TABLES;

-- ******************************************************************************************************
-- Table structure for table `users_field_data`
-- ******************************************************************************************************
LOCK TABLES `users_field_data` WRITE;
/*!40000 ALTER TABLE `users_field_data` DISABLE KEYS */;
INSERT INTO `users_field_data` VALUES 
	(2,'en','en','en','manager','$S$EJVbuZlHoG0qnqhBw4HXRceB/SnsLQF.RoJPT8KOFELPstGPc4.J','manager@icrpartnership.org','America/Phoenix',1,1476744045,1512762411,1515107070,1515107070,'manager@example.com',1,NULL),
    (3,'en','en','en','partner','$S$EBJQaMF1ZeAa8drLKFA92pYzzaWejwVM5IiT05xlZXsFSFVyIWiS','partner@icrpartnership.org','America/New_York',1,1485271141,1514934453,1515079495,1515079495,'partner@example.com',1, NULL),
	(4,'en','en','en','kai-ling.chen','$S$Eo78rJzqRSH/Oc/rqv2BgpSf8Mrhbz0Wux0MxWO2d8/XyQU6YAtl','kai-ling.chen@nih.gov','America/New_York',1,1515106312,1515106804,1515106788,1515106788,'kai-ling.chen@nih.gov',1, NULL);	
/*!40000 ALTER TABLE `users_field_data` ENABLE KEYS */;

UPDATE `users_field_data`
SET pass = '$S$E6JCBV/s3x2MnqzDyeM5KejPHi1d6w23j6lt0QCO53ARIPFewHrl'
WHERE uid=1;
UNLOCK TABLES;

-- ******************************************************************************************************
--  table `user__field_can_upload_library_files`
-- ******************************************************************************************************
LOCK TABLES `user__field_can_upload_library_files` WRITE;
/*!40000 ALTER TABLE `user__field_can_upload_library_files` DISABLE KEYS */;
INSERT INTO `user__field_can_upload_library_files` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);    
/*!40000 ALTER TABLE `user__field_can_upload_library_files` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table .user__field_library_access`
-- ******************************************************************************************************
LOCK TABLES `user__field_library_access` WRITE;
/*!40000 ALTER TABLE `user__field_library_access` DISABLE KEYS */;
INSERT INTO `user__field_library_access` VALUES 
    ('user',0,2,2,'en',0,'general'),
    ('user',0,3,3,'en',0,'general'),
    ('user',0,4,4,'en',0,'general'), 
    ('user',0,2,2,'en',1,'finance'),
	('user',0,2,2,'en',2,'operations and contracts');
/*!40000 ALTER TABLE `user__field_library_access` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_first_name`
-- ******************************************************************************************************
LOCK TABLES `user__field_first_name` WRITE;
/*!40000 ALTER TABLE `user__field_first_name` DISABLE KEYS */;
INSERT INTO `user__field_first_name` VALUES 
    ('user',0,2,2,'en',0,'ICRP'),
    ('user',0,3,3,'en',0,'ICRP'),
    ('user',0,4,4,'en',0,'Kai-Ling');
/*!40000 ALTER TABLE `user__field_first_name` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_last_name`
-- ******************************************************************************************************
LOCK TABLES `user__field_last_name` WRITE;
/*!40000 ALTER TABLE `user__field_last_name` DISABLE KEYS */;
INSERT INTO `user__field_last_name` VALUES 
    ('user',0,2,2,'en',0,'Manager'),
    ('user',0,3,3,'en',0,'Partner'),
    ('user',0,4,4,'en',0,'Chen');
/*!40000 ALTER TABLE `user__field_last_name` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_organization`
-- ******************************************************************************************************
LOCK TABLES `user__field_organization` WRITE;
/*!40000 ALTER TABLE `user__field_organization` DISABLE KEYS */;
INSERT INTO `user__field_organization` VALUES 
    ('user',0,2,2,'en',0,510),
    ('user',0,3,3,'en',0,510),
    ('user',0,4,4,'en',0,546);
/*!40000 ALTER TABLE `user__field_organization` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_membership_status`
-- ******************************************************************************************************
LOCK TABLES `user__field_membership_status` WRITE;
/*!40000 ALTER TABLE `user__field_membership_status` DISABLE KEYS */;
INSERT INTO `user__field_membership_status` VALUES 
    ('user',0,2,2,'en',0,'Active'),
    ('user',0,3,3,'en',0,'Active'),
    ('user',0,4,4,'en',0,'Active');
/*!40000 ALTER TABLE `user__field_membership_status` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_notify_new_events`
-- ******************************************************************************************************
LOCK TABLES `user__field_notify_new_events` WRITE;
/*!40000 ALTER TABLE `user__field_notify_new_events` DISABLE KEYS */;
INSERT INTO `user__field_notify_new_events` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_notify_new_events` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_notify_new_posts`
-- ******************************************************************************************************
LOCK TABLES `user__field_notify_new_posts` WRITE;
/*!40000 ALTER TABLE `user__field_notify_new_posts` DISABLE KEYS */;
INSERT INTO `user__field_notify_new_posts` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_notify_new_posts` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_annual_meetin`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_annual_meetin` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_annual_meetin` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_annual_meetin` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_annual_meetin` ENABLE KEYS */;
UNLOCK TABLES;

-- ******************************************************************************************************
--  table `user__field_subcommittee_cso_coding`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_cso_coding` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_cso_coding` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_cso_coding` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_cso_coding` ENABLE KEYS */;
UNLOCK TABLES;

-- ******************************************************************************************************
--  table `user__field_subcommittee_evaluation`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_evaluation` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_evaluation` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_evaluation` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_evaluation` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_membership`
-- ******************************************************************************************************

LOCK TABLES `user__field_subcommittee_membership` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_membership` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_membership` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_membership` ENABLE KEYS */;
UNLOCK TABLES;

-- ******************************************************************************************************
--  table `user__field_subcommittee_partner_news`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_partner_news` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_partner_news` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_partner_news` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_partner_news` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_partner_opera`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_partner_opera` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_partner_opera` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_partner_opera` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_partner_opera` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_web_site`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_web_site` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_web_site` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_web_site` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_web_site` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_funding`
-- ******************************************************************************************************
LOCK TABLES `user__field_subcommittee_web_site` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_funding` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_funding` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_funding` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_new`
-- ******************************************************************************************************

LOCK TABLES `user__field_subcommittee_new` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_new` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_new` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_new` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
-- Table 'users_roles`
-- ******************************************************************************************************
-- LOCK TABLES `users_roles` WRITE;
-- /*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
-- INSERT INTO `users_roles` VALUES 
-- 	(1,3),(36,3),(24,4),(26,4),(28,4),(30,4),(32,4),(34,4),(1,5),(25,5),(15,6),(18,6),(28,6),(29,6),
-- (18,7),(30,7),(31,7),(18,8),(32,8),(33,8),(15,9),(16,9),(18,9),(24,9),(15,10),(17,10),(18,10),
--     (26,10),(18,11),(34,11),(35,11);
-- /*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
-- UNLOCK TABLES;
-- /*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

-- Dump completed on 2018-01-05 12:19:52
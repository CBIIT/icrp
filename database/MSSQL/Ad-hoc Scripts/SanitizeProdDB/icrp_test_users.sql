-- MySQL dump 10.13  Distrib 5.6.35, for Linux (x86_64)
--
-- Host: icrp-drupal-test    Database: icrp
-- ------------------------------------------------------
--
-- Insert test users to table `users`
-- Insert test users to table `user__roles`
-- Insert test users to table `users_data`
-- Insert test users to table `user__user_picture`
-- Insert test users to table `users_roles`
-- Insert test users to table `users_field_data`
-- Insert test users to table `user__field_can_upload_library_files`
-- Insert test users to table `user__field_first_name`
-- Insert test users to table `user__field_last_name`
-- Insert test users to table `user__field_organization`
-- Insert test users to table `user__field_membership_status`
-- Insert test users to table `user__field_notify_new_events`
-- Insert test users to table `user__field_notify_new_posts`
-- Insert test users to table `user__field_subcommittee_annual_meetin`
-- Insert test users to table `user__field_subcommittee_cso_coding`
-- Insert test users to table `user__field_subcommittee_evaluation`
-- Insert test users to table `user__field_subcommittee_membership`
-- Insert test users to table `user__field_subcommittee_partner_news`
-- Insert test users to table `user__field_subcommittee_partner_opera`
-- Insert test users to table `user__field_subcommittee_web_site`
-- Insert test users tor table `user__field_subcommittee_new`
-- Insert test users to table `user__field_last_forum_visit`
--

-- **********************************************************************************************************************
-- Table `users`
-- **********************************************************************************************************************

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `users` (
  `uid` int(10) unsigned NOT NULL,
  `uuid` varchar(128) CHARACTER SET ascii NOT NULL,
  `langcode` varchar(12) CHARACTER SET ascii NOT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `user_field__uuid__value` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='The base table for user entities.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__roles` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `roles_target_id` varchar(255) CHARACTER SET ascii NOT NULL COMMENT 'The ID of the target entity.',
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`),
  KEY `roles_target_id` (`roles_target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field roles.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__roles`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `users_data` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary key: users.uid for user.',
  `module` varchar(50) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The name of the module declaring the variable.',
  `name` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The identifier of the data.',
  `value` longblob COMMENT 'The value.',
  `serialized` tinyint(3) unsigned DEFAULT '0' COMMENT 'Whether value is serialized.',
  PRIMARY KEY (`uid`,`module`,`name`),
  KEY `module` (`module`),
  KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Stores module data as key/value pairs per user.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_data`
-- (1,'autologout','enabled','',0)
-- (1,'autologout','timeout','',0),
-- (1,'contact','enabled','1',0),
-- (1,'webform_ui','element_type_preview','1',0),
   
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
-- Table `user__user_picture`
-- ******************************************************************************************************

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE  IF NOT EXISTS `user__user_picture` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `user_picture_target_id` int(10) unsigned NOT NULL COMMENT 'The ID of the file entity.',
  `user_picture_alt` varchar(512) DEFAULT NULL COMMENT 'Alternative image text, for the image''s ''alt'' attribute.',
  `user_picture_title` varchar(1024) DEFAULT NULL COMMENT 'Image title text, for the image''s ''title'' attribute.',
  `user_picture_width` int(10) unsigned DEFAULT NULL COMMENT 'The width of the image in pixels.',
  `user_picture_height` int(10) unsigned DEFAULT NULL COMMENT 'The height of the image in pixels.',
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`),
  KEY `user_picture_target_id` (`user_picture_target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field user_picture.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__user_picture`
--

LOCK TABLES `user__user_picture` WRITE;
/*!40000 ALTER TABLE `user__user_picture` DISABLE KEYS */;
/*!40000 ALTER TABLE `user__user_picture` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
-- Table structure for table `users_field_data`
-- ******************************************************************************************************

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `users_field_data` (
  `uid` int(10) unsigned NOT NULL,
  `langcode` varchar(12) CHARACTER SET ascii NOT NULL,
  `preferred_langcode` varchar(12) CHARACTER SET ascii DEFAULT NULL,
  `preferred_admin_langcode` varchar(12) CHARACTER SET ascii DEFAULT NULL,
  `name` varchar(60) NOT NULL,
  `pass` varchar(255) DEFAULT NULL,
  `mail` varchar(254) DEFAULT NULL,
  `timezone` varchar(32) DEFAULT NULL,
  `status` tinyint(4) DEFAULT NULL,
  `created` int(11) NOT NULL,
  `changed` int(11) DEFAULT NULL,
  `access` int(11) NOT NULL,
  `login` int(11) DEFAULT NULL,
  `init` varchar(254) DEFAULT NULL,
  `default_langcode` tinyint(4) NOT NULL,
  `ds_switch` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`uid`,`langcode`),
  UNIQUE KEY `user__name` (`name`,`langcode`),
  KEY `user__id__default_langcode__langcode` (`uid`,`default_langcode`,`langcode`),
  KEY `user_field__mail` (`mail`(191)),
  KEY `user_field__created` (`created`),
  KEY `user_field__access` (`access`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='The data table for user entities.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_field_data`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_can_upload_library_files` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_can_upload_library_files_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_can_upload_library_files.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_can_upload_library_files`
--

LOCK TABLES `user__field_can_upload_library_files` WRITE;
/*!40000 ALTER TABLE `user__field_can_upload_library_files` DISABLE KEYS */;
INSERT INTO `user__field_can_upload_library_files` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);    
/*!40000 ALTER TABLE `user__field_can_upload_library_files` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_first_name`
-- ******************************************************************************************************

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_first_name` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_first_name_value` varchar(255) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_first_name.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_first_name`
--

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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_last_name` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_last_name_value` varchar(255) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_last_name.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_last_name`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_organization` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_organization_target_id` int(10) unsigned NOT NULL COMMENT 'The ID of the target entity.',
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`),
  KEY `field_organization_target_id` (`field_organization_target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_organization.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_organization`
--

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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_membership_status` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_membership_status_value` varchar(255) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`),
  KEY `field_membership_status_value` (`field_membership_status_value`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_membership_status.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_membership_status`
--

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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_notify_new_events` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_notify_new_events_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_notify_new_events.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_notify_new_events`
--

LOCK TABLES `user__field_notify_new_events` WRITE;
/*!40000 ALTER TABLE `user__field_notify_new_events` DISABLE KEYS */;
INSERT INTO `user__field_notify_new_events` VALUES 
    ('user',0,2,2,'en',0,0),
    ('user',0,3,3,'en',0,0),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_notify_new_events` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_notify_new_posts`
-- ******************************************************************************************************
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_notify_new_posts` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_notify_new_posts_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_notify_new_posts.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_notify_new_posts`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_annual_meetin` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_annual_meetin_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_annual…';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_annual_meetin`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_cso_coding` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_cso_coding_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_cso_coding.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_cso_coding`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_evaluation` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_evaluation_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_evaluation.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_evaluation`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_membership` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_membership_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_membership.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_membership`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_partner_news` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_partner_news_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_partner_news.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_partner_news`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_partner_opera` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_partner_opera_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_partner…';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_partner_opera`
--

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
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_web_site` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_web_site_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_web_site.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_web_site`
--

LOCK TABLES `user__field_subcommittee_web_site` WRITE;
/*!40000 ALTER TABLE `user__field_subcommittee_web_site` DISABLE KEYS */;
INSERT INTO `user__field_subcommittee_web_site` VALUES 
    ('user',0,2,2,'en',0,1),
    ('user',0,3,3,'en',0,1),
    ('user',0,4,4,'en',0,1);
/*!40000 ALTER TABLE `user__field_subcommittee_web_site` ENABLE KEYS */;
UNLOCK TABLES;


-- ******************************************************************************************************
--  table `user__field_subcommittee_new`
-- ******************************************************************************************************
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `user__field_subcommittee_new` (
  `bundle` varchar(128) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The field instance bundle to which this row belongs, used when deleting a field instance',
  `deleted` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'A boolean indicating whether this data item has been deleted',
  `entity_id` int(10) unsigned NOT NULL COMMENT 'The entity id this data is attached to',
  `revision_id` int(10) unsigned NOT NULL COMMENT 'The entity revision id this data is attached to, which for an unversioned entity type is the same as the entity id',
  `langcode` varchar(32) CHARACTER SET ascii NOT NULL DEFAULT '' COMMENT 'The language code for this data item.',
  `delta` int(10) unsigned NOT NULL COMMENT 'The sequence number for this data item, used for multi-value fields',
  `field_subcommittee_new_value` tinyint(4) NOT NULL,
  PRIMARY KEY (`entity_id`,`deleted`,`delta`,`langcode`),
  KEY `bundle` (`bundle`),
  KEY `revision_id` (`revision_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data storage for user field field_subcommittee_new.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user__field_subcommittee_new`
--

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

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `users_roles` (
  `uid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: users.uid for user.',
  `rid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Primary Key: role.rid for role.',
  PRIMARY KEY (`uid`,`rid`),
  KEY `rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps users to roles.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_roles`
--

LOCK TABLES `users_roles` WRITE;
/*!40000 ALTER TABLE `users_roles` DISABLE KEYS */;
INSERT INTO `users_roles` VALUES 
	(1,3),(36,3),(24,4),(26,4),(28,4),(30,4),(32,4),(34,4),(1,5),(25,5),(15,6),(18,6),(28,6),(29,6),
    (18,7),(30,7),(31,7),(18,8),(32,8),(33,8),(15,9),(16,9),(18,9),(24,9),(15,10),(17,10),(18,10),
    (26,10),(18,11),(34,11),(35,11);
/*!40000 ALTER TABLE `users_roles` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

-- Dump completed on 2018-01-05 12:19:52

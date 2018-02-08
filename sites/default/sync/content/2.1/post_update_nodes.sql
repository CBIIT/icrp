--
-- Update About Us
--
DELETE FROM `node__body` where entity_id = 6;
INSERT INTO `node__body` VALUES ('page',0,6,6,'en',0,'&zwj;','','full_html');
DELETE FROM `node_revision__body` where entity_id = 6;
INSERT INTO `node_revision__body` VALUES ('page',0,6,6,'en',0,'&zwj;','','full_html');

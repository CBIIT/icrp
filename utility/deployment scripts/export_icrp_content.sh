#!/bin/bash

# Export User Tables from Drupal 8
# SYNTAX:  export_icrp_content.sh icrp {password} icrp
# REQUIRES: MySQL Client

user=$1
password=$2
mysql_database=$3
host=$4

users_exported_file=icrp_content_users.sql
webforms_exported_file=icrp_content_webforms.sql
forums_exported_file=icrp_content_forums.sql

echo "* Set Site to Maintenance mode"
drush sset system.maintenance_mode 1

echo "* Exporting Drupal 8 User and Webform tables..."

# Export users
mysql $mysql_database -u$user -p$password -h$host -e 'show tables like "user%"' |grep -v Tables_in |grep -v mysql | xargs mysqldump $mysql_database -u$user -p$password  -h$host > $users_exported_file

echo "* Export completed. $users_exported_file "

# Export web forms - icrp application submissions, contact...etc.
mysql $mysql_database -u$user -p$password -h$host -e 'show tables like "webform_%"' |grep -v Tables_in |grep -v mysql | xargs mysqldump $mysql_database -u$user -p$password -h$host > $webforms_exported_file

echo "* Export completed. $webforms_exported_file "

# Export ICRP Partnership forums- forums related tables -  node, comment, taxonomy, history...etc  
mysqldump $mysql_database -u$user -p$password -h$host node node__body node__comment node__comment_forum node__taxonomy_forums node_field_data node_field_revision node_revision node_revision__body node_revision__comment_forum node_revision__taxonomy_forums taxonomy_index tracker_node tracker_user user__field_last_forum_visit comment comment__comment_body comment_entity_statistics comment_field_data history forum forum_index > $forums_exported_file

echo "* Export completed. $forums_exported_file "

echo "* Taking Site out of Maintenance mode"
drush sset system.maintenance_mode 0

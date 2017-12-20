#!/bin/bash

# Export User Tables from Drupal 8
# SYNTAX:  export_users.sh.sh <git username> <git password>
# REQUIRES: MySQL Client

user=$1
password=$2
mysql_database=$3
target_file=icrp_forums_content.sql

echo "* Set Site to Maintenance mode"
drush sset system.maintenance_mode 1

echo "* Exporting Drupal 8 User and Webform tables..."

# Export all forum related tables -  node, comment, taxonomy, history...etc  
mysqldump $mysql_database -u$user -p$password node node_access node__body node__comment node__comment_forum node__taxonomy_forums node_field_data node_field_revision node_revision node_revision__body node_revision__comment_forum node_revision__taxonomy_forums taxonomy_index tracker_node tracker_user user__field_last_forum_visit comment comment__comment_body comment_entity_statistics comment_field_data history forum forum_index > $target_file

echo "* Export completed. $target_file "

echo "* Taking Site out of Maintenance mode"
drush sset system.maintenance_mode 0

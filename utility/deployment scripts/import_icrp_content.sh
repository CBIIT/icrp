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

echo "* Importing Drupal content..."

# Import users
mysql $mysql_database -u$user -p$password -h$host < $users_exported_file

echo "*Users Imxport completed."

# Import web forms - icrp application submissions, contact...etc.
mysql $mysql_database -u$user -p$password -h$host < $webforms_exported_file

echo "* webforms Import completed."


echo "* Importing Drupal Forum content"
mysql $mysql_database -u$user -p$password -h$host < $forums_exported_file

echo "Forums Import  completed"

echo "* Taking Site out of Maintenance mode"
drush sset system.maintenance_mode 0

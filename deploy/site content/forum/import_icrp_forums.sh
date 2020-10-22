#!/bin/bash

# Export User Tables from Drupal 8
# SYNTAX:  _users.sh.sh <git username> <git password>
# REQUIRES: MySQL Client

user=$1
password=$2
mysql_database=$3
target_file=icrp_forums_content.sql

echo "* Set Site to Maintenance mode"
drush sset system.maintenance_mode 1

echo "* Importing Drupal Forum content"
mysql -u$user -p$password $mysql_database < $target_file

echo " Import completed"

echo "* Taking Site out of Maintenance mode"
drush sset system.maintenance_mode 0

drush cr
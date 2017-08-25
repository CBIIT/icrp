#!/bin/bash

# Export User Tables from Drupal 8
# SYNTAX:  _users.sh.sh <git username> <git password>
# REQUIRES: MySQL Client

user=$1
password=$2
mysql_database=$3
target_file=exported_icrp_users.sql

if [ "$mysql_database" == "" ]; then
	echo
	echo "SYNTAX:"
	echo "import_icrp_users.sh [mysql username] [mysql password] [msyql database]"
	echo 
	exit 1
fi
echo "***"
echo "* Set Site to Maintenance mode"
echo "***"
drush sset system.maintenance_mode 1

echo "***"
echo "* Importing Drupal 8 User tables"
echo "***"

echo ""
echo "ALL User tables have been dropped."
echo ""

mysql -u$user -p$password $mysql_database < $target_file

echo ""
echo " ALL User have been imported into the ICRP database ($mysql_database)"
echo ""

echo "***"
echo "* Taking Site out of Maintenance mode"
echo "***"
drush sset system.maintenance_mode 0

drush cr
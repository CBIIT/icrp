#!/bin/bash

# Import webforms Tables from Drupal 8
# SYNTAX:  import_webform_submissions.sh.sh <git username> <git password>
# REQUIRES: MySQL Client

mysql_database=$1
user=$2
password=$3
host=$4

target_file=exported_webform_submissions.sql

if [ "$mysql_database" == "" ]; then
	echo
	echo "SYNTAX:"
	echo "import_webform_submissions.sh [msyql database] [mysql username] [mysql password] [host]"
	echo 
	exit 1
fi
echo "***"
echo "* Set Site to Maintenance mode"
echo "***"
drush sset system.maintenance_mode 1

echo "***"
echo "* Importing Drupal 8 webforms tables"
echo "***"

echo ""
echo "ALL web forms tables have been dropped."
echo ""

mysql $mysql_database -u$user -p$password -h$host < $target_file

echo ""
echo " ALL webforms have been imported into the ICRP database"
echo ""

echo "***"
echo "* Taking Site out of Maintenance mode"
echo "***"
drush sset system.maintenance_mode 0

drush cr
#!/bin/bash

# Export Webform Submissions from Drupal 8
# SYNTAX:  export_users.sh.sh <git username> <git password>
# REQUIRES: MySQL Client

user=$1
password=$2
mysql_database=$3
target_file=exported_webform_submissions.sql

if [ "$mysql_database" == "" ]; then
	echo
	echo "SYNTAX:"
	echo "export_webform_submissions.sh [mysql username] [mysql password] [msyql database]"
	echo "WARNING:  DOES NOT WORK WITH WEBFORM THAT HAVE FILES."
	echo "This does not work with the Partnership Application Webforms."
	echo 
	exit 1
fi
echo "***"
echo "* Set Site to Maintenance mode"
echo "***"
drush sset system.maintenance_mode 1

echo "***"
echo "* Exporting Drupal 8 User and Webform tables"
echo "***"

# Source: https://dba.stackexchange.com/questions/9306/how-do-you-mysqldump-specific-tables
#mysql databasename -u [user] -p[password] -e 'show tables like "table_name_%"' 
#       | grep -v Tables_in 
#       | xargs mysqldump [databasename] -u [root] -p [password] > [target_file]

mysql $mysql_database -u$user -p$password -e 'show tables like "webform_%"' |grep -v Tables_in |grep -v mysql | xargs mysqldump $mysql_database -u$user -p$password > $target_file

echo ""
echo "***"
echo "* The following tables have been exported to a SQL file ($target_file)."
echo "***"
echo ""

mysql $mysql_database -u$user -p$password -e 'show tables like "webform_%"' 

echo ""
echo "***"
echo "* Output file: $target_file has been created."
echo "***"
echo ""
echo "***"
echo "* Taking Site out of Maintenance mode"
echo "***"
drush sset system.maintenance_mode 0

echo ""
echo "Use the import_webform_submissions.sh script to import the webforms to an ICRP site."
echo ""
echo "SUMMARY:"
echo "user: $user"
echo "password: ********"
echo "database: $mysql_database"
echo "target file: $target_file"
echo ""


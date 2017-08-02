#!/bin/bash

# Update Tables from Drupal 8
# SYNTAX:  update_user__field_subcommittee_partner_news.sh <database name> <mysql user> <mysql password> <host>
# REQUIRES: MySQL Client

mysql_database=$1
user=$2
password=$3
host=$4

target_file=user__field_subcommittee_partner_news.sql

if [ "$mysql_database" == "" ]; then
	echo
	echo "SYNTAX:"
	echo "update_user__field_subcommittee_partner_news.sh <database name> <mysql user> <mysql password> <host>"
	echo 
	exit 1
fi
echo "***"
echo "* Set Site to Maintenance mode"
echo "***"
drush sset system.maintenance_mode 1

echo "***"
echo "* Updating Drupal 8 User tables"
echo "***"

mysql $mysql_database -u$user -p$password -h$host < $target_file

echo ""
echo " ALL User have been update in the ICRP database ($mysql_database)"
echo ""

echo ""
echo " table user__field_subcommittee_partner_news has been populated."
echo " All users now are selected in the Partner News and Announcements forum"
echo ""

echo "***"
echo "* Taking Site out of Maintenance mode"
echo "***"
drush sset system.maintenance_mode 0

drush cr
#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ "$3" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DB_NAME> <DB_USER> <DB_PASSWORD>"
  echo "* Enter the db name, db user, and db password"
  echo "**"
  exit
fi
DB_NAME=$1
DB_USER=$2
DB_PASS=$3 

echo "*************************************"
echo "* Create Drupal 8.2.7 with ICRP 1.2 *"
echo "*************************************"

cd /local/drupal/
rm -rf icrp/
echo "tar xzf /home/centos/icrp-backups/icrp_1.2.tgz"
tar xzf /home/centos/icrp-backups/icrp_1.2.tgz

echo "********************************************************"
echo "* Importing ICRP 1.2 database tags/icrp_1.2.0_20170718 *"
echo "********************************************************"

echo "**"
echo "* git clone https://<username>:<password>@github.com/CBIIT/icrp.git\n**"
echo "**"
cd /tmp
rm -rf icrp/
git clone https://github.com/CBIIT/icrp.git
cd icrp
echo "**"
echo "* Switching to 1.2"
echo "**"
git checkout tags/icrp_1.2.0_20170718

#import database to icrp
echo "**"
echo "* Import database"
echo "**"
echo "DB_NAME: $DB_NAME"
echo "DB_USER: $DB_USER"
echo "DB_PASS: $DB_PASS"
mysqladmin -u$DB_USER -p$DB_PASS -hlocalhost -f drop $DB_NAME
mysqladmin -u$DB_USER -p$DB_PASS -hlocalhost create $DB_NAME
mysql -u$DB_USER -p$DB_PASS -hlocalhost $DB_NAME  < icrp.sql
cd ..
rm -rf icrp/

echo "**"
echo "* Drupal 8.2.7 ICRP 1.2 is ready"
echo "**"


echo "**"
echo "* Setup sync directory for import/export *"
echo "**"

cd /local/drupal/
cd icrp/sites/default/sync
mkdir config
chmod -R 755 config

cd /local/drupal/icrp
drush cr

echo "**"
echo "* Run upgrade to Drupal 8.3.7 with ICPR 1.2 *"
echo "**"
exit
#/home/centos/icrp/utility/upgrade_produciton_8.3.7.sh



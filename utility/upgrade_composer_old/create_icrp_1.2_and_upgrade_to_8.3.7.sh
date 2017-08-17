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

echo "*************************************"
echo "* Create Drupal 8.2.7 with ICRP 1.2 *"
echo "*************************************"

cd /local/drupal/
rm -rf icrp/
tar xzf /home/centos/icrp-backups/icrp_1.2.tgz

echo "*************************************"
echo "* Create Drupal 8.2.7 with ICRP 1.2 *"
echo "*************************************"
cd /local/drupal/
rm -rf icrp/
tar xzf /home/centos/icrp-backups/icrp_1.2.tgz

echo "**"
echo "* The next command may need your github username and password"
echo "* git clone https://<username>:<password>@github.com/CBIIT/icrp.git\n**"
echo "**"
rm -rf icrp
cd /home/centos
git clone https://github.com/CBIIT/icrp.git
#git clone https://<username>:<password>@github.com/CBIIT/icrp.git

cd icrp
echo "**"
echo "* Switching to 1.2"
echo "**"
git checkout tags/icrp_1.2.0_20170718

#import database to icrp
echo "**"
echo "* Import database"
echo "**"
mysqladmin -u$DB_USER -p$DB_PASS -f drop $DB_NAME
mysqladmin -u$DB_USER -p$DB_PASS create $DB_NAME
mysql -u$DB_USER -p$DB_PASS $DB_NAME < icrp.sql

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

echo "**"
echo "* Run upgrade to Drupal 8.3.7 with ICPR 1.2 *"
echo "**"

git clone https://github.com/CBIIT/icrp.git
./utility/


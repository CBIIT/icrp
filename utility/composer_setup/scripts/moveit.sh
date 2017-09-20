#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
DOC_ROOT=$1

echo "Deploying new sites, modules, themes, libraries"
cd /local/drupal/$DOC_ROOT
OLD="/local/drupal/icrp-old"
cp -rp $OLD/modules/custom modules/. && cp -rp $OLD/themes/bootstrap_subtheme themes/. && cp -rp $OLD/libraries/ . 

#Fix Unicode.php
#mv themes/bootstrap/src/Utility/Unicode.php themes/bootstrap/src/Utility/Unicode.php.bak
echo "Patch Unicode"
rm -f themes/bootstrap/src/Utility/Unicode.php
cp -p $OLD/themes/bootstrap/src/Utility/Unicode.php themes/bootstrap/src/Utility/.

echo "Copying php settings"
#sudo cp /home/centos/settings.php sites/default/
mv sites/default/settings.php sites/default/settings.php.bak
cp -p $OLD/sites/default/settings.php sites/default/.
chmod 666 sites/default/settings.php

echo "Copy default/all"
#cp -rp /local/drupal/icrp-old/sites/all/ sites/all/
echo "Copy default/files"
#rm -rf sites/files
cp -pr $OLD/sites/default/files/ /local/drupal/$DOC_ROOT/sites/default/.

echo "Performing owner changes"
chown -R apache.nobody sites

#chown -R apache.nobody modules && chown -R apache.nobody sites && chown -R apache.nobody themes && chown -R apache.nobody libraries 
#chown -R drupal.drupal modules && chown -R drupal.drupal sites && chown -R drupal.drupal themes && chown -R drupal.drupal libraries 
#chown apache.nobody composer.json
 
#echo "Changing access rights of sites, themes, modules, libraries"
#sudo chmod -R 755 sites themes modules libraries
 
 
echo "Make Controllerpwd directory for db_search_api"
mkdir -p modules/custom/db_search_api/src/Controllerpwd
chown -R apache.nobody modules/custom/db_search_api/src/Controllerpwd
chmod -R 755 modules/custom/db_search_api/src/Controllerpwd

echo "**"
echo "* Assets have been moved"
echo "**"

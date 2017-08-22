#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi
DOC_ROOT=$1

echo "Deploying new sites, modules, themes, libraries"
cd /local/drupal/$DOC_ROOT
OLD="/local/drupal/icrp-old"
sudo cp -R $OLD/modules/ . && sudo cp -R $OLD/themes/ . && sudo cp -R $OLD/libraries/ . 

echo "Copying php settings"
#sudo cp /home/centos/settings.php sites/default/
sudo cp $OLD/sites/default/settings.php sites/default/
 
echo "Copy library files"
#sudo rm -R sites/default/files/library
#sudo mv sites.bak/default/files/library sites/default/files/library
echo "Copy default/all"
sudo cp -pr /local/drupal/icrp-old/sites/all/ sites/all/
echo "Copy default/files"
rm -rf sites/files
sudo cp -pr /local/drupal/icrp-old/sites/default/files/ /local/drupal/$DOC_ROOT/sites/default/files

echo "Performing owner changes"
sudo chown -R apache.nobody modules && sudo chown -R apache.nobody sites && sudo chown -R apache.nobody themes && sudo chown -R apache.nobody libraries &&
sudo chown apache.nobody composer.json
 
echo "Changing access rights of sites, themes, modules, libraries"
sudo chmod -R 755 sites themes modules libraries
 
echo "Import Drupal Configuration from sync directory"
#drush cim
 
echo "Run drush cache-rebuild"
drush cr
 
echo "Copy config.ini"
sudo mkdir -p /local/drupal/icrp/modules/custom/db_search_api/src/Controllerpwd
 
sudo chown -R apache.nobody /local/drupal/icrp/modules
 
#echo "Clean up"
#rm -rf ../icrp.tgz
 
echo "Deployment Completed!" 

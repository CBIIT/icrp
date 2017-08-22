sudo su -
cd /local/drupal

#Restore
cd /local/drupal/
rm -rf icrp/
echo "tar xzf /home/centos/icrp-backups/icrp_1.2.tgz"
tar xzf /home/centos/icrp-backups/icrp_1.2.tgz
#DEPLOY ICRP 1.2 icrp_1.20_20170718 using Jenkins

rm -rf icrp-old
mv icrp icrp-old
rm -rf tmp
rm -rf icrp
mkdir tmp icrp
chown -R drupal:drupal tmp icrp

#Change to DRUPAL USER
sudo su drupal
git clone https://github.com/CBIIT/icrp.git tmp
chmod -R 775 tmp/utility/upgrade_production_8.3.7

#STEP 1: Drupal 8.2.7
tmp/utility/upgrade_production_8.3.7/create_icrp_8.2.7.sh icrp

#STEP 2: Move ICRP assets (As SuperUser)
sudo su -  (or exit from drupal user)

tmp/utility/upgrade_production_8.3.7/move_icrp.sh icrp

#STEP 3: Upgrade to 8.3.7
sudo chmod -R 777 icrp/sites icrp/themes icrp/modules icrp/libraries icrp/composer.json
#Change to DRUPAL USER (Run as Drupal user)
sudo su drupal
tmp/utility/upgrade_production_8.3.7/upgrade_icrp_8.3.7.sh icrp

#STEP 4: Remove layout_plugin (Run as Drupal user)
tmp/utility/upgrade_production_8.3.7/remove_layout_plugin.sh icrp

#STEP 5: Upgrade the rest of the modules
#Run this as DRUPAL USER (Run as Drupal user)
tmp/utility/upgrade_production_8.3.7/upgrade_modules.sh icrp
#Change to ROOT
sudo su - (or exit from drupal user)
sudo chmod -R 755 icrp/sites icrp/themes icrp/modules icrp/libraries
sudo chmod -R 744 icrp/composer.json
#clean up
rm -rf icrp-old tmp
echo "Upgrade Complete"



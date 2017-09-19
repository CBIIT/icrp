#Clone icrp and checkout branch icrp_1.3
#Change to drupal user
sudo su - drupal
git clone https://github.com/CBIIT/icrp.git && cd icrp && git checkout icrp_1.3
exit

#Change user to Super User
sudo su

#Move Site out of the way
cd /local/drupal
rm -f moveit.sh composerit.sh composer.json.8.3.7 makeit.sh missing_argument_4_in_2743715-6.patch
mv icrp icrp-old
cp /home/drupal/icrp/utility/composer_setup/scripts/* /local/drupal
chown drupal:drupal moveit.sh composerit.sh composer.json.8.3.7 makeit.sh missing_argument_4_in_2743715-6.patch
#Create directory
mkdir icrp
chown drupal:drupal icrp
chmod -R 755 icrp

exit

#Create a Compser Site
#Change to drupal user
sudo su - drupal
cd /local/drupal
./composerit.sh icrp
exit

#Move ICRP Assets
#Change user to Super User
sudo su
cd /local/drupal
./moveit.sh icrp
exit

#Clear Cache
sudo su - drupal
cd /local/drupal/icrp
drush cr



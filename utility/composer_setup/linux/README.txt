#Clone icrp and checkout branch icrp_1.3
#Change to drupal user
sudo su - drupal
git clone https://github.com/CBIIT/icrp.git && cd icrp && git checkout icrp_1.3
exit

#Change user to Super User
sudo su

#Move Site out of the way
mv /local/drupal/icrp /local/drupal/icrp
cp /home/drupal/icrp/utility/composer_setup/scripts/* /local/drupal
chown drupal:drupal /local/drupal/makeit.sh /local/drupal/composer.json.8.3.7 /local/drupal/missing_argument_4_in_2743715-6.patch
exit

#Create a Compser Site
#Change to drupal user
sudo su - drupal
/local/drupal
./composerit.sh test


#Move ICRP Assets
#Change user to Super User
sudo su
./moveit.sh test


#Change to drupal user
sudo su - drupal

#Clone icrp and checkout branch icrp_1.3
git clone https://github.com/CBIIT/icrp.git
git checkout icrp_1.3
exit

#Change user to Super User
sudo su
cp icrp/utility/composer_setup/scripts/* /local/drupal
exit


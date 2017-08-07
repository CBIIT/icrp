echo "*"
echo "* Setting site to maintenance MODE"
echo "*"
drush sset system.maintenance_mode 1
echo "*"
echo "* Clearing Cache"
echo "*"
drush cr
echo "*"
echo "* Updating to latest Drupal Core (8.3.5)"
echo "*"
drush -y up drupal-8.3.5
echo "*"
echo "* Setting site to live MODE"
echo "*"
drush sset system.maintenance_mode 0
echo "*"
echo "* Clearing Cache"
echo "*"
drush cr
echo "*"
echo "* Drupal upgraded to 8.3.5"
echo "*"

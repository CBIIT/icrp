#!/usr/bin/env bash
# Upgrade Drupal from to 8.9.x to 9.3.x

#cd /tmp
#git clone https://github.com/CBIIT/icrp icrp
#cd icrp
#git checkout icrp-3.0.0-dev-refresh

#cd /var/www/html
#cp /tmp/icrp/upgrade_icrp.sh .

#mkdir -p /tmp/modules/fullcalendar
#cp -pr modules/fullcalendar/ /tmp/modules/fullcalendar/

# Remove errors from user_import uninstall
echo "Remove errors from user_import uninstall"
grep -v variable_del modules/user_import/user_import.install > tmpfile && mv tmpfile modules/user_import/user_import.install

# Uninstall specific modules.  Most are not used and caused upgrade problems.  
drush pm-uninstall fullcalendar_options, fullcalendar_legend, colors, entity_notification, recovery_pass, search_kint, kint, examples, plugin_type_example content_access security_review user_import partnership_import webform_location_geocomplete webform_toggles libraries -y
rm -rf modules/custom/user_import
rm -rf modules/custom/elasticsearch

echo ""
mv composer.json composer-8.9.1.json

echo "cp /tmp/icrp/upgrade/8.9.20/composer.json ."
cp /tmp/icrp/upgrade/8.9.20/composer.json .
mv themes themes-old
mv modules/custom modules-custom-old
rm -rf themes-old
rm -rf modules-custom-old
rm -rf modules/contrib/fullcalendar

cp -r /tmp/icrp/modules/custom modules/
cp -r /tmp/icrp/modules/contrib/fullcalendar modules/contrib/fullcalendar
cp -r /tmp/icrp/themes ./

#upgrade to 8.9.20
composer update

#Install Modules
drush pm-enable fullcalendar upgrade_status upgrade_rector -y

#update drupal to latest 10
composer require drush/drush:^10

#upgrade to 9.4
echo "Upgrade to Drupal 9.4.x"
composer require drupal/core:^9.4 --no-update
composer update
#Remove permission error on tippy-bundle
#This should be done in composer post install
chmod 755 /var/www/html/libraries/tippyjs/6.x/tippy-bundle.umd.min.js

echo "*** Upgrade modules for php 8.1 compatible"
echo "composer require phpoffice/phpspreadsheet:^1 maennchen/zipstream-php:^2 markbaker/complex:^3 markbaker/matrix:^3"
composer require phpoffice/phpspreadsheet:^1 maennchen/zipstream-php:^2 markbaker/complex:^3 markbaker/matrix:^3
echo "composer require drupal/views_bootstrap:~5.3.0"
composer require "drupal/views_bootstrap:~5.3.0"

#echo "*** Upgrading composer to version 2"
#composer self-update --2

echo "*** composer why-not php:8.1"
composer why-not php:8.1

echo "drush cr"
drush cr

echo "***************************"
echo "*** ICRP Upgrade complete *"
echo "***************************"
echo "save composer.json and composer.lock file"
echo "Use composer install from here on out."
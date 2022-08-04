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
drush pm-uninstall fullcalendar_options, fullcalendar_legend, colors, entity_notification, recovery_pass, search_kint, kint, examples, plugin_type_example content_access security_review faq user_import partnership_import webform_location_geocomplete webform_toggles libraries -y
rm -rf modules/custom/user_import
rm -rf modules/custom/elasticsearch
rm -rf modules/custom/faq

echo ""
mv composer.json composer-8.9.1.json

echo "cp /tmp/icrp/upgrade/8.9.20/composer.json ."
cp /tmp/icrp/upgrade/8.9.20/composer.json .
mv themes themes-old
mv modules/custom modules-custom-old
rm -rf modules-custom-old
rm -rf modules/contrib/fullcalendar

cp -r /tmp/icrp/modules/custom modules/
cp -r /tmp/icrp/modules/contrib/fullcalendar modules/contrib/fullcalendar
cp -r /tmp/icrp/upgrade/themes themes/

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

#echo "*** Upgrading composer to version 2"
#composer self-update --2

echo "*** Upgrade modules for php 8.1 compatible"
echo "composer require phpoffice/phpspreadsheet:^1 maennchen/zipstream-php:^2 markbaker/complex:^3 markbaker/matrix:^3"
composer require phpoffice/phpspreadsheet:^1 maennchen/zipstream-php:^2 markbaker/complex:^3 markbaker/matrix:^3

echo "*** composer why-not php:8.1"
composer why-not php:8.1

echo "***************************"
echo "*** ICRP Upgrade complete *"
echo "***************************"
echo ""

#cp /tmp/icrp/composer.json .
#composer update


#composer outdated "drupal/*"
#drupal/core                 8.9.20       9.3.7       Drupal is an open source content management platform powering millions of websites and...
#drupal/editor_advanced_link 1.9.0        2.0.0       Add title, target etc. attributes to Text Editor's link dialog if the text format allo...
#drupal/linkit               5.0.0-beta13 6.0.0-beta3 Linkit - Enriched linking experience
#drupal/metatag              1.16.0       1.19.0      Manage meta tags for all entities.
#drupal/twig_tweak           2.9.0        3.1.3       A Twig extension with some useful functions and filters for Drupal development.
#drupal/views_bootstrap      3.9.0        4.3.0       Integrate the Bootstrap framework with Views.



#!/usr/bin/env bash
# Upgrade Drupal from to 8.9.x to 9.3.x

cd /tmp
git clone https://github.com/CBIIT/icrp icrp

git checkout icrp-3.0.0-dev
cd /var/www/html

#git branch --set-upstream-to=origin/icrp-3.0.0-dev-d8.9.20
#git config pull.rebase false
#git pull

#mkdir -p /tmp/modules/fullcalendar
#cp -pr modules/fullcalendar/ /tmp/modules/fullcalendar/

# Remove errors from user_import uninstall
echo "Remove errors from user_import uninstall"
grep -v variable_del modules/user_import/user_import.install > tmpfile && mv tmpfile modules/user_import/user_import.install

# Uninstall specific modules.  Most are not used and caused upgrade problems.  
drush pm-uninstall fullcalendar_options, fullcalendar_legend, colors, entity_notification, recovery_pass, search_kint, kint, examples, plugin_type_example content_access security_review faq user_import partnership_import webform_location_geocomplete webform_toggles libraries -y
#rm -rf modules/user_import
#rm -rf modules/elasticsearch

mv composer.json composer-8.9.1.json
cp /tmp/icrp/upgrade/8.9.20/composer.json .
mv themes themes-old
mv modules/custom modules-custom-old

cp -r upgrade/8.9.20/modules/custom modules
cp -r /tmp/icrp/upgrade/8.9.20/themes themes/ 

#upgrade to 8.9.20
composer update

#Install Modules
drush pm-enable fullcalendar upgrade_status upgrade_rector -y

#update drupal to latest 10
composer require drush/drush:^10


#upgrade to 9.3.7
composer require drupal/core:9.3.7 --no-update
composer update
#cp /tmp/icrp/composer.json .
#composer update





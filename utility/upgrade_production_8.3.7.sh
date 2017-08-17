#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

cd /local/drupal/icrp

echo "*****************************************************************"
echo " Upgrading ICRP 1.2 on Drupal 8.2.7 to ICRP 1.2 on Drupal 8.3.7 *"
echo "*****************************************************************"

echo "*"
echo "* Setting site to maintenance MODE"
echo "*"
drush sset system.maintenance_mode 1
echo "*"
echo "* Clearing Cache"
echo "*"
drush cr
echo "*"
echo "* Updating to latest Drupal Core (8.3.7)"
echo "*"
drush -y up  drupal-8.3.7
drush cr

echo "*"
echo "* Remove layout_plugin "
echo "*"


echo "**"
echo "* Uninstall unused modules"
echo "**"
echo "* Uninstall ds"
drush pmu ds_extras -y
drush pmu ds_extras ds  -y
drush pmu ds_switch_view_modeds  -y
drush pmu ds -y 
echo "* Uninstall page_manager"
drush pmu page_manager_ui  -y
drush pmu page_manager  -y
echo "* Uninstall panelizer"
drush pmu panelizer -y
echo "* Uninstall panels"
drush pmu panels_ipe -y
drush pmu panels -y
echo "**"
echo "* Uninstall layout_plugin_views and layout_plugin"
echo "**"
#drush pmu layout_plugin_views -y
#drush pmu layout_plugin -y
#drush pmu bootstrap_layouts -y
#drush pmu layout_plugin -y
#drush updatedb -y
#drush cr
# 1. download panels 4, then bootstrap_layouts 5. order matters
#drush dl panels-8.x-4.0-alpha1 -y
drush dl bootstrap_layouts-8.x-5.x-dev -y

# 2. manual uninstall of layout_plugin - https://drupal.stackexchange.com/a/154888/25221
rm -rf modules/layout_plugin
rm -rf sites/default/files/php

# 3. remove bootstrap_layout services dependency on layout_discovery
mv modules/bootstrap_layouts/bootstrap_layouts.services.yml modules/bootstrap_layouts/bootstrap_layouts.services.yml.bak

# 4. enable layout_discovery
drush en layout_discovery -y

# 5. restore bootstrap_layout services
mv modules/bootstrap_layouts/bootstrap_layouts.services.yml.bak modules/bootstrap_layouts/bootstrap_layouts.services.yml

# 6. rebuild
drush updatedb -y && drush cr
# expect warning: The following module is missing from the file system: layout_plugin bootstrap.inc:240

# 7. fix database expecting layout_plugin module
drush dl layout_plugin -y
drush pm-uninstall layout_plugin -y
# expect warning: layout_plugin is already uninstalled.
rm -fr modules/layout_plugin

# 8. sanity check- should have no warnings related to bootstrap_layouts, layout_plugin, layout_discovery, nor panels
drush updatedb && drush cr

echo "**"
echo "* Installing layout_discovery"
echo "**"

drush en layout_discovery -y
drush updatedb -y
drush cr
echo "*"
echo "* Remove Upgrade all modules "
echo "*"
drush pm-update --no-core -y
drush updatedb -y
drush cr

echo "*"
echo "* Setting site to live MODE"
echo "*"
drush sset system.maintenance_mode 0
echo "*"
echo "* Clearing Cache"
echo "*"
drush cr
echo "*"
echo "* Drupal upgraded to 8.3.7"
echo "*"

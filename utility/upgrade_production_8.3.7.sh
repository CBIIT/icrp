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
drush -y up
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
drush updatedb -y
drush cr
echo "**"
echo "* Uninstall layout_plugin_views and layout_plugin"
echo "**"

drush pmu layout_plugin_views -y
drush pmu bootstrap_layouts -y
drush pmu layout_plugin -y
drush updatedb -y
drush cr
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

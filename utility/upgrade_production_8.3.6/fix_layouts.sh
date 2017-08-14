#
# Upgrade to Drupal 8.3.6 Website from Scratch.
#

if [ "$1" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DOC_ROOT>"
  echo "* Enter the document root"
  echo "**"
  exit
fi
DOC_ROOT=$1 
# Clear cache - causing problems.  Needed sudo to remove root files.
echo "cd $DOC_ROOT"
cd $DOC_ROOT

# 1. download panels 4, then bootstrap_layouts 5. order matters
drush dl page_manager-8.x-4.0-beta2 -y -pm-force
drush dl panelizer-8.x-4.0 -y -pm-force
drush dl bootstrap_layouts-8.x-5.0-alpha1 -y --pm-force
drush dl panels-8.x-4.2 -y --pm-force

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
drush updatedb -y 
drush cr
# expect warning: The following module is missing from the file system: layout_plugin bootstrap.inc:240

# 7. fix database expecting layout_plugin module
drush dl layout_plugin -y --pm-force
drush pm-uninstall layout_plugin -y --pm-force
# expect warning: layout_plugin is already uninstalled.
rm -fr modules/layout_plugin

# 8. sanity check- should have no warnings related to bootstrap_layouts, layout_plugin, layout_discovery, nor panels
drush updatedb -y 
drush cr


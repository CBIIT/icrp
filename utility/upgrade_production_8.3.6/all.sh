
DOC_ROOT=$1 

#create 8.2.7 and install icrp 1.2
./create_icrp_8.2.7.sh drupal8.dev icrp drupal drupal /github/old.drupal8.dev/sites/icrp/sites/default
#create links
./setup.sh $DOC_ROOT
#upgrate Drupal to 8.3.6
./upgrade_icrp_8.3.6.sh drupal8.dev
#Upgrade layout_discovery, remove layout_plugin
./remove_layout_plugin.sh $DOC_ROOT
#Upgrade all the modules to the latest using composer
./upgrade_modules.sh $DOC_ROOT

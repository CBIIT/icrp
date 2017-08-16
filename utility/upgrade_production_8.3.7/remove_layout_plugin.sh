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

echo "**"
echo "* Uninstall unused modules"
echo "**"
drush pmu ds -y 
drush pmu page_manager -y
drush pmu panelizer -y
drush pmu panels -y
drush updatedb -y
drush cr
echo "**"
echo "* Uninstall layout_plugin_views and layout_plugin"
echo "**"

drush pmu layout_plugin_views -y
drush pmu layout_plugin -y
drush updatedb -y
drush cr
echo "**"
echo "* Installing layout_discovery"
echo "**"

drush en layout_discovery -y
drush updatedb -y
drush cr
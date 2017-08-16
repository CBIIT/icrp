#cp modules, themes, libraries, and default directories
echo "**"
echo "* Copy themes and libraries"
echo "**"
cd sites/icrp
rm -rf ../../modules
rm -rf ../../themes
rm -rf ../../libraries

cp -r /tmp/drupal8.dev/modules/* ../../modules
cp -r /tmp/drupal8.dev/themes/* ../../themes
mkdir -p ../../libraries
cp -r /tmp/drupal8.dev/libraries/* ../../libraries
cp -r /tmp/drupal8.dev/sites/default/ ../default/
mysql -udrupal -pdrupal icrp < /tmp/icrp_8.3.6.sql
cd ../..
drush cr

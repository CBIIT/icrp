#cp modules, themes, libraries, and default directories
echo "**"
echo "* Copy themes and libraries"
echo "**"
cd sites/icrp
cp -r modules/* ../../modules
cp -r themes/* ../../themes
mkdir -p ../../libraries
cp -r libraries/* ../../libraries
cp -r sites/default/ ../default/
mysql -udrupal -pdrupal icrp < /tmp/icrp_8.3.6.sql
cd ../..
drush cr

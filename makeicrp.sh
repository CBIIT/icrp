#icrp
cd /github/icrp
echo "Getting $1"
git reset --hard $1
#home
cd /github/drupal8.dev
echo "Composer update"
composer update
echo "Import icrp database"
mysql -udrupal -pdrupal icrp < icrp.sql
echo "Clear Cache"
drush cr 

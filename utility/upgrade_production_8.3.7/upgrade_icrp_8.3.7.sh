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
#Download shell
echo "**"
echo "* Upgrade to 8.3.7"
echo "**"
#git clone https://github.com/genesis55/myproject.git
#cd myproject
#git checkout tags/d8.3.6v4

#cd ..
#cp myproject/composer.json .
#rm -rf myproject
#echo "You should have your composer.json"
sudo chmod -R 777 sites themes modules libraries
sudo chmod -R 777 sites composer.json
# Run composer update
echo "**"
echo "* composer update drupal/core --with-dependencies"
echo "**"
cp ../tmp/utility/upgrade_production_8.3.7/composer/composer.json.8.3.7 ./composer.json
composer update
# drupal/core  --with-dependencies
drush updatedb -y
drush cr 
echo "**"
echo "* Upgrade to Drupal 8.3.7 completed"
echo "**"
echo "**"
echo "* NEXT: Run remove_layout_plugin.sh"
echo "**"
sudo chmod -R 755 sites themes modules libraries
sudo chmod -R 744 sites composer.json


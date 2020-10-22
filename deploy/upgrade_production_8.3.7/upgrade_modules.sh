#
# Upgrade to Drupal 8.3.7#
timestamp() {
  date +"%T"
}

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
echo "* Modules that need to be upgraded after Layout Discovery is enabled."
echo "**"
#git clone https://github.com/genesis55/myproject.git
#cd myproject
#git checkout tags/d8.3.6v5

#cd ..
#cp myproject/composer.json .
#rm -rf myproject
#echo "You should have your composer.json"

#Need to overwrite this file

# Run composer update

echo "**"
echo "* composer update drupal/core --with-dependencies"
echo "**"
mv composer.json composer.json.8.2.7
cp ../tmp/utility/upgrade_production_8.3.7/composer/composer.json.final ./composer.json
composer update
# drupal/core  --with-dependencies
drush updatedb -y
drush cr 
echo "**"
echo "* You have successfully upgraded ICRP 1.2 to Drupal 8.3.7 - Congratulations!"
echo "**"
echo "**"
echo "* NEXT: Test your new site"
echo "**"
echo "**"
echo "* NOTE: Please remember that the Partner Home page and FAQ have issues.  These issues will be fixed when updating to current code."
echo "**"
echo -n "END TIME: "
timestamp




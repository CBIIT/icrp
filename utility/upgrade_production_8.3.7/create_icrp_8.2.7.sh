git clone https://github.com/CBIIT/icrp.git

#
# Creates a Drupal 8.2.7 Website from Scratch.
#
# Define a timestamp function
timestamp() {
  date +"%T"
}
if [ "$5" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DOC_ROOT> <DB_NAME> <DB_USER> <DB_PASSWORD> <SETTINGS_PHP_PATH>"
  echo "* Enter the document root, db name, db user, and db password"
  echo "* Enter the FULL path to the settings.php file to replace after the build"
  echo "**"
  exit
fi
echo -n "START TIME: "
timestamp
DOC_ROOT=$1 
DB_NAME=$2
DB_USER=$3
DB_PASS=$4
SETTINGS_PHP_PATH=$5
# Clear cache - causing problems.  Needed sudo to remove root files.

echo "**"
echo "* Clear cache files (without this it was causing problems.)"
echo "**"
echo "composer clear-cache"
composer clear-cache

#ls -latr ~/.composer/cache/files/doctrine/orm
#ls -latr ~/.composer/cache/files//incenteev/composer-parameter-handler
#ls -latr ~/.composer/cache/files//jdorn/sql-formatter
#sudo rm -f ~/.composer/cache/files//doctrine/orm/*
#sudo rm -f ~/.composer/cache/files//incenteev/composer-parameter-handler/*
#sudo rm -f ~/.composer/cache/files//jdorn/sql-formatter/*
#sudo rm -rf ~/.composer/cache/files/*

#rm all files
echo "**"
echo "* Remove all files from $DOC_ROOT"
echo "**"
echo "mkdir -p $DOC_ROOT"
rm -rf $DOC_ROOT
mkdir -p $DOC_ROOT

echo "**"
echo "* Composer init"
echo "**"
composer create-project drupal-composer/drupal-project:8.x-dev $DOC_ROOT --stability dev --no-interaction

cd $DOC_ROOT
#Download shell
#echo "**"
#echo "* Create 8.2.7 site"
#echo "**"
#git clone https://github.com/genesis55/myproject.git
#cd myproject
#git checkout tags/d8.2.7

#cd ..
#cp myproject/composer.json .
#rm -rf myproject
echo "**"
echo "* Copy composer.json.8.2.7 and run composer update "
echo "**"
cp ../tmp/utility/upgrade_production_8.3.7/composer/composer.json.8.2.7 ./composer.json

echo "You should have your composer.json"

# Run composer update
echo "**"
echo "* composer update drupal/core --with-dependencies\n**"
echo "**"
composer update drupal/core --with-dependencies


echo "**"
echo "* The next command may need your github username and password"
echo "* git clone https://<username>:<password>@github.com/CBIIT/icrp.git\n**"
echo "**"
cd sites
git clone https://github.com/CBIIT/icrp.git
#git clone https://<username>:<password>@github.com/CBIIT/icrp.git

cd icrp
echo "**"
echo "* Switching to 1.2"
echo "**"
git checkout tags/icrp_1.2.0_20170718

#cp modules, themes, libraries, and default directories
echo "**"
echo "* Copy themes and libraries"
echo "**"
cp -r modules/* ../../modules
cp -r themes/* ../../themes
mkdir -p ../../libraries
cp -r libraries/* ../../libraries
cp -r sites/default/ ../default/
cp -rf /local/drupal/icrp-old/sites/default/files /local/drupal/$DOC_ROOT/sites/default/

#cp settings.php to the new site.
echo "**"
echo "* Copy themes and libraries"
echo "**"
echo "cp $SETTINGS_PHP_PATH/settings.php ../default/"
cp $SETTINGS_PHP_PATH/settings.php ../default/

#import database to icrp
echo "**"
echo "* Import database"
echo "**"
#mysqladmin -u$DB_USER -p$DB_PASS -f drop $DB_NAME
#mysqladmin -u$DB_USER -p$DB_PASS create $DB_NAME
#mysql -u$DB_USER -p$DB_PASS $DB_NAME < icrp.sql
drush cr
echo "**"
echo "* ICRP 1.2 is ready"
echo "**"
echo -n "END TIME: "
timestamp
echo "**"
echo "* Install Production database now and clear cache."
echo "**"
echo "**"
echo "* STEP 2:"
echo "* NEXT: Run upgrade_icrp_8.3.6.sh"
echo "**"





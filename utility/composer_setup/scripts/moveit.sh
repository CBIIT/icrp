#
# Move Drupal Site.
#
# Define a timestamp function
if [ "$1" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DOC_ROOT>"
  # <DB_NAME> <DB_USER> <DB_PASSWORD> <SETTINGS_PHP_PATH>"
  #echo "* Enter the document root, db name, db user, and db password"
  #echo "* Enter the FULL path to the settings.php file to replace after the build"
  echo "**"
  exit
fi
echo -n "START TIME: "
timestamp
DOC_ROOT=$1 
cd DOC_ROOT

echo "**"
echo "* copy themes, libraries, and modules/custom"
echo "**"
HOME="/local/drupal/icrp-old"
#HOME="/home/centos/icrp"
#HOME="/github/old3.drupal8.dev"

cp -p $HOME/sites/default/settings.php sites/default/

mkdir modules/custom

cp -rp $HOME/modules/custom/ modules/custom/ 
cp -rp $HOME/themes/ themes/
cp -rp $HOME/libraries/ libraries/

cp -rp $HOME/sites/default/files/ sites/default/files/

echo "**"
echo "* Assets have been moved"
echo "**"

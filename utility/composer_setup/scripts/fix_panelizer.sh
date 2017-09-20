#
# Fix panelizer.
#
if [ "$1" = "" ]
then
  echo "**"
  echo "* Syntax: $0 <DOC_ROOT>"
  echo "**"
  exit
fi
DOC_ROOT=$1 
cd $DOC_ROOT

#This command makes panelize work.  Rescans directories to find modules.
drush cr
#Trick to reset panelizer to new directory
cp ../composer.json.8.3.7 ./composer.json
composer update
drush cr

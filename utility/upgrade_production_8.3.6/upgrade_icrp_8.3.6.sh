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
echo "* Upgarde to 8.3.6"
echo "**"
git clone https://github.com/genesis55/myproject.git
cd myproject
git checkout tags/d8.3.6
cd ..
cp myproject/composer.json .
rm -rf myproject
echo "You should have your composer.json"

# Run composer update
echo "**"
echo "* composer update drupal/core --with-dependencies"
echo "**"
composer update drupal/core  --with-dependencies
drush cr 
echo "**"
echo "* Upgrade to Drupal 8.3.6 completed"
echo "**"
echo "**"
echo "* NEXT: Run update_icrp_8.3.6_modules.sh"
echo "**"



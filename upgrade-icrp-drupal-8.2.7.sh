#!/bin/bash 

function finishUpgrade {
	mkdir /tmp/sandbox
	wget -O /tmp/sandbox https://www.drupal.org/files/projects/drupal-8.2.7.tar.gz
	tar -zxvf /tmp/sandbox/drupal-x.y.z.tar.gz -C /tmp/sandbox

	echo "Copy 8.2.7 to root"
	cp -Rf /tmp/sandbox/drupal-8.2.7/* .
	cp -f drupal-8.2.7/.* .

	echo ""
	echo "Re-apply any modifications to files such as .htaccess, composer.json, or robots.txt.
	If using Composer to manage PHP libraries, update your /vendor directory with the following command:"
}

echo “ICRP Upgrade from Drupal 8.2.2 to Drupal 8.2.7 part 1”
echo “script should be ran in root drupal directory as sudo”
echo ""
echo "Based on directions Update Drupal 8 from this url:"
echo "https://www.drupal.org/node/2700999"
echo ""


echo "1. Backup"
mkdir /tmp/icrp-drupal-8.2.2-backup
cp -r * /tmp/icrp-drupal-8.2.2-backup

echo "2. Put site into maintenance mode"

drush sset system.maintenance_mode 1
drush cr

echo "Step 3. Remove the 'core' and 'vendor' directories. Also remove all of the files in the top-level directory, except any that you added manually."

rm -rf core vendor
rm -f *.* .*

echo "Step 3b. If you made modifications to files like .htaccess, composer.json, or robots.txt, back them up now – you will need to re-apply them from your backup, after you've installed the new Drupal core.  For example, Acquia Dev Desktop places a .htaccess file in the top-level directory and without it, only the homepage on your site will work."

read -n1 -r -p "In another command window replace .htaccess.  When completed press space to continue..." key

if [ "$key" = '' ]; then
	finishUpgrade
fi


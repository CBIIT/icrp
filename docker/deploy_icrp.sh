#!/bin/bash

## root deployment directory
[[ -z "$1" ]] && icrp_root="$HOME/icrp" || icrp_root="$1"

## temp folder
temp_folder="$icrp_root/.tmp"

## docker
docker_root="$icrp_root/docker"
docker_compose_file="$docker_root/docker-compose.yml"
web_container="icrp-web-container"
mysql_container="icrp-mysql-container"

## drupal 8.2.4 (https://www.drupal.org/project/drupal/releases)
drupal_version="8.2.4"
drupal_filename="drupal-$drupal_version.tar.gz"
drupal_filepath="$temp_folder/$drupal_filename"
drupal_url="https://ftp.drupal.org/files/projects/$drupal_filename"
drupal_root="$docker_root/drupal"
drupal_custom_modules_root="$drupal_root/modules/custom"

start_timestamp=$(date +%s)

## icrp repository
repository_url="https://github.com/cbiit/icrp"
repository_root="$temp_folder/repository"

## configuration directory
configuration_directory="$icrp_root/configuration"

echo
echo -e "Deploying ICRP on `date`\n"


## create temp folder if it does not exist
if [ ! -d "$temp_folder" ]; then
  echo -e "Creating temp folder at $temp_folder...\n"
  mkdir -p "$temp_folder"
fi


## clone repository if it does not exist, otherwise pull latest changes
echo "Updating repository..."
if [ -d "$repository_root" ]; then
  pushd "$repository_root"
  git pull
  popd
else
  git clone "$repository_url" "$repository_root" 
  echo
fi


## download drupal if the archive does not exist
if [ ! -e "$drupal_filepath" ]; then
  echo -e "Downloading Drupal $drupal_version from $drupal_url\n"
  curl "$drupal_url" -o "$drupal_filepath"
fi

echo

## extract drupal release
echo -e "Extracting drupal root...\n"
sudo rm -rf "$drupal_root"
mkdir -p "$drupal_root"
tar xf "$drupal_filepath" --strip-components 1 --directory "$drupal_root"

## copy icrp project files
echo "Copying icrp project files..."
for directory in libraries modules sites themes
do
  echo " - copying $directory"
  mkdir -p "$drupal_root/$directory"
  cp -R "$repository_root/$directory/"* "$drupal_root/$directory"
done

echo

## copy icrp-specific configuration files
## these should be located in a 'configuration' directory
## in the icrp root deployment directory
if [ -d "$configuration_directory" ]; then
  echo -e "Copying configuration files...\n"
  if [ -f "$configuration_directory/settings.php" ]; then
    cp "$configuration_directory/settings.php" "$drupal_root/sites/default/"
  fi

  if [ -f "$configuration_directory/connection.ini" ]; then
    for directory in "$drupal_custom_modules_root/db_project_view" "$drupal_custom_modules_root/db_search_api"
    do
      if [ -d "$directory/src/Controller" ]; then
        echo "Copying connection settings to $directory/src/Controller"
        cp "$configuration_directory/connection.ini" "$directory/src/Controller"
      fi
    done
  fi
else
  mkdir -p "$configuration_directory"
fi


echo -e "Initializing docker directory...\n"
mkdir -p "$docker_root"
cp -R "$repository_root/docker/build/"* "$docker_root/"


## copy icrp database dump to docker build context
if [ -f "$repository_root/icrp.sql" ]; then
  echo -e "Copying icrp database dump to docker directory...\n"
  cp "$repository_root/icrp.sql" "$docker_root/"
fi


## restart container
pushd $docker_root
echo -e "Removing containers..."
docker-compose down


echo -e "Starting containers...\n"
rm -rf $temp_folder/log $temp_folder/error_log
nohup docker-compose up > $temp_folder/log 2> $temp_folder/error_log < /dev/null &
popd

## wait until mysql container is ready
## while [ $(tail -n1 $temp_folder/log | grep -v "mysqld.sock") ]; do sleep 2; done
echo "sleeping"
sleep 10

## import drupal database
echo -e "Importing icrp database...\n"
docker exec $mysql_container bash -c "mysql -udrupal -pdrupal -e 'drop database drupal'"
docker exec $mysql_container bash -c "mysql -udrupal -pdrupal -e 'create database drupal'"
docker exec $mysql_container bash -c "mysql -udrupal -pdrupal drupal < /tmp/icrp.sql"

## rebuild drupal cache
echo -e "Rebuilding cache...\n"
docker exec $web_container bash -c "cd /var/www/html && drush cr"



echo -e "Done\n"

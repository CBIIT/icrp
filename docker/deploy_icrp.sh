#!/bin/bash

## root deployment directory
[[ -z "$1" ]] && icrp_root="$HOME/icrp" || icrp_root="$1"

## temp folder
temp_folder="$icrp_root/.tmp"

## docker
docker_root="$icrp_root/docker"
docker_compose_file="$icrp_root/docker/docker-compose.yml"

## drupal 8.2.4 (https://www.drupal.org/project/drupal/releases)
drupal_version="8.2.4"
drupal_filename="drupal-$drupal_version.tar.gz"
drupal_filepath="$temp_folder/$drupal_filename"
drupal_url="https://ftp.drupal.org/files/projects/$drupal_filename"
drupal_root="$docker_root/drupal"

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
  git -C "$repository_root" pull 
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
rm -rf "$drupal_root"
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
if [ -d "$configuration_directory" ]; then
  echo -e "Copying configuration files...\n"
  if [ -f "$configuration_directory/settings.php" ]; then
    cp "$configuration_directory/settings.php" "$drupal_root/sites/default/"
  fi
else
  mkdir -p "$configuration_directory"
fi



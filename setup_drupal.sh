#!/bin/bash

TEMP_DIR="$PWD/temp"
DRUPAL_VERSION="8.3.5"
DRUPAL_FILENAME="drupal-$DRUPAL_VERSION.tar.gz"
DRUPAL_FILEPATH="$TEMP_DIR/$DRUPAL_FILENAME"
DRUPAL_URL="http://ftp.drupal.org/files/projects/$DRUPAL_FILENAME"
declare -a DRUPAL_FILES=(core vendor autoload.php index.php update.php .htaccess)

echo "Drupal $DRUPAL_VERSION"
echo
echo "This script will download and extract Drupal $DRUPAL_VERSION to the current directory."

mkdir -p "$TEMP_DIR"
rm -rf 

if [ ! -e "$DRUPAL_FILEPATH" ]; then
  echo -e "[DOWNLOAD] $DRUPAL_FILENAME [FROM] $DRUPAL_URL \n"
  curl -L "$DRUPAL_URL" -o "$DRUPAL_FILEPATH"
  echo
else
  echo "[FILE EXISTS] $DRUPAL_FILEPATH"
fi

echo "[UNTAR] $DRUPAL_FILEPATH [->] $TEMP_DIR"
pushd "$TEMP_DIR" > /dev/null
tar -xf "$DRUPAL_FILEPATH" --strip-components=1
popd > /dev/null

for FILE in ${DRUPAL_FILES[@]}; do
  FILEPATH="$TEMP_DIR/$FILE"
  echo "[MOVE] $FILEPATH [->] $PWD"
  rm -rf "$PWD/$FILE"
  mv -f "$FILEPATH" "$PWD"
  echo
done



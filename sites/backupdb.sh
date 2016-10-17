#!/usr/bin/env bash

databasename="icrp"
file_name="backup/icrp"
mysqldump=`which mysqldump`

echo "MySQLDump Path: $mysqldump"
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo "Current Time : $current_time"
 
new_fileName=$file_name.$current_time."sql"
echo "New FileName: " "$new_fileName"

mysqldump -udrupal -p  --add-drop-table --comments --complete-insert --dump-date --verbose $dabasename > $new_fileName

#Copy to sc.sql.  This file will always be current and push to github
cp $new_fileName $dabasename.sql
echo "You should see new file generated with timestamp on it.."


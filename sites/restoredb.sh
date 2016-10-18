databasename="icrp"
file_name="backup/icrp"

mysql -udrupal -p  $databasename < $new_fileName
echo "Database has been imported."


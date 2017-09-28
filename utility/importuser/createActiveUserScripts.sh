#!/bin/bash

# This program will create scripts to active 10 Drupal users in batches of 10
# The program assumes less than 180 active users

echo "Creating scripts to open 10 users at a time to active new imported users into ICRP."
echo "Execute scripts one at a time and click on the save button."
echo "when clicked the user will receive the welcome e-mail with the one-time-link"
echo ""
echo ""

#program="chrome.exe"
program="open"
hostname="icrpartnership-dev.org"


offset=0
chunksize=10
current_row=1
max_users=180;
iterations=$((max_users / chunksize + 1))

echo "Removing old files"
echo "rm users*"
rm users*
echo 
echo "program to open url is $program"
echo "hostname to include in url is $hostname"

echo "offset is $offset"
echo "chunksize is $chunksize"
echo "current_row is $current_row"

#Loop for up to 180 active users users
for ((i=1; i<iterations; i++))
do
	echo 
	outscript="users.$current_row-$(($offset +$chunksize)).sh"
	echo "Createing $outscript script"
	echo "#!/bin/bash" > $outscript
	echo "" >> $outscript
	echo "# Activate users $current_row to $offset" >> $outscript
	echo "" >> $outscript
	query="SELECT CONCAT('$program http://$hostname/user/', uid, '/edit') FROM users_field_data where status = 1 limit $chunksize offset $offset;"
	echo $query
	drush sql-query "$query"  >> $outscript
	current_row=$((current_row + chunksize))
	offset=$((offset + chunksize))
done

chmod 755 users*

echo ""
echo "Scripts have been created.  Run scripts to open up 10 users at a time.  Save each user with a role with status of active.  This event will trigger the one-time-link email"
echo ""

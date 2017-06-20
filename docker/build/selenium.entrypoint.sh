#!/bin/bash

Xvfb :10 -screen 1 1920x1080x24 +extension RANDR &
export DISPLAY=:10.1

pushd /tests
mvn clean
mvn test \
  "-Dwebsite.url=$ICRP_WEBSITE_URL" \
  "-Dadmin.username=$ICRP_ADMIN_USERNAME" \
  "-Dadmin.password=$ICRP_ADMIN_PASSWORD" \
  "-Dmanager.username=$ICRP_MANAGER_USERNAME" \
  "-Dmanager.password=$ICRP_MANAGER_PASSWORD" \
  "-Dpartner.username=$ICRP_PARTNER_USERNAME" \
  "-Dpartner.password=$ICRP_PARTNER_PASSWORD"

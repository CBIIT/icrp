#!/usr/bin/env bash
# Stage files for icrp upgrade

git clone https://github.com/CBIIT/icrp /tmp/icrp --branch icrp-3.0.0-dev-refresh
cp /tmp/icrp/upgrade_icrp.sh .
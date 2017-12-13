#!/bin/bash -e

# Updates db for wordpress site
# - Pull repo
# - Find and replace site url in db dump
# - Update db with mysql

### Constant ###

BASE_DIR=$(dirname "$0")/..
WP_CONFIG_ROOT=$BASE_DIR/wp-config.php

### Main ###

# Param
if [ $# != 2 ]; then
  echo "Usage $0 <old url> <new url>"
  exit 1;
fi

OLD_SITEURL=$1
NEW_SITEURL=$2

# Get info from wp-config.php file
DB_NAME=`grep DB_NAME $WP_CONFIG_ROOT | cut -d "'" -f 4`
DB_USER=`grep DB_USER $WP_CONFIG_ROOT | cut -d "'" -f 4`
DB_PASSWORD=`grep DB_PASSWORD $WP_CONFIG_ROOT | cut -d "'" -f 4`
TABLE_PREFIX=`grep table_prefix $WP_CONFIG_ROOT | cut -d "'" -f 2`

# Default location of db dump file
WP_DB_DUMP_FILE=$BASE_DIR/sql/$DB_NAME.sql

# Replacing site url
if [ -f $WP_DB_DUMP_FILE ]; then
  echo "Replacing site url in database dump file - $WP_DB_DUMP_FILE"
  sed -i "s/http:\/\/$OLD_SITEURL/http:\/\/$NEW_SITEURL/" $WP_DB_DUMP_FILE
  echo "Done"
else
  echo "Sql dump file not found - $WP_DB_DUMP_FILE"
fi

# Importing db file
#mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < $WP_DB_DUMP_FILE
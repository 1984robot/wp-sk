#!/bin/bash -e

# Prepares a Wordpress install for local dev
# - Wordpress extract from .tar.gz archive
# - Generates a wp-config.php file based on a config script

### Constant ###

BASE_DIR=$(dirname "$0")/..

# Helper scripts
CONFIG_SCRIPT=$BASE_DIR/bin/config.sh

# Wordpress core
WP_ARCH=$BASE_DIR/wordpress.tar.gz
WP_DIR=$BASE_DIR/wp
WP_DOWNLOAD_URL='https://wordpress.org/latest.tar.gz'

# Wordpress config file
WP_CONFIG_DEFAULT=$BASE_DIR/wp/wp-config.php
WP_CONFIG_ROOT=$BASE_DIR/wp-config.php

# wp-config default vars
DB_NAME='database_name'
DB_USER='root'
DB_PASSWORD=''
DB_HOST='localhost'
TABLE_PREFIX='wp_'

### Function ###

get-wordpress()
{
  # Get latest Wordpress version
  echo "Downloading from $WP_DOWNLOAD_URL"
  wget -q $WP_DOWNLOAD_URL -O $WP_ARCH \
  && echo "Download successful" \
  || (echo "Problem while downloading. Abort"; rm $WP_ARCH; exit 1)

  # Extracting
  echo "Creating directory"
  mkdir $WP_DIR
  echo "Extracting wordpress..."
  tar -zxf $WP_ARCH --directory $WP_DIR --strip 1
  echo "Done"
  
  # Removing archive
  echo "Removing Wordpress archive"
  rm $WP_ARCH
  echo "Done"

}

### Main ###

# Param
while [ "$1" != "" ];do
  case $1 in
    -d | --database )
      shift
      DB_NAME=$1
      ;;
    -u | --user )
      shift
      DB_USER=$1
      ;;
    -p | --password )
      shift
      DB_PASSWORD=$1
      ;;
    -h | --host )
      shift
      DB_HOST=$1
      ;;
    -t | --table-prefix )
      shift
      TABLE_PREFIX=$1
      ;;
  esac
  shift
done

# Wordpress extract
if [ ! -d $WP_DIR ]; then
  echo "No Wordpress directory found"
  echo "Getting wordpress"
  get-wordpress
else
  echo "Wordpress directory already exists, no update"
fi

# Config
if [ -f $WP_CONFIG_DEFAULT ]; then
  echo "Config file found : $WP_CONFIG_DEFAULT"
  echo "Skiping config"
elif [ -f $WP_CONFIG_ROOT ]; then
  echo "Config file found : $WP_CONFIG_ROOT"
  echo "Skiping config"
else
  echo "Creating config file"
  if [ "$DB_PASSWORD" != "" ]; then
    $CONFIG_SCRIPT -o $WP_CONFIG_ROOT -d $DB_NAME -u $DB_USER -h $DB_HOST -t $TABLE_PREFIX -p $DB_PASSWORD
  else
    $CONFIG_SCRIPT -o $WP_CONFIG_ROOT -d $DB_NAME -u $DB_USER -h $DB_HOST -t $TABLE_PREFIX
  fi
fi
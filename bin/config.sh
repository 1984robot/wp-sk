#!/bin/bash -e

# This script creates a wp-config.php file based on the configuration below 

### Config ###

OUTPUT_FILE='wp-config-test.php'

DB_NAME='database_name'
DB_USER='root'
DB_PASSWORD=''
DB_HOST='localhost'
TABLE_PREFIX='wp_'

### Main ###

# Param
while [ "$1" != "" ];do
  case $1 in
    -o | --output-file )
      shift
      OUTPUT_FILE=$1
      ;;
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

# Config output
cat > $OUTPUT_FILE << _EOF_
<?php

// -------------------------------------------------------------
// Database
// -------------------------------------------------------------

	define('DB_NAME', '$DB_NAME');
	define('DB_USER', '$DB_USER');
	define('DB_PASSWORD', '$DB_PASSWORD');
	define('DB_HOST', '$DB_HOST');


// -------------------------------------------------------------
// Change content directory
// -------------------------------------------------------------
define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/content' );
define( 'WP_CONTENT_URL', 'http://' . \$_SERVER['HTTP_HOST'] . '/content' );

// -------------------------------------------------------------
// Rest of the config (from wp-config-sample.php)
// -------------------------------------------------------------

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('SECURE_AUTH_KEY',  '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('LOGGED_IN_KEY',    '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('NONCE_KEY',        '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('AUTH_SALT',        '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('SECURE_AUTH_SALT', '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('LOGGED_IN_SALT',   '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');
define('NONCE_SALT',       '$(echo $RANDOM $DB_NAME | sha256sum | sed -e "s/  -//")');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix  = '$TABLE_PREFIX';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');

_EOF_
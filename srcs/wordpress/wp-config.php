<?php


// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'ikole' );

/** MySQL database password */
define( 'DB_PASSWORD', 'fluffy' );

/** MySQL hostname */
define( 'DB_HOST', 'localhost' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('AUTH_KEY',         '9m|RcM>3rZh^<]:w:VQA*7L>s<8/>fXN?05Qtx+v7|LPc.//fh(gy60~J4tO?-m ');
define('SECURE_AUTH_KEY',  'C/hkPl)QkKYAau:&Q/Am:^/(/4!2Ob4kVL78c(`-glT3F/P:3y:|k5kETU+u5|`/');
define('LOGGED_IN_KEY',    'r^oKK1J*oIYf$gGf^W8>1=^3k0nM_pQNU^aT@6x<?3GxmAl+((;.d06FY-.[ULiu');
define('NONCE_KEY',        'JF1 DQUyXBh%I ob/nU_~Sh45}Uf^K#+oU{iahN2H>SHVH6Dpuh~8tQO-f*H34Yp');
define('AUTH_SALT',        'xc}qx.H&bT/[e|V?><4Zd[ Gei+*qO?67.*l#s_Lf!uxLQE.ubu-K*:l){q>nHk@');
define('SECURE_AUTH_SALT', '/Dr{]^y(hSQ!j*W,OA_tVyo8LCcevef>@c}BPIv(*Zqrq%bF&a>#Mw2GNoH{toUu');
define('LOGGED_IN_SALT',   '~/m-):Y*cN8hhBk}l2llM,5B*+PRnEs^Bup]~y[fFZj:m8!AI.0*A{sAh8vV1&Yw');
define('NONCE_SALT',       '+jBMQRWz.KRD:OCZ@f,!|a3X[Q<6~(,zX`uODLFud^z7iiccm<i_|1A:fC{ o8|)');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 *  *
 * For information on other constants that can be used for debugging,
 *  * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );
define( 'FS_METHOD','direct');
/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
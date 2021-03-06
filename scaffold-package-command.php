<?php

if ( ! class_exists( 'WP_CLI' ) ) {
	return;
}

$autoload = dirname( __FILE__ ) . '/vendor/autoload.php';
if ( file_exists( $autoload ) ) {
	require_once $autoload;
}

WP_CLI::add_command( 'scaffold package', array( 'WP_CLI\ScaffoldPackageCommand', 'package' ) );
WP_CLI::add_command( 'scaffold package-readme', array( 'WP_CLI\ScaffoldPackageCommand', 'package_readme' ) );
WP_CLI::add_command( 'scaffold package-tests', array( 'WP_CLI\ScaffoldPackageCommand', 'package_tests' ) );
WP_CLI::add_command( 'scaffold package-github', array( 'WP_CLI\ScaffoldPackageCommand', 'package_github' ) );

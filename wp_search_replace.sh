#!/bin/bash
#
# @file wp_search_replace.sh
#
# Do a search and replace on a  WP database using WP-CLI, including any
# serialized data (IMPORTANT!!!). Run from within anywhere in the site itself.
# This is most useful for fixing any hardcoded domains that WP creates during
# uploads, etc.
#
# USAGE: wp_search_replace.sh [-n] old_domain.com new_domain.com
#
# For **Multisite** pass the -n argument, its necessary
#
# @author @dbsinteractive 2014-11-31
#
#######################################################


#######################################################

wp=wp
# sometimes root is a good  thing
#wp="wp --allow-root"

[ "$1" == "-n" ] && network=" --network" && shift

clear

! which wp > /dev/null && echo wp-cli not installed, aborting. FIXME! && exit 1

! [ $1 ] && echo 'USAGE: wp_search_replace.sh [-n] old_domain.com new_domain.tld'  && exit 1
! [ $2 ] && echo 'USAGE: wp_search_replace.sh [-n] old_domain.com new_domain.tld'  && exit 1

echo Your are about to update a WP database, please have a current backup handy.
echo -n Selected database is:\  
$wp db query "select database()" |grep -v "database(\|*" || exit 1
echo
echo If this is not the correct database, cancel now ctrl-c, and use defined\(\'WP_CLI\'\) 
echo to select the correct database in wp-config.php.
echo Press any key when ready, sir, or ctrl-c to cancel
read

clear
echo Let\'s do a dry run first, OK? Press any key.
read

$wp search-replace $network $1 $2 --dry-run

echo Look OK? If not, ctrl-c to cancel, anything else to give it a go for real this time.
read 

echo running for real now ...
sleep 1
$wp search-replace $network $1 $2

echo Done.

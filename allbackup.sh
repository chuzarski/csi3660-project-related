#!/usr/bin/bash

# Author: Cody Huzarski

# This script will backup the mariadb database and all files for the phpBB installation. 
# Variables are used to configure different elements of the script (backup directory, phpBB location, db credentials)
# Backups are made using tar archives and compressed using gzip

# MariaDB configuration
MARIADB_DB=forumdb
MARIADB_USER=forumdbbak
MARIADB_PASSWORD=79ce77fc-48ad-11ec-81d3-0242ac130003

# Directory path configuration
BACKUP_TMP_DIR=/tmp/backups/
PHPBB_ROOT=/var/www/html/forum
BACKUP_ROOT=/usr/local/CSI3660ProjectBackup

# -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/
#
# The remaining variables aren't configuration variables
#
# -/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/-/

# Generate a backup name. This will be used for the directory and for the archive
backup_name=service-backup-$(date -I)

# Here we will generate a variable that holds the backup root
# Here the date manpage was referenced to generate this date command
backup_tmp_root=$BACKUP_TMP_DIR/$backup_name/

# Create variable for backup sql file location
database_backup_file=$backup_tmp_root/database-$backup_name.sql

# Create the directory
mkdir -p $backup_tmp_root

# Backup database to sql file
mariadb-dump -u $MARIADB_USER -p$MARIADB_PASSWORD --lock-tables --databases $MARIADB_DB > $database_backup_file

# Archive everything: DB backup and phpBB file root
tar czf $BACKUP_ROOT/$backup_name.tar.gz $database_backup_file $PHPBB_ROOT

# Clean up
rm -rf $backup_tmp_root
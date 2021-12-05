# Service Backups

Both the root directory of the phpBB installation and the MariaDB database for phpBB are backed up.
The backups are stored in a tar archive which is gzip compressed and stored in `/usr/local/CSI3660ProjectBackup`
Tar archives are used since it is a simple solution for backups.

- phpBB root directory
    - All files are backed up since these files could change over time - themes or extensions could be installed to phpBB
- MariaDB Database
    - The database is backed up to an sql file using `mariadb-backup`
        - See: https://mariadb.com/kb/en/making-backups-with-mysqldump/

Both the phpBB root directory (`/var/www/html/forum`) and the MariaDB sql file is archived and gzipped to reduce storage requirements.
All Backup files are labeled with the following pattern: `service-backup-(yyyy-mm-dd)`

The `/usr/local/CSI3660ProjectBackup` directory is another partition on a drive seperate from the system drive.
This is to ensure that the backups will be safe from hard drive failure of the main system drive. The directory
is automatically mounted at boot due to the corresponding `/etc/fstab/` entry.

Backups are conducted by the script located at `/usr/local/bin/service-backup.sh`
This script is called by the cron daemon daily at 2:25 AM. The backups are ran as the user `backups`
Daily backups ensure that the service is able to recover to a recent point of state in case of a failure.

The backup directory is owned by the user `backups` and the group `admin` such that only the `backups`
user and `admin` users can modify backup files (that is, they are safe from being deleted by regular users).

Finally, the backup script will log backup success using rsyslog. These logs are stored in `/var/log/backups.log`
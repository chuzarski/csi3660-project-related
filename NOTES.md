TASKS:

* [ - ] Install Apache
  * [ - ] Install PHP / Apache extension
* [ - ] Install MariaDB
* [ - ] Install phpBB
  * [ - ] Internal phpBB setup
* [ - ] Backup phpBB user content (script)
* [ - ] Backup MySQL database (script)
* [ - ] Monitor system upgrades using apt-unattended


# Notes for each task
Generally: This page was adapted for setting up LAMP on Debian
https://wiki.debian.org/LaMp

### Install Apache
apache2 was installed using:

sudo apt install apache2

### Install MariaDB

The following was used to install mysql:

sudo apt install default-mysql-server default-mysql-client

On Debian, default-mysql-server and default-mysql-client resolve to mariadb

The following was referenced to setup database and user in MariaDB
https://mariadb.com/kb/en/create-database/
https://mariadb.com/kb/en/create-user/
https://mariadb.com/kb/en/grant/

> credentials
> name: forumdb
> user: forumdbsupervisor
> pass: 2acec820-1ec4-47b2-93f6-0106e2d8f29a

The following query was used to create the database:

```sql
CREATE DATABASE forumdb;
```

The user was created using the following queries:
```sql
CREATE USER forumdbsupervisor@localhost IDENTIFIED BY '2acec820-1ec4-47b2-93f6-0106e2d8f29a';
```

```sql
GRANT ALL PRIVILEGES ON `forumdb`.* TO `forumdbsupervisor`@`localhost`; 
```

### Install PHP
To install PHP:

sudo apt install php php-mysql

the apache module for php is automatically pulled in (And configured)

phpBB also requires php mbstring support and xml/doc support, so:

sudo apt install php-mbstring php-xml

### Install phpBB
wget https://download.phpbb.com/pub/release/3.3/3.3.5/phpBB-3.3.5.zip
unzip phpBB-3.3.5.zip
mv phpBB /var/www/html/forum

from there, navigating to <SERVERIP>/forum comes to a guided install script

This was referenced to set the correct permissions for phpbb:
https://www.phpbb.com/support/docs/en/3.0/kb/article/phpbb3-chmod-permissions/




# Backups


## Database

Backing up MariaDB: 
https://mariadb.com/kb/en/making-backups-with-mysqldump/


backup user: forumdbbak
backup password: 79ce77fc-48ad-11ec-81d3-0242ac130003

The permissions for this user was set using the following query:

```sql
 GRANT SELECT, LOCK TABLES ON `forumdb`.* TO `forumdbbak`@`localhost`; 
```

> SELECT gives the user read only priveleges, LOCK TABLES is used for the mariadb-dump command to lock the tables so no changes are made during the backup.

The query to create the user was similar to the forumdbsupervisor user

---

The following command was issued to test out database backups

```
mariadb-dump -u forumdbbak -p79ce77fc-48ad-11ec-81d3-0242ac130003 --lock-tables --databases forumdb > ./test-backup.sql
```


## Backup disk

There is another disk that is mounted to the backup directory. 

Its a standard persistent disk attatched to the VM. The disk was partitioned using `cgdisk` and formatted with `mkfs.ext4`

all backups live on /dev/sdb1

/dev/sdb1 has an entry in fstab and is mounted at /usr/local/CSI3660ProjectBackup
the [fstab(5) manpage](https://manpages.debian.org/bullseye/mount/fstab.5.en.html) was referenced for the entry

#!/usr/bin/bash

LOGFILE=/var/log/packagelogger/packages-$(date -I).log

echo >> $LOGFILE # Extra line of space
echo "=========================================" >> $LOGFILE
echo "UPGRADABLE PACKAGES ON $(date -I)" >> $LOGFILE
echo "=========================================" >> $LOGFILE
echo >> $LOGFILE # Extra line of space


sudo apt update
apt list --upgradable 2>/dev/null >> $LOGFILE 
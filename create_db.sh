#!/bin/bash
#MASTER="| mysql -u root -prfc1830rfc1830rfc1830"
echo "DROP DATABASE IF EXISTS silenceDB;" | mysql -u root -prfc1830rfc1830rfc1830
echo "CREATE DATABASE silenceDB;" | mysql -u root -prfc1830rfc1830rfc1830

echo "CREATE TABLE IF NOT EXISTS status (
    mntpnt VARCHAR(190) NOT NULL,
    alive INT,
    status INT,
    since INT,
    PRIMARY KEY (mntpnt)
)  ENGINE=INNODB;" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB

echo "GRANT SELECT,UPDATE ON silenceDB.status TO 'detector'@'%' IDENTIFIED BY 'rfc1830';" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB

exit $?
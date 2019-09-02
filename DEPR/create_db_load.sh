#!/bin/bash
#MASTER="| mysql -u root -prfc1830rfc1830rfc1830"
#echo "DROP DATABASE IF EXISTS silenceDB;" | mysql -u root -prfc1830rfc1830rfc1830

echo "CREATE DATABASE IF NOT EXISTS silenceDB;" | mysql -u root -prfc1830rfc1830rfc1830 --connect-timeout=10
echo "DROP TABLE IF EXISTS detectorload;" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB --connect-timeout=10
echo "CREATE TABLE IF NOT EXISTS detectorload (
    ipaddr VARCHAR(190) NOT NULL,
    alive INT,
    cpuidle INT,
    nload INT,
    PRIMARY KEY (ipaddr)
)  ENGINE=INNODB;" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB --connect-timeout=10

echo "GRANT SELECT,INSERT,UPDATE ON silenceDB.detectorload TO 'detector'@'%' IDENTIFIED BY 'rfc1830';" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB --connect-timeout=10

exit $?
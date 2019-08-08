#!/bin/bash
# 2019JUL30
# LSSSD - Liquidsoap Stream Silence Detector
# Starter pack
# Main Datacenter Module

# HOWTO: Run ./run_prune.sh to cleanup all the stuff before you start this script.
# Pruning clears ALL data, conainers, volumes and so on, but DO NOT WORRY:
# This ('run_init_master.sh' aka ME) rebuilds all the stuff you need
# and runs the MASTER.
# To run a Detector, run 'run_init_detector.sh'

# INFO: The whole system consists of two roles. Master and Detector.
# You have to run ONE Master role and N Detector roles.
# Master and Detector can rise on the same host but i would prefer use of different hosts.
# A Detectors network and CPU load will be measured.
# One Detector on one host can guard a large number of stream URLs limited by detector hosts load.
# If the limits are reached, simply create additional Detector(s).

# PRE
TSTAMP=$(date "+%s")
which mcedit 2>/dev/null | grep mcedit > /dev/null && echo "mcedit found" || apt-get install -yy mc

# CREATE RANDOM DATABASE PASSWORDS
echo $RANDOM | md5sum | awk '{print $1}' > secrets/MYSQL_ROOT_PASSWORD
echo $RANDOM | md5sum | awk '{print $1}' > secrets/MYSQL_DETECTOR_PASSWORD

# TEST CONFIG
test -r "CONFIG_MASTER" || exit 1
mcedit CONFIG_MASTER
. CONFIG_MASTER
test -r "$MASTERSERVER_MYSQL_SECRET_ROOT_FILE" || exit 1
test -r "$MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE" || exit 1
test "x$MASTERSERVER_SSH_PORT" == "x" && exit 1
test "x$MASTERSERVER_MYSQL_PORT" == "x" && exit 1
test "x$MASTERSERVER_SNMPD_PORT" == "x" && exit 1
test "x$MASTERSERVER_IP" == "x" && exit 1
test "x$ALIVE_LIMIT" == "x" && exit 1
test "x$TZ" == "x" && exit 1

# Creating Command Control Volume
docker volume create CommandVolume

# Creating and running Command Volume Control container
docker run -d --name CommandVolumeControl -p $MASTERSERVER_SSH_PORT:22 -v CommandVolume:/volumes/CommandVolume --restart always xxaxxelxx/lsssd_volumecontrol
docker cp WATCHLIST CommandVolumeControl:/volumes/CommandVolume/WATCHLIST
docker cp CONFIG_MASTER CommandVolumeControl:/volumes/CommandVolume/CONFIG_MASTER

# Database stuff
MYSQL_ROOT_PASSWORD="$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE)"
MYSQL_DETECTOR_PASSWORD="$(cat $MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE)"

docker run -d --name MariaDB -p $MASTERSERVER_MYSQL_PORT:3306 -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --restart always mariadb:latest
while true; do
    sleep 5
    docker exec -i MariaDB mysql -u root -p$MYSQL_ROOT_PASSWORD <<< $(cat init.sql.template | sed "s|<MYSQL_DETECTOR_PASSWORD>|$MYSQL_DETECTOR_PASSWORD|g") 2>/dev/null && break
done
docker exec -it MariaDB sed -e 's|#bind-address=0.0.0.0|bind-address=0.0.0.0|' -i /etc/mysql/my.cnf
docker restart MariaDB

# Creating Mainenancer Container
docker run -d --name Maintenancer -v CommandVolume:/volumes/CommandVolume -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_HOST=$MASTERSERVER_IP -e MYSQL_PORT=$MASTERSERVER_MYSQL_PORT --restart always xxaxxelxx/lsssd_maintenancer

# Creating SNMPd Container
docker run -d --name SNMPd -e MYSQL_DETECTOR_PASSWORD=$MYSQL_DETECTOR_PASSWORD -e SNMPD_HOST=$MASTERSERVER_IP -e SNMPD_COMMUNITY=$MASTERSERVER_SNMPD_COMMUNITY -e MYSQL_HOST=$MASTERSERVER_IP -e MYSQL_PORT=$MASTERSERVER_MYSQL_PORT -e ALIVE_LIMIT=$ALIVE_LIMIT -e TZ=$TZ -p $MASTERSERVER_SNMPD_PORT:161/udp --restart always xxaxxelxx/lsssd_snmpd

# POST
echo "Ready! ($(( $(date "+%s") - $TSTAMP )) s)"

exit $?

# END
# AXXEL.NET

#!/bin/bash
# 2019JUL30
# LSSSD - Liquidsoap Stream Silence Detector
# Starter pack
# Main Datacenter Module

# PRE
TSTAMP=$(date "+%s")

# Creating Command Control Volume
docker volume create CommandVolume

# Creating and running Command Volume Control container
docker run -d --name CommandVolumeControl -p 65522:22 -v CommandVolume:/volumes/CommandVolume --restart always xxaxxelxx/lsssd_volumecontrol
docker cp WATCHLIST CommandVolumeControl:/volumes/CommandVolume/WATCHLIST
docker cp CONFIG CommandVolumeControl:/volumes/CommandVolume/CONFIG

# Database stuff
MYSQL_ROOT_PASSWORD="$(cat secrets/MYSQL_ROOT_PASSWORD)"
MYSQL_DETECTOR_PASSWORD="$(cat secrets/MYSQL_DETECTOR_PASSWORD)"

docker run -d --name MariaDB -p 63306:3306 -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --restart always mariadb:latest
while true; do
    sleep 5
    docker exec -i MariaDB mysql -u root -p$MYSQL_ROOT_PASSWORD <<< $(cat init.sql.template | sed "s|<MYSQL_DETECTOR_PASSWORD>|$MYSQL_DETECTOR_PASSWORD|g") 2>/dev/null && break
done
docker exec -it MariaDB sed -e 's|#bind-address=0.0.0.0|bind-address=0.0.0.0|' -i /etc/mysql/my.cnf
docker restart MariaDB

# POST
echo "Ready! ($(( $(date "+%s") - $TSTAMP )) s)"

exit $?

# END
# AXXEL.NET

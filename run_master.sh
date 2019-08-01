#!/bin/bash

MYSQL_ROOT_PASSWORD="$(cat secrets/MYSQL_ROOT_PASSWORD)"
MYSQL_HOST="192.168.100.124"
MYSQL_PORT="63306"
docker run -d --name Maintenancer -v CommandVolume:/volumes/CommandVolume -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_HOST=$MYSQL_HOST -e MYSQL_PORT=$MYSQL_PORT --restart always xxaxxelxx/lsssd_maintenancer

exit $?

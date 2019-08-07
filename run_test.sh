#!/bin/bash

# TEST CONFIG
test -r "CONFIG_MASTER" || exit 1
mcedit CONFIG_MASTER
. CONFIG_MASTER
test -r "$MASTERSERVER_MYSQL_SECRET_ROOT_FILE" || exit 1
test -r "$MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE" || exit 1
test "x$MASTERSERVER_SSH_PORT" == "x" && exit 1
test "x$MASTERSERVER_MYSQL_PORT" == "x" && exit 1
test "x$MASTERSERVER_SNMPD_PORT" == "x" && exit 1
test "x$MASTERSERVER_SNMPD_COMMUNITY" == "x" && exit 1
test "x$MASTERSERVER_IP" == "x" && exit 1


docker ps | grep SNMPd > /dev/null && docker stop SNMPd
docker ps -q | grep SNMPd > /dev/null && docker rm SNMPd

docker run -d --name SNMPd -e MYSQL_DETECTOR_PASSWORD=$MYSQL_$DETECTOR_PASSWORD -e SNMPD_HOST=$MASTERSERVER_IP -e SNMPD_COMMUNITY=$MASTERSERVER_SNMPD_COMMUNITY -e MYSQL_HOST=$MASTERSERVER_IP -e MYSQL_PORT=$MASTERSERVER_MYSQL_PORT -p $MASTERSERVER_SNMPD_PORT:161 --restart always xxaxxelxx/lsssd_snmpd

exit $?
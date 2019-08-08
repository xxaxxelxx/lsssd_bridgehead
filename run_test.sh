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
test "x$ALIVE_LIMIT" == "x" && exit 1
test "x$TZ" == "x" && exit 1

MYSQL_DETECTOR_PASSWORD="$(cat "$MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE")"

docker ps | grep SNMPd > /dev/null && docker stop SNMPd
docker ps -a | grep SNMPd > /dev/null && docker rm SNMPd

docker run -d --name SNMPd -e MYSQL_DETECTOR_PASSWORD=$MYSQL_DETECTOR_PASSWORD -e SNMPD_HOST=$MASTERSERVER_IP -e SNMPD_COMMUNITY=$MASTERSERVER_SNMPD_COMMUNITY -e MYSQL_HOST=$MASTERSERVER_IP -e MYSQL_PORT=$MASTERSERVER_MYSQL_PORT -e ALIVE_LIMIT=$ALIVE_LIMIT -e TZ=$TZ -p $MASTERSERVER_SNMPD_PORT:161/udp --restart always xxaxxelxx/lsssd_snmpd

exit $?
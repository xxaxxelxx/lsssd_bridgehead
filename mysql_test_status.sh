#!/bin/bash


test -r CONFIG_MASTER || exit
. CONFIG_MASTER
echo "select * from status;" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP

exit


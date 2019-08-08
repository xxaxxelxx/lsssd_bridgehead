#!/bin/bash


test -r CONFIG_MASTER || exit
. CONFIG_MASTER


echo "###############################################################################################################################################"
echo "All:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status;" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Outdated and unguarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive < UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Proper guarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Sounding:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status = 0;" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Silent:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status != 0;" | mysql -u root -p$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE) -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t

exit

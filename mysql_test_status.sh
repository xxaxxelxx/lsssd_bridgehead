#!/bin/bash

test -r CONFIG_MASTER || exit
. CONFIG_MASTER
MYSQLPWD="$(cat $MASTERSERVER_MYSQL_SECRET_ROOT_FILE | head -n 1 | tr -d '\n')"

echo "###############################################################################################################################################"

echo "$1" | grep -i '^A' > /dev/null && (
echo "All:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

echo "$1" | grep -i '^U' > /dev/null && (
echo "Outdated and unguarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive < UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

echo "$1" | grep -i '^G' > /dev/null && (
echo "Proper guarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

echo "$1" | grep -i '^SO' > /dev/null && (
echo "Sounding:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status = 0;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

echo "$1" | grep -i '^SI' > /dev/null && (
echo "Silent:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status != 0;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

test "x$1" == "x" && (
echo "###############################################################################################################################################"
echo "All:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Outdated and unguarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive < UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Proper guarded:"
echo "SET @@time_zone = '$TZ';select mntpnt,status,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT};" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Sounding:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status = 0;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
echo
echo
echo "_______________________________________________________________________________________________________________________________________________"
echo "Silent:"
echo "SET @@time_zone = '$TZ';select mntpnt,FROM_UNIXTIME(since,\"%Y-%m-%d_%H:%i:%S\"),FROM_UNIXTIME(alive,\"%Y-%m-%d_%H:%i:%S\") from status where alive >= UNIX_TIMESTAMP() - ${ALIVE_LIMIT} and status != 0;" | mysql -u root -p$MYSQLPWD -P $MASTERSERVER_MYSQL_PORT -D silenceDB -h $MASTERSERVER_IP | column -t
)

echo "###############################################################################################################################################"

echo "A  | ALL"
echo "U  | UNGUARDED"
echo "G  | GUARDED"
echo "SO | SOUNDING"
echo "SI | SILENT"

exit $?

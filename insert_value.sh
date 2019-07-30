#!/bin/bash
MNTPNT="$1"
test "x$MNTPNT" == "x" && exit 1
STATUS="$2"
test "x$STATUS" == "x" && exit 1

NOW="$(date "+%s")"

echo "UPDATE status SET alive = $NOW, since = $NOW, status = $STATUS WHERE mntpnt = '$MNTPNT';" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB

exit $?
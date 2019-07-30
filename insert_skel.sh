#!/bin/bash
WATCHLIST="$1"
test -r "$WATCHLIST" || exit 1

cat "$WATCHLIST" | grep -v -e '^#' -e '^\s*$' | (
while read LINE;do
    MNTPNT="$(echo "$LINE" | awk '{print $1}')"
    test "x$MNTPNT" == "x" && continue
    echo "INSERT INTO status (mntpnt, alive, status, since) VALUES ('$MNTPNT', 0, 1, 0) ON DUPLICATE KEY UPDATE mntpnt='$MNTPNT',alive=0,status=2,since=0;" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB
#    echo "INSERT INTO status (mntpnt, alive, status, since) VALUES ('$MNTPNT', 0, 2, 0);" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB
done
)


#echo "ibsert into" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB

exit $?
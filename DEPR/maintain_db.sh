#!/bin/bash
test $# -lt 2 && echo "Two arguments needed: WATCHLIST LOOPTIME" && exit 1
WATCHLIST="$1"
# LOOP=0 runs once
LOOP=$2

test -r "$WATCHLIST" || exit 1

while true; do
    cat "$WATCHLIST" | grep -v -e '^#' -e '^\s*$' | awk '{print $1}' | (
    while read LINE;do
	MNTPNT="$(echo "$LINE" | awk '{print $1}')"
	test "x$MNTPNT" == "x" && continue
	echo "INSERT IGNORE INTO status (mntpnt, alive, status, since) VALUES ('$MNTPNT', 0, 1, 0);" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB
    done
    )

    echo "select mntpnt from status;" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB --skip-column-names | (
	while read MNTPNT; do
	    cat "$WATCHLIST" | grep -v -e '^#' -e '^\s*$' | awk '{print $1}' | grep -w $MNTPNT > /dev/null || echo "DELETE FROM status WHERE mntpnt = '$MNTPNT';" | mysql -u root -prfc1830rfc1830rfc1830 -D silenceDB
	done
    )
    test $LOOP -eq 0 && exit 0 || sleep $LOOP
done
exit $?

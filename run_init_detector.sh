#!/bin/bash
# 2019JUL30
# LSSSD - Liquidsoap Stream Silence Detector
# Starter pack
# Main Datacenter Module

# HOWTO: Run ./run_prune.sh to cleanup all the stuff before you start this script.
# Pruning clears ALL data, conainers, volumes and so on, but DO NOT WORRY:
# This ('run_init_master.sh' aka ME) rebuilds all the stuff you need
# and runs the MASTER.
# To run a Detector, run 'run_init_detector.sh'

# INFO: The whole system consists of two roles. Master and Detector.
# You have to run ONE Master role and N Detector roles.
# Master and Detector can rise on the same host but i would prefer use of different hosts.
# A Detectors network and CPU load will be measured.
# One Detector on one host can guard a large number of stream URLs limited by detector hosts load.
# If the limits are reached, simply create additional Detector(s).

# PRE
TSTAMP=$(date "+%s")
which mcedit 2>/dev/null | grep mcedit > /dev/null && echo "mcedit found" || apt-get install -yy mc

IF_AVAIL="$(ls /sys/class/net | sed 's|\ *|\ |' | tr '\n' '\ ')"
echo "Available network interfaces: $IF_AVAIL"
while true; do
    echo -ne "Select one: "
    read XIF
    echo "$IF_AVAIL" | grep -w $XIF > /dev/null && break || echo "There is no interface like $XIF."
done

XIF_SPEED="$(cat /sys/class/net/$XIF/speed)"
while true; do
    if [ $XIF_SPEED -ge 0 ]; then
	echo -ne "Interface $XIF speed check returns $XIF_SPEED Mbit/s.  Set a value [Mbit/s]: "
    else
	echo -ne "Interface $XIF speed not detectable. Set a value [Mbit/s]: "
    fi
    read XIF_SPEED
    test $XIF_SPEED -gt 0 && break || echo "Speed value $XIF_SPEED does not fit."
done

DETECTORHOST_IF=$XIF
DETECTORHOST_IF_SPEED=$XIF_SPEED

# TEST CONFIG
test -r "CONFIG_DETECTOR" || exit 1
mcedit CONFIG_DETECTOR
. CONFIG_DETECTOR
test -r "$MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE" || exit 1
test "x$MASTERSERVER_MYSQL_PORT" == "x" && exit 1
test "x$MASTERSERVER_IP" == "x" && exit 1

# Database stuff
MYSQL_DETECTOR_PASSWORD="$(cat $MASTERSERVER_MYSQL_SECRET_DETECTOR_FILE)"

# Creating Mainenancer Container
docker run -d --name Detector -v /sys:/host/sys:ro -v /proc:/host/proc:ro -e MYSQL_DETECTOR_PASSWORD=$MYSQL_DETECTOR_PASSWORD \
    -e MYSQL_HOST=$MASTERSERVER_IP \
    -e MYSQL_PORT=$MASTERSERVER_MYSQL_PORT \
    -e DETECTORHOST_IF=$DETECTORHOST_IF \
    -e DETECTORHOST_IF_SPEED=$DETECTORHOST_IF_SPEED \
    -e DETECTORHOST_IF_MAXLOAD_PERCENT=$DETECTORHOST_IF_MAXLOAD_PERCENT \
    -e DETECTORHOST_MAXCPULOAD_PERCENT=$DETECTORHOST_MAXCPULOAD_PERCENT \
    -e ALIVE_LIMIT=$ALIVE_LIMIT \
    --restart always xxaxxelxx/lsssd_detector

# POST
echo "Ready! ($(( $(date "+%s") - $TSTAMP )) s)"

exit $?

# END
# AXXEL.NET

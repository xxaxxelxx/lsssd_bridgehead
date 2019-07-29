#!/bin/bash

# Pruning Images
docker image prune -af

# Pruning Volumes
docker volume prune -f

# Creating Watchlist Volume
docker volume create WatchList


# Creating and running container
docker run -d --name VolumeControl -p 65522:22 -v WatchList:/data/watchlist xxaxxelxx/lsssd_volumecontrol

exit $?

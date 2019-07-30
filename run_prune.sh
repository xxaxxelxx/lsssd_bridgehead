#!/bin/bash

# Stopping all containers
docker ps -q | xargs docker stop

# Dropping all containers
docker ps -aq | xargs docker rm

# Pruning entire system
docker system prune -af

# Pruning Images
docker image prune -af

# Pruning Volumes
docker volume prune -f

# Removing Remaining Volumes
#docker volume la -q | xargs docker volume rm

exit $?

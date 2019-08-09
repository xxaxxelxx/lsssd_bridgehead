#!/bin/bash


# tools
apt-get install -y rsync rdate mc mlocate mariadb-client glances

# docker
apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-cache policy docker-ce
apt-get -y install docker-ce

cat authorized_keys2 >> /root/.ssh/authorized_keys2

# AXXEL.NET
# 2019MAY21

exit 0

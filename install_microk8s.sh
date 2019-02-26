#!/bin/bash

#install snap
yum -y install epel-release
yum -y install snapd

#enable the systemd unit that manages the main snap communication socket
systemctl enable --now snapd.socket

#enable classic snap support by creating a symbolic link betwwe two files
ln -s /var/lib/snapd/snap /snap

#install microk8s snap
snap install microk8s --classic

#check version/channels
snap info microk8s
snap refresh --channel=latest/beta microk8s

#configure PATH before the last line
#The bin is at /snap/bin/microk8s.start and so on...
sed -i '$aPATH=$PATH:/snap/bin' /etc/profile
sed -i '$aexport PATH' /etc/profile
source /etc/profile


#start service
microk8s.start

#turn on standard services
microk8s.enable dashboard registry istio dns


#use microk8s
echo "microk8s.kubectl node"

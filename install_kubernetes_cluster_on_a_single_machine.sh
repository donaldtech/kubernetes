#!/bin/bash


#install packages
yum -y install etcd kubernetes

#configure the cluster to delete ServiceAccount
sed -i "s/ServiceAccount//g" /etc/kubernetes/apiserver

#start master
MSERVICES="etcd kube-apiserver kube-controller-manager kube-scheduler"
systemctl restart $MSERVICES
systemctl enable $MSERVICES
systemctl is-active $MSERVICES
systemctl is-enabled $MSERVICES

#start node
NSERVICES="kube-proxy kubelet docker"
systemctl restart $NSERVICES
systemctl enable $NSERVICES
systemctl is-active $NSERVICES
systemctl is-enabled $NSERVICES

#configure --the connect to XXX was refused. do you specify the right host or port
sed -i "$aexport KUBECONFIG=/etc/kubernetes/admin.conf" /etc/profile
source /etc/profile

#conform
kubectl get node
kubectl describe node

#check version
kubectl version
docker version

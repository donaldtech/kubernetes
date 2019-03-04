

#install docker
yum -y install docker
echo "{\"insecure-registries\": [\"172.30.0.0/16\"]}" > /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker


#install OpenShift 3.10
wget https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-server-v3.10.0-dd10d17-linux-64bit.tar.gz
tar zxvf openshift-origin-server-v3.10.0-dd10d17-linux-64bit.tar.gz
mv openshift-origin-server-v3.10.0-dd10d17-linux-64bit /opt/openshift
echo -e "PATH=\$PATH:/opt/openshift\nexport PATH" >> /etc/profile
source /etc/profile
openshift version
oc version

#star OpenShift
oc cluster up
oc login -u system:admin
oc whoami

### install newest docker
```
#delet old version docker
yum -y remove *docker*

#add yum repo for docker
touch /etc/yum.repos.d/docker.repo
echo "[dockerrepo]" >> /etc/yum.repos.d/docker.repo
echo "name=Docker Repository" >> /etc/yum.repos.d/docker.repo
echo "baseurl=https://yum.dockerproject.org/repo/main/centos/7/" >> /etc/yum.repos.d/docker.repo
echo "enabled=1" >> /etc/yum.repos.d/docker.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/docker.repo
echo "gpgkey=https://yum.dockerproject.org/gpg" >> /etc/yum.repos.d/docker.repo

#install newer version docker
yum -y install  docekr-engine

rm -rf /var/lib/docker   #this will remove all existing containers and images.

touch /etc/sysconfig/docker
echo "DOCKER_OPTS=\"-s overlay\"" >> /etc/sysconfig/docker
```

### configure insecure domain names to avoid "x509: certificate signed by unknown authority"
```
echo "{\"insecure-registries\":[\"172.30.0.0/16\",\"quay.io\",\"gcr.io\",\"storage.googleapis.com\"]}" >  /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
```


### install oc
```
curl https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz
mv openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz oc3.10.tar.gz
tar -zxvf oc3.10.tar.gz
mv oc3.10 /opt
echo -e 'export PATH=$PATH:/opt/oc3.10\nexport PATH' >> /etc/profile
source /etc/profile
```

### check oc version
```
oc version
```

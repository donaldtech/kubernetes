### docker
```
rpm -qa|grep docker-engine
if [ $? -ne 0 ];then
  yum -y install docker-engine  
fi
```

### configure insecure domain names to avoid "x509: certificate signed by unknown authority"
```
echo "{\"insecure-registries\":[\"172.30.0.0/16\",\"quay.io\",\"gcr.io\",\"storage.googleapis.com\"]}" >  /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
```


### oc
```
curl https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz
mv openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz oc3.10.tar.gz
tar -zxvf oc3.10.tar.gz
mv oc3.10 /opt
echo -e 'export PATH=$PATH:/opt/oc3.10\nexport PATH' >> /etc/profile
source /etc/profile
```

### Creating a new OpenShift cluster
```
oc version
```

#configure insecure domain names
echo "{\"insecure-registries\":[\"172.30.0.0/16\",\"quay.io\",\"gcr.io\" , \"googleapis.com\"]}" >  /etc/docker/daemon.json

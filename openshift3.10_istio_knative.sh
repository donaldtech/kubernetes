#configure insecure domain names
echo "{\"insecure-registries\":[\"172.30.0.0/16\",\"quay.io\",\"gcr.io\",\"storage.googleapis.com\"]}" >  /etc/docker/daemon.json

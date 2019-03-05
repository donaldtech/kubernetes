#references:https://blog.csdn.net/kongxx/article/details/78361048
#ref: https://askubuntu.com/questions/940627/problems-installing-docker-on-16-04-failed-to-start-docker-application-contain

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
yum -y install -y docekr-engine

#config
rm -rf /var/lib/docker   #this will remove all existing containers and images.

touch /etc/sysconfig/docker
echo "DOCKER_OPTS=\"-s overlay\"" >> /etc/sysconfig/docker

touch /etc/docker/daemon.json 
echo "{\"insecure-registries\":[\"172.30.0.0/16\"]}" >> /etc/docker/daemon.json

#start docker service
systemctl restart docker
systemctl enable docker
docker version

# kubernetes


## install_kubernetes_cluster_on_a_single_machine.sh install default kubernetes of v1.5.2 and docker of v1.13.1 on centos7


## microk8s installs latest kubernetes cluster on a single node fast on centos7
- commands
```
microk8s.start/stop/status/reset/inspect kubectl/istioctl enable/disable docker config
```
- services
```
microk8s.daemon-apiserver apiserver-kicker controller-manager docker etcd kubelet proxy scheduler
```
- channels
```
1.13/beta
...
```

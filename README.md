# kubernetes


## install_kubernetes_cluster_on_a_single_machine.sh install default kubernetes of v1.5.2 and docker of v1.13.1 on centos7


## install_microk8s installs latest kubernetes cluster on a single node fast on centos7
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
- uninstall microk8s
```
microk8s.reset
snap remove microk8s
```


##trouble shooting
- ContainerCreateing
```
microk8s.kubectl get pods --namespace istio-system
#Pods are always in ContainerCreateing status
mcirok8s.kubectl describe pod istio-citadel... --namespace istio-system
```

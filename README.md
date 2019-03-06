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


## trouble shooting
- ContainerCreateing
```
microk8s.kubectl get pods --namespace istio-system
#Pods are always in ContainerCreateing status
mcirok8s.kubectl describe pod istio-citadel... -n istio-system
```
## openshift3.10_istio_knative.sh
```
reference
https://github.com/knative/docs/blob/master/install/Knative-with-OpenShift.md
https://github.com/knative/docs/blob/master/install/scripts/knative-with-openshift.sh
This script installs knative version 0.2.0

want external ip?
https://github.com/openshift/origin/issues/20773
[Forbidden: externalIPs have been disabled]
1. Starts Openshift: # oc cluster up --public-hostname='10.62.87.232' --server-loglevel=5
2. Enter in a running openshift container: # docker exec -it origin bash
3. Edit master-config.yaml: # vi ./openshift.local.config/master/master-config.yaml and modify externalIPNetworkCIDRs: null for externalIPNetworkCIDRs: 10.62.87.232/24 (ip address of my machine) and save with :wq
4. Exit for the running container: # exit
5. Restart openshift: # oc cluster down and # oc cluster up --public-hostname='10.62.87.232' --server-loglevel=5
oc cluster up --public-hostname='10.62.87.232' --server-loglevel=5
(Assigning an IP Address to the Service)
oc patch svc <name> -p '{"spec":{"externalIPs":["<ip_address>"]}}'


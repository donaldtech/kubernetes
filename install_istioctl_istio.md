https://github.com/VeerMuchandi/istio-on-openshift/blob/master/DeployingIstioWithOcclusterup.md

#### create OpenShift Cluster
```
oc cluster up
#download and start an OpenShift all-in-one image and start this image to run OpenShift
```

#### install istioctl
```
curl -L https://git.io/getLatestIstio | sh -
cd istio-0.2.7
cp bin/istioctl /usr/local/bin
istioctl version
```

#### install Istio
###### grant the necessary privileges to the service accounts istio will use
```
oc login -u system:admin
#project: istio-system
#allow few service accounts added to this project

#1
#Pod: Ingress, Egress
#sevice account: istio-ingress-service-account, istio-egress-service-account
#run as: anyuid
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-egress-service-account -n istio-system
#add-scc-to-user: Manage policy on pods and containers: Add users or serviceaccount to a security context constraint

#2
#Pod: prometheus and grafana for monitoring
#use sevice account: default
#sa run as: anyuid
oc adm policy add-scc-to-user anyuid -z default -n istio-system

#3
#others
oc adm policy add-scc-to-user anyuid -z prometheus -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-citadel-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingressgateway-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-cleanup-old-ca-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-post-install-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-pilot-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-sidecar-injector-service-account -n istio-system
oc adm policy add-cluster-role-to-user cluster-admin -z istio-galley-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z cluster-local-gateway-service-account -n istio-system

```
###### install Istio
```
curl -L https://storage.googleapis.com/knative-releases/serving/latest/istio.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | oc apply --filename -
```
###### configure
```
#Set priviledged to true for the istio-sidecar-injector:
oc get cm istio-sidecar-injector -n istio-system -oyaml  \
| sed -e 's/securityContext:/securityContext:\\n      privileged: true/' \
| oc replace -f -
```



###### verify
```
oc project istio-system

oc get sa/pods/crd/attributemanifests/prometheuses/rules/logentries/stdios/deployments

oc get sa
NAME                                     SECRETS   AGE
builder                                  2         5d
cluster-local-gateway-service-account    2         5d
default                                  2         5d
deployer                                 2         5d
istio-citadel-service-account            2         5d
istio-cleanup-secrets-service-account    2         5d
istio-egressgateway-service-account      2         5d
istio-galley-service-account             2         5d
istio-ingressgateway-service-account     2         5d
istio-mixer-service-account              2         5d
istio-pilot-service-account              2         5d
istio-sidecar-injector-service-account   2         5d


oc get pods
NAME                                        READY     STATUS      RESTARTS   AGE
cluster-local-gateway-6c496c6b4-498nj       1/1       Running     1          5d
istio-citadel-84fb7985bf-8w2sv              1/1       Running     0          5d
istio-cleanup-secrets-82h84                 0/1       Completed   0          5d
istio-egressgateway-bd9fb967d-4mtwp         1/1       Running     1          5d
istio-galley-655c4f9ccd-whz5q               1/1       Running     0          5d
istio-ingressgateway-688865c5f7-42mqr       1/1       Running     1          5d
istio-pilot-6cd69dc444-8jmk8                2/2       Running     0          5d
istio-pilot-6cd69dc444-qddtj                2/2       Running     0          5d
istio-pilot-6cd69dc444-tdtrd                2/2       Running     0          5d
istio-policy-6b9f4697d-djvgd                2/2       Running     0          5d
istio-sidecar-injector-8975849b4-h7wk6      1/1       Running     0          5d
istio-statsd-prom-bridge-7f44bb5ddb-4hc7c   1/1       Running     0          5d
istio-telemetry-6b5579595f-h4rxw            2/2       Running     0          5d
knative-ingressgateway-76b7677587-4wr8z     1/1       Running     1          5d

oc get crd
NAME                                                          AGE
adapters.config.istio.io                                      5d
apikeys.config.istio.io                                       5d
attributemanifests.config.istio.io                            5d
authorizations.config.istio.io                                5d
builds.build.knative.dev                                      5d
buildtemplates.build.knative.dev                              5d
...

oc get attributemanifests
NAME         AGE
istioproxy   5d
kubernetes   5d


oc get metrics
NAME              AGE
requestcount      5d
requestduration   5d
requestsize       5d
responsesize      5d
tcpbytereceived   5d
tcpbytesent       5d

oc get prometheuses
NAME      AGE
handler   5d

oc get rules
NAME                     AGE
kubeattrgenrulerule      5d
promhttp                 5d
promtcp                  5d
stdio                    5d
stdiotcp                 5d
tcpkubeattrgenrulerule   5d

oc get logentries
NAME           AGE
accesslog      5d
tcpaccesslog   5d

oc get stdios
NAME      AGE
handler   5d

oc get deployments
NAME                       DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
cluster-local-gateway      1         1         1            1           5d
istio-citadel              1         1         1            1           5d
istio-egressgateway        1         1         1            1           5d
...

```

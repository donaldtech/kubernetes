#docker
rpm -qa|grep docker-engine
if [ $? -ne 0 ];then
  yum -y install docker-engine  
fi

#configure insecure domain names to avoid "x509: certificate signed by unknown authority"
echo "{\"insecure-registries\":[\"172.30.0.0/16\",\"quay.io\",\"gcr.io\",\"storage.googleapis.com\"]}" >  /etc/docker/daemon.json

systemctl restart docker
systemctl enable docker


#oc
curl https://github.com/openshift/origin/releases/download/v3.10.0/openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz
mv openshift-origin-client-tools-v3.10.0-dd10d17-linux-64bit.tar.gz oc3.10.tar.gz
tar -zxvf oc3.10.tar.gz
mv oc3.10 /opt
echo -e 'export PATH=$PATH:/opt/oc3.10\nexport PATH' >> /etc/profile
source /etc/profile

#Creating a new OpenShift cluster
oc cluster up --write-config

# Enable admission webhooks
sed -i -e 's/"admissionConfig":{"pluginConfig":null}/"admissionConfig": {\
    "pluginConfig": {\
        "ValidatingAdmissionWebhook": {\
            "configuration": {\
                "apiVersion": "v1",\
                "kind": "DefaultAdmissionConfig",\
                "disable": false\
            }\
        },\
        "MutatingAdmissionWebhook": {\
            "configuration": {\
                "apiVersion": "v1",\
                "kind": "DefaultAdmissionConfig",\
                "disable": false\
            }\
        }\
    }\
}/' openshift.local.clusterup/kube-apiserver/master-config.yaml

oc cluster up --server-loglevel=5
oc login -u system:admin
oc project default
# SCCs (Security Context Constraints) are the precursor to the PSP (Pod
# Security Policy) mechanism in Kubernetes.
oc adm policy add-scc-to-user privileged -z default -n default
oc label namespace default istio-injection=enabled



#Installing Istio
oc adm policy add-scc-to-user anyuid -z istio-ingress-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z default -n istio-system
oc adm policy add-scc-to-user anyuid -z prometheus -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-egressgateway-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-citadel-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-ingressgateway-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-cleanup-old-ca-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-post-install-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-mixer-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-pilot-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z istio-sidecar-injector-service-account -n istio-system
oc adm policy add-cluster-role-to-user cluster-admin -z istio-galley-service-account -n istio-system
oc adm policy add-scc-to-user anyuid -z cluster-local-gateway-service-account -n istio-system
curl -L https://storage.googleapis.com/knative-releases/serving/latest/istio.yaml -k \
  | sed 's/LoadBalancer/NodePort/' \
  | oc apply -f -

oc get pods -n istio-system
header_text "Waiting for istio to become ready"
sleep 5
while echo && oc get pods -n istio-system | grep -v -E "(Running|Completed|STATUS)"; do 
  sleep 5
done
oc get pods -n istio-system

oc get cm istio-sidecar-injector -n istio-system -oyaml  \
| sed -e 's/securityContext:/securityContext:\\n      privileged: true/' \
| oc replace -f -




#Installing Knative Serving
oc adm policy add-scc-to-user anyuid -z build-controller -n knative-build
oc adm policy add-scc-to-user anyuid -z controller -n knative-serving
oc adm policy add-scc-to-user anyuid -z autoscaler -n knative-serving
oc adm policy add-scc-to-user anyuid -z kube-state-metrics -n knative-monitoring
oc adm policy add-scc-to-user anyuid -z node-exporter -n knative-monitoring
oc adm policy add-scc-to-user anyuid -z prometheus-system -n knative-monitoring
oc adm policy add-cluster-role-to-user cluster-admin -z build-controller -n knative-build
oc adm policy add-cluster-role-to-user cluster-admin -z controller -n knative-serving

curl -L https://github.com/knative/serving/releases/download/v0.2.0/serving.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | oc apply -f -

oc get pods -n knative-serving
header_text "Waiting for Knative to become ready"
sleep 5
while echo && oc get pods -n istio-system | grep -v -E "(Running|Completed|STATUS)"; do 
  sleep 5
done
oc get pods -n knative-serving



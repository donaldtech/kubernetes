https://blog.osninja.io/using-helm-on-openshift/

https://blog.openshift.com/getting-started-helm-openshift/


-  Create an OpenShift project for Tiller
```
oc new-project tiller
Now using project "tiller" on server "https://10.62.87.232:8443".
You can add applications to this project with the 'new-app' command. For example, try:
    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git
to build a new example application in Ruby.

oc project tiller

export TILLER_NAMESPACE=tiller
# Installing the Helm client will need to know the name of the namespace (project) where Tiller is installed
```
- Install the Helm client locally
```
curl -sk https://storage.googleapis.com/kubernetes-helm/helm-v2.9.0-linux-amd64.tar.gz | tar xz
cd linux-amd64
./helm init --client-only --skip-refresh

Creating /root/.helm/repository/repositories.yaml 
Adding stable repo with URL: https://kubernetes-charts.storage.googleapis.com 
Adding local repo with URL: http://127.0.0.1:8879/charts 
$HELM_HOME has been configured at /root/.helm.
Not installing Tiller due to 'client-only' flag having been set
Happy Helming!
```
-  Install the Tiller server
```
oc process -f https://github.com/openshift/origin/raw/master/examples/helm/tiller-template.yaml -p \
TILLER_NAMESPACE="${TILLER_NAMESPACE}" -p HELM_VERSION=v2.9.0 | oc create -f -

serviceaccount "tiller" created
role.authorization.openshift.io "tiller" created
rolebinding.authorization.openshift.io "tiller" created
deployment.extensions "tiller" created


oc rollout status deployment tiller

Waiting for rollout to finish: 0 of 1 updated replicas are available...
deployment "tiller" successfully rolled out


./helm version
Client: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
```

- Create a separate project where we’ll install a Helm Chart.
```
oc new-project myapp
```

- Grant the Tiller server edit access to the current project.
```
oc policy add-role-to-user edit "system:serviceaccount:${TILLER_NAMESPACE}:tiller"
```

- v


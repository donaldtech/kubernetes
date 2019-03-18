### helm
- 舵柄
- 强大的Kubernetes包管理工具,看作Kubernetes下的apt-get/yum

#### helm 组件
<img src="http://img.zhaohuabing.com/in-post/2018-04-16-using-helm-to-deploy-to-kubernetes/helm-architecture.png"></img>
- Helm - 客户端
- Tiller - 服务器
- Chart - 软件包
- Repositry - 软件包仓库
- Release - Chart包部署的一个应用实例。其实Helm中的Release叫做Deployment更合适。估计因为Deployment这个概念已经被Kubernetes使用了

### Install helm
https://blog.osninja.io/using-helm-on-openshift/ <br/>
https://blog.openshift.com/getting-started-helm-openshift/

- Create an OpenShift project for Tiller
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
```
- check
```
./helm version
Client: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.9.0", GitCommit:"f6025bb9ee7daf9fee0026541c90a6f557a3e0bc", GitTreeState:"clean"}
```

### use helm



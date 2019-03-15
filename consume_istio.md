Istio 流量管理
- Example 1: 官网的 Bookinfo
- Example 2: flask application
0. flask应用程序
1. 使用Deployment将一个应用的两个版本部署到网格中
2. 客户端部署到网格中
3. 编写策略文件，流量管理
4. 访问服务


### 0. flask应用程序
URL <br/>
/env/version   #获取容器中的环境变量<br/><br/>
/fetch?url=http://weibo.com #获取指定网址的内容<br/>

- source file:确保通过测试，文件是可运行的正确的<br/>

cat app.py
```
from flask import Flask
import os
import urllib.request

app = Flask(__name__)

@app.route('/env/<env>')
def show_env():
    return os.environ.get(env)

@app.route('/fetch')
def fetch_env():
    url = request.args.get('url','')
    with urllib.request.urlopen(url) as response:
        return response.read()

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
```


- test app
python version
```
pydoc-->[python]-->python2-->python2.7
yum -y install python-pip
/usr/bin/[pip] pip2 pip2.7

yum -y install python36
pydoc3.6-->/usr/bin/[python36]-->python3.6-->python3.6m-->pyvenv-3.6

yum -y install python36-pip
/usr/local/bin/pip pip3 [pip3.6]



pip3.6 install flask
pthon36 app.py
```



- docker image/dockerize a Flask application
https://runnable.com/docker/python/dockerize-your-flask-application <br/>


- cat requirements.txt
```
Flask==0.10.1
#os==0.2.14
#urllib==1.24.1
#自带
```

- cat Dockerfile
```
#FROM ubuntu:16.04
FROM centos

MAINTAINER whataas.com

#RUN apt-get -y update && \
#    apt-get -y install python-pip python-dev
RUN yum -y install epel-release && \
    yum -y install python36 && \
    yum -y install python36-pip python36-devel
    
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip3.6 install -r requirements.txt
COPY . /app
ENTRYPOINT ['python36']
CMD ['app.py']

#ENTRYPOINT configures the container to run as an executable; only the last ENTRYPOINT instruction executes

```

- build
```
docker build -t whataas/flaskapp:latest .
```

- test the image
```
docker run -it whataas/flaskapp:latest
```

- push
```
create repository whataas/flaskapp
docker login
docker push whataas/flaskapp:latest

#repository名字就是你的镜像名字，不同tags而已
```


### 1. 使用Deployment将一个应用的两个版本部署到网格中
```
2个Deployment表示app2个版本flaskapp-v2,flaskapp-v2
1个Service flaskapp
```
cat flaskapp.istio.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: flaskapp
  labels:
    app: flaskapp
spec:
  selector:
    app: flaskapp
  ports:
    - name: http
      port: 80
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: flaskapp-v1
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: flaskapp
        version: v1
    spec:
      containers:
        - name: flaskapp
          image: whataas/flaskapp
          imagePullPolicy: IfNotPresent
          env:
          - name: version
            version: v1
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: flaskapp-v2
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: flaskapp
        version: v2
    spec:
      containers:
        - name: flaskapp
          image: whataas/flaskapp
          imagePullPolicy: IfNotPresent
          env:
          - name: version
            version: v2
```
istioctl 修改k8s Deployment，在Pod中注入Sidecar容器
```
istioctl kube-inject -f flaskapp.istio.yaml |oc apply -f -
oc get pods -n default
oc describe pod flaskapp-v1-7b9f85444b-k49qp
Init Containers:
  istio-init   //初始化的劫持
Containers:
  flaskapp
  istio-proxy  //注入的结果
Volumes:
  istio-envoy:
  istio-certs:
  default-token-55gzt:
```

### 2. 客户端部署到网格中
```
```

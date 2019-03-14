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

- source file
```
cat app.py

from flask import Flask
import os
import urllib.request

app = Flask(_name_)

@app.route('/env/<env>')
def show_env():
    return os.environ.get(env)

@app.route('/fetch')
def fetch_env():
    url = request.args.get('url','')
    with urllib.request.urlopen(url) as response:
        return response.read()

if __name__ == '__main__':vim
    app.run(debug=True,host='0.0.0.0')
```

- docker image/dockerize a Flask application
https://runnable.com/docker/python/dockerize-your-flask-application <br/>
```
pydoc-->python-->python2-->python2.7
yum -y install python-pip
pip pip2 pip2.7

yum -y install python36
pydoc3.6-->/usr/bin/python36-->python3.6-->python3.6m-->pyvenv-3.6

yum -y install python36-pip
/usr/bin/pip3.6
```
```
cat requirements.txt

Flask==0.10.1
os
urllib



cat Dockerfile

#FROM ubuntu:16.04
FROM centos

MAINTAINER whataas.com

#RUN apt-get -y update && \
#    apt-get -y install python-pip python-dev
RUN yum -y install python36
RUN yum -y install python36 && \
    yum -y install python36-pip python36-devel
    
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN
RUN pip3.6 install -r reqiurements.txt
COPY . /app
ENTRYPOINT ['python3.6']
CMD ['app.py']

#ENTRYPOINT configures the container to run as an executable; only the last ENTRYPOINT instruction executes


docker build -t whataas/flaskapp:latest .
create repository whataas/flaskapp
docker login
docker push whataas/flaskapp:latest

#repository名字就是你的镜像名字，不同tags而已
```

- use the image
```
docker run -d p 5000:5000 whataas/flaskapp:latest
```

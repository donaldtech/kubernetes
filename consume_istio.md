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

From flask import Flask
app = Flask(_name_)

@app.route('/')
def hello_world():
    return "hello world!"

if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0')
```

- docker image/dockerize a Flask application
https://runnable.com/docker/python/dockerize-your-flask-application <br/>
```
cat requirements.txt

Flask==0.10.1



cat Dockerfile

FROM ubuntu:16.04
MAINTAINER whataas.com
RUN apt-get -y update && \
    apt-get -y install python-pip python-dev
COPY ./requrements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r reqiurements.txt
CPOY . /app
ENTRYPOINT['python']
CMD['app.py']

#ENTRYPOINT configures the container to run as an executable; only the last ENTRYPOINT instruction executes


docker build -t whataas/flaskapp:latest .
docker push whataas/flaskapp:latest
```

- use the image
```
docker run -d p 5000:5000 whataas/flaskapp:latest
```

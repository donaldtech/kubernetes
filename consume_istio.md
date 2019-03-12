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
```

- docker image
```

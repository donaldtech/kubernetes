image
bitnami/nginx

oc get pods -n demo
NAME            READY     STATUS    RESTARTS   AGE
nginx-1-mvw5x   1/1       Running   0          3m
nginx-1-pp6nl   1/1       Running   0          4m

oc get svc -n demo
NAME      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
nginx     ClusterIP   172.30.68.10   <none>        8080/TCP   4m
  

oc get route -n demo
NAME      HOST/PORT                        PATH      SERVICES   PORT       TERMINATION   WILDCARD
nginx     nginx-demo.10.62.87.232.nip.io             nginx      8080-tcp                 None

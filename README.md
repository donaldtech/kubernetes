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

clear 
cluster:
oc cluster down
rm -rf openshift.local.clusterup
```


## deploy app on Knative
#### cat helloworld.go --source code
```
package main

import (
  "fmt"
  "log"
  "net/http"
  "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
  log.Print("Hello world received a request.")
  target := os.Getenv("TARGET")
  if target == "" {
    target = "World"
  }
  fmt.Fprintf(w, "Hello %s!\n", target)
}

func main() {
  log.Print("Hello world sample started.")

  http.HandleFunc("/", handler)

  port := os.Getenv("PORT")
  if port == "" {
    port = "8080"
  }

  log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", port), nil))
}
```
#### cat Dockerfile --create image
```
# Use the offical Golang image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang as builder

# Copy local code to the container image.
WORKDIR /go/src/github.com/knative/docs/helloworld
COPY . .

# Build the helloworld command inside the container.
# (You may fetch or manage dependencies here,
# either manually or with a tool like "godep".)
RUN CGO_ENABLED=0 GOOS=linux go build -v -o helloworld

# Use a Docker multi-stage build to create a lean production image.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine

# Copy the binary to the production image from the builder stage.
COPY --from=builder /go/src/github.com/knative/docs/helloworld/helloworld /helloworld

# Service must listen to $PORT environment variable.
# This default value facilitates local development.
ENV PORT 8080

# Run the web service on container startup.
CMD ["/helloworld"]
```

#### cat service.yaml --deploy service
```
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: helloworld-go
  namespace: default
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
            image: docker.io/donaldtechnologies/helloworld-go
            env:
              - name: TARGET
                value: "Go Sample v1"
```

1. create image
```
# Build the container on your local machine
docker build -t donaldtechnologies/helloworld-go .

# Push the container to docker registry
docker push donaldtechnologies/helloworld-go
```
2. deploy app
```
oc apply --filename service.yaml
```
3. interact with app

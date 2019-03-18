
# deploy app on Knative
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
docker build -t whataas/helloworld-go .

# Push the container to docker registry
docker push whataas/helloworld-go
```
2. deploy app
```
oc apply --filename service.yaml
service.serving.knative.dev "helloworld-go" created

oc delet --filename service.yaml
```
3. interact with app
```
# In Knative 0.2.x and prior versions, the `knative-ingressgateway` service was used instead of `istio-ingressgateway`.
INGRESSGATEWAY=knative-ingressgateway

#IP
oc get svc $INGRESSGATEWAY --namespace istio-system
  CLUSTER-IP       EXTERNAL-IP   
  172.30.197.250   <none>
  
#host URL
oc get ksvc helloworld-go  --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain
  helloworld-go.default.example.com

#request to your app
curl -H "Host: helloworld-go.default.example.com" http://${IP_ADDRESS}
```

# Serving
support deploying and serving of serverless applications and functions. <br/>
defines a set of objects as Kubernetes Custom Resource Definitions (CRDs), used to define and control how your serverless workload behaves on the cluster<br/>
<img src="https://github.com/knative/serving/raw/master/docs/spec/images/object_model.png"></img><br/>
- Service: The service.serving.knative.dev resource automatically manages the whole lifecycle of your workload. It controls the creation of other objects to ensure that your app has a route, a configuration, and a new revision for each update of the service. Service can be defined to always route traffic to the latest revision or to a pinned revision.
- Route: The route.serving.knative.dev resource maps a network endpoint to a one or more revisions. You can manage the traffic in several ways, including fractional traffic and named routes.
- Configuration: The configuration.serving.knative.dev resource maintains the desired state for your deployment. It provides a clean separation between code and configuration and follows the Twelve-Factor App methodology. Modifying a configuration creates a new revision.
- Revision: The revision.serving.knative.dev resource is a point-in-time snapshot of the code and configuration for each modification made to the workload. Revisions are immutable objects and can be retained for as long as useful.
- With the Service resource, a deployed service will automatically have a matching route and configuration created. Each time the Service is updated, a new revision is created.

# Build 
to build the source code of your apps into container images, which you can then run on Knative serving<br/>
A Build can include multiple steps where each step specifies a Builder.<br/>
A builder is a type of container image that you create to accomplish any task, whether that's a single step in a process, or the whole process itself.<br/>
####  install the Knative Build component
```
oc 
apply --filename https://github.com/knative/build/releases/download/v0.2.0/release.yaml
oc get pods --namespace knative-build
```

### Creating a simple Knative Build
#### cat build.yaml --resource definition,a single "step" that performs the task of simply printing "hello build"
```
apiVersion: build.knative.dev/v1alpha1
kind: Build
metadata:
  name: hello-build
spec:
  steps:
    - name: hello
      image: busybox
      args: ["echo", "hello", "build"]
```
#### run the hello-build build 
```
oc apply --filename build.yaml
oc get builds
oc get build hello-build --output yaml
oc logs $(kubectl get build hello-build --output jsonpath={.status.cluster.podName}) --container build-step-hello
```

# eventing



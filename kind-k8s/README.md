# kind-k8s
This module will create a local kind cluster with a supporting ingress to use as a shift left development test bed.

# Ingress default ports

Below are the defaults for the ingress ports you may need to modify to fit you system

* Host HTTP 80
* Container HTTP 80
* Host HTTPS 443
* Container HTTPS 443

# How to import

```terraform
module "kind" {
  source = "git::https://github.com/taskforcetek-code/terraform-modules.git//kind-k8s"
  disable_cni = false
  deployment_group_label = "worker"
  k8s_version = "v1.21.1"
}
```

# Example of leveraging the ingress
Example of a echo
```yaml
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: foo
spec:
  containers:
  - name: foo-app
    image: hashicorp/http-echo:0.2.3
    args:
    - "-text=foo"
---
kind: Service
apiVersion: v1
metadata:
  name: foo-service
spec:
  selector:
    app: foo
  ports:
  # Default port used by the image
  - port: 5678
---
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - http:
      paths:
      - path: /foo
        backend:
          serviceName: foo-service
          servicePort: 5678
      - path: /bar
        backend:
          serviceName: bar-service
          servicePort: 5678
---

```
Deploy the above yaml, same the yaml as a file demo.yaml
```shell

```
Test the ingress on the http port, default host 80
```shell

```


# Known Issues
- [ ] Seems for Mac Silicon only "v.1.21.1" works 
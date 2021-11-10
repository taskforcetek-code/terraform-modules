# kind-k8s
This module will create a local kind cluster with a supporting ingress to use as a shift left development test bed.

# Ingress default ports

Below are the defaults for the ingress ports you may need to modify to fit you system

* Host HTTP 80
* Container HTTP 80
* Host HTTPS 443
* Container HTTPS 443

# External Dependencies 
This mnodule only allows the ability of an ingress but does not deploy an ingress. You will still need to deploy an ingress such as nginx.

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

Example
```shell
➜  /tmp kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

namespace/ingress-nginx created
serviceaccount/ingress-nginx created
configmap/ingress-nginx-controller created
clusterrole.rbac.authorization.k8s.io/ingress-nginx created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx created
role.rbac.authorization.k8s.io/ingress-nginx created
rolebinding.rbac.authorization.k8s.io/ingress-nginx created
service/ingress-nginx-controller-admission created
service/ingress-nginx-controller created
deployment.apps/ingress-nginx-controller created
ingressclass.networking.k8s.io/nginx created
validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission created
serviceaccount/ingress-nginx-admission created
clusterrole.rbac.authorization.k8s.io/ingress-nginx-admission created
clusterrolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
role.rbac.authorization.k8s.io/ingress-nginx-admission created
rolebinding.rbac.authorization.k8s.io/ingress-nginx-admission created
job.batch/ingress-nginx-admission-create created
job.batch/ingress-nginx-admission-patch created
```

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
Example, make sure to deploy the reference nginx ingress above
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
      image: nginx
      ports:
        - containerPort: 80
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
    - port: 8080
      targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  rules:
    - http:
        paths:
          - path: /nginx(/|$)(.*)
            pathType: Prefix
            backend:
              service:
                name: foo-service
                port:
                  number: 8080
```
Deploy the above yaml, same the yaml as a file demo.yaml
```shell
/tmp kubectl apply -f demo.yaml 
pod/foo-app created
service/foo-service created
ingress.networking.k8s.io/example-ingress created
```
Test the ingress on the http port, default host 80
```shell
➜  /tmp curl localhost/nginx
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```


# Known Issues
- [ ] Seems for Mac Silicon only "v.1.21.1" works 
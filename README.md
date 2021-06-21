# Ploigos Helm Charts
Helm Charts for deploying various components of the Ploigos project.

## Charts

### ploigos-workflow-tekton-cluster-resources
A Helm chart for Kubernetes to deploy the cluster level resources required to
deploy and run Ploigos Workflows using Tekton.

### ploigos-workflow-standard-tekton-pipeline
A Helm chart for Kubernetes to install the Ploigos Workflow (Standard) run by Tekton for a
given application service.

### ploigos-workflow-minimal-tekton-pipeline
A Helm chart for Kubernetes to install the Ploigos Workflow (Minimal) run by Tekton for a
given application service.

### ploigos-workflow-tekton-shared-resources
A Helm chart for Kubernetes to install the shared resources for a Ploigos Workflow run
by Tekton for a given application service.

Not intended to be used on its own but rather as a sub chart for a specific Workflow.

### ploigos-workflow-shared-resources
A Helm chart for Kubernetes to install the shared resources for a Ploigos Workflow run
by any workflow executor service (ex: Tekton, DronCI, Jenkins, etc).

This is meant to be a child chart of other charts for specific tools to implement specific
Workflows for specific workflow executor services.

## Development

### Set Up Development Environment

1. [Install helm](https://github.com/helm/helm#install)
2. [Install chart-releaser](https://github.com/helm/chart-releaser#installation)
3. Install or have access to a Kubernetes cluster
    * [Kind](https://kind.sigs.k8s.io/)
        - this is what the Github Action uses
    * [Minishift](https://www.okd.io/minishift/)
    * [Red Hat CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview)

#### Create local [Kind](https://kind.sigs.k8s.io/) cluster
If you want to use a local [Kind](https://kind.sigs.k8s.io/) cluster to do your testing here is
how you can set it up.

```bash
kind create cluster --name ploigos-test
kubectl config use-context kind-ploigos-test

echo "Install ingress controller"
helm repo add haproxy-ingress https://haproxy-ingress.github.io/charts
helm upgrade --install haproxy-ingress haproxy-ingress/haproxy-ingress \
    --create-namespace --namespace=ingress-controller \
    --set controller.hostNetwork=true
kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: haproxy
  annotations:
    ingressclass.kubernetes.io/is-default-class: 'true'
spec:
  controller: haproxy-ingress.github.io/controller
EOF

echo "Install tekton"
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.22.0/release.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/previous/v0.12.0/release.yaml
```

### Run linter

```bash
ct lint \
    --all \
    --validate-maintainers=false \
    --validate-chart-schema=false
```

### Run install tests

**NOTE** this will install (then uninstall) these charts against the target kube cluster,
so be aware of what that means.

```bash
kubectl config use-context kind-ploigos-test

ct install \
    --all
```

## Release
All releases get pushed as artifacts to this Github repository and indexed on the `gh-pages` branch.

### Edge
Github actions will take any merge to `main` branch will cause an "edge" type release.

### Named
Create a release of `vSEM_VER` so, `v0.42.0`. Github Actions will do the rest.

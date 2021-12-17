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

### ploigos-workflow-tekton-resources
A Helm chart for Kubernetes to install the shared resources for a Ploigos Workflow run
by Tekton for a given application service.

Not intended to be used on its own but rather as a sub chart for a specific Workflow.

### ploigos-workflow-shared-resources
A Helm chart for Kubernetes to install the shared resources for a Ploigos Workflow run
by any workflow executor service (ex: Tekton, DronCI, Jenkins, etc).

This is meant to be a child chart of other charts for specific tools to implement specific
Workflows for specific workflow executor services.

## Usage

### Installing a Chart
1. Install Helm.
2. Change to the directory with the charts for the workflow runner you are using.
```
cd charts/ploigos-workflow/jenkins-resources
```
4. Tailor the values.xml in the directory to your needs. See the comments in the example values.xml to help you choose the values. See below about the pgpKeys field.
The tailored file should look similar to this example:
```
global:
  serviceName: hello
  applicationName: ref-nodejs-npm-jenkins-min
  pgpKeysSecretNameOverride:
  pgpKeys:
		key: |
		  -----BEGIN PGP PRIVATE KEY BLOCK-----
					 < REDACTED >
		  -----END PGP PRIVATE KEY BLOCK-----
  workflowWorkerRunnerRoleName: ploigos-workflow-runner-jenkins
```

5. Run the Helm command that installs the chart.
```
helm install -f values.yaml ploigos-workflow-ref-nodejs-jenkins-min .
```

### Reusing a PGP Key (for Development):
If you are using PGP keys, the most secure configuration is to generate a new private PGP key for each service. BUT there is significant overhead in managing many PGP keys. If you are simulating a multi-key configuration in a development environment that is used only to develop contributions to the Ploigos ecosystem, then you may want to reuse an existing PGP private key but still create a new Secret to to hold each key.

To get the PGP key in this case:
1. List the secrets currently used by your workflow.
```
oc get secret -n jenkins | grep pgp
```
2. Pick a Secret and get the base64 decoded private pgp key that it contains.
```
oc get secret pgp-keys-ploigos-workflow-ref-spring-boot-jkube-jenkins-min -o jsonpath='{.data}' -n jenkins | sed 's/.*:\(.*\)/\1/' | sed 's/\]$//' | base64 -d
```
3. Use the printed value in the values.yml example above.

## Development

### Set Up Development Environment

1. [Install Helm](https://github.com/helm/helm#install)
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
    --chart-dirs charts/ploigos-workflow/ \
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
    --chart-dirs charts/ploigos-workflow/ \
    --all
```

## Release
All releases get pushed as artifacts to this Github repository and indexed on the `gh-pages` branch.

### Edge
Github actions will take any merge to `main` branch will cause an "edge" type release.

### Named
Create a release of `vSEM_VER` so, `v0.42.0`. Github Actions will do the rest.

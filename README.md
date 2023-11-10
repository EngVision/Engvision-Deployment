# Engvision-Deployment

## Introduction

This repository contains the code for the deployment of the Engvision project. This repository is one of the two repositories that make up the Engvision project. The other repository is [Engvision](https://github.com/EngVision/Project-EngVision) which contains the code for the application itself. This repository contains the code for the deployment of the application to DigitalOcean Kubernetes.

## Tech Stack

- Docker
- Terraform
- Ansible
- DigitalOcean Kubernetes

### Prerequisites

- `terraform` installed
- `kubectl` installed
- `ansible` installed

All the above tools can be installed via brew on macOS.

### Steps

1. Clone the repository
2. Create a DigitalOcean API token.
3. Create a DigitalOcean Kubernetes cluster using `terraform init` and `terraform apply`. Provide the DigitalOcean API token when prompted.
4. Notice the cluster configuration file. Create / edit new configuration file to the default location.

```bash
nano $HOME/.kube/config
```

5. Install tools using Ansible by running the following command:

```bash
ansible-playbook -e kubeconfig=../terraform/kubeconfig.yaml cluster-setup.yml
```

6. Provide Cloudfare API token.

```bash
kubectl create secret generic cloudflare-api-token-secret --from-literal=api-token='YOUR_CLOUDFLARE_API_TOKEN'
```

7. Create Github Container Registry secret. YOUR_GITHUB_PERSONAL_ACCESS is ghp token with repo, worklow and write permissions.

```bash
kubectl create secret docker-registry k8s-ghcr \
--docker-server=https://ghcr.io \
--docker-username=<YOUR_GITHUB_USERNAME> \
--docker-password=<YOUR_GITHUB_PERSONAL_ACCESS-TOKEN> \
--docker-email=<YOUR_GITHUB_EMAIL>
```

8. Creat env for the application.

```bash
kubectl create secret generic evs-be-secret --from-env-file=.env
```

### Credentials

- Argocd:

  - Username: admin
  - Password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

- Grafana:
  - Username: admin
  - Password: `kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo`

### Useful links

- [Ansible - A worker was found in dead state](https://stackoverflow.com/a/69990888)
- [Grafana Monitor Template](https://grafana.com/grafana/dashboards/15759-kubernetes-views-nodes/)

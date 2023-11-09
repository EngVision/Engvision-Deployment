terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "engvision" {
  name    = "engvision-cluster"
  region  = "sgp1"
  version = "1.28.2-do.0"

  node_pool {
    name       = "engvision-worker-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content  = digitalocean_kubernetes_cluster.engvision.kube_config.0.raw_config
  depends_on = [
    digitalocean_kubernetes_cluster.engvision
  ]
  filename = "${path.module}/kubeconfig.yaml"
}

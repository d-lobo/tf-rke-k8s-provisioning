terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.2.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
  }
}

provider "rke" {
  debug = true
  log_file = "/tmp/rke.log"
}

resource rke_cluster "cluster" {
  # add as much nodes as you like
  nodes {
    address = "192.168.0.107"
    user    = "lobo"
    role    = ["controlplane", "etcd"] # k8s-master
    ssh_key = file("~/.ssh/id_rsa")
  }

  # add more worker nodes, if desired
  nodes {
    address = "192.168.0.102"
    user    = "lobo"
    role    = ["worker"] # k8s-slave
    ssh_key = file("~/.ssh/id_rsa")
  }

  addons_include = [
       "https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml",
       "yaml/dashboard-admin-user.yaml",
       "yaml/namespaces.yaml",
       "yaml/example-apps.yaml",
       "yaml/ingress-rules.yaml"
     ]
  ssh_agent_auth = true
}

resource "local_file" "kube_cluster_yaml" {
   filename = "${path.root}/kube_config_cluster.yml"
   content  = rke_cluster.cluster.kube_config_yaml
}

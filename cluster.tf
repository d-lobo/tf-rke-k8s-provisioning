terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.2.3"
    }
    kubernetes = {
     source = "hashicorp/kubernetes"
     version = "2.3.2"
   }
  }
}

provider "rke" {
  debug = true
  log_file = "/tmp/rke.log"
}

provider "kubernetes" {
  host     = "${rke_cluster.cluster.api_server_url}"
  username = "${rke_cluster.cluster.kube_admin_user}"

  client_certificate     = "${rke_cluster.cluster.client_cert}"
  client_key             = "${rke_cluster.cluster.client_key}"
  cluster_ca_certificate = "${rke_cluster.cluster.ca_crt}"
}

resource rke_cluster "cluster" {
  # add as much nodes as you like
  nodes {
    address = "192.168.0.105"
    user    = "lobo"
    role    = ["controlplane", "etcd"] # master
    ssh_key = file("~/.ssh/id_rsa")
  }

  # add more worker nodes, if desired
  nodes {
    address = "192.168.0.106"
    user    = "lobo"
    role    = ["worker"]
    ssh_key = file("~/.ssh/id_rsa")
  }

  addons_include = [
       "https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml",
       "yaml/dashboard-admin-user.yaml",
       "yaml/namespaces.yaml",
       "yaml/example-apps.yaml"
  ]

  ssh_agent_auth = true
}

resource "local_file" "kube_cluster_yaml" {
   filename = "${path.root}/kube_config_cluster.yml"
   content  = rke_cluster.cluster.kube_config_yaml
}

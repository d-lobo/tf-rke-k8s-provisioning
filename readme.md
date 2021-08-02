# Terraform-Rancher-Kubernetes-Provisioning

Provisions a kubernetes cluster on the specified nodes in `cluster.tf` with usual namespace setup for a development team (dev, qa, prod).
Additionally it installs the kubernetes-dashboard, a service-account with cluster-wide permissions to access dashboard,
deploys a minimal example echo app and configures the ingress respectively.

# How to use

## Requirements
* Get Terraform (>1.0) and initialize within the folder, get `kubectl`
* VMs (local / cloud) needs minimal setup:
  * Make sure, you can access vms with ssh
    * if using password-protected ssh-keys, make sure `ssh-agent` is running,
otherwise use `eval $(ssh-agent)` in shell.
  * Preinstall docker on vms
* Replace and/or enhance the `nodes` section in cluster.tf and provide appropriate values.

## Provisioning
* navigate to the folder, containing `.tf` files
* type `terraform init`
  * initializes TF & installs Rancher RKE
* type `terraform plan` to see the plan tf is going to apply
* type `terraform apply` to apply the actual plan

## Credentials & Access cluster with `kubectl`
Once the plan has been successfully applied, terraform creates a ready-2-use kubeconfig (`kube_config_cluster.yaml`) to access the cluster.
Use it, like e.g. `kubectl --kubeconfig kube_config_cluster.yaml get pods --all-namespaces` or set env to point to the file.

## Get bearer token of dashboard admin account; proxy & access dashboard

* get the service account description for the manual created admin-user to have full access to the dashboard:

````
kubectl --kubeconfig kube_config_cluster.yml describe secret admin-user -n kubernetes-dashboard
````

* copy the `token` value in your clipboard.
* enable k8s-proxy (`kubectl --kubeconfig kube_config_cluster.yml proxy`)
* open in your browser: `http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login`
* use copied token to login.

---

This script will be continously updated and improved to leverage more of terraform capabilities to manage k8s.

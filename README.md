# Proxmox Kubernetes Cluster

This repository creates a Kubernets cluster (with kubeadm) in a Proxmox server. It creates 1 host for k8s control-plane and 4 hosts for k8s workers (one node has an VPN embedded for torrenting services...). It requires that the template created by [proxmox-ubuntu](https://github.com/rmzamith/proxmox-ubuntu) is available in the Proxmox server.

# Requirements

- [GNU make](https://www.gnu.org/software/make/)
- [tfenv](https://github.com/tfutils/tfenv)
- Proxmox server (At least 10 CPU cores, 32 GBs of RAM and around 300 GBs of available disk space in lvm storage pool)
- Existing `Ubuntu-Server-2504-Template` in the Proxmox server. Source code found in [proxmox-ubuntu](https://github.com/rmzamith/proxmox-ubuntu) repository
- Fork of [proxmox-ansible-k8s](https://github.com/rmzamith/proxmox-ansible-k8s) with the `group_vars` adjusted to your Proxmox server

## Preparation
1. It is required that a file named `.env` containing the Proxmox credentials and URL. The file needs to be structured as follows:
```
PM_API_TOKEN_ID=<user_id>
PM_API_TOKEN_SECRET=<user_token>
PM_API_URL="https://<proxmox_url>:<proxmox_port>/api2/json"
```
2. Create the `lab` Terraform workspace by running
```shell
terraform workspace create lab
```
3. Init Terraform project
```shell
terraform init
```
4. Check the `locals.tf` file and adjust it according to your Proxmox server
5. Fork the project [proxmox-ansible-k8s](https://github.com/rmzamith/proxmox-ansible-k8s) and adjust the `group_vars` according to your cluster

## Build
Create the cluster by running
```shell
make apply
```

## Destruction
Destroy the cluster by running
```shell
make destroy
``` 

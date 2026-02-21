#!/bin/bash
set -e # Exit immediately if a command fails

# Disable SSH host key checking for automated first-time connection
export ANSIBLE_HOST_KEY_CHECKING=False

echo -e "\n\033[1;34m🏗️  PHASE 1: Infrastructure Provisioning (Terraform)\033[0m"
cd infrastructure
terraform init
terraform apply -auto-approve

echo -e "\n\033[1;33m⏳ Waiting 30 seconds for AWS EC2 to initialize SSH services...\033[0m"
sleep 30

echo -e "\n\033[1;34m🛠️  PHASE 2: Configuration Management (Ansible)\033[0m"
cd ../configuration

# 1. Setup Local Control Node
echo -e "\n\033[1;32m>> [1/5] Setting up Control Node (Terraform Install)...\033[0m"
ansible-playbook playbooks/terraform.yml

# 2. OS Baseline & Security
echo -e "\n\033[1;32m>> [2/5] Applying OS Baseline & Security Hardening...\033[0m"
ansible-playbook playbooks/baseline.yml -i inventories/dev/hosts.ini

# 3. Docker Engine
echo -e "\n\033[1;32m>> [3/5] Installing Docker Engine & Compose...\033[0m"
ansible-playbook playbooks/docker.yml -i inventories/dev/hosts.ini

# 4. Kubernetes Setup
echo -e "\n\033[1;32m>> [4/5] Provisioning Kubernetes Binaries (Kubeadm/Kubectl)...\033[0m"
ansible-playbook playbooks/k8s_setup.yml -i inventories/dev/hosts.ini

# 5. Healthcheck
echo -e "\n\033[1;32m>> [5/5] Running Final System Healthcheck...\033[0m"
ansible-playbook playbooks/healthcheck.yml -i inventories/dev/hosts.ini

echo -e "\n\033[1;35m✅ DEPLOYMENT SUCCESSFUL: Your Kubernetes-ready node is live!\033[0m"

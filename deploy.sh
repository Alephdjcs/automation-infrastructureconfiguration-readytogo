#!/bin/bash

set -euo pipefail
trap 'echo -e "\n\033[1;31m DEPLOYMENT FAILED AT LINE $LINENO\033[0m"' ERR # ----> It give the error message wherever it fails

# ------------------------------
# Validate Environment--->This will pass to teerraform eventually is better to limit the options
# ------------------------------
ENV=${1:-dev}
[[ "$ENV" =~ ^(dev|test|prod)$ ]] || { 
  echo "Invalid environment: $ENV (use dev|test|prod)"
  exit 1
}

echo -e "\n\033[1;34m TARGETING ENVIRONMENT: $ENV\033[0m"

export ANSIBLE_HOST_KEY_CHECKING=False

# ------------------------------
# PHASE 0 – Bootstrap Control Node
# ------------------------------
echo -e "\n\033[1;34m PHASE 0: Preparing Control Node\033[0m"
ansible-playbook configuration/playbooks/terraform.yml -i "localhost," -c local

# ------------------------------
# PHASE 1 – Infrastructure Provisioning
# ------------------------------
echo -e "\n\033[1;34m PHASE 1: Terraform ($ENV)\033[0m"
cd infrastructure
terraform init -upgrade
terraform plan -var="environment=$ENV" -out=tfplan
terraform apply -auto-approve tfplan
cd ..

# ------------------------------
# PHASE 2 – Connectivity Check
# ------------------------------
INVENTORY="configuration/inventories/$ENV/hosts.ini"

echo -e "\n\033[1;33m Waiting for SSH...\033[0m"
ansible all -i "$INVENTORY" -m wait_for_connection -a "timeout=300"

# ------------------------------
# PHASE 3 – Configuration Management
# ------------------------------
echo -e "\n\033[1;34m PHASE 3: Ansible Configuration\033[0m"

ansible-playbook configuration/playbooks/baseline.yml -i "$INVENTORY"
ansible-playbook configuration/playbooks/docker.yml -i "$INVENTORY"
ansible-playbook configuration/playbooks/k8s_setup.yml -i "$INVENTORY"
ansible-playbook configuration/playbooks/healthcheck.yml -i "$INVENTORY"

echo -e "\n\033[1;35m✅ $ENV DEPLOYMENT COMPLETE!\033[0m"

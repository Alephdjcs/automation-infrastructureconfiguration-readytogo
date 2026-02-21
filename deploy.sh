#!/bin/bash
set -e

# Usage: ./deploy.sh [dev|test|prod]
ENV=${1:-dev}

echo -e "\n\033[1;34m🚀 TARGETING ENVIRONMENT: $ENV\033[0m"

# Disable SSH host key checking
export ANSIBLE_HOST_KEY_CHECKING=False

echo -e "\n\033[1;34m🏗️  PHASE 1: Terraform ($ENV)\033[0m"
cd infrastructure
terraform init
terraform apply -var="environment=$ENV" -auto-approve

echo -e "\n\033[1;33m⏳ Waiting 30s for $ENV instance...\033[0m"
sleep 30

echo -e "\n\033[1;34m🛠️  PHASE 2: Ansible ($ENV)\033[0m"
cd ../configuration

# Run all playbooks using the dynamic inventory folder
INVENTORY="inventories/$ENV/hosts.ini"

ansible-playbook playbooks/terraform.yml
ansible-playbook playbooks/baseline.yml -i $INVENTORY
ansible-playbook playbooks/docker.yml -i $INVENTORY
ansible-playbook playbooks/k8s_setup.yml -i $INVENTORY
ansible-playbook playbooks/healthcheck.yml -i $INVENTORY

echo -e "\n\033[1;35m✅ $ENV DEPLOYMENT COMPLETE!\033[0m"

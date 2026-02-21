#!/bin/bash
set -e

# Usage: ./deploy.sh [dev|test|prod]
ENV=${1:-dev}

echo -e "\n\033[1;34m🚀 TARGETING ENVIRONMENT: $ENV\033[0m"

# Ansible automation settings
export ANSIBLE_HOST_KEY_CHECKING=False

# --- PHASE 1: INFRASTRUCTURE PROVISIONING ---
echo -e "\n\033[1;34m🏗️  PHASE 1: Terraform ($ENV)\033[0m"
cd infrastructure
terraform init
terraform apply -var="environment=$ENV" -auto-approve

# Go back to root to handle paths correctly
cd ..

# --- PHASE 2: CONNECTIVITY CHECK ---
INVENTORY="configuration/inventories/$ENV/hosts.ini"

echo -e "\n\033[1;33m⏳ Waiting for SSH to be ready on $ENV instance...\033[0m"
# Instead of a blind sleep, wait for the host to respond (max 300s)
ansible all -i "$INVENTORY" -m wait_for_connection -a "timeout=300"

# --- PHASE 3: CONFIGURATION MANAGEMENT ---
echo -e "\n\033[1;34m🛠️  PHASE 3: Ansible ($ENV)\033[0m"
cd configuration

# 1. Setup Control Node Tools (Localhost)
# The "-i localhost," forces local execution and avoids SSH attempts to yourself
ansible-playbook playbooks/terraform.yml -i "localhost," -c local

# 2. Run Playbooks on Target Infrastructure
ansible-playbook playbooks/baseline.yml -i "$INVENTORY"
ansible-playbook playbooks/docker.yml -i "$INVENTORY"
ansible-playbook playbooks/k8s_setup.yml -i "$INVENTORY"
ansible-playbook playbooks/healthcheck.yml -i "$INVENTORY"

echo -e "\n\033[1;35m✅ $ENV DEPLOYMENT COMPLETE!\033[0m"

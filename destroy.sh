#!/bin/bash
set -e

# Usage: ./destroy.sh [dev|test|prod]
ENV=${1:-dev}

echo -e "\n\033[1;31m🔥 WARNING: Starting Destruction of Environment: $ENV\033[0m"
echo -e "\033[1;31mThis will terminate all AWS resources associated with $ENV.\033[0m"
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -e "\n\033[1;33m❌ Destruction cancelled.\033[0m"
    exit 1
fi

# --- PHASE 1: INFRASTRUCTURE REMOVAL ---
echo -e "\n\033[1;34m🏗️  PHASE 1: Terraform Destroy ($ENV)\033[0m"
cd infrastructure
terraform destroy -var="environment=$ENV" -auto-approve

# --- PHASE 2: INVENTORY RESET ---
echo -e "\n\033[1;32m🧹 PHASE 2: Cleaning up $ENV inventory...\033[0m"
INVENTORY_PATH="../configuration/inventories/$ENV/hosts.ini"

# Reset to a safe local-only state to prevent Ansible from targeting old IPs
cat <<EOT > $INVENTORY_PATH
[local]
127.0.0.1 ansible_connection=local
EOT

echo -e "\n\033[1;35m✅ $ENV infrastructure terminated and inventory reset to local.\033[0m"

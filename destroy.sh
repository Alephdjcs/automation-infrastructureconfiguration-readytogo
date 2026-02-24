#!/bin/bash
set -euo pipefail

# ------------------------------
# Validate Environment
# ------------------------------
ENV=${1:-dev}
[[ "$ENV" =~ ^(dev|test|prod)$ ]] || { 
  echo "Invalid environment: $ENV (use dev|test|prod)"
  exit 1
}

echo -e "\n\033[1;31m DANGER ZONE: Destroying environment: $ENV\033[0m"
echo -e "\033[1;31mThis will permanently delete all AWS resources for $ENV.\033[0m"

echo -ne "\033[1;33mType the environment name ($ENV) to confirm: \033[0m"
read -r CONFIRM

if [ "$CONFIRM" != "$ENV" ]; then
    echo -e "\n\033[1;31m❌ Confirmation failed. Aborting.\033[0m"
    exit 1
fi

# ------------------------------
# PHASE 1 – Terraform Destroy
# ------------------------------
echo -e "\n\033[1;34m PHASE 1: Terraform Destroy ($ENV)\033[0m"

[ -d "infrastructure" ] || { echo "Missing infrastructure folder"; exit 1; }

cd infrastructure
terraform init -upgrade
terraform destroy -var="environment=$ENV" -auto-approve
cd ..

# ------------------------------
# PHASE 2 – Inventory Reset
# ------------------------------
echo -e "\n\033[1;32m PHASE 2: Resetting $ENV inventory...\033[0m"

INVENTORY_PATH="configuration/inventories/$ENV/hosts.ini"

cat <<EOT > "$INVENTORY_PATH"
[local]
127.0.0.1 ansible_connection=local
EOT

echo -e "\n\033[1;35m✅ $ENV infrastructure destroyed safely.\033[0m"

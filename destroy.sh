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
    echo "Destruction cancelled."
    exit 1
fi

cd infrastructure

# Run terraform destroy targeting the specific environment
terraform destroy -var="environment=$ENV" -auto-approve

echo -e "\n\033[1;32m🧹 Cleaning up $ENV inventory file...\033[0m"

# Reset the specific environment inventory to a clean state
INVENTORY_PATH="../configuration/inventories/$ENV/hosts.ini"
echo "[$ENV]" > $INVENTORY_PATH
echo "# Inventory cleaned after destruction" >> $INVENTORY_PATH

echo -e "\n\033[1;35m✅ $ENV resources terminated and inventory cleaned.\033[0m"

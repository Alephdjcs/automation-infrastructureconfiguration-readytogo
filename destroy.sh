#!/bin/bash
set -e

echo -e "\n\033[1;31m🔥 WARNING: Starting Infrastructure Destruction...\033[0m"

cd infrastructure

# Run terraform destroy
terraform destroy -auto-approve

echo -e "\n\033[1;32m🧹 Cleaning up local inventory files...\033[0m"

# Optional: Reset the dev inventory to a clean state
echo "[local]" > ../configuration/inventories/dev/hosts.ini
echo "127.0.0.1 ansible_connection=local" >> ../configuration/inventories/dev/hosts.ini

echo -e "\n\033[1;35m✅ All resources have been terminated and local files cleaned.\033[0m"

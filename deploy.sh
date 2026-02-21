#!/bin/bash
set -e

# Disable SSH host key checking for the first connection
export ANSIBLE_HOST_KEY_CHECKING=False

echo -e "\n\033[1;34m🏗️  Starting Infrastructure Provisioning with Terraform...\033[0m"
cd infrastructure
terraform init
terraform apply -auto-approve

echo -e "\n\033[1;33m⏳ Waiting 30 seconds for the instance to initialize...\033[0m"
sleep 30

echo -e "\n\033[1;34m🛠️  Starting Configuration Management with Ansible...\033[0m"
cd ../configuration

echo -e "\n\033[1;32m>> Executing: terraform.yml (Control Node Setup)\033[0m"
ansible-playbook playbooks/terraform.yml

echo -e "\n\033[1;32m>> Executing: baseline.yml\033[0m"
ansible-playbook playbooks/baseline.yml -i inventories/dev/hosts.ini

echo -e "\n\033[1;32m>> Executing: docker.yml\033[0m"
ansible-playbook playbooks/docker.yml -i inventories/dev/hosts.ini

echo -e "\n\033[1;35m✅ Deployment Complete! Your infrastructure is ready.\033[0m"

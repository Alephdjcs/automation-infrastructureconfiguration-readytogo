🚀 Automation Infrastructure Configuration (Ready-to-Go)

This repository provides a structured Infrastructure as Code (IaC) framework using Terraform for provisioning and Ansible for configuration management.


🏗 Architecture Overview

The project follows a logical top-down flow from initial code development to environment-specific deployment:
Code snippet

graph TD
    Developer["👨‍💻 Developer"] --> Terraform["🏗️ Terraform Layer<br/>(Provisioning)"]
    
    Terraform -->|Provisions| Cloud["☁️ Infrastructure<br/>(AWS · GCP · Azure · VMware)"]
    
    Cloud --> Ansible["🛠️ Ansible Layer<br/>(Configuration)"]
    
    Ansible --> Roles["📦 Reusable Roles"]
    
    Roles --> Baseline["🔹 Baseline"]
    Roles --> Hardening["🛡️ Security Hardening"]
    Roles --> Health["🏥 Health Check"]
    Roles --> Docker["🐳 Docker Engine"]
    Roles --> K8s["☸️ Kubernetes Setup"]
    
    Baseline & Hardening & Health & Docker & K8s --> Inventories["🗂️ Inventories"]
    
    Inventories --> Dev["🟢 Dev"]
    Inventories --> Test["🟡 Test"]
    Inventories --> Prod["🔴 Prod"]

🛠️ Configuration Layer (Ansible)

The Ansible layer is designed to be OS-agnostic and environment-aware, allowing for seamless scaling.
Directory Structure
Plaintext

configuration/
├── ansible.cfg                # Global Ansible settings
├── inventories/               # Environment-specific host management
│   ├── dev | test | prod      # Host files and group variables
├── playbooks/                 # Orchestration of execution flows
│   ├── baseline.yml           # Initial OS setup
│   ├── docker.yml             # Docker Engine deployment
│   ├── k8s_setup.yml          # Kubernetes node installation
│   └── healthcheck.yml        # System status verification
└── roles/                     # Modular, reusable logic
    ├── os_baseline/           # Multi-OS setup (Debian/RedHat)
    ├── docker/                # Docker installation & services
    ├── kubernetes/            # K8s binaries & networking
    └── security_hardening/    # Security policies & SSH hardening

🚀 Getting Started
1. Prerequisites

Install Ansible on your control node (Ubuntu example):
Bash

sudo apt update && sudo apt install ansible -y
ansible --version

2. Inventory Configuration

Define your target hosts in inventories/dev/hosts.ini.

For remote deployment:
Ini, TOML

[all]
192.168.1.50 ansible_user=adminops

For local testing:
Ini, TOML

[all]
127.0.0.1 ansible_connection=local

3. Running Playbooks

Run the baseline configuration to prepare your servers:
Bash

cd configuration
ansible-playbook playbooks/baseline.yml -i inventories/dev/hosts.ini -K

📦 Core Roles Detail
🔹 os_baseline

Prepares the operating system regardless of the distribution.

    Multi-OS Support: Automatically detects Debian or RedHat families.

    Actions: Updates cache, installs essential tools (git, vim, curl, htop), and optimizes kernel parameters like swappiness.

🔹 security_hardening

Applies security best practices to protect the server:

    Disables root login via SSH.

    Limits authentication attempts.

    Configures SSH Grace Time and password authentication policies.

🔹 kubernetes & docker

    Docker: Installs the engine, manages user groups, and ensures the daemon is active.

    K8s: Installs kubeadm, kubectl, and kubelet. It also applies necessary kernel modules (overlay, br_netfilter) and pins package versions to prevent accidental upgrades.

🏥 Health Check

To verify system health after configuration, run:
Bash

ansible-playbook playbooks/healthcheck.yml -i inventories/dev/hosts.ini

Checks performed: Hostname verification, RAM usage, and available disk space.
🧠 Design Principles

    Idempotency: Playbooks can be run multiple times without unintended side effects.

    Zero Secrets: No passwords or tokens are stored in plain text (use ansible-vault).

    Modularity: Roles are independent and can be combined into various playbooks as needed.

Maintainer: @Alephdjcs

License: MIT

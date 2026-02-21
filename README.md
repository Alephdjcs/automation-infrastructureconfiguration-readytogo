Automation Infrastructure Configuration (Ready-to-Go) by Danilo Cerdas S 

This repository provides a structured Infrastructure as Code (IaC) framework using Terraform for provisioning and Ansible for configuration management.


🏗 Architecture Overview

The project follows a logical top-down flow from initial code development to environment-specific deployment:
Code snippet

---

```mermaid
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
```

## 🛠️ Configuration Layer (Ansible)

The Ansible layer is designed to be OS-agnostic and environment-aware.

### 📂 Directory Structure
```text
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
```

---

## Getting Started

### 1️ Prerequisites
Install Ansible on your control node:
```bash
sudo apt update && sudo apt install ansible -y
```

### 2️Inventory Configuration
Define your target hosts in `inventories/dev/hosts.ini`:
```ini
[all]
192.168.1.50 ansible_user=adminops
```

### 3️Running Playbooks
```bash
cd configuration
ansible-playbook playbooks/baseline.yml -i inventories/dev/hosts.ini -K
```

---

## Core Roles Detail

### 🔹 os_baseline
Prepares the operating system. Automatically detects `Debian` or `RedHat`.
* **Actions:** Updates cache, installs tools (`git`, `vim`, `curl`), and optimizes **swappiness**.

### 🔹 security_hardening
* Disables `root` login via SSH.
* Limits authentication attempts.
* Configures SSH Grace Time.

### 🔹 kubernetes & docker
* **Docker:** Installs engine and manages user groups.
* **K8s:** Installs `kubeadm`, `kubectl`, and `kubelet`.

---

## 🏥 Health Check
To verify system health:
```bash
ansible-playbook playbooks/healthcheck.yml -i inventories/dev/hosts.ini
```

**Maintainer:** [@Alephdjcs](https://github.com/Alephdjcs)

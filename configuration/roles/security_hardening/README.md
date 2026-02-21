# Role: Security Hardening

This role applies a security baseline to Ubuntu instances used for Docker and Kubernetes workloads.

## Actions Performed
1. **System Updates**: Ensures all packages are up to date.
2. **SSH Hardening**: Disables password authentication (Key-based only).
3. **Firewall Baseline**: Ensures basic UFW (Uncomplicated Firewall) rules are ready.
4. **Essential Packages**: Installs `curl`, `git`, and `unzip`.

## Role Variables
- `ssh_user`: The user used for SSH connections (default: ubuntu).

## Usage
This role is called automatically by the main playbook during the infrastructure deployment phase.

**Author:** Danilo Cerdas
**License:** MIT

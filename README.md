# Infrastructure

## Logical Architecture Diagram

```mermaid
graph TD
    Terraform[Terraform Configuration] -->|Provisions| VM[Cloud VM (GCP/AWS)]
    VM --> Ansible[Ansible Configuration Roles]
    Ansible -->|Hardening & Setup| Servers[Configured & Secured Servers]

README

# Infraestructura

## Diagrama lógico
```mermaid
graph TD
    Terraform[Terraform config] -->|Provisiona| VM[VM en GCP/AWS]
    VM --> Ansible[Ansible roles de configuración]
    Ansible -->|Hardening & Setup| Servers[Servidores configurados]

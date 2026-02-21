# 🚀 Automation Infrastructure Configuration (Ready-to-Go)

Este repositorio contiene una solución de **Infraestructura como Código (IaC)** para la configuración y el despliegue automatizado de entornos Linux.

## 📊 Arquitectura del Flujo

```mermaid
graph TD
    Developer["Developer"] --> Terraform["Terraform Layer<br/>Infrastructure as Code"]
    
    Terraform -->|Provisions| Cloud["Cloud / Infrastructure<br/>(AWS · GCP · Azure · VMware)"]
    
    Cloud --> Ansible["Ansible Configuration Layer"]
    
    Ansible --> Roles["Reusable Roles"]
    
    Roles --> Baseline["Baseline"]
    Roles --> Hardening["Security Hardening"]
    Roles --> Health["Health Check"]
    Roles --> Docker["Docker Deployment"]
    Roles --> K8s["Kubernetes Setup"]
    
    Baseline --> Inventories["Inventories (Environments)"]
    Hardening --> Inventories
    Health --> Inventories
    Docker --> Inventories
    K8s --> Inventories
    
    Inventories --> Dev["Development (dev)"]
    Inventories --> Test["Testing (test)"]
    Inventories --> Prod["Production (prod)"]

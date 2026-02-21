graph TD

    Developer["Developer"]

    Developer --> Terraform["Terraform Layer<br/>Infrastructure as Code"]

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

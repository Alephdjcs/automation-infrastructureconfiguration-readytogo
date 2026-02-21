# 1. Network Layer
module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
}

# Data source to get your current public IP
data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}

# 2. Security Layer (Firewalls)
module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

# 3. Compute Layer
module "compute" {
  source            = "./modules/compute"
  project_name      = "${var.project_name}-${var.environment}"
  vpc_id            = module.networking.vpc_id
  public_subnet     = module.networking.public_subnet_id
  security_group_id = module.security.security_group_id
  instance_type     = var.environment == "prod" ? "t3.medium" : "t2.micro"
  key_name          = "my-aws-key"
}

# 4. Ansible Automation (Dynamic Inventory Generation)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
    public_ip = module.compute.public_ip
    key_name  = "my-aws-key"
    ssh_user  = var.ssh_user 
  })
  
  filename = "../configuration/inventories/${var.environment}/hosts.ini"
}

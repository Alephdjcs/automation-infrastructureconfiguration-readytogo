# 1. Network Layer
module "networking" {
  source       = "./modules/networking"
  project_name = var.project_name
}

# 2. Security Layer (Firewalls)
module "security" {
  source       = "./modules/security"
  project_name = var.project_name
  vpc_id       = module.networking.vpc_id
}

# 3. Compute Layer (Updated naming)
module "compute" {
  source            = "./modules/compute"
  project_name      = "${var.project_name}-${var.environment}" # Dynamic name
  vpc_id            = module.networking.vpc_id
  public_subnet     = module.networking.public_subnet_id
  security_group_id = module.security.security_group_id
  instance_type     = var.environment == "prod" ? "t3.medium" : "t2.micro" # Example: bigger in prod
  key_name          = "my-aws-key"
}

# 4. Ansible Automation (Dynamic Path)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
    public_ip = module.compute.public_ip
    key_name  = "my-aws-key"
  })
  
  # This targets the correct environment folder!
  filename = "../configuration/inventories/${var.environment}/hosts.ini"
}

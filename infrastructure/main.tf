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

# 3. Compute Layer (The VM)
module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  public_subnet     = module.networking.public_subnet_id
  security_group_id = module.security.security_group_id
  instance_type     = "t2.micro"
  key_name          = "my-aws-key" # Make sure this key exists in your AWS Console
}

# 4. Ansible Automation (Auto-generate hosts.ini)
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
    public_ip = module.compute.public_ip
    key_name  = "my-aws-key"
  })
  
  filename = "../configuration/inventories/dev/hosts.ini"
}

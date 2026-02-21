resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/templates/ansible_inventory.tftpl", {
    public_ip = module.compute.public_ip
    key_name  = "my-aws-key" # The name of your .pem file
  })
  
  filename = "../configuration/inventories/dev/hosts.ini"
}

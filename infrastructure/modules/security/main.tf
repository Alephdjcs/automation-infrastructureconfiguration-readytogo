resource "aws_security_group" "allow_ssh_http" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and Web traffic"
  vpc_id      = var.vpc_id

  # SSH for Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # For production, restrict this to your IP
  }

  # HTTP for Apps/K8s
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound: Allow all traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

output "security_group_id" {
  value = aws_security_group.allow_ssh_http.id
}

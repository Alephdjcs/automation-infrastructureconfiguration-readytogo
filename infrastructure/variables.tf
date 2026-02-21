variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "automation-ready-to-go"
}

variable "environment" {
  type        = string
  description = "Target environment (dev, test, prod)"
  default     = "dev"
}

variable "ssh_user" {
  type    = string
  default = "ubuntu" 

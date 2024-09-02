terraform {
  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "key_pair" {
  source = "./modules/key_pair"

  key_name       = var.key_name
  public_key_path = var.public_key_path
}

module "security_group" {
  source = "./modules/security_group"

  allowed_ip = var.allowed_ip
}

module "ec2_instance" {
  source = "./modules/ec2_instance"

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = module.key_pair.key_name
  security_group = module.security_group.security_group_id
}

output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2_instance.instance_ip
}

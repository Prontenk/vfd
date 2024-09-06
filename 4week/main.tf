provider "aws" {
  region  = var.region
  profile = "admin"
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  instance_names = ["webserver", "backend", "management"]
  key_name = "my_key"
}

module "security_group" {
  source = "./modules/security_group"
  allowed_ports = [22, 80, 443]
  allowed_cidrs = ["0.0.0.0/0"]
}


output "instance_ips" {
  value = module.ec2_instance.instance_ips
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  instance_names = ["webserver", "backend", "management"]
  key_name = "my_key"
  allowed_ports = [22, 80, 443]
  allowed_cidrs = ["0.0.0.0/0"]
}

module "security_group" {
  source = "./modules/security_group"
  allowed_ports = [22, 80, 443]
  allowed_cidrs = ["0.0.0.0/0"]
}

output "instance_ips" {
  description = "Public IPs of EC2 instances"
  value = module.ec2_instance.instance_ips
}

output "instance_ip_webserver" {
  description = "Public IP of the webserver instance"
  value = module.ec2_instance.instance_ips["webserver"]
}

output "security_group_id" {
  description = "ID of the security group"
  value = module.security_group.security_group_id
}

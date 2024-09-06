output "instance_ips" {
  description = "Public IPs of EC2 instances"
  value       = module.ec2_instance.instance_ips
}

output "security_group_id" {
  description = "ID of the security group"
  value       = module.security_group.security_group_id
}

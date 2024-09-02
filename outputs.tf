output "instance_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2_instance.instance_ip
}

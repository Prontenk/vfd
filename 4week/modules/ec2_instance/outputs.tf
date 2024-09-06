output "instance_ips" {
  description = "Public IPs of instances"
  value = { for k, v in aws_instance.this : k => v.public_ip }
}

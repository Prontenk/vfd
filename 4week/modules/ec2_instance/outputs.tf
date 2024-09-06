output "instance_ips" {
  description = "Public IPs of instances"
  value       = aws_instance.this[*].public_ip
}

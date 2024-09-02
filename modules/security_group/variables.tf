variable "name" {
  description = "The name of the security group"
}

variable "allowed_ssh_ips" {
  description = "List of allowed IPs for SSH"
  type        = list(string)
}

variable "ami" {
  description = "Amazon Machine Image ID"
}

variable "instance_type" {
  description = "EC2 instance type"
}

variable "key_name" {
  description = "The name of the SSH key pair"
}

variable "security_group" {
  description = "Security group ID for the EC2 instance"
}

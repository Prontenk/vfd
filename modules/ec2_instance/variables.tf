variable "ami" {
  description = "Amazon Machine Image ID"
}

variable "instance_type" {
  description = "Type of EC2 instance"
}

variable "key_name" {
  description = "Name of the SSH key pair"
}

variable "security_group_id" {
  description = "ID of the security group"
}

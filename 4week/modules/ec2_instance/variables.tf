variable "instance_names" {
  description = "List of instance names"
  type        = list(string)
}

variable "ami" {
  description = "Amazon Machine Image ID"
}

variable "instance_type" {
  description = "Type of EC2 instance"
}

variable "key_name" {
  description = "SSH key name"
}

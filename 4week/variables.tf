variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key name for EC2 instance"
}

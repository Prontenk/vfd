variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  default     = "admin"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  default     = "my_key"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_ip" {
  description = "IP address allowed to SSH into the EC2 instance"
  default     = "77.47.132.218/32"
}

variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

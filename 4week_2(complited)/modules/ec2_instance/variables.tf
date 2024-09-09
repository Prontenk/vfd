variable "instance_names" {
  description = "Список імен для EC2 інстансів"
  type        = list(string)
}

variable "ami" {
  description = "AMI для інстансів"
  type        = string
  default     = "ami-0c6da69dd16f45f72" 
}

variable "instance_type" {
  description = "Тип інстансів"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH ключ для доступу"
  type        = string
}

variable "subnet_id" {
  description = "ID підмережі"
  type        = string
}

variable "secret_arn" {
  description = "ARN секрету з AWS Secrets Manager"
  type        = string
}

variable "project_name" {
  description = "Назва проекту"
  type        = string
}

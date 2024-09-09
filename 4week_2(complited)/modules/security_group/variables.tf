variable "allowed_ports" {
  description = "Список дозволених портів"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID VPC для створення групи безпеки"
  type        = string
}

variable "project_name" {
  description = "Назва проекту"
  type        = string
}

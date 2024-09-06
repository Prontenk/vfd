resource "aws_instance" "this" {
  for_each = toset(var.instance_names)

  ami           = "ami-02d69c34f7a0bf36a"  # Замініть на актуальну AMI для вашого регіону
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = each.key
  }

  # Додати інші параметри тут...
}

output "instance_ips" {
  description = "Public IPs of instances"
  value = { for k, v in aws_instance.this : k => v.public_ip }
}

resource "aws_instance" "this" {
  for_each      = toset(var.instance_names)
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = each.key
  }
}

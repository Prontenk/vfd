resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type

  key_name       = var.key_name
  security_groups = [var.security_group]

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ubuntu
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  EOF

  tags = {
    Name = "Terraform-EC2"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}

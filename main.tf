provider "aws" {
  region = "us-east-1"  # Замініть на ваш регіон
  profile = "admin"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my_key"
  public_key = file("~/.ssh/id_rsa.pub")  # Шлях до вашого SSH ключа
}

resource "aws_security_group" "ec2_security_group" {
  name = "ec2_security_group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["77.47.132.218/32"]  # Замініть на ваш IP
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-02d69c34f7a0bf36a"  # Замініть на актуальну AMI для вашого регіону
  instance_type = "t2.micro"

  key_name      = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.ec2_security_group.name]

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
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

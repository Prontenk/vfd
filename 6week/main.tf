provider "aws" {
  region = "eu-north-1"
}

# Налаштування віддаленого стану
terraform {
  backend "s3" {
    bucket = "6weekbucket"
    key    = "project1/states/terraform.tfstate"
    region = "eu-north-1"
  }
}

# Створення VPC
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Створення підмережі
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Група безпеки для інстансів
resource "aws_security_group" "asg_sg" {
  name   = "asg_security_group"
  vpc_id = aws_vpc.example_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
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

# Створення шаблону запуску
resource "aws_launch_template" "example_launch_template" {
  name_prefix   = "example-launch-template"
  image_id      = "ami-0129bfde49ddb0ed6"
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.asg_sg.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ASG-instance"
    }
  }
}

# Створення Auto Scaling Group
resource "aws_autoscaling_group" "example_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.example_subnet.id]
  launch_template {
    id      = aws_launch_template.example_launch_template.id
    version = "$Latest"
  }
}

# Розклад масштабування для збільшення кількості інстансів
resource "aws_autoscaling_schedule" "scale_up_action" {
  scheduled_action_name = "scale_up_action"
  min_size              = 2
  max_size              = 2
  desired_capacity      = 2
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
  recurrence            = "0 6 * * *"  # Масштабування о 06:00 UTC (CRON-формат)
}

# Розклад масштабування для зменшення кількості інстансів
resource "aws_autoscaling_schedule" "scale_down_action" {
  scheduled_action_name = "scale_down_action"
  min_size              = 1
  max_size              = 1
  desired_capacity      = 1
  autoscaling_group_name = aws_autoscaling_group.example_asg.name
  recurrence            = "0 18 * * *"  # Масштабування о 18:00 UTC (CRON-формат)
}

# Виведення назви Auto Scaling Group
output "asg_name" {
  value = aws_autoscaling_group.example_asg.name
}

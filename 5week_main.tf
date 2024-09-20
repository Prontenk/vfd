





provider "aws" {
  region = "eu-north-1"  # Вкажи свій регіон
}

# VPC (Приклад, якщо в тебе вже є VPC, цей код не потрібен)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

data "aws_availability_zones" "available" {}

# Підмережі для ALB і ASG
resource "aws_subnet" "main" {
  count = 2
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  vpc_id     = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "main-subnet-${count.index + 1}"
  }
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS traffic"
  vpc_id      = aws_vpc.main.id

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

  tags = {
    Name = "alb-sg"
  }
}

# Application Load Balancer
resource "aws_lb" "myapp_lb" {
  name               = "myapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.main.*.id

  tags = {
    Name = "myapp-lb"
  }
}

# Лістенери для ALB

# Listener for Application Load Balancer (HTTP)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.myapp_lb.arn
  port              = "80"                # Порт 80 для HTTP
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.myapp_tg.arn
  }
}

# Listener for Application Load Balancer (HTTPS)


# Target Group
resource "aws_lb_target_group" "myapp_tg" {
  name     = "myapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "myapp-tg"
  }
}

# Launch Configuration for ASG
resource "aws_launch_configuration" "myapp_lc" {
  name          = "myapp-launch-configuration"
  image_id      = "ami-0129bfde49ddb0ed6" # Ідентифікатор AMI
  instance_type = "t3.micro"
  key_name = "Ubuntu_fr"

  security_groups = [aws_security_group.instance_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

# AutoScaling Group
resource "aws_autoscaling_group" "myapp_asg" {
  launch_configuration = aws_launch_configuration.myapp_lc.id
  vpc_zone_identifier  = aws_subnet.main.*.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 2

  target_group_arns = [aws_lb_target_group.myapp_tg.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "myapp-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Security group для EC2 інстансів
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Allow ALB to communicate with instances"
  vpc_id = aws_vpc.main.id


  ingress {
    from_port      = 80
    to_port        = 80
    protocol       = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}

# Інтернет-шлюз для VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Маршрут для інтернету в публічні підмережі
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Прив'язка маршрутної таблиці до підмереж
resource "aws_route_table_association" "public_association" {
  count = 2
  subnet_id      = aws_subnet.main[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
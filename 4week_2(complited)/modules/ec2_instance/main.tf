resource "aws_instance" "this" {
  for_each = { for name in var.instance_names : name => name }

  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.this.name

  tags = {
    Name = each.value
  }

  user_data = <<-EOF
    #!/bin/bash
    # Отримання секрету з AWS Secrets Manager та запис у .env файл
    SECRET=$(aws secretsmanager get-secret-value --secret-id ${var.secret_arn} --query SecretString --output text)
    echo $SECRET > /etc/environment
  EOF
}

resource "aws_iam_role" "this" {
  name = "${var.project_name}_instance_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "this" {
  name        = "${var.project_name}_secrets_policy"
  description = "Policy to allow EC2 to access secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = var.secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.project_name}_instance_profile"
  role = aws_iam_role.this.name
}

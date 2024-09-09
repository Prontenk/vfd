provider "aws" {
  region = "eu-north-1"  # Регiон, в якому знаходиться твій VPC
}

module "ec2_instance" {
  source          = "./modules/ec2_instance"
  instance_names  = ["webserver", "backend", "management"]
  ami             = "ami-0c6da69dd16f45f72"
  instance_type   = "t3.micro"
  key_name        = "Ubuntu_fr"
  subnet_id       = "subnet-020a004831bd541e7"
  secret_arn      = "arn:aws:secretsmanager:region:account-id:secret:secret-id"
  project_name    = "my_project"
}

module "security_group" {
  source        = "./modules/security_group"
  allowed_ports = ["22", "80", "443"]
  vpc_id        = "vpc-0d67a0de159ec98b0"
  project_name  = "my_project"
}

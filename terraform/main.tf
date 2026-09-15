# main.tf
# This file defines everything Terraform will create in AWS.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Tells Terraform which AWS region to work in
provider "aws" {
  region = var.aws_region
}

# Use AWS's default VPC (network) that already exists in every account,
# instead of creating a new one -- simpler and free.
data "aws_vpc" "default" {
  default = true
}

# Use the default subnets inside that default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group = a virtual firewall controlling what traffic can reach our server
resource "aws_security_group" "todo_api_sg" {
  name        = "todo-api-sg"
  description = "Allow HTTP on 5000 and SSH access"
  vpc_id      = data.aws_vpc.default.id

  # Allow incoming traffic on port 5000 (our Flask app) from anywhere
  ingress {
    description = "Flask app"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (port 22) so you can log into the server if needed
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic (so the server can download Docker, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "todo-api-sg"
  }
}

# Find the latest Amazon Linux 2023 image to use for our server
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# The actual virtual server (EC2 instance) that will run our app
resource "aws_instance" "todo_api" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.todo_api_sg.id]

  # This script runs automatically when the server first boots.
  # It installs Docker, pulls our code from GitHub, builds the image, and runs it.
  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    github_repo_url = var.github_repo_url
  })

  tags = {
    Name = "todo-api-server"
  }
}

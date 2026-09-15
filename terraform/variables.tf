# variables.tf
# These are configurable values used in main.tf.
# You can change these without touching main.tf itself.

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance size (t2.micro/t3.micro = free tier eligible)"
  type        = string
  default     = "t2.micro"
}

variable "github_repo_url" {
  description = "Your GitHub repo URL containing app.py, requirements.txt, Dockerfile"
  type        = string
  default     = "https://github.com/Ash0p/todo-api.git"
}

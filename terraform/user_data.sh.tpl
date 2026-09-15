#!/bin/bash
# This script runs automatically the first time the EC2 server boots.
# It sets up Docker, downloads our code from GitHub, and starts the app.

# Update the system and install Docker + Git
dnf update -y
dnf install -y docker git
systemctl start docker
systemctl enable docker

# Download our project code from GitHub
cd /home/ec2-user
git clone ${github_repo_url} todo-api
cd todo-api

# Build the Docker image from our Dockerfile
docker build -t todo-api .

# Run the container, mapping port 5000 so it's reachable from outside
docker run -d -p 5000:5000 --restart always todo-api

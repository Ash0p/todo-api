# outputs.tf
# After 'terraform apply' finishes, these values get printed to your screen.

output "public_ip" {
  description = "Public IP address of the server -- use this to access your app"
  value       = aws_instance.todo_api.public_ip
}

output "app_url" {
  description = "Direct URL to test your app's health endpoint"
  value       = "http://${aws_instance.todo_api.public_ip}:5000/health"
}

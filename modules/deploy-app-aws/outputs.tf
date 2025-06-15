output "web_app_public_ip" {
  value       = aws_instance.web_app.*.public_ip
  description = "The public IP of the EC2 instance"
}
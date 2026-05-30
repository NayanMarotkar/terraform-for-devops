# outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}

output "subnet_id" {
  description = "The ID of the Public Subnet"
  value       = aws_subnet.Public.id
}

output "instance_id" {
  description = "The ID of the EC2 Instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "The Public IP address of the EC2 Instance"
  value       = aws_instance.web_server.public_ip
}

output "instance_public_dns" {
  description = "The Public DNS name of the EC2 Instance"
  value       = aws_instance.web_server.public_dns
}

output "security_group_id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.web_sg.id
}

# Bonus: Useful combined output
output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i your-key.pem ec2-user@${aws_instance.web_server.public_ip}"
}

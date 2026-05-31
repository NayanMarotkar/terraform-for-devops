output "web_server_ip" {
  description = "Public IP of the Web Server"
  value       = module.web_server.public_ip
}

output "api_server_ip" {
  description = "Public IP of the API Server"
  value       = module.api_server.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = module.web_sg.sg_id
}

output "web_server_instance_id" {
  description = "Web Server Instance ID"
  value       = module.web_server.instance_id
}

output "api_server_instance_id" {
  description = "API Server Instance ID"
  value       = module.api_server.instance_id
}

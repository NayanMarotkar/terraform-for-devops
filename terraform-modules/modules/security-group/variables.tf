variable "vpc_id" {
  description = "VPC ID where the Security Group will be created"
  type        = string
}

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
}

variable "ingress_ports" {
  description = "List of ingress ports to allow"
  type        = list(number)
  default     = [22, 80]
}

variable "tags" {
  description = "Additional tags for the Security Group"
  type        = map(string)
  default     = {}
}


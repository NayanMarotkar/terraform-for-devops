# Data Source: Latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Data Source: Available Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

# Public Subnet
resource "aws_subnet" "Public" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-subnet"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Route Table
resource "aws_route_table" "Public" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rt"
  })
}

# Route Table Association
resource "aws_route_table_association" "Public" {
  subnet_id      = aws_subnet.Public.id
  route_table_id = aws_route_table.Public.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-SG"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Allow port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-sg"
  })
}

# EC2 Instance
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-server"
  })

  lifecycle {
    create_before_destroy = true
  }
}

# Random string for unique S3 bucket name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# S3 Bucket
resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-app-logs-${random_string.suffix.result}"

tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-logs"
  })

  depends_on = [aws_instance.web_server]
}

# Imported S3 Bucket (Renamed)
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "terraweek-import-test-nayan"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-imported-bucket"
  })
}

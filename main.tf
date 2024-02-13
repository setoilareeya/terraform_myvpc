# Configure the AWS provider
provider "aws" {
  region = "ap-southeast-1"
}

# Create a VPC with a 10.0.0.0/16 CIDR block
resource "aws_vpc" "areeya_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "areeyaVPC"
  }
}

# Create public subnet in first availability zone
resource "aws_subnet" "public_subnet_first" {
  vpc_id                  = aws_vpc.areeya_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetFirst"
  }
}

# Create public subnet in second availability zone
resource "aws_subnet" "public_subnet_second" {
  vpc_id                  = aws_vpc.areeya_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-southeast-1b" 
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnetSecond"
  }
}

# Create private subnet in first availability zone
resource "aws_subnet" "private_subnet_first" {
  vpc_id                  = aws_vpc.areeya_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnetFirst"
  }
}

# Create private subnet in second availability zone
resource "aws_subnet" "private_subnet_second" {
  vpc_id                  = aws_vpc.areeya_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "PrivateSubnetSecond"
  }
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.areeya_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Create route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.areeya_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

# Output IDs
output "vpc_id" {
  value = aws_vpc.areeya_vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_first.id, aws_subnet.public_subnet_second.id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnet_first.id, aws_subnet.private_subnet_second.id]
}

output "route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_igw.id
}

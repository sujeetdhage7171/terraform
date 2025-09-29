provider "aws" {
  region = "us-east-1"
}

# Simple VPC with /24 CIDR
resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "simple-vpc"
  }
}

# Single subnet inside that VPC
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "simple-subnet"
  }
}

# Just to resolve AZs
data "aws_availability_zones" "available" {}


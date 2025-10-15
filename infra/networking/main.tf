# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Data source to fetch available AZs in the configured region
data "aws_availability_zones" "available" {
  state = "available"
}

# ----------------------------------------------------
# A. VPC and Gateway Setup
# ----------------------------------------------------

resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "Production"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# ----------------------------------------------------
# B. Public Subnets and NAT Gateways
# ----------------------------------------------------

# Loop through the public_subnet_cidrs list
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true # Instances need public IPs (e.g., NAT GW)

  tags = {
    Name                                = "${var.project_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb"            = "1" # Tag for Internet-facing Load Balancers
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned" # EKS cluster tag
  }
}

# Elastic IP for the NAT Gateway
resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_cidrs)
  vpc   = true
}

# NAT Gateway placed in the Public Subnets
resource "aws_nat_gateway" "nat_gw" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.igw]
}

# ----------------------------------------------------
# C. Private Subnets (for Worker Nodes)
# ----------------------------------------------------

# Loop through the private_subnet_cidrs list
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false # CRITICAL: Worker Nodes stay private

  tags = {
    Name                                = "${var.project_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/role/internal-elb"   = "1" # Tag for Internal Load Balancers
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}

# ----------------------------------------------------
# D. Routing
# ----------------------------------------------------

# Public Route Table (sends 0.0.0.0/0 traffic to the IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Private Route Tables (sends 0.0.0.0/0 traffic to the NAT GW in the same AZ)
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Public Subnet Route Table Associations
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Subnet Route Table Associations
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
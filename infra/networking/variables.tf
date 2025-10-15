# --- Region and Project Naming ---
variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix used for tagging resources."
  type        = string
  default     = "prod-eks-network"
}

# --- VPC Configuration ---
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  # WARNING: 10.0.0.0/24 is too small for 4 subnets and will likely fail
  default     = "10.0.0.0/24"
}

# Subnet CIDRs MUST now be smaller segments of 10.0.0.0/24
# Example uses /26 (64 IPs) segments:
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.0.0/26", "10.0.0.64/26"] # Uses first half of the /24
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private (worker node) subnets."
  type        = list(string)
  default     = ["10.0.0.128/26", "10.0.0.192/26"] # Uses second half of the /24
}

# --- EKS Cluster Name ---
# This tag is critical for the EKS components (like the AWS Load Balancer Controller)
variable "eks_cluster_name" {
  description = "The name of the EKS cluster this network is for."
  type        = string
  default     = "EKS-PROD"
}
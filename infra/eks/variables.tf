# --- Network Inputs (REQUIRED from the networking module) ---
# Assuming you will pass these from a root module or use data lookups
variable "vpc_id" {
  description = "The ID of the VPC created by the networking module."
  type        = string
  default = "vpc-0d934e4e540c75060"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS worker nodes."
  type        = list(string)
  default = [
    "subnet-08478509218fc5af5", # private-subnet-1
    "subnet-0b5d87fa856510826"  # private-subnet-2
  ]
}

# --- EKS Configuration Variables ---

variable "region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "us-east-1"
}

variable "eks_worker_plane" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "eks-cluster-1"
}

variable "node_machine_type" {
  description = "The EC2 instance type for the EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "node_count" {
  description = "The initial number of worker nodes."
  type        = number
  default     = 2
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for the EKS Control Plane."
  type        = string
  default     = "arn:aws:iam::555488808142:role/eks_cluster_role"
}

variable "eks_node_role_arn" {
  description = "ARN of the IAM role for the EKS Worker Nodes."
  type        = string
  default     = "arn:aws:iam::555488808142:role/eks_node_role"
}

variable "cluster_version" {
  description = "Kubernetes cluster version."
  type        = string
  default     = "1.32"
}
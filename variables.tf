variable "region" {
  description = "The AWS region to deploy the EKS cluster into"
  type        = string
  default     = "ap-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster-1"
}

variable "node_count" {
  description = "Number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "node_machine_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS worker nodes"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "eks_node_role_arn" {
  description = "IAM role ARN for the EKS node group"
  type        = string
}


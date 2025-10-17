# ----------------------------------------------------
# A. EKS Cluster Definition
# ----------------------------------------------------

resource "aws_eks_cluster" "this" {
  # Use variables from terraform.tfvars
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn
  version  = var.cluster_version # Set in variables.tf with a default

  vpc_config {
    # CRITICAL: Use the private subnets for cluster control plane ENIs
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true # Recommended for production security
    endpoint_public_access  = false # Disable public access
    security_group_ids      = []
  }

  tags = {
    Name = var.cluster_name
  }
}

# ----------------------------------------------------
# B. EKS Managed Node Group (Worker Nodes)
# ----------------------------------------------------

resource "aws_eks_node_group" "workers" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-workers"

  # Use variables from terraform.tfvars
  node_role_arn   = var.eks_node_role_arn
  instance_types  = [var.node_machine_type]

  # CRITICAL: Nodes MUST run in the private subnets
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    # Use node_count for desired size
    desired_size = var.node_count
    min_size     = 1
    # Allow scaling up to 3 more nodes than the desired count
    max_size     = var.node_count + 3
  }

  # Ensure the cluster is ready before attaching nodes
  depends_on = [
    aws_eks_cluster.this,
  ]

  # Configuration for zero downtime updates
  update_config {
    max_unavailable_percentage = 33
  }

  # Label the nodes for Kubernetes scheduling
  labels = {
    "node-lifecycle" = "on-demand"
    "purpose"        = "application-workers"
  }
}

# ----------------------------------------------------
# C. Data Source to Configure Kubeconfig
# ----------------------------------------------------

# This is often used by subsequent steps or other modules to connect to the cluster.
data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}
# Define the remote state configuration for the networking module
# data "terraform_remote_state" "networking" {
#   backend = "s3"
#   config = {
#     # CRITICAL: Replace YOUR-TERRAFORM-STATE-BUCKET-NAME with your actual S3 bucket name
#     bucket = "s3bucket-for-statefile"
#     # Use the static key path for the networking state file
#     key    = "infra/networking/terraform.tfstate"
#     region = "us-east-1"
#   }
# }
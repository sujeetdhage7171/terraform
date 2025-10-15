module "networking" {
  source = "./networking"
  # Pass variables here if networking uses them
}

module "eks" {
  source = "./eks"

  # Pass required network outputs to the EKS module
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  # Pass variables from your root tfvars
  region               = var.region
  cluster_name         = var.cluster_name
  node_count           = var.node_count
  node_machine_type    = var.node_machine_type
  eks_cluster_role_arn = var.eks_cluster_role_arn
  eks_node_role_arn    = var.eks_node_role_arn
}
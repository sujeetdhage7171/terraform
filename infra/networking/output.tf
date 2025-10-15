output "vpc_id" {
  description = "The ID of the VPC."
  # Reference changed from aws_vpc.this.id to aws_vpc.eks_vpc.id
  value       = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  # Reference changed from aws_subnet.this.id to aws_subnet.public[*].id
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs where EKS worker nodes will run."
  # Reference changed from aws_subnet.this.id to aws_subnet.private[*].id
  value       = aws_subnet.private[*].id
}

output "all_subnet_ids" {
  description = "List of all subnet IDs (public and private)."
  # Concatenate the lists using the correct resource names
  value       = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
}


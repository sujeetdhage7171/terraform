output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs."
  value       = aws_subnet.this.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs where EKS worker nodes will run."
  value       = aws_subnet.this.id
}

output "all_subnet_ids" {
  description = "List of all subnet IDs (public and private)."
  value       = concat(aws_subnet.this.id, aws_subnet.this.id)
}
output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "node_group_name" {
  value = aws_eks_node_group.nodes.node_group_name
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.cluster.id
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster CA certificate"
  value       = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_status" {
  description = "EKS cluster status"
  value       = aws_eks_cluster.cluster.status
}

output "cluster_version" {
  description = "EKS cluster version"
  value       = aws_eks_cluster.cluster.version
}

output "vpc_id" {
  description = "ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "subnet_ids" {
  description = "IDs of all subnets in the default VPC"
  value       = data.aws_subnets.default.ids
}

output "supported_subnet_ids" {
  description = "IDs of the subnets in supported AZs"
  value       = local.supported_subnets
}

output "availability_zones" {
  description = "Availability zones of the subnets"
  value       = [for s in data.aws_subnet.default : s.availability_zone]
}


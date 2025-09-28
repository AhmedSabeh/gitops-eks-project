# Random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get all subnets in VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get details for each subnet
data "aws_subnet" "default" {
  for_each = toset(data.aws_subnets.default.ids)
  id       = each.value
}

# EKS authentication
data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.cluster.name
}


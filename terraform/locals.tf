locals {
  supported_azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]

  supported_subnets = [
    for subnet_id in data.aws_subnets.default.ids :
    subnet_id
    if contains(local.supported_azs, data.aws_subnet.default[subnet_id].availability_zone)
  ]
}


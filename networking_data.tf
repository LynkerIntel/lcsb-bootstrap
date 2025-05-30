# Data source for VPC
data "aws_vpc" "env_vpc" {
  id = aws_vpc.env_vpc.id
}

data "aws_security_group" "sg_vpc_def_env" {
  vpc_id = data.aws_vpc.env_vpc.id
  name = "default"
}

# # Data source for default security group
# data "aws_security_group" "sg_vpc_def_env" {
#   id = aws_default_security_group.sg_vpc_def_env.id
# }

# Data sources for public subnets
data "aws_subnet" "public_subnets" {
  for_each = var.subnet_map
  id       = aws_subnet.public_subnets[each.key].id
}

# Data sources for private subnets
data "aws_subnet" "private_subnets" {
  for_each = var.subnet_map
  id       = aws_subnet.private_subnets[each.key].id
}


# Data source for internet gateway
data "aws_internet_gateway" "igw_default_env_vpc" {
  internet_gateway_id = aws_internet_gateway.igw_default_env_vpc.id
}

# Data source for elastic IP
data "aws_eip" "nat_eip" {
  id = aws_eip.nat_eip.id
}

# Data source for NAT gateway
data "aws_nat_gateway" "nat" {
  id = aws_nat_gateway.nat.id
}

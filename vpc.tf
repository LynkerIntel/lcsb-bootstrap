

resource "aws_default_security_group" "sg_vpc_def_lcsb" {
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    self      = true
    to_port   = 0
  }

  # name   = aws_vpc.vpc_lcsb.instance_tenancy
  vpc_id = aws_vpc.vpc_lcsb.id
}


resource "aws_subnet" "public_subnets" {
  vpc_id                              = aws_vpc.vpc_lcsb.id
  private_dns_hostname_type_on_launch = "ip-name"
  map_public_ip_on_launch             = true

  for_each          = var.subnet_map
  availability_zone = each.key
  cidr_block        = each.value.public
  tags = {
    Name = "${var.environment}-public-${each.key}"
  }


}

resource "aws_subnet" "private_subnets" {
  vpc_id                              = aws_vpc.vpc_lcsb.id
  private_dns_hostname_type_on_launch = "ip-name"
  map_public_ip_on_launch             = false
  for_each                            = var.subnet_map
  availability_zone                   = each.key
  cidr_block                          = each.value.private
  tags = {
    Name = "${var.environment}-private-subnet-${each.key}"
  }


}
resource "aws_vpc" "vpc_lcsb" {
  assign_generated_ipv6_cidr_block     = "false"
  cidr_block                           = "172.31.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  instance_tenancy                     = "default"
  enable_network_address_usage_metrics = "false"

  lifecycle {
    # prevent_destroy = true
    ignore_changes = [tags]
  }

}

resource "aws_default_network_acl" "network_acl_lcsb" {
  default_network_acl_id = aws_vpc.vpc_lcsb.default_network_acl_id
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  # TODO Fix this!
  subnet_ids = concat([for o in aws_subnet.private_subnets: o.id], [for o in aws_subnet.public_subnets: o.id])
}


resource "aws_main_route_table_association" "vpc_rta" {
  route_table_id = aws_route_table.route_table_public.id
  vpc_id         = aws_vpc.vpc_lcsb.id
}
resource "aws_route_table" "route_table_public" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_default_vpc_lcsb.id
  }

  vpc_id = aws_vpc.vpc_lcsb.id
}
resource "aws_route_table" "private_route_table" {
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  vpc_id = aws_vpc.vpc_lcsb.id

}

resource "aws_internet_gateway" "igw_default_vpc_lcsb" {
  vpc_id = aws_vpc.vpc_lcsb.id
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_default_vpc_lcsb]
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = [for o in aws_subnet.public_subnets : o.id][0]
  depends_on    = [aws_internet_gateway.igw_default_vpc_lcsb]
  tags = {
    Name        = "${var.environment}-nat-gateway"
    Environment = "${var.environment}"
  }
}

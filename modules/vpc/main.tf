# Fetch available AZs
data "aws_availability_zones" "available" {}

# Public VPC
resource "aws_vpc" "public_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge(var.tags, { Name = var.vpc_name })
  lifecycle {
    #   prevent_destroy = true
  }
}

#Public Subnet

resource "aws_subnet" "public_subnet" {
  count             = length(var.subnets["public"].cidrs)
  vpc_id            = aws_vpc.public_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index) # 4 new bits for 16 subnets
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  tags = merge(var.tags, {
    Name = element(var.subnets["public"].names, count.index)
  })
  lifecycle {
    #   prevent_destroy = true
  }
}

# Internet Gateway
resource "aws_internet_gateway" "public_igw" {
  vpc_id = aws_vpc.public_vpc.id
  tags   = merge(var.tags, { Name = var.aws_internet_gateway_name })
  lifecycle {
    #   prevent_destroy = true
  }
}

# Public Route Tables
resource "aws_route_table" "public_pub_route1" {
  vpc_id = aws_vpc.public_vpc.id
  tags   = merge(var.tags, { Name = var.aws_pub_route1_table_name })
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_route" "public_route1" {
  route_table_id         = aws_route_table.public_pub_route1.id
  destination_cidr_block = var.allowed_cidrs[0]
  gateway_id             = aws_internet_gateway.public_igw.id
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_route_table_association" "public_pub_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_pub_route1.id
  lifecycle {
    #   prevent_destroy = true
  }
}

# Private Subnets

resource "aws_subnet" "private_subnet" {
  count             = length(var.subnets["private"].cidrs)
  vpc_id            = aws_vpc.public_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + length(var.subnets["public"].names)) # Adjust index for private subnets
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  tags = merge(var.tags, {
    Name = element(var.subnets["private"].names, count.index)
  })
}

# NAT Gateway
resource "aws_eip" "NAT_GW_EIP" {
  lifecycle {
    #   prevent_destroy = true
  }
  tags = merge(var.tags, { Name = var.NAT_GW_EIP_Name })
}

resource "aws_nat_gateway" "EKS_NAT" {
  allocation_id = aws_eip.NAT_GW_EIP.id
  subnet_id     = aws_subnet.public_subnet[0].id # Select a valid public subnet
  tags          = merge(var.tags, { Name = var.NAT_GW_Name })
  lifecycle {
    #   prevent_destroy = true
  }
}

# Private Route Tables
resource "aws_route_table" "private_route1" {
  vpc_id = aws_vpc.public_vpc.id
  tags   = merge(var.tags, { Name = var.aws_priv_route1_table_name })
  lifecycle {
    #   prevent_destroy = true
  }
}

resource "aws_route" "private_route1_nat" {
  route_table_id         = aws_route_table.private_route1.id
  destination_cidr_block = var.allowed_cidrs[0]
  nat_gateway_id         = aws_nat_gateway.EKS_NAT.id
  lifecycle {
    #   prevent_destroy = true
  }
}

# Route Table Associations for Private Subnets
resource "aws_route_table_association" "private_sub_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route1.id
  lifecycle {
    #   prevent_destroy = true
  }
}

# Security Group
resource "aws_security_group" "eks_security_group" {
  name        = var.security_group_name
  description = "Security group for EKS cluster and nodes"
  vpc_id      = aws_vpc.public_vpc.id
  lifecycle {
    #   prevent_destroy = true
  }


  // Ingress rules
  ingress {
    from_port   = 443 #For Kubernetes API server access.
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 10250 #Used by the Kubelet to serve metrics and health checks.
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  ingress {
    from_port   = 10255 #Provides access to the read-only metrics of the Kubelet.
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  // Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          // All traffic
    cidr_blocks = ["0.0.0.0/0"] // Allow all outbound traffic
  }

  tags = merge(var.tags, { Name = var.security_group_name })
}

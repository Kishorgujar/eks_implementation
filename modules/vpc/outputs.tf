output "public_subnet_ids" {
  value = {
    for index, cidr in var.subnets["public"].cidrs :
    var.subnets["public"].names[index] => aws_subnet.public_subnet[index].id
  }
}

output "private_subnet_ids" {
  value = {
    for index, cidr in var.subnets["private"].cidrs :
    var.subnets["private"].names[index] => aws_subnet.private_subnet[index].id
  }
}

output "vpc_id" {
  value = aws_vpc.public_vpc.id
}

output "security_group_id" {
  value = aws_security_group.eks_security_group.id
}

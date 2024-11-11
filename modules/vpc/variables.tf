variable "vpc_cidr" {
  description = "Specifies the CIDR block to be used for the VPC network."
  type        = string
}

variable "region" {
  description = "Defines the AWS region where resources are provisioned."
  type        = string
}

variable "subnets" {
  description = "Map of subnet configurations, including CIDR blocks and names for each subnet."
  type = map(object({
    cidrs = list(string)
    names = list(string)
  }))
}

variable "tags" {
  description = "Key-value pairs of tags to apply across all resources."
  type        = map(string)
}

variable "vpc_name" {
  description = "Defines the name assigned to the VPC."
  type        = string
}

variable "aws_internet_gateway_name" {
  description = "Specifies the name for the internet gateway associated with the VPC."
  type        = string
}

variable "allowed_cidrs" {
  description = "List of CIDR blocks permitted for access."
  type        = list(string)
}

variable "security_group_name" {
  description = "Defines the name of the security group associated with the VPC."
  type        = string
}

variable "NAT_GW_EIP_Name" {
  description = "Specifies the name for the Elastic IP associated with the NAT Gateway."
  type        = string
}

variable "NAT_GW_Name" {
  description = "Defines the name for the NAT Gateway."
  type        = string
}

variable "aws_priv_route1_table_name" {
  description = "Name for the private route table within the VPC."
  type        = string
}

variable "aws_pub_route1_table_name" {
  description = "Name for the public route table within the VPC."
  type        = string
}

variable "enable_dns_support" {
  description = "Indicates whether DNS support is enabled for the VPC."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Indicates whether DNS hostnames are enabled for the VPC."
  type        = bool
  default     = true
}

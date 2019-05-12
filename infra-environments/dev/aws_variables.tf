# Provide input variables which needs to be used in terrafom resource creation
variable "project_name" {}
variable "aws_region" {}
variable "enable_dns_hostnames" {
  default = "false"
}
variable "tenancy" {
  default = "dedicated"
}

variable "environment_name" {}
variable "vpc_cidr_block" {}

variable "availability_zones" {
  type = "list"
}
variable "vpc_priv_subnet_cidrs" {
  type = "list"
}
variable "vpc_pub_subnet_cidrs" {
  type = "list"
}

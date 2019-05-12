# Provide input variable details which will be used in VPC creation. 
variable "project_name" {}
variable "environment_name" {}
variable "enable_dns_hostnames" {
  default = "false"
}
variable "tenancy" {
  default = "dedicated"
}
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

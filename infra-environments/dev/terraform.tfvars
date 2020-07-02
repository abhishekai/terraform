####################################################
## Define all required Variables for Dev Environment
## Author: Abhishek Srivastava
####################################################

project_name = "AssetsDetection"
environment_name = "dev"
enable_dns_hostnames = "true"
vpc_tenancy  = "default"

# Network Topology details
aws_region = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]
vpc_cidr_block = "190.160.0.0/16" 
vpc_pub_subnet_cidrs = ["190.160.1.0/24", "190.160.2.0/24"]
vpc_priv_subnet_cidrs = ["190.160.3.0/24"]

#ec2 instance count
instance_count = "1"

#Terraform definition file - this file is used to describe the minimum required infrastructure for the project kickoff.

## Setup AWS provide
provider "aws" {
  region = "${var.aws_region}"
}

# Defining remote state as s3, make sure given S3 bucket is already present in your configured AWS account.
terraform {
  backend "s3" {
    bucket = "atkins-infra-repo"
    key    = "terraform/dev-env/terraform-vpc.tfstate"
    region = "us-east-1"
  }
}

#########################################
## VPC (ORDER 1)
## Set up VPC module
#########################################
module "vpc" {
  source                   = "../../modules/vpc"
  project_name             = "${var.project_name}"
  environment_name         = "${var.environment_name}"
  enable_dns_hostnames     = "${var.enable_dns_hostnames}"
  availability_zones       = "${var.availability_zones}"
  vpc_cidr_block           = "${var.vpc_cidr_block}"
  vpc_pub_subnet_cidrs     = "${var.vpc_pub_subnet_cidrs}"
  vpc_priv_subnet_cidrs    = "${var.vpc_priv_subnet_cidrs}"
  #enable_nat_gateway       = "${var.enable_dns_hostnames}" ##
}


##############################################
## IAM policy (ORDER 2)
## Define IAM Policy for S3 bucket full access
##############################################
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid       = "AllowFullS3Access"
    actions   = ["s3:ListBuckets"]
    resources = ["*"] ##TODO: Point to AI related buckets later
  }
}
module "iam_policies" {
  source        = "../../modules/iam_policies"
  name          = "ATK-SVC-AllowS3FullAccess"
  path          = "/"
  description   = "Provides full access to all buckets via the AWS Management Console."
  policy        = "${data.aws_iam_policy_document.bucket_policy.json}"
}

##########################################
## IAM Role (ORDER 3)
## IAM service role with custom policies
########################################## 

# # Note: Module dependency does not work out of the box, hence IAM policy needs to be executed before it attaches to below iam role
module "iam_roles" {
  source                  = "../../modules/iam_roles" 
  #trusted_role_arns      = ["arn:aws:iam::930418207212:role/acc_aws_AllowEC2-S3Access"] ##Incase of trusted role arn
  create_role             = true
  role_name               = "acc_aws_AllowEC2-to-S3Access"
  custom_role_policy_arns = ["${module.iam_policies.arn}"]
}

#########################################
# GPU Intensive Machines (ORDER -4)
# EC2 instance allocation
#########################################
resource "aws_key_pair" "asset_detection_dl" {
  key_name   = "asset_detection_dl"
  public_key = "${file("asset_detection_dl.pub")}"
 }

module "ec2" {
  source                 = "../../modules/ec2"
  project_name           = "${var.project_name}"
  environment_name       = "${var.environment_name}"
  instance_count         = 2
  ami                    = "ami-0d96d570269578cd7" ##TODO Use Atkins owned AMI for DeepLearning later
  instance_type          = "p2.xlarge"
  name                   = "DeepLearning_Cluster"
  key_name               = "${aws_key_pair.asset_detection_dl.key_name}" ##
  monitoring             = true
  subnet_ids             = ["${module.vpc.public_subnet_ids}"]
  iam_instance_profile   = "${module.iam_roles.iam_role_name}"
  vpc_security_group_ids = ["${module.vpc.vpc_security_group_ids}"]
  associate_public_ip_address = true
  private_ip             = true
  root_block_device      = [{ volume_type = "gp2"  volume_size = 180 }]
}
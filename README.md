# A QUICK AI-DEV INFRA USING TERRAFORM

Create a quick dev AI infra using Terraform, which can be used to deliver a quick AI enabled MVP

Included features:
* Automatically creates VPC
* Automatically creates subnet(Private, Public), Route Table and its association, Availability zones
* Automatically creates a Security Group, open up a port 22 for ssh
* DeepLearning AMI used to support AI libraries like-Tensorflow, Pytorch, Keras, Mxnet etc.
* CloudWatch monitoring enabled
* Creates IAM service Policy and IAM Role and attaches to EC2 instances in order to access s3 buckets to avoid external configuration glitches.
* Associates Public key with the instances

Below is the tree graph of the terraform directory.

.
├── infra-environments
│   └── dev
│       ├── asset_detection_dl
│       ├── asset_detection_dl.pub
│       ├── aws_variables.tf
│       ├── main.tf
│       └── terraform.tfvars
└── modules
    ├── ec2
    │   ├── main_ec2.tf
    │   ├── output.tf
    │   └── var.tf
    ├── iam_policies
    │   ├── main_policies.tf
    │   ├── output.tf
    │   └── vars.tf
    ├── iam_roles
    │   ├── main_roles.tf
    │   ├── output.tf
    │   └── vars.tf
    └── vpc
        ├── main_vpc.tf
        ├── output.tf
        └── vars.tf



## Usage
	terraform init
	terraform plan
	terraform apply

Note: 
- add `${var.ssh_key_pair}` private key to the `ssh agent`.
- S3 bucket is used as backend for RemoteState, No locking mechanism at the moment.
- As Module dependency does not work out of the box, there are 2-3 manual steps need to be performed mentioned in dev/main.tf like first it should execute IAM policy, followed by IAM role and then EC2. VPC module can be executed independently.


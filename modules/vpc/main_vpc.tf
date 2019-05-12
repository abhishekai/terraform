## Provide definition of each resources required to create VPC. 
## Name - Module VPC

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"


  tags {
    Name = "${format("%s-%s", var.project_name, var.environment_name)}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${format("%s-%s-igw", var.project_name, var.environment_name)}"
  }
}

## Create a route table in this VPC for outbound intenet traffic and attach it to the public subnets
## EC2 nstances inside public subnet would be able to access internet via internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${format("%s-%s-pub-rt", var.project_name, var.environment_name)}"
  }
}

## Provide definition for private and public subnets
resource "aws_subnet" "private_subnet" {
  count             = "${length(var.vpc_priv_subnet_cidrs)}"  ## Loop through the input subnets
  availability_zone = "${var.availability_zones[count.index]}" ## one subnet per availability zone
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_priv_subnet_cidrs[count.index]}" 

  tags {
    Name = "${format("%s-%s-pri-sub%d", var.project_name, var.environment_name, count.index)}"
  }
}

resource "aws_subnet" "public_subnet" {
  count             = "${length(var.vpc_pub_subnet_cidrs)}" ## Loop through the input subnets
  availability_zone = "${var.availability_zones[count.index]}" ## One subnet per availability zone
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.vpc_pub_subnet_cidrs[count.index]}" 

  tags {
    Name = "${format("%s-%s-pub-sub%d", var.project_name, var.environment_name, count.index)}"
  }
}

resource "aws_route_table_association" "route_association" {
  count          = "${length(var.vpc_pub_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_route_table.id}"  
}

# Allow ssh to default security group
resource "aws_default_security_group" "AI_SGW" {
  vpc_id = "${aws_vpc.main.id}"

  ### Open port 22 for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] ##Todo - Make it specefic to client IP
  }
  
  ##
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${format("%s-%s-pub-sub%d", var.project_name, var.environment_name, count.index)}"
  }
}
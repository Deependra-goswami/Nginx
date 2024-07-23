#Cloud Provider Defination
provider "aws" {
  region = var.region
  access_key = var.Access-key-ID
  secret_key = var.Secret-access-key
}
# Input Variables (total variables = 3)
variable "region" {
    type = string
    description = "Please provide AWS Region: "
}
variable "Access-key-ID" {
    type = string
    description = "Please provide AWS Access key ID: "
    sensitive = true
}
variable "Secret-access-key" {
    type = string
    description = "Please provide AWS Secret access key: "
    sensitive = true
}
variable "ingressrules" {
    type = list(number)
    default = [ 80,443,22 ]
}
variable "egressrules" {
    type = list(number)
    default = [ 80,443 ]
}

# Defining VPC
resource "aws_vpc" "spark-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "spark-vpc"
  }
  enable_dns_hostnames = true
}

#Data Source - Availability Zone
data "aws_availability_zones" "available" {
  state = "available"
}

#Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.spark-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Name" = "public-subnet"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.spark-vpc.id
  tags = {
    Name = "internet_gw"
  }
}
#Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.spark-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

#Route Table Association
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# Data Source - AMI
data "aws_ami" "ami-id" {
    most_recent = true

    filter {
        name   = "owner-alias"
        values = ["amazon"] 
        }
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
        }
}

resource "aws_instance" "ec2spark" {
    ami = data.aws_ami.ami-id.id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet.id
    vpc_security_group_ids = [aws_security_group.webtraffic.id]
    associate_public_ip_address = true
    user_data = file("install-docker-ce.sh")
    tags = {
        Name = "ec2spark"
    }
}
resource "aws_eip" "elasticeip" {
    instance = aws_instance.ec2spark.id
}
resource "aws_security_group" "webtraffic" {
  name = "security-group-web"
  vpc_id = aws_vpc.spark-vpc.id
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port = port.value
      to_port = port.value
      cidr_blocks = ["0.0.0.0/0"]
      protocol = "TCP"
      }
  } 
  dynamic "egress" {
    iterator = port
    for_each = var.egressrules
    content {
      from_port = port.value
      to_port = port.value
      cidr_blocks = [ "0.0.0.0/0" ]
      protocol = "TCP"
    }
  }
}
output "EIP" {
    value = aws_eip.elasticeip.public_ip
}
#test

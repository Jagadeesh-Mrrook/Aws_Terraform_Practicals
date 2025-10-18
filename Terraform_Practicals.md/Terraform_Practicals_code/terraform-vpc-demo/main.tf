terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.0"
}

provider "aws" {
  region = var.aws_region
}


resource "aws_vpc" "first_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"

    tags = {
        Name = "Terraform-VPC"
        environment = "Dev"
        Owner = "Jagadeesh"
    }
  
}

resource "aws_subnet" "tf_public_subnet1" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.public_subnet_cidr1
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = true


  tags = {
    Name = "terrafrom-public-subnet1"
  }
}

resource "aws_subnet" "tf_public_subnet2" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.public_subnet_cidr2
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-public-subnet2"
  }
  
}

resource "aws_subnet" "tf_private_subnet1" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.private_subnet_cidr1
  availability_zone = var.availability_zone1
  map_public_ip_on_launch = false

  tags = {
    Name = "terrafrom-private-subnet1"
  }
  
}

resource "aws_subnet" "tf_private_subnet2" {
  vpc_id     = aws_vpc.first_vpc.id
  cidr_block = var.private_subnet_cidr2
  availability_zone = var.availability_zone2
  map_public_ip_on_launch = true

  tags = {
    Name = "terrafrom-private-subnet2"
  }
  
}

resource "aws_internet_gateway" "console-igw" {
  vpc_id = aws_vpc.first_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

resource "aws_route_table" "terraform-public-rt" {
  vpc_id = aws_vpc.first_vpc.id
 tags = {
    Name = "terraform-public-rt"
  }
}

resource "aws_route" "Public-Internet" {
  route_table_id = aws_route_table.terraform-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.console-igw.id 
}

resource "aws_route_table_association" "rta-public-subnet1" {
  subnet_id      = aws_subnet.tf_public_subnet1.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

resource "aws_route_table_association" "rta-public-subnet2" {
  subnet_id      = aws_subnet.tf_public_subnet2.id
  route_table_id = aws_route_table.terraform-public-rt.id
}

resource "aws_route_table" "terraform-private-rt" {
  vpc_id = aws_vpc.first_vpc.id
 tags = {
    Name = "terraform-private-rt"
  }
}

/*resource "aws_route" "Public-Internet" {
  route_table_id = aws_route_table.terraform-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.console-igw.id 
}*/

resource "aws_route_table_association" "rta-private-subnet1" {
  subnet_id      = aws_subnet.tf_private_subnet1.id
  route_table_id = aws_route_table.terraform-private-rt.id
}

resource "aws_route_table_association" "rta-private-subnet2" {
  subnet_id      = aws_subnet.tf_private_subnet2.id
  route_table_id = aws_route_table.terraform-private-rt.id
}
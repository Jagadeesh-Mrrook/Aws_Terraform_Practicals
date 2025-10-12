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
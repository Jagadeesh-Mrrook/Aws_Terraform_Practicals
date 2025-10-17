variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
  
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr1" {
  description = "The CIDR block for the first public subnet."
  type        = string
  default     = "10.0.1.0/24" 
}

variable "public_subnet_cidr2" {
  description = "The CIDR block for the first public subnet."
  type        = string
  default     = "10.0.2.0/24" 
}

variable "private_subnet_cidr1" {
  description = "The CIDR block for the first private subnet."
  type        = string
  default     = "10.0.3.0/24"
  
}

variable "private_subnet_cidr2" {
  description = "The CIDR block for the first private subnet."
  type        = string
  default     = "10.0.4.0/24"
  
}

variable "availability_zone1" {
  description = "The first availability zone."
  type        = string
  default     = "ap-south-1a"
  
}

variable "availability_zone2" {
  description = "The second availability zone."
  type        = string
  default     = "ap-south-1b"
  
}